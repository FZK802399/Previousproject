//
//  SearchViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-4.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultViewController.h"
#import "SearchHistoryTableViewCell.h"

@interface SearchViewController ()

@end

@implementation SearchViewController{

    NSString * searchWord;
    
    UITapGestureRecognizer *tap;
}

+ (instancetype)searchVC {
    return [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
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
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    
    if (kCurrentSystemVersion >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setExtraCellLineHidden:self.tableView];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView {
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.allItems = [self getSearchArray];
    if (!self.allItems) {
        self.allItems = [[NSMutableArray alloc] initWithCapacity:0];
    }
    [self.tableView reloadData];
}

- (void)resignKeyboard {
    [self.searchBar resignFirstResponder];
}

#pragma mark - tableView数据源代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    rows = [self.allItems count];

    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SearchHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kSearchHistoryTableViewCellMainView];
    if (cell == nil) {
        
        cell = [[SearchHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kSearchHistoryTableViewCellMainView];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    }

    
//    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.menuName.text = [self.allItems objectAtIndex:indexPath.row];
//    CALayer *bottomLayer = [CALayer layer];
//    bottomLayer.frame = CGRectMake(0, 43, 320, 1);
//    bottomLayer.backgroundColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
//    [cell.contentView.layer addSublayer:bottomLayer];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    searchWord = [self.allItems objectAtIndex:indexPath.row];
    [self.searchBar resignFirstResponder];
    [self performSegueWithIdentifier:kSegueSearchResult sender:self];
}


#pragma mark - search Delegate
//search Button 点击监听
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    if (allTrim(self.searchBar.text).length == 0) {
        [self showAlertWithMessage:NSLocalizedString(@"请先输入搜索关键字", nil)];
        return;
    }
    [self.allItems addObject:self.searchBar.text];
    [self SaveArrayToPlist:self.allItems];
    searchWord = allTrim(self.searchBar.text);
    //去除焦点设置
    [searchBar resignFirstResponder];
    [self performSegueWithIdentifier:kSegueSearchResult sender:self];
    
}


-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self.view addGestureRecognizer:tap];
    
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self.view removeGestureRecognizer:tap];
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     
     SearchResultViewController * searchResultView = [segue destinationViewController];
     if ([segue.identifier isEqualToString:kSegueSearchResult]) {
         if ([searchResultView respondsToSelector:@selector(setSearchText:)]) {
//             [searchResultView setValue:self.searchBar.text forKey:@"SearchText"];
             searchResultView.searchText = searchWord;
             searchResultView.TitleName = @"商品搜索";
         }
     }
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }



@end
