//
//  FootMarkViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "FootMarkViewController.h"
#import "DZYMerchandiseDetailController.h"
#import "OrderIntroModel.h"
#import "BluePrintingModel.h"
#import "BluePrintingViewController.h"

@interface FootMarkViewController ()

@end

@implementation FootMarkViewController
{

    NSString * productGuid;
    NSString * orderNumber;
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
    //返回按钮
    [self loadLeftBackBtn];
    
    if (_viewType == MerchandiseForFavo) {
        self.title = @"商品收藏";
        [self loadCollectData];
    }else if (_viewType == MerchandiseForFootMark) {
        self.title = @"我的足迹";
        [self loadFootMarkData];
    }else{
        self.title = @"去晒单";
        [self loadCommentProductList];
    }
    
    self.FootMarkTableView.rowHeight = 100;
    self.FootMarkTableView.layer.borderWidth = 1;
    self.FootMarkTableView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    self.FootMarkData = [NSMutableArray arrayWithCapacity:0];
//    [self.FootMarkTableView registerClass:[FootMarkTableViewCell class] forCellReuseIdentifier:kFootMarkTableViewCellMainView];
}

-(void)commentProduct:(OrderMerchandiseIntroModel *)model{

    productGuid = model.ProductGuid;
    orderNumber = model.orderNum;
    [self performSegueWithIdentifier:kSegueProductListToComment sender:self];
}

-(void)loadCommentProductList{
    NSDictionary * orderDic =[NSDictionary dictionaryWithObjectsAndKeys:
                              kWebAppSign, @"AppSign",
                              self.appConfig.loginName, @"memLoginID",
                              @"0", @"t",
                              @"1", @"pageIndex",
                              @"100", @"pageCount",nil];
    [OrderIntroModel getOrderListWithParameters:orderDic andblock:^(NSArray *list, NSError *error) {
        self.FootMarkData = [NSMutableArray arrayWithCapacity:0];
        for (OrderIntroModel * order in list) {
            if (order.OrderStatus == 5 && order.ShipmentStatus == 2) {
                for (OrderMerchandiseIntroModel * product in order.ProductList) {
                   [self.FootMarkData addObject:product];
                }
            }
        }
        if (self.FootMarkData.count > 0) {
            [self.FootMarkTableView reloadData];
        }else{
            [self showAlertWithMessage:@"暂无晒单商品"];
        }
        
    }];

}

-(void)loadCollectData{
    
    NSDictionary * collectDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 self.appConfig.loginName, @"MemLoginID",
                                 kWebAppSign, @"AppSign",
                                 @"1", @"pageIndex",
                                 @"100", @"pageCount",nil];
    [MerchandiseCollectModel getCollectListByparameters:collectDic andblock:^(NSArray *CollectList, NSError *error) {
        if(error){
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
            
        }else{
            
            NSInteger introCount;
            if (![CollectList isEqual:[NSNull null]]) {
                introCount = [CollectList count];
            }
            
            //首先判断是否有数据
            if (introCount > 0) {
                self.FootMarkData =[NSMutableArray arrayWithArray:CollectList];
                [self.FootMarkTableView reloadData];
            }else{
                [self showMessage:@"暂无收藏商品"];
            }
        }
    }];
    
}


-(void)loadFootMarkData{

    NSDictionary * footmarkDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  self.appConfig.loginName, @"MemLoginID",
                                  kWebAppSign, @"AppSign",nil];
    [FootMarkModel getFootMarkListByparameters:footmarkDic andblock:^(NSArray *FootMarklist, NSError *error) {
        if(error){
            
            [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                        subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                            type:TSMessageNotificationTypeError];
            
        }else{
            
            NSInteger introCount;
            if (![FootMarklist isEqual:[NSNull null]]) {
                introCount = [FootMarklist count];
            }
            
            //首先判断是否有数据
            if (introCount > 0) {
                self.FootMarkData =[NSMutableArray arrayWithArray:FootMarklist];
                [self.FootMarkTableView reloadData];
            }else{
                
                [self showAlertWithMessage:@"暂无浏览足迹"];
            }
        }
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView数据源代理

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 100;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.FootMarkData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FootMarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFootMarkTableViewCellMainView];
    if (cell == nil) {
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor whiteColor] icon:[UIImage imageNamed:@"btn_shopcart_delete.png"] andLightImage:[UIImage imageNamed:@"btn_shopcart_delete_selected.png"]];
        
        cell = [[FootMarkTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                            reuseIdentifier:kFootMarkTableViewCellMainView
                                        containingTableView:tableView // Used for row height and selection
                                         leftUtilityButtons:nil
                                        rightUtilityButtons:rightUtilityButtons];
    }
    
    if (_viewType == MerchandiseForFootMark) {
        [cell creatFootMarkTableViewCellWithMerchandiseIntroModel:[self.FootMarkData objectAtIndex:indexPath.row]];
    }else if(_viewType == MerchandiseForFavo){
        [cell creatCollectTableViewCellWithMerchandiseIntroModel:[self.FootMarkData objectAtIndex:indexPath.row]];
    
    }else{
        cell.cellScrollView.scrollEnabled = NO;
        [cell creatCollectTableViewCellWithOrderMerchandiseIntroModel:[self.FootMarkData objectAtIndex:indexPath.row]];
    
    }
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    FootMarkModel * temp  = [self.FootMarkData objectAtIndex:indexPath.row];
    productGuid = [[self.FootMarkData objectAtIndex:indexPath.row] ProductGuid];
    [self performSegueWithIdentifier:kSegueFootMarkToDetail sender:self];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (_viewType == MerchandiseForComment) {
//        return NO;
//    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
       
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }

}


- (void)swippableTableViewCell:(FootMarkTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSIndexPath *IndexPath = [self.FootMarkTableView indexPathForCell:cell];
    NSString * deleteDataID = [[self.FootMarkData objectAtIndex:IndexPath.row] ID];
    NSString * Guid = [[self.FootMarkData objectAtIndex:IndexPath.row] ProductGuid];
    switch (index) {
        case 0:
        {
            
            if (self.viewType == MerchandiseForFootMark) {
                NSDictionary * deleteFootMarkDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                    deleteDataID,@"id",
                                                    kWebAppSign, @"AppSign",
                                                    nil];
                
                [FootMarkModel deleteFootMarkByparameters:deleteFootMarkDic andblock:^(NSInteger reslut, NSError *error) {
                    if(error){
                        [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                                    subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                                        type:TSMessageNotificationTypeError];
                        
                    }else{
                        
                        if (reslut == 202) {
                            
                            [self showAlertWithMessage:NSLocalizedString(@"删除足迹成功", nil)];
                            //                        [TSMessage showNotificationWithTitle:NSLocalizedString(@"删除足迹成功", nil)
                            //                                                    subtitle:NSLocalizedString(@"删除足迹成功", nil)
                            //                                                        type:TSMessageNotificationTypeSuccess];
                        }
                    }
                    
                }];
            }else if (self.viewType == MerchandiseForFavo){
                NSDictionary * deleteCollectDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   deleteDataID,@"CollectId",
                                                   self.appConfig.loginName, @"MemLoginID",
                                                   kWebAppSign, @"AppSign",
                                                   nil];
                
                [MerchandiseCollectModel deleteCollectProductByparameters:deleteCollectDic andblock:^(NSInteger reslut, NSError *error) {
                    if(error){
                        [TSMessage showNotificationWithTitle:NSLocalizedString(@"获取信息错误，点击屏幕重新加载", nil)
                                                    subtitle:NSLocalizedString(@"网络连接失败，请检查网络设置", nil)
                                                        type:TSMessageNotificationTypeError];
                        
                    }else{
                        
                        if (reslut == 202) {
                            
                            [self showAlertWithMessage:NSLocalizedString(@"删除收藏成功", nil)];
                            NSInteger i = 0;
                            NSMutableArray * arr = [NSMutableArray arrayWithArray:config.collectGuidList];
                            for (NSString * str in arr) {
                                if ([str isEqualToString:Guid]) {
                                    NSInteger n = [arr indexOfObject:str];
                                    i = n;
                                }
                            }
                            [arr removeObjectAtIndex:i];
                            config.collectGuidList = arr;
                            [config saveConfig];
                            //                        [TSMessage showNotificationWithTitle:NSLocalizedString(@"删除收藏成功", nil)
                            //                                                    subtitle:NSLocalizedString(@"删除收藏成功", nil)
                            //                                                        type:TSMessageNotificationTypeSuccess];
                        }
                    }
                    
                }];
                
            }
            
            
            [self.FootMarkData removeObjectAtIndex:IndexPath.row];
            // Delete the row from the data source.
            [self.FootMarkTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:IndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            [cell hideUtilityButtonsAnimated:YES];
        }
            
            break;
        default:
            break;
    }
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DZYMerchandiseDetailController * mdvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueFootMarkToDetail]) {
        if ([mdvc respondsToSelector:@selector(setGuid:)]) {
            mdvc.Guid = productGuid;
        }
    }
    BluePrintingViewController * bpvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueProductListToComment]) {
        if ([bpvc respondsToSelector:@selector(setOrderNumber:)]) {
            bpvc.productGuid = productGuid;
            bpvc.orderNumber = orderNumber;
        }
    }
}


@end
