//
//  UseDetailsViewController.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/27.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "UseDetailsViewController.h"

@interface UseDetailsViewController()


@end

@implementation UseDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"优惠券详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initViewFirstUI];
    [self initViewSecondUI];
    [self initViewThirdUI];

}

-(void)initViewFirstUI
{

    UIView *firstView = [[UIView alloc]init];
    firstView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 125);
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.frame = CGRectMake(20, 5, firstView.frame.size.width-40, 30);
    firstLabel.text = @"新人首次下载app可领取150澳币组合优惠券礼包";
    firstLabel.tintColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f];
    firstLabel.font =[UIFont boldSystemFontOfSize:17];
    [firstView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.frame = CGRectMake(20, 45, firstView.frame.size.width-40, 20);
    secondLabel.text = @"优惠券使用限制:";
    secondLabel.alpha = 0.5;
    secondLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:secondLabel];
    
    
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.frame = CGRectMake(20, 70, firstView.frame.size.width-40, 20);
    thirdLabel.text = @"不能兑换现金，不可以叠加使用 ;";
    thirdLabel.alpha = 0.5;
    thirdLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:thirdLabel];

    
    UILabel *fourthLabel = [[UILabel alloc]init];
    fourthLabel.frame = CGRectMake(20, 95, firstView.frame.size.width-40, 20);
    fourthLabel.text = @"退款后不能退还已使用优惠券";
    fourthLabel.alpha = 0.5;
    fourthLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:fourthLabel];

}

-(void)initViewSecondUI
{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 64+125, SCREEN_WIDTH, 10);
    view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1.0f];
    [self.view addSubview:view];

}


-(void)initViewThirdUI
{
    
    UIView *firstView = [[UIView alloc]init];
    firstView.frame = CGRectMake(0, 64+125+10, SCREEN_WIDTH, 145);
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.frame = CGRectMake(20, 0, firstView.frame.size.width-40, 30);
    firstLabel.text = @"具体包括:";
    firstLabel.tintColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f];
    firstLabel.font =[UIFont boldSystemFontOfSize:17];
    [firstView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.frame = CGRectMake(20, 40, firstView.frame.size.width-40, 20);
    secondLabel.text = @"1. 2张3澳币无门槛优惠券";
    secondLabel.alpha = 0.5;
    secondLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:secondLabel];
    
    
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.frame = CGRectMake(20, 65, firstView.frame.size.width-40, 20);
    thirdLabel.text = @"2. 2张10澳币优惠券(满299澳币使用)";
    thirdLabel.alpha = 0.5;
    thirdLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:thirdLabel];
    
    
    UILabel *fourthLabel = [[UILabel alloc]init];
    fourthLabel.frame = CGRectMake(20, 90, firstView.frame.size.width-40, 20);
    fourthLabel.text = @"3. 1张38澳币优惠券(满499澳币使用)";
    fourthLabel.alpha = 0.5;
    fourthLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:fourthLabel];
    
    UILabel *fifthLabel = [[UILabel alloc]init];
    fifthLabel.frame = CGRectMake(20, 115, firstView.frame.size.width-40, 20);
    fifthLabel.text = @"2. 1张48澳币优惠券(满799澳币使用)";
    fifthLabel.alpha = 0.5;
    fifthLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:fifthLabel];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
