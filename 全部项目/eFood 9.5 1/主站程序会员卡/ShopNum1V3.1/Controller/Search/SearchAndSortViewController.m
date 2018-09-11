//
//  SearchAndSortViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-12.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SearchAndSortViewController.h"
#import "brandCollectionViewCell.h"
#import "SortModel.h"
#import "SearchResultViewController.h"
#import "SortBrandReusableView.h"
#import "secondSortTableViewCell.h"
#import "ShopsViewController.h"
@interface SearchAndSortViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic)  UITableView *SecondTableView;
@property (strong, nonatomic)  UITableView *SortTableView;

@end

@implementation SearchAndSortViewController{
    
    NSIndexPath * TableViewSelectPath;
    NSString * BrandGuid;
    NSString * ProductCategoryID;
    SortModel * FatherModel;
    NSString * titleName;
    UITapGestureRecognizer *tap;
    //webView
    NSString *webSiteUrl;
    //判断是否客户点击的是品牌中心 如果为品牌中心为YES 其他为NO
    BOOL isShops;
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
    isShops = NO;
    if (kCurrentSystemVersion >= 7.0) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //    self.SortTopImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 225, 60)];
    //    self.SortTopImageView.contentMode = UIViewContentModeScaleAspectFit;
    //    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 235, 68)];
    //    UIView * spaceView = [[UIView alloc] initWithFrame:CGRectMake(5, 60, 225, 8)];
    //    spaceView.backgroundColor = [UIColor whiteColor];
    //    [headerView addSubview:self.SortTopImageView];
    //    [headerView addSubview:spaceView];
    //
    //    self.SecondTableView.tableHeaderView = headerView;
    //
    //    self.SecondTableView.layer.borderWidth = 1;
    //    self.SecondTableView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    //    TableViewSelectPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    //注册CollectionView的 cell
    //    [self.SortAllCollectionView registerClass:[brandCollectionViewCell class] forCellWithReuseIdentifier:kSortBrandCollectionCellMainView];
    
    
    //    [self loadBrandCollectioniewData];
    
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setupFirstTableView];
}


- (void)setupFirstTableView {
    CGRect frame = _contentView.bounds;
    frame.size.height = SCREEN_HEIGHT - 64 - 49 - 44;
    
    _SortTableView = [[UITableView alloc] initWithFrame:frame];
    self.SortTableView.delegate = self;
    self.SortTableView.dataSource = self;
    self.SortTableView.rowHeight = 40.0f;
    self.SortTableView.tag = 101;
    [self.contentView addSubview:_SortTableView];
    [self setExtraCellLineHidden:_SortTableView];
    [self loadTableViewData];
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
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

- (void)setupSecondTableView {
    if (CGRectGetWidth(self.SortTableView.frame) == SCREEN_WIDTH) {
        CGRect frame = self.SortTableView.bounds;
        CGFloat width = CGRectGetWidth(self.SortTableView.frame) / 3.0;
        frame.size.width = width;
        self.SortTableView.frame = frame;
        
        frame.origin.x = width;
        frame.size.width = SCREEN_WIDTH - width;
        _SecondTableView = [[UITableView alloc] initWithFrame:frame];
        _SecondTableView.delegate = self;
        _SecondTableView.dataSource = self;
        _SecondTableView.rowHeight = 40.0f;
//        [self setExtraCellLineHidden:_SecondTableView];
        
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor clearColor];
        [_SecondTableView setTableFooterView:view];
        [self.contentView addSubview:_SecondTableView];
    }
}

- (void)resignKeyboard {
    [self.SortSearchBar resignFirstResponder];
}

-(void)loadTableViewData {
    
    NSDictionary * allSortDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"0",@"id",
                                 kWebAppSign, @"AppSign",
                                 nil];
    [SortModel getAllSortsByParamer:allSortDic andBlocks:^(NSArray *sortsList, NSError *error) {
        if(error){
            
            [self showAlertWithMessage:NSLocalizedString(@"获取信息错误", nil)];
            
        }else {
            
            [self.AllSorts removeAllObjects];
            NSInteger introCount = [sortsList count];
            if (introCount > 0) {
                self.AllSorts = [NSMutableArray arrayWithArray:sortsList];
                [self.SortTableView reloadData];
                //                NSIndexPath *selectPath = [NSIndexPath indexPathForRow:0 inSection:0];
                //                [self.SortTableView selectRowAtIndexPath:selectPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                //                [self.SecondTableView setHidden:YES];
                //                [self.SortAllCollectionView setHidden:NO];
            }
        }
    }];
}

-(void)loadBrandCollectioniewData {
    
    if ([self.secondBrandDatas count] == 0) {
        NSDictionary *getBrandIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          kWebAppSign, @"AppSign", nil];
        
        [BrandModel getAllBrandsByParamer:getBrandIntroDic andBlocks:^(NSArray *brandList, NSError *error) {
            if(error){
                
                [self showAlertWithMessage:NSLocalizedString(@"获取信息错误", nil)];
                
            }else{
                //            [self.secondBrandDatas removeAllObjects];
                NSInteger introCount;
                if (![brandList isEqual:[NSNull null]]) {
                    introCount = [brandList count];
                }
                
                //首先判断是否有数据
                if (introCount > 0) {
                    self.secondBrandDatas =[NSMutableArray arrayWithArray:brandList];
                    
                    //                UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
                    //                [self.SortTopImageView setImageWithURL:[[self.secondSortDatas objectAtIndex:0] logoUrl] placeholderImage:blankImg];
                    [self.SortAllCollectionView reloadData];
                }
            }
        }];
    }else {
        //        [self.SortAllCollectionView reloadData];
    }
}


-(void)loadSortCollectioniewDataById:(NSString *) sortID {
    NSDictionary *getBrandIntroDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                      sortID, @"id",
                                      kWebAppSign, @"AppSign", nil];
    [SortModel getSecondSortsByParamer:getBrandIntroDic andBlocks:^(NSArray *sortsList, NSError *error) {
        if(error){
            
            [self showAlertWithMessage:NSLocalizedString(@"获取信息错误", nil)];
        }else{
            [self.secondSortDatas removeAllObjects];
            NSInteger introCount;
            if (![sortsList isEqual:[NSNull null]]) {
                introCount = [sortsList count];
            }
            
            if (introCount == 0) {
                NSDictionary * sortdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                          sortID,@"ID",
                                          @"其他商品",@"Name",
                                          @"其他商品", @"Keywords",
                                          @" ",@"Description",
                                          @"1",@"OrderID",
                                          @"1",@"CategoryLevel",
                                          @"0",@"FatherID",
                                          @"false", @"IsLastLevel",
                                          @" ",@"AgentID",
                                          @"http://fxv86.nrqiang.com/ImgUpload/2015.jpg",@"BackgroundImage", nil];
                SortModel * tempModel = [[SortModel alloc] initWithAttributes:sortdic];
                self.secondSortDatas = [NSMutableArray arrayWithObject:tempModel];
                [self.SecondTableView reloadData];
            }else{
                self.secondSortDatas =[NSMutableArray arrayWithArray:sortsList];
                [self.SecondTableView reloadData];
            }
        }
    }];
}



#pragma mark - collection数据源代理
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    SortBrandReusableView * ReusableView= nil;
    if (kind == UICollectionElementKindSectionHeader) {
        ReusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        
        if (TableViewSelectPath.row == 0) {
            [ReusableView.backgroundImage setImage:[UIImage imageNamed:@"brandsearch_banner.png"]];
        }
        //        else {
        //            SortModel * selectSortModel = [self.AllSorts objectAtIndex:TableViewSelectPath.row - 1];
        //
        //            UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
        //
        //            [ReusableView.backgroundImage setImageWithURL:selectSortModel.BackgroundImage placeholderImage:blankImg];
        //
        //        }
    }
    return ReusableView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (TableViewSelectPath.row == 0) {
        return self.secondBrandDatas.count;
    }
    return self.secondSortDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    brandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSortBrandCollectionCellMainView forIndexPath:indexPath];
    if (TableViewSelectPath.row == 0) {
        
        [cell creatbrandCollectionViewCellWithMerchandiseIntroModel:[self.secondBrandDatas objectAtIndex:indexPath.row]];
    }
    //    else{
    //
    //        [cell creatSortCollectionViewCellWithMerchandiseIntroModel:[self.secondSortDatas objectAtIndex:indexPath.row]];
    //    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.SortSearchBar resignFirstResponder];
    if (TableViewSelectPath.row == 0) {
        ProductCategoryID = @"";
        BrandModel * tempBrand = [self.secondBrandDatas objectAtIndex:indexPath.row];
        BrandGuid = tempBrand.guid;
        titleName = tempBrand.name;
        webSiteUrl = tempBrand.webSiteUrl;
    }
    //    else {
    //        BrandGuid = @"";
    //        SortModel * tempSort = [self.secondSortDatas objectAtIndex:indexPath.row];
    //        ProductCategoryID = [NSString stringWithFormat:@"%@", tempSort.SortID];
    //        titleName = tempSort.Name;
    //    }
    if (isShops) {
        [self performSegueWithIdentifier:@"kSegueShopToResult" sender:self];
    }else {
        [self performSegueWithIdentifier:kSegueGetproductBySort sender:self];
    }
}


#pragma mark - tableView数据源代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 101) {
        NSInteger rows = 0;
        rows = [self.AllSorts count];
        //        if (rows > 0) {
        //            rows = rows + 0;
        //        }else{
        //            rows = 0;
        //        }
        
        return rows;
    }else{
        
        return [self.secondSortDatas count];
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell1";
    static NSString *CellIdentifier2 = @"Cell2";
    
    if (tableView.tag == 101) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *backView = [[UIView alloc] initWithFrame:cell.frame];
            backView.backgroundColor = [UIColor whiteColor];
            cell.selectedBackgroundView = backView;
            cell.backgroundColor = [UIColor colorWithWhite:0.966 alpha:1.000];
            
            // 右侧竖线
            //            UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(roundf(CGRectGetMaxX(tableView.frame) - 0.5), 0, 0.5, CGRectGetHeight(cell.frame))];
            //            sepView.backgroundColor = [UIColor colorWithWhite:0.491 alpha:1.000];
            //            [cell addSubview:sepView];
            
        }
        //        UIImageView * backGroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_sortbg_normal.png"]];
        //        cell.backgroundView = backGroundView;
        //
        //        UIImageView * selectView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"search_sortbg_select.png"]];
        //        cell.selectedBackgroundView = selectView;
        /* Configure the cell. */
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.highlightedTextColor = [UIColor barTitleColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        [cell.textLabel setFont:[UIFont systemFontOfSize:13]];
        
        //        if (indexPath.row == 0) {
        //            cell.textLabel.text = @"品牌中心";
        //        }else{
        SortModel * thisSort = [self.AllSorts objectAtIndex:indexPath.row];
        cell.textLabel.text = thisSort.Name;
        //        }
        return cell;
    }else {
        
        UITableViewCell *secondcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (secondcell == nil) {
            secondcell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault                   reuseIdentifier:CellIdentifier2];
            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            secondcell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        secondcell.textLabel.textAlignment = NSTextAlignmentLeft;
        secondcell.textLabel.textColor = [UIColor grayColor];
        secondcell.textLabel.highlightedTextColor = [UIColor barTitleColor];
        secondcell.textLabel.backgroundColor = [UIColor clearColor];
        [secondcell.textLabel setFont:[UIFont systemFontOfSize:13]];
        secondcell.selectionStyle = UITableViewCellSelectionStyleNone;
        secondcell.textLabel.text = [[self.secondSortDatas objectAtIndex:indexPath.row] Name];
        return secondcell;
        
        //        secondSortTableViewCell * secondcell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        //        if (secondcell == nil) {
        //            secondcell = [[secondSortTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
        //        }
        //        secondcell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        secondcell.menuName.text = [[self.secondSortDatas objectAtIndex:indexPath.row] Name];
        //        return secondcell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.SortSearchBar resignFirstResponder];
    if (tableView.tag == 101) {
        //        if (TableViewSelectPath.row == indexPath.row) {
        //            return;
        //        }
        //        TableViewSelectPath = indexPath;
        //        if (indexPath.row == 0) {
        //客户点击了第一行
        //            isShops = YES;
        //            [self.SecondTableView setHidden:YES];
        //            [self.SortAllCollectionView setHidden:NO];
        //            [self loadBrandCollectioniewData];
        //        }else{
        isShops =NO;
        //            [self.SecondTableView setHidden:NO];
        //            [self.SortAllCollectionView setHidden:YES];
        SortModel * selectSortModel = [self.AllSorts objectAtIndex:indexPath.row];
        FatherModel = selectSortModel;
        [self setupSecondTableView];
        [self loadSortCollectioniewDataById:selectSortModel.SortID];
        
        
        //            UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
        //            [self.SortTopImageView setImageWithURL:selectSortModel.BackgroundImage  placeholderImage:blankImg];
        //        }
        
    }else {
        
        BrandGuid = @"";
        SortModel * tempSort = [self.secondSortDatas objectAtIndex:indexPath.row];
        ProductCategoryID = [NSString stringWithFormat:@"%@", tempSort.SortID];
        titleName = tempSort.Name;
        [self performSegueWithIdentifier:kSegueGetproductBySort sender:self];
    }
}

// 兼容iOS7 8 分隔线铺满
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (allTrim(self.SortSearchBar.text).length == 0) {
        [self showAlertWithMessage:NSLocalizedString(@"请先输入搜索关键字", nil)];
        return;
    }
    [self.SortSearchBar resignFirstResponder];
    [self performSegueWithIdentifier:kSegueSortToSearchResult sender:self];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    [self.view addGestureRecognizer:tap];
//    [self resignKeyboard];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.view removeGestureRecognizer:tap];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //    NSLog(@"%hhd",isShops);
    if (isShops == YES) {
        ShopsViewController *shopVC = [segue destinationViewController];
        if ([segue.identifier isEqualToString:@"kSegueShopToResult"]) {
            shopVC.shopName = titleName;
            shopVC.webSiteUrl = webSiteUrl;
        }
    } else {
        
        SearchResultViewController * resultView = [segue destinationViewController];
        if ([segue.identifier isEqualToString:kSegueSortToSearchResult]) {
            if ([resultView respondsToSelector:@selector(setSearchText:)]) {
//                [resultView setValue:allTrim(self.SortSearchBar.text) forKey:@"searchText"];
                resultView.searchText = allTrim(self.SortSearchBar.text);
                resultView.TitleName = @"商品搜索";
            }
        }else if ([segue.identifier isEqualToString:kSegueGetproductBySort]){
            if ([resultView respondsToSelector:@selector(setSearchBrandGuid:)] && [resultView respondsToSelector:@selector(setSearchProductCategoryID:)]) {
                resultView.searchText = @"";
                [resultView setValue:BrandGuid forKey:@"searchBrandGuid"];
                [resultView setValue:ProductCategoryID forKey:@"searchProductCategoryID"];
                [resultView setValue:FatherModel forKey:@"fatherModel"];
                resultView.TitleName = titleName;
            }
        }
    }
}

@end
