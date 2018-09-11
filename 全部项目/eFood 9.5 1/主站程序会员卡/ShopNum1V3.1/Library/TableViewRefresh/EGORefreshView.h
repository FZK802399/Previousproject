//
//  EGORefreshView.h
//  weibo
//
//  Created by Ocean Zhang on 3/15/13.
//
//
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshCommon.h"

@interface EGORefreshView : UIViewController <EGORefreshTableDelegate,UITableViewDelegate,UITableViewDataSource>{
    EGORefreshTableHeaderView *_refreshHeaderView;
    EGORefreshTableFooterView *_refreshFooterView;
    
    UITableView *_tableView;
    
    BOOL _reloading;
}

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) EGORefreshTableHeaderView *refreshHeaderView;

// create/remove footer/header view, reset the position of the footer/header views
-(void)setFooterView;
-(void)removeFooterView;
-(void)createHeaderView;
-(void)removeHeaderView;

// overide methods
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos;
-(void)finishReloadingData;

// force to refresh
-(void)showRefreshHeader:(BOOL)animated;

@end
