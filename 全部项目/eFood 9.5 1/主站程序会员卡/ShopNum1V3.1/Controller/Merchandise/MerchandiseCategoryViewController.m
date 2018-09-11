//
//  MerchandiseCategoryViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-28.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "MerchandiseCategoryViewController.h"
#import "ProductCategoryTableViewCell.h"
#import "SearchResultViewController.h"

@interface MerchandiseCategoryViewController ()

@property (nonatomic, strong) NSArray *topCategoryList;
@property (nonatomic, strong) NSArray *childCategoryList;

@end

@implementation MerchandiseCategoryViewController {

    NSInteger sortId;

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
    self.rootID = 0;
    [self getCategoryList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getCategoryList{
    
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                          kWebAppSign,@"AppSign",
                          [NSNumber numberWithInteger:self.rootID],@"FatherID", nil];
    [SortModel getScoreSortsByParamer:dic andBlocks:^(NSArray *sortsList, NSError *error) {
        if(error){
            
        }else{
            [self loadHeadViewModelWithMerchandiseCategoryArray:sortsList];
            _topCategoryList = [NSArray arrayWithArray:sortsList];
            [self.categoryTableView reloadData];
        }
        
    }];
    
}

- (void)loadHeadViewModelWithMerchandiseCategoryArray:(NSArray *)CategoryArray{
    _currentRow = -1;
    _headViewArray = [[NSMutableArray alloc] initWithCapacity:CategoryArray.count];
    for(int i = 0;i< CategoryArray.count ;i++)
	{
        SortModel * tempModel = [CategoryArray objectAtIndex:i];
		HeadView* headview = [[HeadView alloc] init];
        headview.delegate = self;
		headview.section = i;
        //        headview.imgIcon.image = [self.headIconArray objectAtIndex:i];
        [headview createHeadViewCategoryItem:tempModel];
		[self.headViewArray addObject:headview];
	}
}
     

#pragma mark - UITableViewDataSource
#pragma mark - TableViewdelegate&&TableViewdataSource

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HeadView* headView = [self.headViewArray objectAtIndex:indexPath.section];
    
    return headView.open?44:0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HeadView * headerView = [self.headViewArray objectAtIndex:section];
    if (headerView.open) {
        headerView.imgArrow.image = [UIImage imageNamed:@"ico_arrow_up.png"];
    }else{
        headerView.imgArrow.image = [UIImage imageNamed:@"ico_arrow_down.png"];
    }
    
    return headerView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    HeadView* headView = [self.headViewArray objectAtIndex:section];
    return headView.open ? [self.childCategoryList count] : 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.headViewArray count];
}


#pragma mark - HeadViewdelegate
-(void)selectedWith:(HeadView *)view{
    _currentRow = -1;
    
    _currentSection = view.section;
    
    if (!view.open) {
        SortModel *selectCategory = [_topCategoryList objectAtIndex:_currentSection];
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              kWebAppSign,@"AppSign",
                              selectCategory.SortID,@"FatherID", nil];
        [SortModel getScoreSortsByParamer:dic andBlocks:^(NSArray *sortsList, NSError *error) {
            if(error){

            }else{
                if (sortsList.count > 0) {
                    _childCategoryList = [NSArray arrayWithArray:sortsList];
                }else {
                
                    NSDictionary * sortdic = [NSDictionary dictionaryWithObjectsAndKeys:
                                              selectCategory.SortID,@"ID",
                                              @"其他商品",@"Name",
                                              @"其他商品", @"Keywords",
                                              @" ",@"Description",
                                              @"1",@"OrderID",
                                              @"1",@"CategoryLevel",
                                              @"0",@"FatherID",
                                              @"1", @"IsShow",nil];
                    SortModel * tempModel = [[SortModel alloc] initWithAttributes:sortdic];
                    _childCategoryList = [NSArray arrayWithObjects:tempModel, nil];
                
                }
                
                [self reset];
            }
        }];
    }else{
        [self reset];
    }
}

//界面重置
- (void)reset
{
    for(int i = 0;i<[_headViewArray count];i++)
    {
        HeadView *head = [_headViewArray objectAtIndex:i];
        
        if(head.section == _currentSection)
        {
            head.open = !head.open;
        }else {
            head.open = NO;
        }
        
    }
    [self.categoryTableView reloadData];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIndicator = @"CellIndicator";
    
    ProductCategoryTableViewCell *cell = (ProductCategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIndicator];
    if(cell == nil){
        cell = [[ProductCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndicator];
    }
    
    if(indexPath.row < [_childCategoryList count]){
        SortModel *currentCategory = [_childCategoryList objectAtIndex:indexPath.row];
        [cell createCategoryItem:currentCategory];
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //子分类
    SortModel *selectCategory = [_childCategoryList objectAtIndex:indexPath.row];
    sortId = [selectCategory.SortID integerValue];
    [self performSegueWithIdentifier:kSegueScoreSortToList sender:nil];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    SearchResultViewController * resultVC = [segue destinationViewController];
    if ([segue.identifier isEqualToString:kSegueScoreSortToList]) {
        if ([resultVC respondsToSelector:@selector(setShopID:)]) {
            resultVC.TitleName = @"积分商品";
            resultVC.ScoreProductCategoryID = sortId;
            resultVC.viewType = MerchandiseForScore;
        }
    }
}


@end
