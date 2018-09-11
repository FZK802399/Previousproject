//
//  ShoppingCartViewController.m
//  OnlineShop
//
//  Created by yons on 15/8/19.
//  Copyright (c) 2015年 m. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "SubmitOrderViewController.h"
#import "DZYSubmitOrderController.h"
#import "ShopCartMerchandiseModel.h"
#import "MerchandiseDetailModel.h"
#import "OrderMerchandiseSubmitModel.h"
#import "AppConfig.h"
#import "ShopCartCell.h"
#import "AFAppAPIClient.h"
#import "ChaiDan.h"

#define KSelectAllBtn 101
@interface ShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource,ShopCartDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/// 购物车数据组
@property (nonatomic,strong)  NSMutableArray * arr;

///结算按钮
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;


@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
///约 rmb
@property (weak, nonatomic) IBOutlet UILabel *rmbPrice;
///编辑按钮
@property (weak, nonatomic)UIButton * editBtn;

///商品总重量
@property (nonatomic,assign)CGFloat allProductWeight;
///提交订单时的选中商品
@property (nonatomic,strong)NSMutableArray * submitArray;

@property (nonatomic,strong)NSMutableArray *resultArray;

@end

@implementation ShoppingCartViewController
+ (instancetype) create{
    return [[UIStoryboard storyboardWithName:@"Center" bundle:nil] instantiateViewControllerWithIdentifier:@"ShoppingCartViewController"];
}

-(AppConfig *)appConfig{
    
    return [AppConfig sharedAppConfig];
}

- (NSMutableArray *)resultArray {
    if (!_resultArray) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 90;
    self.title = @"购物车";
    [_btn addTarget:self action:@selector(clickBuyChoose:) forControlEvents:UIControlEventTouchUpInside];
    [_selectAllBtn addTarget:self action:@selector(selectAllList:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setNaviBar
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(LZScreenWidth-50, 12, 35, 20);
    [btn setTitleColor:FONT_BLACK forState:UIControlStateNormal];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitle:@"完成" forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn addTarget:self action:@selector(editClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:btn];
    self.editBtn = btn;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataForWeb];
    [self setNaviBar];
    [self refershAllNum];

}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.selectAllBtn.selected = NO;
    [self.editBtn removeFromSuperview];
    NSInteger normarl = [self.view.subviews indexOfObject:[self.view viewWithTag:99]];
    NSInteger edit = [self.view.subviews indexOfObject:[self.view viewWithTag:66]];
    if (edit > normarl) {
        [self.view exchangeSubviewAtIndex:normarl withSubviewAtIndex:edit];
    }
}
- (void) loadDataForWeb
{
    [self.arr removeAllObjects];
    NSDictionary * shopcartDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.appConfig.loginName,@"loginId",
                                  self.appConfig.appSign,@"AppSign",
                                  nil];
    [ShopCartMerchandiseModel getShopCartMerchandiseListByParamer:shopcartDic andblock:^(NSArray *shopCartList, NSError *error) {
        if (error) {
            [self showErrorWithStr:@"网络错误"];
        }else{
            NSInteger count = [shopCartList count];
            if (count > 0) {
                [self.appConfig loadConfig];
                NSInteger num = 0;
                for (ShopCartMerchandiseModel * model in shopCartList) {
                    num += model.buyNumber;
                }
                self.appConfig.shopCartNum = num;
                [self.appConfig saveConfig];
                [self.arr addObjectsFromArray:shopCartList];
                [self.tableView reloadData];
            }else{
                [self.appConfig loadConfig];
                self.appConfig.shopCartNum = 0;
                [self.appConfig saveConfig];
                self.navigationController.tabBarItem.badgeValue = nil;
                [self.tableView reloadData];
                [self refershAllNum];
//                [self showErrorWithStr:@"暂无数据"];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationGoodsChange object:nil];
        }
    }];
}

#pragma mark - Table view data source


//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return self.sectionDatas.count;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShopCartCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ShopCartCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"ShopCartCell" owner:nil options:nil].firstObject;
    }
    ShopCartMerchandiseModel * mode = self.arr[indexPath.row];
    cell.model = mode;
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopCartMerchandiseModel * mode = self.arr[indexPath.row];
    mode.isCheckForShopCart = !mode.isCheckForShopCart;
    [self refershAllNum];
    [self.tableView reloadData];
}

#pragma mark - cellDelegate

- (void)cellDidSelectWithModel:(ShopCartMerchandiseModel *)model andCell:(ShopCartCell *)cell
{
    [self.tableView reloadData];
    [self refershAllNum];
}

-(void)goodsReduceOrAddWithModel:(ShopCartMerchandiseModel *)model addCell:(ShopCartCell *)cell andBtn:(UIButton *)btn
{
    if (!model.isEdit) {
        return;
    }
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    switch (btn.tag) {
        case 1:
        {
            if (model.buyNumber == 1) {
                return;
            }
            //删减
            model.isEdit = NO;
            NSDictionary * dict = @{
                                    @"BuyNumber":@(-1),
                                    @"Attributes":model.Attributes,
                                    @"BuyPrice":@(model.buyPrice),
                                    @"ProductGuid":model.productGuid,
                                    @"DetailedSpecifications":model.specificationName,
                                    @"ExtensionAttriutes":@(model.RepertoryCount),
                                    @"MemLoginID":config.loginName,
                                    @"AppSign":config.appSign
                                    };
            [MerchandiseDetailModel addMerchandiseToShopCartByParamer:dict andblock:^(NSInteger result, NSError *error) {
                model.isEdit = YES;
                if (error) {
                    [self showErrorWithStr:@"网络错误"];
                }
                if (result == 202) {
                    model.buyNumber --;
                    [self.tableView reloadData];
                    [self refershAllNum];
                    config.shopCartNum --;
                    [config saveConfig];
                    [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationGoodsChange object:nil];
                }
                else if (result == 101){
                    [self showErrorWithStr:@"超过限购量"];
                }
                else if (result == 100){
                    [self showErrorWithStr:@"库存不足"];
                }
                else
                {
                    [self showErrorWithStr:@"添加失败"];
                }
            }];
            break;
        }
        case 2:
        {
            //添加
//            if (model.IsJoinActivity < 1) {
//                [self showErrorWithStr:@"库存不足"];
//                return;
//            }
            model.isEdit = NO;
            NSDictionary * dict = @{
                                    @"BuyNumber":@(1),
                                    @"Attributes":model.Attributes,
                                    @"BuyPrice":@(model.buyPrice),
                                    @"ProductGuid":model.productGuid,
                                    @"DetailedSpecifications":model.specificationName,
                                    @"ExtensionAttriutes":@(model.RepertoryCount),
                                    @"MemLoginID":config.loginName,
                                    @"AppSign":config.appSign
                                    };
            [MerchandiseDetailModel addMerchandiseToShopCartByParamer:dict andblock:^(NSInteger result, NSError *error) {
                model.isEdit = YES;
                NSLog(@"result %ld",result);
                if (error) {
                    [self showErrorWithStr:@"网络错误"];
                }
                if (result == 202) {
                    model.buyNumber ++;
                    [self.tableView reloadData];
                    [self refershAllNum];
                    config.shopCartNum ++;
                    [config saveConfig];
                    [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationGoodsChange object:nil];
                }
                else if (result == 101){
                    [self showErrorWithStr:@"超过限购量"];
                }
                else if (result == 100){
                    [self showErrorWithStr:@"库存不足"];
                }
                else {
                    [self showErrorWithStr:@"添加失败"];
                }
            }];
            break;
        }
    }
}


#pragma mark - 全选  结算按钮
/// 全选
-(void)selectAllList:(UIButton *)btn
{
    btn.selected = !btn.isSelected;
    [self.arr enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(ShopCartMerchandiseModel *obj, NSUInteger idx, BOOL *stop) {
        obj.isCheckForShopCart = btn.selected;
    }];
    [self.tableView reloadData];
    [self refershAllNum];
}
#pragma mark - 提交订单
/// 结算 ：
- (void) clickBuyChoose:(UIButton*)sender{
    if (![self allOrderNum]) {
        [self showMessage:@"请选择商品订单"];
        return;
    }
    _allProductWeight = 0;
    _submitArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (ShopCartMerchandiseModel *model in self.arr) {
        if(model.isCheckForShopCart){
            
            _allProductWeight = _allProductWeight + model.buyNumber * model.procuctWeight;
            
            OrderMerchandiseSubmitModel *subimitModel = [[OrderMerchandiseSubmitModel alloc] init];
            
            subimitModel.Attributes = model.Attributes;
            subimitModel.Name = model.name;
            subimitModel.BuyNumber = model.buyNumber;
            subimitModel.BuyPrice = model.buyPrice;
            subimitModel.Guid = model.guid;
            subimitModel.MarketPrice = model.MarketPrice;
            subimitModel.MemLoginID = self.appConfig.loginName;
            subimitModel.OriginalImge = model.originalImageStr;
            subimitModel.ProductGuid = model.productGuid;
            subimitModel.SpecificationName = model.specificationName;
            subimitModel.IncomeTax = model.IncomeTax;
            subimitModel.SpecificationValue = @"";
            subimitModel.ShopID = @"0";
            subimitModel.ShopName = @"";
            subimitModel.CreateTime = [NSDate date];
            subimitModel.IsJoinActivity = 0;
            subimitModel.IsPresent = 0;
            subimitModel.RepertoryNumber = @"JK";
            subimitModel.ExtensionAttriutes = @"M";
            subimitModel.CouponRule         = model.CouponRule;
            [_submitArray addObject:subimitModel];
            
        }
    }
//    [self performSegueWithIdentifier:kSegueShopCartToSubmit sender:self];
    
    // MARK: 拆单
    
    [ChaiDanModel getRateWithBlock:^(CGFloat rate,CGFloat PostageMoney,CGFloat SplitPostageMoney) {
        if (rate != -1) {
            NSMutableArray * newArr = [ChaiDan ChanDanWithArr:_submitArray Rate:rate];
            DZYSubmitOrderController * vc = [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"DZYSubmitOrderController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.productArr = [NSArray arrayWithArray:newArr];
            vc.PostageMoney = PostageMoney;
            vc.SplitPostageMoney = SplitPostageMoney;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [MBProgressHUD showMessage:@"网络错误，请稍候再试" hideAfterTime:2];
        }
    }];
    
    
//    SubmitOrderViewController * sovc = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateViewControllerWithIdentifier:@"SubmitOrderViewController"];
//    if ([sovc respondsToSelector:@selector(setProductArray:)]) {
//        sovc.submitProductType = SubmitOrderForCommon;
//    }
//    sovc.productArray = _submitArray;
//    sovc.totalPrice = [self allOrderPrice];
//    sovc.totalWeight = _allProductWeight;
//    [self.navigationController pushViewController:sovc animated:YES];
}
///结算按钮实时刷新
- (void) refershAllNum
{
    [self.btn setTitle:[NSString stringWithFormat:@"结算(%d)",[self allOrderNum]] forState:UIControlStateNormal];
    self.totalPrice.text = [NSString stringWithFormat:@"合计: AU$%.2f",[self allOrderPrice]];
    self.rmbPrice.text = [NSString stringWithFormat:@"约¥ %.2f",[self allOrderRMBPrice]];
    UIButton *btn = (UIButton*)[self.view viewWithTag:KSelectAllBtn];
    btn.selected = [self hasAllSelected];
}
/// 是否 全部tfpq中
- (BOOL) hasAllSelected {
    if(!self.arr.count) return NO; //如果购物车为空
    __block BOOL result = YES;
    [self.arr enumerateObjectsUsingBlock:^(ShopCartMerchandiseModel *obj, NSUInteger idx, BOOL *stop) {
        if (obj.isCheckForShopCart == NO) {
            result = NO;
            *stop  = YES;
        }
    }];
    return result;
}
/// 选中的件数
- (int) allOrderNum {
    int i = 0;
    for (ShopCartMerchandiseModel * obj in self.arr) {
        if (obj.isCheckForShopCart == YES) {
            i++;
        }
    }
    return i;
}
///澳元价格
- (CGFloat )allOrderPrice
{
    CGFloat a = 0;
    for (ShopCartMerchandiseModel * obj in self.arr) {
        if (obj.isCheckForShopCart == YES) {
            a = a + (obj.buyPrice * obj.buyNumber);
        }
    }
    return a;
}
///rmb价格
- (CGFloat )allOrderRMBPrice
{
    CGFloat a = 0;
    for (ShopCartMerchandiseModel * obj in self.arr) {
        if (obj.isCheckForShopCart == YES) {
            a = a + (obj.MarketPrice * obj.buyNumber);
        }
    }
    return a;
}

#pragma mark - 编辑 完成

-(void)editClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    NSInteger normarl = [self.view.subviews indexOfObject:[self.view viewWithTag:99]];
    NSInteger edit = [self.view.subviews indexOfObject:[self.view viewWithTag:66]];
    
    if(btn.selected)
    {
        if (normarl > edit) {
            [self.view exchangeSubviewAtIndex:normarl withSubviewAtIndex:edit];
        }
    }
    else
    {
        if (normarl < edit) {
            [self.view exchangeSubviewAtIndex:normarl withSubviewAtIndex:edit];
        }
    }
}

#pragma mark - 批量删除
- (IBAction)deleGoodClick:(id)sender {
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSMutableArray * arr = [NSMutableArray array];
    for (ShopCartMerchandiseModel * model in self.arr) {
        if (model.isCheckForShopCart == YES) {
            [arr addObject:model];
        }
    }
    if (arr.count > 0) {
        for (int i = 0; i < arr.count; i++) {
            ShopCartMerchandiseModel * model = arr[i];
            NSDictionary * dict = @{
                                    @"MemLoginID":config.loginName,
                                    @"AppSign":config.appSign,
                                    @"Guid":model.guid
                                    };
            [ShopCartMerchandiseModel deleteShopCartMerchandiseByParamer:dict andblock:^(NSInteger result, NSError *error) {
                if (error) {
                    [self showErrorWithStr:@"网络错误"];
                }
                if (result == 202 && i == arr.count - 1) {
                    [self showSuccessMessage:@"删除成功"];
                    [self loadDataForWeb];
                }
            }];
        }
    }
    else
    {
        [self showMessage:@"请选择商品"];
    }
}

#pragma mark - 批量添加收藏
- (IBAction)addCollectClickj:(id)sender {
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSMutableArray * arr = [NSMutableArray array];
    for (ShopCartMerchandiseModel * model in self.arr) {
        if (model.isCheckForShopCart == YES) {
            [arr addObject:model];
        }
    }
   
    if (arr.count > 0) {
        for (NSInteger i = 0; i < arr.count; i++) {
            ShopCartMerchandiseModel * model = arr[i];
            NSDictionary * dict = @{
                                    @"MemLoginID":config.loginName,
                                    @"AppSign":config.appSign,
                                    @"productGuid":model.productGuid
                                    };
            
            [MerchandiseDetailModel addMerchandiseToCollectByParamer:dict andblock:^(NSInteger result, NSError *error) {
                if (error) {
                    [self showErrorWithStr:@"网络错误"];
                } else {
                    if (result == 202) {
                        [self.resultArray addObject:[NSNumber numberWithInteger:i-100]];
                    } else {
                        [self.resultArray addObject:[NSNumber numberWithInteger:i+1]];
                    }
                    if (self.resultArray.count == arr.count) {
                        [self showAddCollectResult];
                    }
                }
            }];
        }
    }
    else
    {
        [self showMessage:@"请选择商品"];
    }
}

// 显示收藏结果
- (void)showAddCollectResult {
    NSMutableString *resultString = [NSMutableString string];
    BOOL ifAll = YES;
    for (NSNumber * num in _resultArray) {
        if (num.integerValue > 0) {
            ifAll = NO;
            break;
        }
    }
    if (ifAll == NO) {
        NSArray * arr = [_resultArray sortedArrayUsingComparator:^NSComparisonResult(NSNumber * obj1, NSNumber * obj2) {
            if ([obj1 integerValue] > [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            
            if ([obj1 integerValue] < [obj2 integerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        for (NSNumber * num in arr) {
            if (num.integerValue > 0 ) {
                [resultString appendFormat:[NSString stringWithFormat:@"%ld ", [num integerValue]]];
            }
        }
        [self showMessage:[NSString stringWithFormat:@"第 %@件已收藏", resultString]];
        [_resultArray removeAllObjects];
    } else {
        [_resultArray removeAllObjects];
        [self showSuccessMessage:@"添加成功"];
    }
}

-(void)showErrorWithStr:(NSString *)str
{
    [self showErrorMessage:str];
}


@end
