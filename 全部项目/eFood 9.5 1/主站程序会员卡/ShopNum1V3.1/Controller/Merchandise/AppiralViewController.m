//
//  AppiralViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-26.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "AppiralViewController.h"
#import "CommentDetailModel.h"


//-------------------------------------------------------------------------------


@interface AppiralViewController ()

@end

@implementation AppiralViewController

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
    [self loadRightShortCutBtn];
    [self.topView setBackgroundColor:[self getMatchTopColor]];
    self.title = @"商品评价";
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([[self.btnAppiral backgroundImageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"big_leftbg_selected.png"]]) {
        //加载商品评价
        [self loadCommentListWithViewTyep:CommentForMerchandise];
    }else{
        //加载商品评价
        [self loadCommentListWithViewTyep:CommentForPicture];
    }
    

}


-(void)loadCommentListWithViewTyep:(CommentListViewType) viewType{
    
    [_appraisalListView.view removeFromSuperview];
    _appraisalListView = [[CommentList alloc] init];
    _appraisalListView.view.frame = self.ViewContent.bounds;
    _appraisalListView.tableView.frame = _appraisalListView.view.bounds;
    _appraisalListView.viewType = viewType;
    _appraisalListView.merchandiseGuid = self.ProductGuid;
    [self.ViewContent addSubview:_appraisalListView.view];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)changeViewClick:(id)sender {
    
    UIButton * btn = (UIButton *)sender;
    if (btn.tag == 101) {
        
        [self.btnAppiral setBackgroundImage:[UIImage imageNamed:@"big_leftbg_selected.png"] forState:UIControlStateNormal];
        [self.btnAppiral setTitleColor:[UIColor barTitleColor] forState:UIControlStateNormal];
        [self.btnBlueprinting setBackgroundImage:[UIImage imageNamed:@"big_rightbg_normal.png"] forState:UIControlStateNormal];
        [self.btnBlueprinting setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self loadCommentListWithViewTyep:CommentForMerchandise];
        self.title = @"商品评价";
    }
    if (btn.tag == 102) {
        
        [self.btnBlueprinting setBackgroundImage:[UIImage imageNamed:@"big_rightbg_selected.png"] forState:UIControlStateNormal];
        [self.btnBlueprinting setTitleColor:[UIColor barTitleColor] forState:UIControlStateNormal];
        [self.btnAppiral setBackgroundImage:[UIImage imageNamed:@"big_leftbg_normal.png"] forState:UIControlStateNormal];
        [self.btnAppiral setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self loadCommentListWithViewTyep:CommentForPicture];
        self.title = @"商品晒单";
    }

}
@end
