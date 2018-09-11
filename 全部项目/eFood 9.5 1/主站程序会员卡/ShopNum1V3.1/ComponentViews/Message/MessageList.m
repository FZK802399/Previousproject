//
//  MessageList.m
//  Shop
//
//  Created by Ocean Zhang on 5/8/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MessageList.h"
#import "MessageItemTableViewCell.h"
#import "LoadingView.h"
#import "ErrorView.h"

@interface MessageList ()<MessageItemTableViewCellDelegate>

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger currentRefreshPos;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) LoadingView *loading;
@property (nonatomic, strong) ErrorView *errorView;

@end

@implementation MessageList

@synthesize pageSize = _pageSize;
@synthesize pageIndex = _pageIndex;
@synthesize currentRefreshPos = _currentRefreshPos;
@synthesize dataSource = _dataSource;

@synthesize parentVc = _parentVc;

@synthesize loading = _loading;
@synthesize errorView = _errorView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _appConfig = [AppConfig sharedAppConfig];
    [_appConfig loadConfig];
    _errorView = [ErrorView sharedErrorView];
    [_errorView setErrorFrame:self.parentVc.view.frame];
    [self.view addSubview:_errorView];
    
    [_loading setLoadingFrame:self.parentVc.view.frame];
    [self.view addSubview:_loading];
    
    [self createHeaderView];
    [self showRefreshHeader:YES];
    
    self.tableView.rowHeight = 115;
    _pageIndex = 0;
    _currentRefreshPos = 0;
    _pageSize = 5;
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.view addSubview:_loading];
    
    [self performSelector:@selector(getDataFromServer) withObject:nil afterDelay:1.0f];
}


- (void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    [super beginToReloadData:aRefreshPos];
    
    if(aRefreshPos == EGORefreshHeader){
        _currentRefreshPos = 0;
        _pageIndex = 0;
        
        [_dataSource removeAllObjects];
        [self performSelector:@selector(getDataFromServer) withObject:nil afterDelay:1.0f];
    }else if(aRefreshPos == EGORefreshFooter){
        _currentRefreshPos = 1;
        [self performSelector:@selector(pullDownFromServer) withObject:nil afterDelay:1.0f];
    }
}

- (void)pullDownFromServer{
    NSInteger oldCount = [_dataSource count];
    _pageIndex = oldCount / _pageSize ;
    
    [self getDataFromServer];
}

- (void)getDataFromServer{
    
    [_loading startLoading];
    NSDictionary * messageDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 kWebAppSign,@"AppSign",
                                 self.appConfig.loginName, @"receiveMemLoginID",
                                 [NSNumber numberWithInt:_pageIndex],@"pageIndex",
                                 [NSNumber numberWithInt:_pageSize],@"pageCount", nil];
    [MessageModelMy getMessageListWithParameters:messageDic andblock:^(NSArray *list, NSError *error) {
        if(error){
            [_errorView setErrorInfo:@"网络连接失败，请检查网络设置" andtitle:@"获取会员消息发生错误"];
            [_errorView startError];
        }else{
            NSMutableArray *signalPageData = [[NSMutableArray alloc] initWithArray:list];
            
            if([signalPageData count] < _pageSize){
                [self removeFooterView];
            }else{
                [self setFooterView];
            }
            
            [_dataSource addObjectsFromArray:signalPageData];
            
#warning Handle Empty data
            if ([_dataSource count] == 0) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"暂无消息"
                                                                   delegate:self
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                
//                DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"暂无消息" leftButtonTitle:nil rightButtonTitle:@"确定"];
//                [alert show];
                
                [self finishReloadingData];
            }else{
                [self.tableView reloadData];
                [self finishReloadingData];
            }
            
            
        }
        
        [_loading stopLoading];
    }];
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
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 115;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_dataSource == nil){
        return 0;
    }
    
    return [_dataSource count];
}

#pragma mark - UItableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    MessageItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor whiteColor] icon:[UIImage imageNamed:@"btn_shopcart_delete.png"] andLightImage:[UIImage imageNamed:@"btn_shopcart_delete_selected.png"]];
        
        cell = [[MessageItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                            reuseIdentifier:CellIdentifier
                                        containingTableView:tableView // Used for row height and selection
                                         leftUtilityButtons:nil
                                        rightUtilityButtons:rightUtilityButtons];
        cell.delegate = self;
    }
    
    if(indexPath.row < [_dataSource count]){
        MessageModelMy *MessageModelMy = [_dataSource objectAtIndex:indexPath.row];
        [cell createWithMessageModelMy:MessageModelMy];
    }

//    if(indexPath.row % 2 == 0){
//        cell.contentView.backgroundColor = [UIColor whiteColor];
//    }else{
//        cell.contentView.backgroundColor = [UIColor colorWithRed:242 /255.0f green:243 /255.0f blue:245 /255.0f alpha:1];
//    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     MessageModelMy *selectMessage = [_dataSource objectAtIndex:indexPath.row];
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(selectedMessage:)]){
            [self.delegate selectedMessage:selectMessage];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
}


- (void)swippableTableViewCell:(MessageItemTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            [_loading startLoading];
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];

            MessageModelMy *selectMessage = [_dataSource objectAtIndex:cellIndexPath.row];
            
            NSDictionary * messageDeleteDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                               kWebAppSign,@"AppSign",
                                               self.appConfig.loginName, @"memLoginID",
                                               selectMessage.Guid,@"msgId",nil];
            [MessageModelMy deleteMessageWithParameters:messageDeleteDic andblock:^(NSInteger result, NSError *error) {
                if(error){
                    [_errorView setErrorInfo:@"网络连接失败，请检查网络设置" andtitle:@"删除消息发生错误"];
                    [_errorView startError];
                }else{
                    if(result == 202){
                        //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                        //                                                                    message:@"删除消息成功"
                        //                                                                   delegate:self
                        //                                                          cancelButtonTitle:@"OK"
                        //                                                          otherButtonTitles:nil, nil];
                        //                    [alert show];
                        
                        
                        [_dataSource removeObjectAtIndex:cellIndexPath.row];
                        [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        
                        //                    [_loading startLoading];
                        //                    [MessageModelMy getMessageListWithType:2 andblock:^(NSArray *list, NSError *error){
                        //                        if(error){
                        //                            [_errorView setErrorInfo:@"网络连接失败，请检查网络设置" andtitle:@"获取未读消息发生错误"];
                        //                            [_errorView startError];
                        //                        }else{
                        //                            self.lbNoReadCount.text = [NSString stringWithFormat:@"%d条未读消息",[list count]];
                        //                        }
                        //                        [_loading stopLoading];
                        //                    }];
                    }else{
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                            message:@"删除消息失败"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                        [alertView show];
//                        DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"删除消息失败" leftButtonTitle:nil rightButtonTitle:@"确定"];
//                        [alert show];
                    }
                }
                [_loading stopLoading];
            }];
            
            [cell hideUtilityButtonsAnimated:YES];
        }
            
            break;
        default:
            break;
    }
}


@end
