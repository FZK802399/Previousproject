//
//  ShopCartViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-4.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ShopCartViewController.h"
#import "LoginViewController.h"
#import "ShopCartTableViewCell.h"
#import "MerchandiseDetailModel.h"
#import "ShopCartMerchandiseModel.h"
#import "OrderMerchandiseSubmitModel.h"
#import "SubmitOrderViewController.h"
#import "MerchandiseDetailViewController.h"
#import "ShopCartScoreMerchandiseModel.h"

//----------------------------------------------------------------------------

@interface ShopCartViewController ()<ShopCartTableViewCellDelegate>

@end

@implementation ShopCartViewController{
    //提交的商品数组
    NSMutableArray * submitArray;
    //商品总重量
    CGFloat allProductWeight;
    
    NSInteger allScore;
    
    NSString * productGuid;
    
    NSInteger ProductType;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.tabBarController.tabBar.hidden) {
        [self loadLeftBackBtn];
    }
    
    [self.topView setBackgroundColor:[self getMatchTopColor]];
    
//    self.navigationController.tabBarItem.badgeValue = nil;
    self.shopcartTableView.layer.borderWidth = 1;
    self.shopcartTableView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.allCheckBtn.delegate = self;
    [self.allCheckBtn setImage:[UIImage imageNamed:@"shopcart_uncheck.png"] forState:UIControlStateNormal];
    [self.allCheckBtn setImage:[UIImage imageNamed:@"shopcartAllCheck.png"] forState:UIControlStateSelected];
    UIView * footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    self.shopcartTableView.tableFooterView = footView;
    // Do any additional setup after loading the view.
    
    self.gobuyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.tabBarController.tabBar setHidden:NO];
//    self.navigationController.tabBarItem.badgeValue  = [NSString stringWithFormat:@"%d", self.appConfig.shopCartNum];
    [self.allCheckBtn setSelected:NO];
    if (![self.appConfig isLogin]) {
        [self performSegueWithIdentifier:kSegueShopCartToLogin sender:self];
    }else{
        [self changeTabViewAction:self.commonBtn];
    }

}



-(void)loadScoreShopCartData {
    [self.shopCartData removeAllObjects];
    [self.shopcartTableView reloadData];
    NSDictionary * shopcartDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.appConfig.loginName,@"MemLoginID",
                                  kWebAppSign,@"AppSign",
                                  nil];
    [ShopCartScoreMerchandiseModel getScoreShopCartMerchandiseListByParamer:shopcartDic andblock:^(NSArray *shopCartList, NSError *error) {
        if (error) {
            [self showAlertWithMessage:@"网络错误"];
        }else{
            NSInteger count = [shopCartList count];
            if (count > 0) {
                
//                NSInteger sum = 0;
//                for (ShopCartMerchandiseModel *shopcart in shopCartList) {
//                    sum += shopcart.buyNumber;
//                }
//                self.appConfig.shopCartNum = sum;
//                [self.appConfig saveConfig];
                
                [self.shopcartTableView setHidden:NO];
                self.shopCartData = [NSMutableArray arrayWithArray:shopCartList];
                [self.shopcartTableView reloadData];
                [self.noProductImage setHidden:YES];
                [self.noProductLabel setHidden:YES];
                [self.bottomView setHidden:NO];
                [self setTotalCount];
                [self setShopCardTotalPrice];
                
            }else{
//                [self.appConfig loadConfig];
//                self.appConfig.shopCartNum = 0;
//                [self.appConfig saveConfig];
//                self.navigationController.tabBarItem.badgeValue = nil;
                
                [self.shopcartTableView setHidden:YES];
                [self.noProductImage setHidden:NO];
                [self.noProductLabel setHidden:NO];
                [self.bottomView setHidden:YES];
            }
            
            
        }
    }];
    
}


-(void)loadShopCartData {
    [self.shopCartData removeAllObjects];
    NSDictionary * shopcartDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.appConfig.loginName,@"loginId",
                                  kWebAppSign,@"AppSign",
                                  nil];
    [ShopCartMerchandiseModel getShopCartMerchandiseListByParamer:shopcartDic andblock:^(NSArray *shopCartList, NSError *error) {
        if (error) {
            [self showAlertWithMessage:@"网络错误"];
        }else{
            NSInteger count = [shopCartList count];
            if (count > 0) {
                
                NSInteger sum = 0;
                for (ShopCartMerchandiseModel *shopcart in shopCartList) {
                    sum += shopcart.buyNumber;
                }
                self.appConfig.shopCartNum = sum;
                [self.appConfig saveConfig];
                
                [self.shopcartTableView setHidden:NO];
                self.shopCartData = [NSMutableArray arrayWithArray:shopCartList];
                [self.shopcartTableView reloadData];
                [self.noProductImage setHidden:YES];
                [self.noProductLabel setHidden:YES];
                [self.bottomView setHidden:NO];
                [self setTotalCount];
                [self setShopCardTotalPrice];
                
            }else{
                [self.appConfig loadConfig];
                self.appConfig.shopCartNum = 0;
                [self.appConfig saveConfig];
                self.navigationController.tabBarItem.badgeValue = nil;

                [self.shopcartTableView setHidden:YES];
                [self.noProductImage setHidden:NO];
                [self.noProductLabel setHidden:NO];
                [self.bottomView setHidden:YES];
            }
        
        
        }
    }];
    
}

-(void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{

    if (checked) {
        for (ShopCartMerchandiseModel * tempModel in self.shopCartData) {
            tempModel.isCheckForShopCart = YES;
        }
    }else{
        for (ShopCartMerchandiseModel * tempModel in self.shopCartData) {
            tempModel.isCheckForShopCart = NO;
        }
    }
    [self.shopcartTableView reloadData];
    [self setShopCardTotalPrice];
    [self setTotalCount];
    
}

//获取所有商品的重量
-(CGFloat)getAllProductWeight{
    return 0;
}

-(void)btnCheckOrUnCheck:(id)merchandise status:(Boolean)isCheck{
    [self setShopCardTotalPrice];
    [self setTotalCount];
}

-(void)countAdd:(id)merchandise{
    
    [self setTotalBadgeCount];
    if ([merchandise isCheckForShopCart]) {
        [self setShopCardTotalPrice];
        [self setTotalCount];
    }
}

-(void)countSubtract:(id)merchandise{
    
    [self setTotalBadgeCount];
    if ([merchandise isCheckForShopCart]) {
        [self setShopCardTotalPrice];
        [self setTotalCount];
    }

}


- (void)setShopCardTotalPrice{
    _allTotalPrice = 0;
    allScore = 0;
    
    if (ProductType == 1) {
        for (ShopCartScoreMerchandiseModel *model in self.shopCartData) {
            if(model.isCheckForShopCart){
                _allTotalPrice += model.buyNumber * model.prmo;
                allScore += model.buyNumber * model.buyScore;
            }
        }
        
        if(_allTotalPrice < 0){
            _allTotalPrice = 0;
        }
        
        self.totalPrice.text = [NSString stringWithFormat:@"AU$%.2f + %d积分",_allTotalPrice, allScore];
        
    }else {
        for (ShopCartMerchandiseModel *model in self.shopCartData) {
            if(model.isCheckForShopCart){
                _allTotalPrice += model.buyNumber * model.buyPrice;
            }
        }
        
        if(_allTotalPrice < 0){
            _allTotalPrice = 0;
        }
        
        self.totalPrice.text = [NSString stringWithFormat:@"AU$%.2f",_allTotalPrice];
    }
    
}

-(void)setTotalBadgeCount{
    int badgeInt = 0;
    for (ShopCartMerchandiseModel *model in self.shopCartData) {
        badgeInt += model.buyNumber;
    }
    if (badgeInt > 99) {
        badgeInt = 99;
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d.", badgeInt];
    }else {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", badgeInt];
    }
}

- (void)setTotalCount{
    
    int count = 0;
    if (ProductType == 1) {
        for (ShopCartScoreMerchandiseModel *model in self.shopCartData) {
            if(model.isCheckForShopCart){
                count += model.buyNumber;
                
            }
        }
        [self.gobuyBtn setTitle:[NSString stringWithFormat:@"去结算(%d)",count] forState:UIControlStateNormal];
        
    }else {
        for (ShopCartMerchandiseModel *model in self.shopCartData) {
            if(model.isCheckForShopCart){
                count += model.buyNumber;
                
            }
        }
        [self.gobuyBtn setTitle:[NSString stringWithFormat:@"去结算(%d)",count] forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView数据源代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    
    rows = [self.shopCartData count];
    
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopCartTableViewCell *cell = (ShopCartTableViewCell*)[tableView dequeueReusableCellWithIdentifier:kShopCartTableViewCellMainView];
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    if (ProductType == 1) {
        
    }else {
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor whiteColor] icon:[UIImage imageNamed:@"btn_shopcart_move.png"] andLightImage:[UIImage imageNamed:@"btn_shopcart_move_selected.png"]];
    }
    [rightUtilityButtons addUtilityButtonWithColor:
     [UIColor whiteColor] icon:[UIImage imageNamed:@"btn_shopcart_delete.png"] andLightImage:[UIImage imageNamed:@"btn_shopcart_delete_selected.png"]];
    
    cell = [[ShopCartTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                        reuseIdentifier:kShopCartTableViewCellMainView
                                    containingTableView:tableView // Used for row height and selection
                                     leftUtilityButtons:nil
                                    rightUtilityButtons:rightUtilityButtons];
    if (ProductType == 1) {
        [cell creatShopCartTableViewCellWithShopCartScoreMerchandiseModel:[self.shopCartData objectAtIndex:indexPath.row]];
    }else {
        [cell creatShopCartTableViewCellWithShopCartMerchandiseModel:[self.shopCartData objectAtIndex:indexPath.row]];
    }
    
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   
}


-(void)clickImageOrTitle:(id)merchandise{

    productGuid = [merchandise productGuid];
    [self performSegueWithIdentifier:kSegueShopCartToDetail sender:self];
}


#pragma mark - SWTableViewDelegate

- (void)swippableTableViewCell:(ShopCartTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:

            break;
        case 1:

            break;
        case 2:

            break;
        case 3:

        default:
            break;
    }
}

- (void)swippableTableViewCell:(ShopCartTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (ProductType == 1) {
        switch (index) {
            case 0:
            {
                
                NSDictionary * deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            self.appConfig.loginName,@"MemLoginID",
                                            [cell.currentMerchandise guid], @"Guid",
                                            kWebAppSign, @"AppSign",nil];
                
                [ShopCartMerchandiseModel deleteShopCartMerchandiseByParamer:deleteDic andblock:^(NSInteger result, NSError *error) {
                    if (error) {
                        
                    }else{
                        if (result == 202) {
                            [self.appConfig loadConfig];
                            NSInteger count = self.appConfig.shopCartNum;
                            count = count - [cell.currentMerchandise buyNumber];
                            self.appConfig.shopCartNum = count;
                            [self.appConfig saveConfig];
                            [self.appConfig loadConfig];
                            if (count > 0) {
                                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
                            }else {
                                self.navigationController.tabBarItem.badgeValue = nil;
                                [self.shopcartTableView setHidden:YES];
                                [self.noProductImage setHidden:NO];
                                [self.noProductLabel setHidden:NO];
                                [self.bottomView setHidden:YES];
                            }
                        }
                    }
                }];
                // Delete button was pressed
                NSIndexPath *cellIndexPath = [self.shopcartTableView indexPathForCell:cell];
                
                [_shopCartData removeObjectAtIndex:cellIndexPath.row];
                [self.shopcartTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                
                break;
            }
            default:
                break;
        }

        
    }else {
        switch (index) {
            case 0:
            {
                NSDictionary * addCollectDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                self.appConfig.loginName,@"MemLoginID",
                                                [cell.currentMerchandise productGuid], @"productGuid",
                                                kWebAppSign, @"AppSign",nil];
                [MerchandiseDetailModel addMerchandiseToCollectByParamer:addCollectDic andblock:^(NSInteger result, NSError *error) {
                    if (error) {
                        
                    }else{
                        if (result == 202) {
                            NSMutableArray * tempArray = [NSMutableArray arrayWithArray:self.appConfig.collectGuidList];
                            if (!tempArray) {
                                tempArray = [NSMutableArray arrayWithCapacity:0];
                            }
                            [tempArray addObject:[cell.currentMerchandise productGuid]];
                            
                            self.appConfig.collectGuidList = [NSMutableArray arrayWithArray:tempArray];
                            [self.appConfig saveConfig];
                        }
                        
                        NSDictionary * deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    self.appConfig.loginName,@"MemLoginID",
                                                    [cell.currentMerchandise guid], @"Guid",
                                                    kWebAppSign, @"AppSign",nil];
                        
                        [ShopCartMerchandiseModel deleteShopCartMerchandiseByParamer:deleteDic andblock:^(NSInteger result, NSError *error) {
                            if (error) {
                                
                            }else{
                                if (result == 202) {
                                    NSInteger count = self.appConfig.shopCartNum;
                                    count -= [cell.currentMerchandise buyNumber];
                                    self.appConfig.shopCartNum = count;
                                    [self.appConfig saveConfig];
                                    if (count > 0) {
                                        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
                                    }else {
                                        self.navigationController.tabBarItem.badgeValue = nil;
                                    }
                                    
                                }
                            }
                        }];
                        // Delete button was pressed
                        NSIndexPath *cellIndexPath = [self.shopcartTableView indexPathForCell:cell];
                        
                        [_shopCartData removeObjectAtIndex:cellIndexPath.row];
                        [self.shopcartTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                }];
                
                [cell hideUtilityButtonsAnimated:YES];
            }
                
                break;
            case 1:
            {
                
                NSDictionary * deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                            self.appConfig.loginName,@"MemLoginID",
                                            [cell.currentMerchandise guid], @"Guid",
                                            kWebAppSign, @"AppSign",nil];
                
                [ShopCartMerchandiseModel deleteShopCartMerchandiseByParamer:deleteDic andblock:^(NSInteger result, NSError *error) {
                    if (error) {
                        
                    }else{
                        if (result == 202) {
                            [self.appConfig loadConfig];
                            NSInteger count = self.appConfig.shopCartNum;
                            count = count - [cell.currentMerchandise buyNumber];
                            self.appConfig.shopCartNum = count;
                            [self.appConfig saveConfig];
                            [self.appConfig loadConfig];
                            if (count > 0) {
                                self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", count];
                            }else {
                                self.navigationController.tabBarItem.badgeValue = nil;
                                [self.shopcartTableView setHidden:YES];
                                [self.noProductImage setHidden:NO];
                                [self.noProductLabel setHidden:NO];
                                [self.bottomView setHidden:YES];
                            }
                        }
                    }
                }];
                // Delete button was pressed
                NSIndexPath *cellIndexPath = [self.shopcartTableView indexPathForCell:cell];
                
                [_shopCartData removeObjectAtIndex:cellIndexPath.row];
                [self.shopcartTableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                
                break;
            }
            default:
                break;
        }

    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    LoginViewController * lgvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueShopCartToLogin]) {
        if ([lgvc respondsToSelector:@selector(setFatherViewType:)]) {
            lgvc.FatherViewType = LoginForShopCart;
        }
    }
    
    SubmitOrderViewController * sovc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueShopCartToSubmit]) {
        if ([sovc respondsToSelector:@selector(setProductArray:)]) {
            if (ProductType == 1) {
                sovc.submitProductType = SubmitOrderForScore;
            }else {
                sovc.submitProductType = SubmitOrderForCommon;
            }
            
            sovc.productArray = submitArray;
            sovc.totalPrice = _allTotalPrice;
            sovc.totalWeight = allProductWeight;
        }
    }
    
    MerchandiseDetailViewController * mdvc = [segue destinationViewController];
#pragma mark - 商品详情
    if ([segue.identifier isEqualToString:kSegueShopCartToDetail]) {
        if ([mdvc respondsToSelector:@selector(setGuID:)]) {
            mdvc.GuID = productGuid;
        }
    }
    
}

- (IBAction)goBuyAction:(id)sender {
    if (_allTotalPrice == 0 && allScore == 0) {
        [self showAlertWithMessage:@"请先选择要购买的商品"];
        return;
    }
    if (ProductType == 1) {
        if (allScore > self.appConfig.userScore) {
            [self showAlertWithMessage:@"积分不足"];
            return;
        }
        
        submitArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (ShopCartScoreMerchandiseModel *model in self.shopCartData) {
            if(model.isCheckForShopCart){
                OrderMerchandiseSubmitModel *subimitModel = [[OrderMerchandiseSubmitModel alloc] init];
                
                subimitModel.Attributes = @"";
                subimitModel.Name = model.name;
                subimitModel.BuyNumber = model.buyNumber;
                subimitModel.BuyPrice = model.prmo;
                subimitModel.Guid = model.guid;
                subimitModel.Score = model.buyScore;
//                subimitModel.MarketPrice = model.MarketPrice;
                subimitModel.MemLoginID = self.appConfig.loginName;
                subimitModel.OriginalImge = model.originalImageStr;
                subimitModel.ProductGuid = model.productGuid;
                subimitModel.SpecificationName = @"";
                subimitModel.SpecificationValue = @"";
                subimitModel.ShopID = @"0";
                subimitModel.ShopName = @"";
                subimitModel.CreateTime = [NSDate date];
                subimitModel.IsJoinActivity = 0;
                subimitModel.IsPresent = 0;
                subimitModel.RepertoryNumber = @"JK";
                subimitModel.ExtensionAttriutes = @"M";
                subimitModel.CouponRule  = model.CouponRule;
                subimitModel.MemberI=model.MemberI;
                [submitArray addObject:subimitModel];
            }
        }

    }else {
        allProductWeight = 0;
        submitArray = [[NSMutableArray alloc] initWithCapacity:0];
        for (ShopCartMerchandiseModel *model in self.shopCartData) {
            if(model.isCheckForShopCart){
                
                allProductWeight = allProductWeight + model.buyNumber * model.procuctWeight;
                
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
                subimitModel.SpecificationValue = @"";
                subimitModel.ShopID = @"0";
                subimitModel.ShopName = @"";
                subimitModel.CreateTime = [NSDate date];
                subimitModel.IsJoinActivity = 0;
                subimitModel.IsPresent = 0;
                subimitModel.RepertoryNumber = @"JK";
                subimitModel.ExtensionAttriutes = @"M";
                 subimitModel.CouponRule  = model.CouponRule;
                [submitArray addObject:subimitModel];
            }
        }

    }
#pragma mark - 提交订单
    [self performSegueWithIdentifier:kSegueShopCartToSubmit sender:self];
}

- (IBAction)changeTabViewAction:(id)sender {
    
    UIButton * selectBtn = (UIButton*)sender;
    if (selectBtn == self.commonBtn) {
        [self.commonBtn setBackgroundImage:[UIImage imageNamed:@"big_leftbg_selected.png"] forState:UIControlStateNormal];
        [self.commonBtn setTitleColor:[UIColor barTitleColor] forState:UIControlStateNormal];
        [self.ScoreBtn setBackgroundImage:[UIImage imageNamed:@"big_rightbg_normal.png"] forState:UIControlStateNormal];
        [self.ScoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ProductType = 0;
        [self loadShopCartData];

    }else {
        [self.ScoreBtn setBackgroundImage:[UIImage imageNamed:@"big_rightbg_selected.png"] forState:UIControlStateNormal];
        [self.ScoreBtn setTitleColor:[UIColor barTitleColor] forState:UIControlStateNormal];
        [self.commonBtn setBackgroundImage:[UIImage imageNamed:@"big_leftbg_normal.png"] forState:UIControlStateNormal];
        [self.commonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        ProductType = 1;
        [self loadScoreShopCartData];

    }

    
}
@end
