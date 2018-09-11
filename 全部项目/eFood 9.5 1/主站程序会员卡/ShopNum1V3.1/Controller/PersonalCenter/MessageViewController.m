//
//  MessageViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageDetailViewController.h"
#import "MessageItemTableViewCell.h"
#import "MJRefresh.h"

@interface MessageViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tableViewData;

@end

@implementation MessageViewController{
    MessageModelMy * currentMessage;
    NSInteger pageIndex;
    NSInteger pageSize;
}
+ (instancetype) create {
    return [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateViewControllerWithIdentifier:@"MessageViewController"];
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
    [self loadLeftBackBtn];
//    [self loadRightShortCutBtn];
    pageIndex = 1;
    pageSize = 20;
    self.tableView.rowHeight = 115;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    ZDXWeakSelf(weakSelf);
    [self.tableView addHeaderWithCallback:^{
        pageIndex = 1;
        [weakSelf.tableViewData removeAllObjects];
        [weakSelf setupTableViewData];
    }];
    
    [self.tableView addFooterWithCallback:^{
        pageIndex ++;
        [weakSelf setupTableViewData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView headerBeginRefreshing];
//    if(_messageList == nil){
//        _messageList = [[MessageList alloc] init];
//        _messageList.view.frame = self.view.bounds;
//        _messageList.tableView.frame = _messageList.view.bounds;
//        _messageList.delegate = self;
//        [self.messageView addSubview:_messageList.view];
//    }else {
//        [_messageList refreshList];
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 发请求，标记已读
    
}

- (NSMutableArray *)tableViewData {
    if (!_tableViewData) {
        _tableViewData = [NSMutableArray array];
    }
    return _tableViewData;
}

- (void)setupTableViewData {
    NSDictionary * messageDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 kWebAppSign,@"AppSign",
                                 self.appConfig.loginName, @"receiveMemLoginID",
                                 @(pageIndex),@"pageIndex",
                                 @(pageSize),@"pageCount", nil];
    ZDXWeakSelf(weakSelf);
    [MessageModelMy getMessageListWithParameters:messageDic andblock:^(NSArray *list, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        if(error){
            [weakSelf showErrorMessage:@"网络异常"];
        } else {
            if (list && list.count > 0) {
                [weakSelf.tableViewData addObjectsFromArray:list];
                [weakSelf.tableView reloadData];
            } else {
                // 无数据时判断
                if (self.tableViewData.count > 0) {
                    [weakSelf showMessage:@"暂无更多消息"];
                } else {
                    [weakSelf showMessage:@"暂无消息"];
                }
            }
        }
    }];
}


-(void)selectedMessage:(MessageModelMy *)model{
    currentMessage = model;
    [self performSegueWithIdentifier:kSegueMessagListToDetail sender:self];
    
}


#pragma mark - UITableView Delegate Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tableViewData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MessageItemTableViewCell";
    MessageItemTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){        
        cell = [[MessageItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                               reuseIdentifier:CellIdentifier
                                           containingTableView:tableView // Used for row height and selection
                                            leftUtilityButtons:nil
                                           rightUtilityButtons:nil];
//        cell = [[MessageItemTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    MessageModelMy *MessageModelMy = [self.tableViewData objectAtIndex:indexPath.row];
    [cell createWithMessageModelMy:MessageModelMy];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageModelMy *selectMessage = [self.tableViewData objectAtIndex:indexPath.row];
    [self selectedMessage:selectMessage];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MessageModelMy *selectMessage = [self.tableViewData objectAtIndex:indexPath.row];        
        NSDictionary * messageDeleteDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                           kWebAppSign,@"AppSign",
                                           self.appConfig.loginName, @"memLoginID",
                                           selectMessage.Guid,@"msgId",nil];
        ZDXWeakSelf(weakSelf);
        [MessageModelMy deleteMessageWithParameters:messageDeleteDic andblock:^(NSInteger result, NSError *error) {
            if(error) {
                    [weakSelf showErrorMessage:@"网络异常"];
            } else {
                if(result == 202){
                    [weakSelf.tableViewData removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                }else{
                    [weakSelf showErrorMessage:@"删除失败"];
                }
            }
        }];
    }
}


#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MessageDetailViewController * mdvc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueMessagListToDetail]) {
        if ([mdvc respondsToSelector:@selector(setMessageDeatil:)]) {
            mdvc.MessageDeatil = currentMessage;
        }
    }
}


@end
