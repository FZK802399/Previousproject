//
//  RecommenListdViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "RecommenListdViewController.h"

@interface RecommenListdViewController ()

@end

@implementation RecommenListdViewController

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
    [self.topView setBackgroundColor:[self getMatchTopColor]];
    
    [self TableViewRegisterNib];
    
    // Do any additional setup after loading the view.
}

-(void)TableViewRegisterNib{
    UINib *cellNib = [UINib nibWithNibName:@"RecommendPersonTableViewCell" bundle:nil];
    [self.ShowTableView registerNib:cellNib forCellReuseIdentifier:RecommendPersonTableViewCellID];
    
    UINib *reusableViewNib = [UINib nibWithNibName:@"RecommendScoreTableViewCell" bundle:nil];
    [self.ShowTableView registerNib:reusableViewNib forCellReuseIdentifier:RecommendScoreTableViewCellID];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeViewAction:self.RecommendPerBtn];
}

-(void)reloadShowData {
    [self.ShowData removeAllObjects];
    [self.ShowTableView reloadData];
    if (self.ShowType == RecommendForPerson) {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.appConfig.loginName,@"CommendPeople",
                             self.appConfig.appSign,@"AppSign", nil];
        [RecommendPersonModel getRecommendPersonListByParameters:dic andblock:^(NSArray *List, NSError *error) {
            if (error) {
                
            }else {
                if (List.count > 0) {
                    self.ShowData = [NSMutableArray arrayWithArray:List];
                    self.personData = [NSArray arrayWithArray:List];
                    [self.ShowTableView reloadData];
                }
            }
        }];
    }else{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             self.appConfig.loginName,@"MemLoginID",
                             self.appConfig.appSign,@"AppSign", nil];
        [RecommendScoreModel getRecommendScoreListByParameters:dic andblock:^(NSArray *List, NSError *error) {
            if (error) {
                
            }else {
                if (List.count > 0) {
                    self.ShowData = [NSMutableArray arrayWithArray:List];
                    self.rebateData = [NSArray arrayWithArray:List];
                    [self.ShowTableView reloadData];
                }
            }
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSLog(@"self.ShowData.count == %d", self.personData.count);
    return self.ShowData.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.ShowType == RecommendForPerson){
//        NSLog(@"wewewwewe");
        RecommendPersonTableViewCell *cell = (RecommendPersonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RecommendPersonTableViewCellID];
        if(cell == nil){
//            NSLog(@"2222222wewewwewe");
            cell =[[[NSBundle mainBundle] loadNibNamed:@"RecommendPersonTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
//        NSLog(@"indexPath.row = =%d", [self.personData count]);
        if(indexPath.row < [self.personData count]){
//            NSLog(@"111111111wewewwewe");
            RecommendPersonModel *currentModel = [self.personData objectAtIndex:indexPath.row];
            [cell creatRecommendPersonTableViewCell:currentModel];
        }
        return cell;
    }else{
        RecommendScoreTableViewCell *cell = (RecommendScoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RecommendScoreTableViewCellID];
        if(cell == nil){
            cell =[[[NSBundle mainBundle] loadNibNamed:@"RecommendScoreTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        if(indexPath.row < [self.rebateData count]){
            RecommendScoreModel *currentModel = [self.rebateData objectAtIndex:indexPath.row];
            [cell creatRecommendScoreTableViewCell:currentModel];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.ShowType == RecommendForPerson){
        return 150.0f;
    }else{
        return 105.0f;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (IBAction)changeViewAction:(id)sender {
    UIButton * btn = (UIButton *)sender;
    if (btn.tag == 101) {
        
        [self.RecommendPerBtn setBackgroundImage:[UIImage imageNamed:@"big_leftbg_selected.png"] forState:UIControlStateNormal];
        [self.RecommendPerBtn setTitleColor:[UIColor barTitleColor] forState:UIControlStateNormal];
        [self.RecommendScoreBtn setBackgroundImage:[UIImage imageNamed:@"big_rightbg_normal.png"] forState:UIControlStateNormal];
        [self.RecommendScoreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.ShowType = RecommendForPerson;
        [self reloadShowData];
    }
    
    if (btn.tag == 102) {
        
        [self.RecommendScoreBtn setBackgroundImage:[UIImage imageNamed:@"big_rightbg_selected.png"] forState:UIControlStateNormal];
        [self.RecommendScoreBtn setTitleColor:[UIColor barTitleColor] forState:UIControlStateNormal];
        [self.RecommendPerBtn setBackgroundImage:[UIImage imageNamed:@"big_leftbg_normal.png"] forState:UIControlStateNormal];
        [self.RecommendPerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.ShowType = RecommendForScore;
        [self reloadShowData];
    }
}
@end
