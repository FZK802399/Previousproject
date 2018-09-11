//
//  DZYMerchandiseDetailController.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/27.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "DZYMerchandiseDetailController.h"
#import "DZYSubmitOrderController.h"
#import "ShoppingCartViewController.h"
#import "MerchandiseSpecificationItem.h"
#import "DZYSelectView.h"
#import "DZYADView.h"
#import "DZYTools.h"
#import "TSLocateView.h"
#import <objc/runtime.h>
#import "ChaiDan.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "MerchandisePriceCell.h"
#import "DispathCell.h"
#import "DetailCell.h"
#import "CommentCellOne.h"
#import "DZYShowImageView.h"

#import "MerchandiseDetailModel.h"
#import "FootMarkModel.h"
#import "MerchandiseDetailModel.h"
#import "OrderMerchandiseSubmitModel.h"
#import "MerchandiseSpecificationPriceModel.h"
#import "MerchandisePingJiaModel.h"
#import "ShopCartMerchandiseModel.h"
#import "ChatViewController.h"
#import "EMIMHelper.h"

//static char addressCell;
@interface DZYMerchandiseDetailController ()<UITableViewDelegate,UITableViewDataSource,SelectDelegate,MerchandisePriceCellDeleagte,MerchandiseSpecficationItemDelegate,IChatManagerDelegate,UIAlertViewDelegate,UIWebViewDelegate,UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) DZYSelectView * selectView;
@property (weak, nonatomic) UITableView * mainTable;
@property (weak, nonatomic) UITableView * commentTable;
///单独的商品详情界面
@property (weak, nonatomic) UIWebView * detailWeb;
///商品页面详情web
@property (weak, nonatomic) UIWebView * goodsWeb;
@property (strong, nonatomic) MerchandiseSpecificationItem *specificationItem;
@property (nonatomic, strong) UIView *backImageView;

@property (nonatomic,strong)MerchandiseDetailModel * currentModel;
@property (strong, nonatomic) OrderMerchandiseSubmitModel * subimitModel;
@property (nonatomic,strong)NSMutableArray * commentArr;

///限购量
@property (nonatomic,assign)NSInteger shopcartMaxCount;
///判断是否滚动（用来处理bar的点击事件和scrollView的手势滑动事件）
@property (nonatomic,assign)BOOL Scrolling;
///区域是否有库存
@property (nonatomic,assign)BOOL isAreaStock;
///添加购物车或者立即购买
@property (assign, nonatomic) NextStepType stepType;
///是否选择配送区域
@property (assign, nonatomic)BOOL selectDispath;
///购物车商品数量
@property (weak, nonatomic) IBOutlet UIButton *goodsNum;

@property (weak, nonatomic) IBOutlet UIButton *KeFuBtn;
@end

@implementation DZYMerchandiseDetailController

+(instancetype)create
{
    return [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil]instantiateViewControllerWithIdentifier:@"DZYMerchandiseDetailController"];
}

- (MerchandiseSpecificationItem *) specificationItem {
    if (!_specificationItem) {
        _specificationItem = [[MerchandiseSpecificationItem alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _specificationItem.delegate  =self;
    }
    return  _specificationItem;
}

-(NSMutableArray *)commentArr
{
    if (_commentArr == nil) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicStep];
    
}

-(void)basicStep
{
//    [self huanXinLogin];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud hide:YES];
    });
    
    self.goodsNum.layer.cornerRadius = 7;
    self.goodsNum.layer.borderColor = [UIColor redColor].CGColor;
    self.goodsNum.layer.borderWidth = 1;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.Scrolling = NO;
    CGFloat height = self.view.bounds.size.height - 50 - 64;
    self.scrollView.contentSize = CGSizeMake(LZScreenWidth*3,height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    
    UITableView * mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, height) style:UITableViewStylePlain];
    mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.tag = 101;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.scrollView addSubview:mainTable];
    self.mainTable = mainTable;
    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(LZScreenWidth, 0, LZScreenWidth, height)];
    webView.scrollView.showsVerticalScrollIndicator = NO;
    webView.scrollView.delegate = self;
    [self.scrollView addSubview:webView];
    self.detailWeb = webView;
    
    UITableView * commentTable = [[UITableView alloc]initWithFrame:CGRectMake(LZScreenWidth*2, 0, LZScreenWidth, height) style:UITableViewStylePlain];
    commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    commentTable.tag = 102;
    commentTable.delegate = self;
    commentTable.dataSource = self;
    commentTable.backgroundColor = BACKGROUND_GRAY;
    [self.scrollView addSubview:commentTable];
    self.commentTable = commentTable;
    
    ///暂无评论的视图
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(LZScreenWidth*2, 0, LZScreenWidth, height)];
    view.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    view.tag = 99;
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake((LZScreenWidth-70)/2.0, (height-70)/2.0-80, 70, 70)];
    imgView.image = [UIImage imageNamed:@"no_comment"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((LZScreenWidth-70)/2.0-5, CGRectGetMaxY(imgView.frame), 70, 30)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"暂无评论";
    label.textColor = [UIColor colorWithRed:187.0/255.0 green:187.0/255.0 blue:187.0/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:16];
    
    [view addSubview:imgView];
    [view addSubview:label];
    [self.scrollView addSubview:view];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:self action:@selector(ShareBtnClick:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginEnd) name:HUANXIN_LOGINEND_NOTICE object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    DZYSelectView * selectView = [[DZYSelectView alloc]initWithFrame:CGRectMake((LZScreenWidth-180)/2, 0, 180, 40) dataSource:[NSMutableArray arrayWithObjects:@"商品",@"详情",@"评价",nil] delegate:self normalColor:FONT_BLACK selectedColor:FONT_BLACK lineColor:FONT_BLACK fontNum:13];
    [self.navigationController.navigationBar addSubview:selectView];
    selectView.firstClick = 0;
    self.selectView = selectView;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.selectView removeFromSuperview];
}

#pragma 获取商品详情
-(void)loadCommonProductDetail{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * detailDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                _Guid,@"id",
                                config.appSign,@"AppSign",
                                config.loginName,@"MemLoginID",nil];
    [MerchandiseDetailModel getMerchandiseDetailByParamer:detailDic andblock:^(MerchandiseDetailModel *detail, NSError *error) {
        if (error) {
            //            [self showAlertWithMessage:@"网络错误"];
        }else {
            if (detail.guid) {
                _currentModel = detail;
// MARK: 滚动广告
                DZYADView * adView = [[DZYADView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 250) ImageUrlList:detail.imagesList];
                _mainTable.tableHeaderView = adView;
                
                NSString * str = [NSString stringWithFormat:@"<head><style>img{max-width:%.0fpx !important;}</style></head>%@",LZScreenWidth-14,_currentModel.MobileDetail];
                [_detailWeb loadHTMLString:str baseURL:[NSURL URLWithString:kWebMainBaseUrl]];
                
                _shopcartMaxCount = detail.repertoryCount;
                ///添加足迹
                [self addFootMarkWithConfig:config model:detail];
                ///创建规格视图
                [self.specificationItem createSpecification:detail];
                [_mainTable reloadData];
            }
        }
    }];
}

///获取购物车商品数量
- (void)loadShopCartNum
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    if (config.shopCartNum > 0) {
        self.goodsNum.hidden = NO;
        [self.goodsNum setTitle:@(config.shopCartNum).stringValue forState:UIControlStateNormal];
    }
    else
    {
        self.goodsNum.hidden = YES;
    }
    
//    NSDictionary * shopcartDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  config.loginName,@"loginId",
//                                  config.appSign,@"AppSign",
//                                  nil];
//    [ShopCartMerchandiseModel getShopCartMerchandiseListByParamer:shopcartDic andblock:^(NSArray *shopCartList, NSError *error) {
//        if (error) {
//            [MBProgressHUD showError:@"网络错误"];
//        }else{
//            NSInteger count = [shopCartList count];
//            if (count > 0) {
//                self.goodsNum.hidden = NO;
//
//            }else{
//                self.goodsNum.hidden = YES;
//            }
//        }
//    }];

}

#pragma mark - 添加足迹
-(void)addFootMarkWithConfig:(AppConfig *)config model:(MerchandiseDetailModel *)detail
{
    ///添加足迹
    NSDictionary * addDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             config.appSign,@"AppSign",
                             detail.guid, @"ProductGuid",
                             detail.name, @"ProductName",
                             detail.originalImageStr, @"ProductOriginalImge",
                             [NSString stringWithFormat:@"%.2f", detail.shopPrice],@"ProductShopPrice",
                             [NSString stringWithFormat:@"%.2f", detail.marketPrice],@"ProductMarketPrice",
                             config.loginName, @"MemLoginID", nil];
    [FootMarkModel addFootMarkByparameters:addDic andblock:^(NSInteger reslut, NSError *error) {
        if (error) {
            
        }else{
            
            if (reslut == 202) {
                
            }
        }
    }];
}

#pragma mark - 获取评价
- (void)loadPinJiaData {
    // 添加评论及晒图，调接口
    //fxmhv811app.groupfly.cn/api/getproductassess?AppSign=8bffae3f7bc59d3821be2081e21728bf&startPage=1&pageSize=5&productID=9D0A20CA-242F-450C-8E74-96053162A305
    AppConfig * config =[AppConfig sharedAppConfig];
    [config loadConfig];
    [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"productID"] = _currentModel.guid;
    dict[@"AppSign"] = config.appSign;
    dict[@"startPage"] = @"1";
    dict[@"pageSize"] = @"100";
    [MerchandisePingJiaModel fetchMerchandisePingJiaListWithParameters:dict block:^(NSArray *list, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        if (error) {
            //            [self showAlertWithMessage:@"获取评论信息失败"];
        } else {
            if (list.count == 0) {
//                [MBProgressHUD showError:@"暂无评价"];
                [self.scrollView bringSubviewToFront:[self.scrollView viewWithTag:99]];
            } else {
                [self.commentArr addObjectsFromArray:list];
                [self.scrollView bringSubviewToFront:self.commentTable];
            }
            [self.commentTable reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 101) {
//        return 3;
        return 2;
    }
    return self.commentArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) {
        if (indexPath.row == 0) {
           MerchandisePriceCell* cell = [[NSBundle mainBundle]loadNibNamed:@"MerchandisePriceCell" owner:nil options:nil].lastObject;
            cell.delegate = self;
            if (_currentModel) {
                cell.model = _currentModel;
            }
            return cell;
        }
        /*
        else if (indexPath.row == 1)
        {
            DispathCell * cell = [[NSBundle mainBundle]loadNibNamed:@"DispathCell" owner:nil options:nil].lastObject;
            return cell;
        }
         */
        else if (indexPath.row == 1)
        {
            DetailCell * cell = [[NSBundle mainBundle]loadNibNamed:@"DetailCell" owner:nil options:nil].lastObject;
            cell.webView.scrollView.delegate = self;
            cell.webView.delegate = self;
            cell.webView.scrollView.tag = 66;
            cell.webView.scrollView.scrollEnabled = NO;
            
            UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            [cell.webView addGestureRecognizer:singleTap];
            singleTap.delegate = self;
            singleTap.cancelsTouchesInView = NO;
            
            self.goodsWeb = cell.webView;
            if (_currentModel) {
                NSString * str = [NSString stringWithFormat:@"<head><style>img{max-width:%.0fpx !important;}</style></head>%@",LZScreenWidth-14,_currentModel.MobileDetail];
                [cell.webView loadHTMLString:str baseURL:[NSURL URLWithString:kWebMainBaseUrl]];
            }
            return cell;
        }
    }
    else{
        CommentCellOne * cell = [[NSBundle mainBundle]loadNibNamed:@"CommentCellOne" owner:nil options:nil].lastObject;
        cell.model = [self.commentArr objectAtIndex:indexPath.row];
        return cell;
    }
    return nil;
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) {
        if (indexPath.row == 1) {
            DispathCell * cell = (DispathCell *)[tableView cellForRowAtIndexPath:indexPath];
            TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"选择城市" delegate:self];
            objc_setAssociatedObject(locateView, &addressCell, cell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            [locateView showInView:self.view];
        }
    }
}
 */

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) {
        if (indexPath.row == 0) {
            if (_currentModel) {
                return [self getMerchandisePriceCellHeight];
            }
            else
            {
                return 133;
            }
        }/*
        else if (indexPath.row == 1)
        {
            return 61;
        }*/
        else if (indexPath.row == 1)
        {
            return self.view.frame.size.height - 31 - 50;
        }
        return 44;
    }
    else
    {
        //17.5 一行字的高度
        if (self.commentArr.count > 0) {
            MerchandisePingJiaModel * model = self.commentArr[indexPath.row];
            CGFloat height = [self getHeightWithStr:model.content width:LZScreenWidth-20-58 FontNum:13];
            if (model.attributes.length > 0) {
                return height + 5 + 13 + 17 + 13 + 25 ;
            }
            else{
                return height + 5 + 13 + 17 + 13 + 10 ;
            }
        }
        return 111;
    }
}

/////选择配送地区
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    TSLocateView * loca = (TSLocateView *)actionSheet;
//    if(buttonIndex == 0) {
//        
//    }else {
//        DispathCell * cell = objc_getAssociatedObject(loca, &addressCell);
//        cell.address.text = [NSString stringWithFormat:@"%@%@%@", loca.procinelocate.name, loca.citylocate.name ,loca.regionlocate.name];
//        [self checkAreaStockByProvinceCode:loca.procinelocate.code andCityCode:loca.citylocate.code andRegionCode:loca.regionlocate.code cell:cell];
//    }
//}

////区域库存查询
//-(void)checkAreaStockByProvinceCode:(NSString *)ProvinceCode andCityCode:(NSString *)CityCode andRegionCode:(NSString *)RegionCode cell:(DispathCell *)cell
//{
//    AppConfig * config = [AppConfig sharedAppConfig];
//    [config loadConfig];
//    NSDictionary * stockDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                               _currentModel.guid,@"ProducGuid",
//                               ProvinceCode,@"province",
//                               CityCode,@"city",
//                               RegionCode,@"region",
//                               config.appSign, @"AppSign",
//                               nil];
//    [MerchandiseDetailModel getMerchandiseAreaStockByParamer:stockDic andblock:^(NSInteger result, NSError *error) {
//        if (error) {
//            [MBProgressHUD showError:@"网络错误"];
//        }else {
//            cell.kucun.hidden = NO;
//            self.selectDispath = YES;
//            if (result == 202) {
//                _isAreaStock = YES;
//                cell.kucun.text = @"有货";
//                cell.kucun.textColor = MAIN_ORANGE;
//            }else{
//                _isAreaStock = NO;
//                cell.kucun.text = @"无货";
//                cell.kucun.textColor = [UIColor redColor];
//            }
//        }
//    }];
//}

#pragma mark - 计算价格视图的高
-(CGFloat )getMerchandisePriceCellHeight
{
    CGFloat height = 133;
    CGFloat nameH = [self getHeightWithStr:_currentModel.name width:LZScreenWidth-8-65 FontNum:13];
    CGFloat smallH = [self getHeightWithStr:_currentModel.SmallTitle width:LZScreenWidth-8-65 FontNum:12];
    CGFloat jieshaoH = [self getHeightWithStr:_currentModel.Brief width:LZScreenWidth-8-65 FontNum:12];
    if (nameH > 20) {
        height += 18;
    }
    
    if (smallH > 20 && smallH < 40) {
        height += 20;
    }
    else if (smallH > 40 ) {
        height += 40;
    }
    
    if (jieshaoH > 20 && jieshaoH < 40) {
        height += 15;
    }
    else if (jieshaoH > 40 ) {
        height += 30;
    }
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 滑动事件相关
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.scrollView]) {
         self.Scrolling = NO;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if([scrollView isEqual:self.scrollView])
    {
        if (self.Scrolling == NO) {
            NSInteger i = scrollView.contentOffset.x/LZScreenWidth;
            UIButton * btn = self.selectView.btnArr[i];
            if (btn.selected == NO) {
                [btn sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    if (scrollView.tag == 66) {
        CGFloat y = -scrollView.contentOffset.y;
        if (y > 100) {
            [self.mainTable scrollRectToVisible:CGRectMake(0, 0, LZScreenWidth, 50) animated:YES];
            self.goodsWeb.scrollView.scrollEnabled = NO;
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row == 0) {
        self.goodsWeb.scrollView.scrollEnabled = YES;
    }
}

#pragma mark - barBtnClick
-(void)selectWithSelectView:(DZYSelectView *)selectView btn:(UIButton *)btn
{
    CGFloat height = self.view.bounds.size.height - 50 - 64;
    switch (btn.tag) {
        case 0:
        {
            self.Scrolling = YES;
            if (_currentModel == nil) {
                [self loadCommonProductDetail];
                [self loadShopCartNum];
            }
            if (_firstIn == NO) {
                _firstIn = YES;
            }
            else
            {
                [self.scrollView scrollRectToVisible:CGRectMake(0, 0, LZScreenWidth, height) animated:YES];
            }
            break;
        }
        case 1:
        {
            self.Scrolling = YES;
            [self.scrollView scrollRectToVisible:CGRectMake(LZScreenWidth, 0, LZScreenWidth, height) animated:YES];
            break;
        }
        default:
        {
            if (self.commentArr.count == 0) {
                [self loadPinJiaData];
            }
            self.Scrolling = YES;
            [self.scrollView scrollRectToVisible:CGRectMake(2*LZScreenWidth, 0, LZScreenWidth, height) animated:YES];
            break;
        }
    }
}

-(CGFloat)getContentOffsetY
{
    return self.mainTable.contentOffset.y;
}

#pragma mark - 收藏
-(void)merchandisePriceCell:(MerchandisePriceCell *)cell favoBtnDidClick:(UIButton *)btn
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    if (![config isLogin]) {
        //        [self performSegueWithIdentifier:kSegueFavToLogin sender:self];
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
    }else{
        NSDictionary * addCollectDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        config.loginName,@"MemLoginID",
                                        _currentModel.guid,@"productGuid",
                                        config.appSign,@"AppSign",nil];
        [MerchandiseDetailModel addMerchandiseToCollectByParamer:addCollectDic andblock:^(NSInteger result, NSError *error) {
            if (error) {
                
            }else {
                if (result == 202) {
                    [cell favoSuccess];
                    [MBProgressHUD showSuccess:@"收藏成功"];
                }else {
                    [MBProgressHUD showSuccess:@"收藏失败"];
                }
            }
        }];
    }
}

-(void)createFinished{
    NSLog(@"Frame : %@", NSStringFromCGRect(self.specificationItem.frame));
    
}

// 规格视图关闭
-(void)closeFinished{
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
}

//根据规格参数查询价格库存
-(void)chooseSpec{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * priceDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               _currentModel.guid,@"productGuid",
                               [NSString stringWithFormat:@"%@", _specificationItem.specificationName], @"Detail",
                               config.appSign, @"AppSign", config.loginName,@"MemLoginID", nil];
    [MerchandiseSpecificationPriceModel getPriceWithparameters:priceDic andblock:^(MerchandiseSpecificationPriceModel *price, NSError *error) {
        if (error) {
            
        }else {
            if (price) {
                _shopcartMaxCount = price.GoodsStock;
                [_specificationItem setRepertoryCount:price.GoodsStock];
                [_specificationItem setShopPrice:price.GoodsPrice];
            }
            
        }
    }];
}

//确定按钮  规格视图
-(void)sureBtnFinished{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    _subimitModel = [[OrderMerchandiseSubmitModel alloc] init];
    _subimitModel.Attributes = _specificationItem.specificationValue;
    _subimitModel.Name = _currentModel.name;
    _subimitModel.BuyNumber = _specificationItem.selectCount;
    _subimitModel.BuyPrice = _currentModel.shopPrice;
    _subimitModel.Guid = _currentModel.guid;
    _subimitModel.MarketPrice = _currentModel.marketPrice;
    _subimitModel.MemLoginID = config.loginName;
    _subimitModel.OriginalImge = _currentModel.originalImageStr;
    _subimitModel.ProductGuid = _currentModel.guid;
    _subimitModel.SpecificationName = _specificationItem.specificationName;
    _subimitModel.SpecificationValue = @"";
    _subimitModel.ShopID = @"0";
    _subimitModel.ShopName = @"";
    _subimitModel.CreateTime = [NSDate date];
    _subimitModel.IsJoinActivity = 0;
    _subimitModel.IsPresent = 0;
    _subimitModel.RepertoryNumber = @"JK";
    _subimitModel.ExtensionAttriutes = @"M";
    _subimitModel.CouponRule  = _currentModel.CouponRule;
    _subimitModel.MemberI=_currentModel.MemberI;
    ///税费
    _subimitModel.IncomeTax = _currentModel.IncomeTax;
    
    _currentModel.buyNumber = _specificationItem.selectCount;
    //添加购物车
    if (self.stepType == AddShopCart) {
        if (_specificationItem.selectCount > _currentModel.LimitBuyCount && _currentModel.LimitBuyCount != 0) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"超过最大限制购买数量，限购数量为%ld",_currentModel.LimitBuyCount]];
            return;
        }
        
        if (_shopcartMaxCount > _currentModel.LimitBuyCount && _currentModel.LimitBuyCount != 0) {
            _shopcartMaxCount = _currentModel.LimitBuyCount;
        }
        
        NSDictionary * addDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%ld",_specificationItem.selectCount],@"BuyNumber",
                                 _specificationItem.specificationValue,@"Attributes",
                                 [NSString stringWithFormat:@"%f",_currentModel.shopPrice],@"BuyPrice",
                                 _currentModel.guid,@"ProductGuid",
                                 _specificationItem.specificationName,@"DetailedSpecifications",
                                 [NSNumber numberWithInteger:_shopcartMaxCount],@"ExtensionAttriutes",
                                 config.loginName,@"MemLoginID",
                                 config.appSign, @"AppSign", nil];
        
        ZDXWeakSelf(weakSelf);
        [MerchandiseDetailModel addMerchandiseToShopCartByParamer:addDic andblock:^(NSInteger result, NSError *error) {
            if (error) {
                
            }else{
                if (result == 202) {
                    [MBProgressHUD showSuccess:@"添加成功"];
                    [self loadShopCartNum];
                    NSInteger count = 0;
                    count += config.shopCartNum;
                    count += _specificationItem.selectCount;
                    config.shopCartNum = count;
                    [config saveConfig];
                    [_specificationItem removeFromSuperview];
                    [weakSelf closeFinished];
                    [self loadShopCartNum];
                    [[NSNotificationCenter defaultCenter]postNotificationName:KNotificationGoodsChange object:nil];
                }
                else if (result == 101){
                    [MBProgressHUD showError:@"超过限购量(*包含购物车中该商品的数量)"];
                }
                else if (result == 100){
                    [MBProgressHUD showError:@"库存不足(*包含购物车中该商品的数量)"];
                }
                else {
                    [MBProgressHUD showError:@"添加失败"];
                }
            }
        }];
    }else{
        if (_specificationItem.selectCount > _currentModel.LimitBuyCount && _currentModel.LimitBuyCount != 0) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"超过最大限制购买数量，限购数量为%ld",_currentModel.LimitBuyCount]];
            return;
        }
        [_specificationItem removeFromSuperview];
        [self closeFinished];
        //购买
        //            [self performSegueWithIdentifier:kSegueDetailToBuy sender:self];
        DZYSubmitOrderController * sovc = [DZYSubmitOrderController create];
        [ChaiDanModel getRateWithBlock:^(CGFloat rate,CGFloat PostageMoney,CGFloat SplitPostageMoney) {
            if (rate != -1) {
                sovc.productArr = [ChaiDan ChanDanWithArr:[NSMutableArray arrayWithObject:_subimitModel] Rate:rate];
                sovc.PostageMoney = PostageMoney;
                sovc.SplitPostageMoney = SplitPostageMoney;
                [self.navigationController pushViewController:sovc animated:YES];
            }
            else
            {
                [MBProgressHUD showMessage:@"网络错误，请稍候再试" hideAfterTime:2];
            }
        }];
        
    }
}

///工具方法
-(CGFloat )getHeightWithStr:(NSString *)Str width:(CGFloat )width FontNum:(NSInteger )fontNum
{
    return [Str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontNum]} context:nil].size.height;
}

#pragma mark - 联系客服
- (IBAction)kefuClick:(id)sender {
//    AppConfig * config = [AppConfig sharedAppConfig];
//    [config loadConfig];
//    if (![config isLogin]) {
//        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
//        return;
//    }
//    else{
    self.KeFuBtn.userInteractionEnabled = NO;
        [[EMIMHelper defaultHelper] loginEasemobSDK];
    
//        NSString *cname = [[EMIMHelper defaultHelper] cname]; //登录帐号
    
//    }
}

///异步登录以后的通知
- (void)loginEnd
{
    self.KeFuBtn.userInteractionEnabled = YES;
    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"注意" message:@"请选择是否发送商品信息" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    alertView.tag = 99;
    [alertView show];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        ChatViewController * chatController = [[ChatViewController alloc] initWithChatter:@"food7" type:eAfterSaleType];
        chatController.title = @"客服";
        if (buttonIndex == 0) {  //否
            chatController.commodityInfo = nil;
        }else{
            chatController.commodityInfo = @{@"type":@"track", @"title":@"EFOOD", @"imageName":@"", @"desc":_currentModel.name, @"price":[NSString stringWithFormat:@"AU$%.2f",_currentModel.shopPrice], @"img_url":_currentModel.originalImageStr, @"item_url":[NSString stringWithFormat:@"http://senghongwap.efood7.com/pages/ProductDetail.html?id=%@",_currentModel.guid]};
        }
        [self.navigationController pushViewController:chatController animated:YES];
    }
}

#pragma mark - 前往购物车
- (IBAction)shopCartClick:(id)sender {
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    if (![config isLogin]) {
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
        return;
    }
    ShoppingCartViewController * shopCart = [ShoppingCartViewController create];
    [self.navigationController pushViewController:shopCart animated:YES];
}

#pragma mark - 立即购买 或者 添加购物车

- (IBAction)addShopCartOrBuyNow:(UIButton *)sender {
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    UIButton * btn = (UIButton *)sender;
    
    if (![config isLogin]) {
        [self presentViewController:ZDX_LOGIN animated:YES completion:nil];
    }else{
        if (_currentModel.repertoryCount <= 0) {
            [MBProgressHUD showError:@"该商品库存不足"];
            return;
        }
        
//        if (self.selectDispath == NO) {
//            [MBProgressHUD showError:@"请选择配送地区"];
//            return;
//        }
//        
//        if (!_isAreaStock) {
//            [MBProgressHUD showError:@"该区域无货不能配送"];
//            return;
//        }
        
        if (!self.backImageView) {
            self.backImageView = [[UIView alloc] initWithFrame:self.view.bounds];
            self.backImageView.backgroundColor = [UIColor blackColor];
            self.backImageView.alpha = 0.3f;
            self.backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        }
        
        [self.view addSubview:self.backImageView];
        [self.view addSubview:_specificationItem];
        if (btn.tag == 1) {
            self.stepType = AddShopCart;
        }
        else
        {
            self.stepType = GoBUY;
        }
    }
}

#pragma mark - 分享
-(IBAction)ShareBtnClick:(id)sender {
    
    NSString *shareURL = [NSString stringWithFormat:@"http://senghongwap.efood7.com/pages/ProductDetail.html?id=%@",_currentModel.guid];
    //1、创建分享参数
    NSArray* imageArray = @[_currentModel.originalImageStr];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:_currentModel.name
                                         images:imageArray
                                            url:[NSURL URLWithString:shareURL]
                                          title:@"Efood7来自澳洲的出口商"
                                           type:SSDKContentTypeAuto];
        
        [shareParams SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@",_currentModel.name,shareURL]
                                                   title:@"Efood7来自澳洲的出口商"
                                                   image:imageArray
                                                     url:[NSURL URLWithString:shareURL]
                                                latitude:0
                                               longitude:0
                                                objectID:@"分享"
                                                    type:SSDKContentTypeImage];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:HUANXIN_LOGINEND_NOTICE object:nil];
}

#pragma mark - 商品详情点击事件
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    CGPoint pt = [sender locationInView:self.goodsWeb];
    NSString *imgURL = [NSString stringWithFormat:@"document.elementFromPoint(%f, %f).src", pt.x, pt.y];
    NSString *urlToSave = [self.goodsWeb stringByEvaluatingJavaScriptFromString:imgURL];
//    NSLog(@"image url=%@", urlToSave);
    if (![urlToSave isEqualToString:@""]) {
        [self showImageWithUrl:urlToSave];
    }
}

-(void)showImageWithUrl:(NSString *)url
{
    DZYShowImageView * view = [[DZYShowImageView alloc]initWithFrame:[UIScreen mainScreen].bounds url:url];
    [view show];
}
@end
