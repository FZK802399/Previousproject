//
//  CommentList.m
//  Shop
//
//  Created by Ocean Zhang on 4/12/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "CommentList.h"
#import "CommentDetailModel.h"
#import "CommentItemTableViewCell.h"
#import "BluePrintingTableViewCell.h"

@interface CommentList ()

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger currentRefreshPos;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation CommentList

@synthesize pageSize = _pageSize;
@synthesize pageIndex = _pageIndex;
@synthesize currentRefreshPos = _currentRefreshPos;
@synthesize dataSource = _dataSource;

@synthesize shopID = _shopID;
@synthesize merchandiseGuid = _merchandiseGuid;
@synthesize commentType = _commentType;

@synthesize viewType = _viewType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createHeaderView];
    
    [self showRefreshHeader:YES];
    
    _pageIndex = 1;
    _currentRefreshPos = 0;
    _pageSize = 30;
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
        
        [_dataSource removeAllObjects];
        [self performSelector:@selector(getDataFromServer) withObject:nil afterDelay:1.0f];
    }else if(aRefreshPos == EGORefreshFooter){
        _currentRefreshPos = 1;
        [self performSelector:@selector(pullDownFromServer) withObject:nil afterDelay:1.0f];
    }
}
       //从服务器下拉
- (void)pullDownFromServer{
    NSInteger oldCount = [_dataSource count];
    _pageIndex = oldCount / _pageSize + 1;
    
    [self getDataFromServer];
}
       //从服务器获取数据
- (void)getDataFromServer{
    
    void(^loadCommentList)(NSArray *,NSError *) = ^void(NSArray *list, NSError *error){
        if(error){
#warning Handle Error
        }else{
            NSMutableArray *signalPageData = [[NSMutableArray alloc] initWithArray:list];
            
            if([signalPageData count] < _pageSize){
                [self removeFooterView];
            }else{
                [self setFooterView];
            }
            
            [_dataSource addObjectsFromArray:signalPageData];
            
#warning Handle Empty data
            
            [self.tableView reloadData];
            [self finishReloadingData];
        }
    };
    
    AppConfig * appConfig = [AppConfig sharedAppConfig];
    [appConfig loadConfig];
    switch (self.viewType) {
        case CommentForMerchandise:
        {
            
            NSDictionary * commentDic= [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.merchandiseGuid,@"productID",
                                        [NSNumber numberWithInteger:_pageIndex],@"startPage",
                                        [NSNumber numberWithInteger:_pageSize],@"pageSize",
                                        appConfig.appSign, @"AppSign", nil];
            [CommentDetailModel getMerchandiseCommentListByParameters:commentDic andblock:^(NSArray *commentList, NSError *error) {
                if (commentList.count == 0) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"该商品无评论"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
//                    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"该商品无评论" leftButtonTitle:nil rightButtonTitle:@"确定"];
//                    [alert show];
                    [self finishReloadingData];
                }else{
                    loadCommentList(commentList,error);
                }
                

            }];

//            [CommentDetailModel getMerchandiseCommentList:self.merchandiseGuid
//                                           pageIndex:_pageIndex
//                                           pageCount:_pageSize
//                                            viewType:self.commentType
//                                            andblock:^(NSArray *list,NSError *error){
//                                                loadCommentList(list,error);
//                                            }];
        }
            break;
        case CommentForPicture:
        {
            
            NSDictionary * picDic= [NSDictionary dictionaryWithObjectsAndKeys:
                                        self.merchandiseGuid,@"ProductGuid",
                                        [NSNumber numberWithInteger:_pageIndex],@"pageIndex",
                                        [NSNumber numberWithInteger:_pageSize],@"pageSize",
                                        appConfig.appSign, @"AppSign", nil];
            [BluePrintingModel getMerchandisePictureListByParameters:picDic andblock:^(NSArray *List, NSInteger count, NSError *error) {
                if (List.count == 0) {
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                        message:@"该商品无晒单"
                                                                       delegate:self
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
//                    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"提示" contentText:@"该商品无晒单" leftButtonTitle:nil rightButtonTitle:@"确定"];
//                    [alert show];
                    [self finishReloadingData];
                }else {
                    loadCommentList(List,error);
                }
                
                
            }];
//            [CommentDetailModel getShopCommentList:self.shopID
//                                    pageIndex:_pageIndex
//                                    pageCount:_pageSize
//                                     viewType:self.commentType
//                                     andblock:^(NSArray *commentList,NSError *error){
//                                         loadCommentList(commentList,error);
//                                     }];
        }
            break;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(_dataSource == nil){
        return 0;
    }
    
    return [_dataSource count];
}

#pragma mark - UItableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.viewType == CommentForMerchandise){
        return 115;
    }else{
        return 235;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cellid";
    if (self.viewType == CommentForMerchandise) {
        CommentItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[CommentItemTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row < [_dataSource count])
            [cell createCommentDetailItem:[_dataSource objectAtIndex:indexPath.row]];
        return cell;
    }else {
        BluePrintingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil){
            cell = [[BluePrintingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row < [_dataSource count])
            [cell createBluePrintingDetailItem:[_dataSource objectAtIndex:indexPath.row]];
        return cell;
    
    }
    return nil;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    ShopsInfoModel *selectShop = [_dataSource objectAtIndex:indexPath.row];
    //    if([self.delegate respondsToSelector:@selector(selectedShop:)]){
    //        [self.delegate selectedShop:selectShop];
    //    }
}

@end
