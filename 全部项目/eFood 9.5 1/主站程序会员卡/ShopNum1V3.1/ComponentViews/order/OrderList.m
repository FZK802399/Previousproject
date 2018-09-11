//
//  OrderList.m
//  Shop
//
//  Created by Ocean Zhang on 4/17/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "OrderList.h"
#import "ErrorView.h"
#import "OrderDetailModel.h"

@interface OrderList ()<UIAlertViewDelegate>

@property (nonatomic, strong) ErrorView *errorView;

@end

@implementation OrderList{
    id currentIntro;
}

@synthesize errorView = _errorView;

@synthesize pageSize = _pageSize;
@synthesize pageIndex = _pageIndex;
@synthesize currentRefreshPos = _currentRefreshPos;
@synthesize dataSource = _dataSource;

@synthesize orderStatusView = _orderStatusView;

@synthesize delegate = _delegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createHeaderView];
    [self showRefreshHeader:YES];
    
    _pageIndex = 1;
    _currentRefreshPos = 0;
    _pageSize = 30;
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    _errorView = [ErrorView sharedErrorView];
    [_errorView setErrorFrame:self.view.frame];
    [self.view addSubview:_errorView];
    
    [self performSelector:@selector(getDataFromServer) withObject:nil afterDelay:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    [super beginToReloadData:aRefreshPos];
    
    if(aRefreshPos == EGORefreshHeader){
        _currentRefreshPos = 0;
        _pageIndex = 1;
        
        if(_dataSource != nil){
            [_dataSource removeAllObjects];
        }
        
        [self performSelector:@selector(getDataFromServer) withObject:nil afterDelay:1.0f];
    }else if(aRefreshPos == EGORefreshFooter){
        _currentRefreshPos = 1;
        [self performSelector:@selector(pullDownFromServer) withObject:nil afterDelay:1.0f];
    }
}

- (void)pullDownFromServer{
    NSInteger oldCount = [_dataSource count];
    _pageIndex = oldCount / _pageSize + 1;
    
    [self getDataFromServer];
}

- (void)getDataFromServer{
    
    void(^loadShopList)(NSArray *,NSError *) = ^void(NSArray *list, NSError *error){
        if(error){
            [_errorView setErrorInfo:@"网络连接失败，请检查网络设置" andtitle:@"获取订单列表失败"];
            [_errorView startError];
            
            
            
        }else{
            NSMutableArray *signalPageData = [[NSMutableArray alloc] initWithArray:list];
            
            if([signalPageData count] < _pageSize){
                [self removeFooterView];
            }else{
                [self setFooterView];
            }
            [_dataSource addObjectsFromArray:signalPageData];
            
            if ([_dataSource count] == 0) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"暂无订单"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                
//                DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"暂无订单" leftButtonTitle:nil rightButtonTitle:@"确定"];
//                [alert show];
                [self finishReloadingData];
            }else{
                [self.tableView reloadData];
                [self finishReloadingData];
            }
            
        }
    };
    
    AppConfig * appConfig = [AppConfig sharedAppConfig];
    [appConfig loadConfig];
    
    if (self.OrderType == 1) {
        NSDictionary * orderDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                  appConfig.appSign, @"AppSign",
                                  appConfig.loginName, @"memLoginID",
                                  [NSString stringWithFormat:@"%d", _orderStatusView], @"tp",
                                  [NSString stringWithFormat:@"%d", _pageIndex], @"pageIndex",
                                  [NSString stringWithFormat:@"%d", _pageSize], @"pageSize",nil];
        [ScoreOrderIntroModel getScoreOrderListWithParameters:orderDic andblock:^(NSArray *list, NSError *error) {
            loadShopList(list,error);
        }];
        
    }else {
        NSDictionary * orderDic =[NSDictionary dictionaryWithObjectsAndKeys:
                                  appConfig.appSign, @"AppSign",
                                  appConfig.loginName, @"memLoginID",
                                  [NSString stringWithFormat:@"%d", _orderStatusView], @"t",
                                  [NSString stringWithFormat:@"%d", _pageIndex], @"pageIndex",
                                  [NSString stringWithFormat:@"%d", _pageSize], @"pageCount",nil];
        [OrderIntroModel getOrderListWithParameters:orderDic andblock:^(NSArray *list, NSError *error) {
            loadShopList(list,error);
        }];
    }
    
    
}

- (void)refreshList{
    [_dataSource removeAllObjects];
    _currentRefreshPos = 0;
    _pageIndex = 1;
    
    [self.tableView setContentOffset:CGPointMake(0, -75) animated:YES];
    [self performSelector:@selector(doneManualRefresh) withObject:nil afterDelay:0.6];
}

- (void)doneManualRefresh{
    [self.refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

#pragma mark - UITableViewDatSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(_dataSource == nil){
        return 0;
    }
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_dataSource == nil){
        return 0;
    }
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"OrderListCell";
    OrderListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[OrderListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row < [_dataSource count]) {
        if (self.OrderType == 1) {
            ScoreOrderIntroModel *intro = [_dataSource objectAtIndex:indexPath.row];
            [cell creatOrderListTableViewCellWithScoreOrderIntroModel:intro];
        }else {
            OrderIntroModel *intro = [_dataSource objectAtIndex:indexPath.row];
            [cell creatOrderListTableViewCellWithOrderIntroModel:intro];
            
        }
        
    }
    
    
    
    
    return cell;
}


#pragma mark - UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //return 110.0f;
    
    return 170;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    OrderIntroModel *order = [_dataSource objectAtIndex:indexPath.row];
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(selectedOrder:)]){
            [self.delegate selectedOrder:order];
        }
    }
}

- (void)viewPayWith:(id)intro{
    if([self.delegate respondsToSelector:@selector(viewPayWith:)]){
        [self.delegate viewPayWith:intro];
    }
}

- (void)viewWuliuWith:(id)intro{
    if([self.delegate respondsToSelector:@selector(viewWuliuWith:)]){
        [self.delegate viewWuliuWith:intro];
    }
}

- (void)confirmReceiver:(id)intro{
    if([self.delegate respondsToSelector:@selector(confirmReceiver:)]){
        [self.delegate confirmReceiver:intro];
    }
}

-(void)cancelOrder:(id)intro{
    currentIntro = intro;
//    
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                        message:@"确定取消订单"
//                                                       delegate:self
//                                              cancelButtonTitle:nil
//                                              otherButtonTitles:@"确定",@"取消",nil];
//    alertView.tag = 1000;
//    [alertView show];
//    
    if([self.delegate respondsToSelector:@selector(cancelOrder:)]){
        [self.delegate cancelOrder:intro];
    }
}

- (void)commentProduct:(id)model{
    if([self.delegate respondsToSelector:@selector(commentProduct:)]){
        [self.delegate commentProduct:model];
    }
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0 && alertView.tag == 1000) {
        AppConfig *appconfig = [AppConfig sharedAppConfig];
        [appconfig loadConfig];
        if (self.OrderType == 1) {
            NSDictionary * cancelDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        appconfig.appSign,@"AppSign",
                                        [(ScoreOrderIntroModel *)currentIntro Guid],@"id",nil];
            [ScoreOrderIntroModel CancelScoreOrderStatueWithParameters:cancelDic andblock:^(NSInteger result, NSError *error) {
                if (error) {
                    
                }else {
                    if (result == 202) {
                        [_dataSource removeObject:currentIntro];
                        [self.tableView reloadData];
                    }
                }
            }];

            
        }else {
        
            NSDictionary * cancelDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                        appconfig.appSign,@"AppSign",
                                        [(OrderIntroModel *)currentIntro Guid],@"id",nil];
            [OrderDetailModel cancelOrderWithparameters:cancelDic andblock:^(NSInteger result, NSError *error) {
                if (error) {
                    
                }else {
                    if (result == 202) {
                        [_dataSource removeObject:currentIntro];
                        [self.tableView reloadData];
                        //                    NSInteger index = [_dataSource indexOfObject:intro];
                        //
                        //                    NSIndexPath * indexpath = [NSIndexPath indexPathForRow:index inSection:0];
                        //                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexpath] withRowAnimation:UITableViewRowAnimationFade];
                        
                        //                    [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
            }];

        }
        
    }
    
}

-(void)alertViewCancel:(UIAlertView *)alertView{
    
    
}

@end
