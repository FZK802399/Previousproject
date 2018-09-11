//
//  MerchandiseList.m
//  Shop
//
//  Created by Ocean Zhang on 3/25/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MerchandiseList.h"
#import "SearchTableViewCell.h"
#import "DZYMerchandiseDetailController.h"
#import "LoadingView.h"
#import "ErrorView.h"
//#import "MemberFavoModel.h"

@interface MerchandiseList ()

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger currentRefreshPos;
@property (nonatomic, strong) NSMutableArray *dataSource;

//@property (nonatomic, strong) UIImageView *noResultView;
//
//@property (nonatomic, strong) UILabel *noResultLabeView;

@property (nonatomic, strong) ErrorView *errorView;

@end

@implementation MerchandiseList

//@synthesize loading = _loading;
@synthesize errorView = _errorView;

@synthesize pageSize = _pageSize;
@synthesize pageIndex = _pageIndex;
@synthesize currentRefreshPos = _currentRefreshPos;
@synthesize dataSource = _dataSource;
@synthesize sorts = _sorts;
@synthesize isAsc = _isAsc;
@synthesize keyWords = _keyWords;
@synthesize delegate = _delegate;

@synthesize shopID = _shopID;
@synthesize shopCategoryID = _shopCategoryID;
@synthesize parentVc = _parentVc;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    _errorView = [ErrorView sharedErrorView];
    //    [_errorView setErrorFrame:self.parentVc.view.frame];
    //    [self.view addSubview:_errorView];
    //
    //    [_loading setLoadingFrame:self.parentVc.view.frame];
    //    [self.view addSubview:_loading];
    
//    self.noResultView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nosearchResultWarning.png"]];
//    self.noResultView.frame = CGRectMake(110, 130, 105, 105);
//    [self.view addSubview:self.noResultView];
//    
//    self.noResultLabeView = [[UILabel alloc] initWithFrame:CGRectMake(110, 250, 150, 20)];
//    self.noResultLabeView.text = @"没有搜索到相关商品";
//    self.noResultLabeView.font  = [UIFont workListDetailFont];
//    [self.view addSubview:self.noResultLabeView];
//    
//    self.noResultLabeView.hidden = YES;
//    self.noResultView.hidden = YES;

    [self createHeaderView];
    [self showRefreshHeader:YES];
    
    _pageIndex = 1;
    _currentRefreshPos = 0;
    _pageSize = 10;
    _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self performSelector:@selector(getDataFromServer) withObject:nil afterDelay:1.0f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
       
- (void)pullDownFromServer {
    NSInteger oldCount = [_dataSource count];
    _pageIndex = oldCount / _pageSize + 1;
    
    [self getDataFromServer];
}

- (void)getDataFromServer {
    
    //    [_loading startLoading];
    void(^loadMerchandise)(NSArray *,NSError *) = ^void(NSArray *list, NSError *error){
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if(error){
            [MBProgressHUD showError:@"网络错误"];
            
        }else {
            NSMutableArray *signalPageData = [[NSMutableArray alloc] initWithArray:list];
            
            if([signalPageData count] < _pageSize){
                [self removeFooterView];
            }else{
                [self setFooterView];
            }
            [_dataSource removeAllObjects];
            [_dataSource addObjectsFromArray:signalPageData];
#warning 空数据处理
            BOOL tyep = [_dataSource count] == 0 ? NO : YES;
            if ([_delegate respondsToSelector:@selector(noResultWarningWithType:)]) {
                [_delegate noResultWarningWithType:tyep];
            }
            [self.tableView reloadData];
        }
        [self finishReloadingData];
        //        [_loading stopLoading];
    };
    NSDictionary * getDataDic;
    AppConfig * appConfig = [AppConfig sharedAppConfig];
    [appConfig loadConfig];
    switch (self.viewType) {
            
        case MerchandiseForFilter:
        {
            NSLog(@"筛选产品");
            //筛选产品
            self.dict[@"pageIndex"] = @(_pageIndex);
            self.dict[@"pageCount"] = @(_pageSize);
            [MerchandiseIntroModel getMerchandiseListByFilterParamer:self.dict CategoryID:self.categoryID andBlocks:^(NSArray *merchandiseList, NSError *error) {
                loadMerchandise(merchandiseList,error);
            }];
        }
            break;
        case MerchandiseForSearch:
        {
            getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"-1", @"ProductCategoryID",
                          self.sorts, @"sorts",
                          self.isAsc, @"isASC",
                          [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                          [NSString stringWithFormat:@"%d",_pageSize], @"pageCount",
                          self.keyWords, @"name",
                          @"", @"BrandGuid",
                          appConfig.appSign, @"AppSign",
                          nil];
            NSLog(@"搜索产品");
            //搜索产品
            [MerchandiseIntroModel getSearchProductListByParamer: getDataDic
                                                       andBlocks:^(NSArray *introArr,NSError *error){
                                                           loadMerchandise(introArr,error);
                                                       }];
        }
            break;
        case MerchandiseForCategory:
        {
            NSLog(@"分类查看");
            getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.keyWords, @"ProductCategoryID",
                          self.sorts, @"sorts",
                          self.isAsc, @"isASC",
                          [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                          [NSString stringWithFormat:@"%d",_pageSize], @"pageCount",
                          @"", @"name",
                          @"", @"BrandGuid",
                          appConfig.appSign, @"AppSign",
                          nil];
//            NSLog(@"%@",getDataDic);
            //分类查看
            [MerchandiseIntroModel getSearchProductListByParamer:getDataDic
                                                       andBlocks:^(NSArray *lsit, NSError *error){
                                                           loadMerchandise(lsit,error);
                                                       }];
        }
            break;
        case MerchandiseForBrand:
        {
            
            getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"-1", @"ProductCategoryID",
                          self.sorts, @"sorts",
                          self.isAsc, @"isASC",
                          [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                          [NSString stringWithFormat:@"%d",_pageSize], @"pageCount",
                          @"", @"name",
                          self.keyWords, @"BrandGuid",
                          appConfig.appSign, @"AppSign",
                          nil];
            NSLog(@"品牌查看");
            //品牌查看
            [MerchandiseIntroModel getSearchProductListByParamer:getDataDic
                                                       andBlocks:^(NSArray *list,NSError *error){
                                                           loadMerchandise(list,error);
                                                       }];
        }
            break;
        case MerchandiseForHomeCategory:
        {
            NSLog(@"店铺分类");
            //店铺分类
            [MerchandiseIntroModel getShopMerchandiseByCategory:self.shopCategoryID
                                                          Sorts:self.sorts
                                                          isAsc:(self.isAsc).boolValue
                                                      pageIndex:_pageIndex
                                                      pageCount:_pageSize
                                                         shopID:self.shopID
                                                           name:self.keyWords
                                                      andBlocks:^(NSArray *list,NSError *error){
                                                          loadMerchandise(list,error);
                                                      }];
        }
            break;
        case MerchandiseForFavo0:
        {
            //收藏
//            [MerchandiseIntroModel getFavoMerchandiseList:_pageIndex pageCount:_pageSize andblock:^(NSArray *list, NSError *error){
//                loadMerchandise(list,error);
//            }];
        }
            break;
        case MerchandiseForScore:
        {
            if (self.shopID == 1) {
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0", @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"0", @"IsBest",
                              @"0", @"IsNew",
                              @"1", @"IsHot",
                              @"0", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
                
            }else if (self.shopID == 2){
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0", @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"0", @"IsBest",
                              @"1", @"IsNew",
                              @"0", @"IsHot",
                              @"0", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
            }else if (self.shopID == 3){
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0", @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"1", @"IsBest",
                              @"0", @"IsNew",
                              @"0", @"IsHot",
                              @"0", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
            }else if (self.shopID == 4){
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"0", @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"0", @"IsBest",
                              @"0", @"IsNew",
                              @"0", @"IsHot",
                              @"1", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
            }
            
            if (self.shopCategoryID > 0) {
                getDataDic = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSString stringWithFormat:@"%d", self.shopCategoryID], @"ScoreProductCategoryID",
                              [NSString stringWithFormat:@"%d",_pageIndex], @"pageIndex",
                              [NSString stringWithFormat:@"%d",_pageSize], @"pageSize",
                              @"0", @"IsBest",
                              @"0", @"IsNew",
                              @"0", @"IsHot",
                              @"0", @"IsRecommend",
                              appConfig.appSign, @"AppSign",
                              nil];
            }
            [ScoreProductIntroModel getScoreMerchandiseIntroForHomeShowByParamer:getDataDic andBlocks:^(NSArray *merchandiseList, NSError *error) {
                loadMerchandise(merchandiseList,error);
            }];
            
            
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    SearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if(indexPath.row < [_dataSource count]){
        if (self.viewType == MerchandiseForScore) {
            [cell creatSearchTableViewCellWithScoreProductIntroModel:[_dataSource objectAtIndex:indexPath.row]];
        }else {
            [cell creatSearchTableViewCellWithMerchandiseIntroModel:[_dataSource objectAtIndex:indexPath.row]];
        }
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 105.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(self.viewType == MerchandiseForFavo){
    //        MerchandiseCollectModel *selectMerchandise = [_dataSource objectAtIndex:indexPath.row];
    //        if([self.delegate respondsToSelector:@selector(selectedFavoMerchandise:)]){
    //            [self.delegate selectedFavoMerchandise:selectMerchandise];
    //        }
    //    }else{
    //        MerchandiseIntroModel *selectMerchandise = [_dataSource objectAtIndex:indexPath.row];
    //        if([self.delegate respondsToSelector:@selector(selectedMerchandise:)]){
    //            [self.delegate selectedMerchandise:selectMerchandise];
    //        }
    //    }
    if (self.viewType == MerchandiseForScore) {
        ScoreProductIntroModel *selectMerchandise = [_dataSource objectAtIndex:indexPath.row];
        if([self.delegate respondsToSelector:@selector(selectedScoreProductIntroModel:)]){
            [self.delegate selectedScoreProductIntroModel:selectMerchandise];
        }
    }else {
        MerchandiseIntroModel *selectMerchandise = [_dataSource objectAtIndex:indexPath.row];
        if([self.delegate respondsToSelector:@selector(selectedMerchandise:)]){
            [self.delegate selectedMerchandise:selectMerchandise];
        }

    
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.viewType == MerchandiseForFavo0){
        return YES;
    }
    
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if(editingStyle == UITableViewCellEditingStyleDelete &&
    //       self.viewType == MerchandiseForFavo){
    //        [_loading startLoading];
    //        MerchandiseCollectModel *model = [_dataSource objectAtIndex:indexPath.row];
    //
    //        [MerchandiseCollectModel deleteFavoMerchandise:model.Guid andblock:^(NSInteger result, NSError *error){
    //            if(error){
    //                [_errorView setErrorInfo:@"网络连接失败，请检查网络设置" andtitle:@"删除失败"];
    //                [_errorView startError];
    //            }else{
    //                if(result == 200){
    //                    [_dataSource removeObjectAtIndex:indexPath.row];
    //                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    //                    [MemberFavoModel deleteFavoWithType:0 andKey:model.ProductGuid];
    //
    //                }else{
    //                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
    //                                                                    message:@"删除收藏商品失败"
    //                                                                   delegate:self
    //                                                          cancelButtonTitle:@"OK"
    //                                                          otherButtonTitles:nil, nil];
    //                    [alert show];
    //                }
    //            }
    //            
    //            [_loading stopLoading];
    //        }];
    //    }
}

@end
