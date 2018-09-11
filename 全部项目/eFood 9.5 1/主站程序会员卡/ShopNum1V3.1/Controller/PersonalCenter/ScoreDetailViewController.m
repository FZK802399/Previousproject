//
//  ScoreDetailViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-2.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ScoreDetailViewController.h"


@interface ScoreTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *conent;
@property (strong, nonatomic) IBOutlet UILabel *timeLabe;

-(void)creatScoreTableViewCellWithScoreModel:(ScoreModel*)intro;

@end

@implementation ScoreTableViewCell

-(void)creatScoreTableViewCellWithScoreModel:(ScoreModel *)intro{
    switch (intro.OperateType) {
        case 0:
            self.conent.text = [NSString stringWithFormat:@"-%d", intro.OperateScore];
            break;
        case 1:
            self.conent.text = [NSString stringWithFormat:@"+%d", intro.OperateScore];
            break;
        case 2:
            self.conent.text = [NSString stringWithFormat:@"+%d", intro.OperateScore];
            break;
        case 3:
            self.conent.text = [NSString stringWithFormat:@"+%d", intro.OperateScore];
            break;
        default:
            break;
    }
    if ([intro.Memo hasPrefix:@"后台"] || intro.Memo.length == 0) {
        if (intro.OperateType == 0) {
            intro.Memo = @"后台提取";
        }else{
            intro.Memo = @"后台添加";
        }
    }
    
    self.titleLabel.text = intro.Memo;
    
    self.timeLabe.text = intro.CreateTime;
}

@end
//--------------------------------------------------------------------------

@interface ScoreDetailViewController ()

@end

@implementation ScoreDetailViewController

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
    self.currentScore.text = [NSString stringWithFormat:@"%d", self.appConfig.userScore];
    [self loadScoreDetailData];
    self.ScoreDetailTbleView.layer.borderWidth = 1;
    self.ScoreDetailTbleView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    // Do any additional setup after loading the view.
}

-(void)loadScoreDetailData{
    NSDictionary * scoreDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               kWebAppSign, @"AppSign",
                               self.appConfig.loginName, @"MemLoginID",
                               nil];
    [ScoreModel getScoreDetailByparameters:scoreDic andblock:^(NSArray *List, NSError *error) {
        if (error) {
            
        }else {
            if ([List count] > 0) {
                self.ScoreDetailList = [NSArray arrayWithArray:List];
                [self.ScoreDetailTbleView reloadData];
            }
        }
    }];
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

#pragma mark - tableView数据源代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger rows = 0;
    rows = [self.ScoreDetailList count];
    return rows;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kScoreTableViewCellMainView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatScoreTableViewCellWithScoreModel:[self.ScoreDetailList objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}


@end
