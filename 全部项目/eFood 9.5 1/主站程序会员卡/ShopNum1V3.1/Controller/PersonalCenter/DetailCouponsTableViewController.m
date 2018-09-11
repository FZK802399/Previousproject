//
//  DetailCouponsTableViewController.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/15.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "DetailCouponsTableViewController.h"

@interface DetailCouponsTableViewController ()

{
    UITableView *_tableView;

}

@end

@implementation DetailCouponsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"优惠券详情";
    _tableView  = self.view;
     [self initViewFirstUI];
     [self initViewSecondUI];
     [self initViewThirdUI];
     [self initViewFourthUI];
     [self initViewFifthUI];
     [self initViewSixthUI];
     [self initViewSeventhdUI];
     [self initViewEightthUI];
     [self initViewNinthUI];


}

-(void)initViewFirstUI
{
    
    UIView *firstView = [[UIView alloc]init];
    firstView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 125);
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
    secondLabel.text = @"优惠券使用限制：";
    secondLabel.alpha = 0.5;
    secondLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:secondLabel];
    
    
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.frame = CGRectMake(20, 70, firstView.frame.size.width-40, 20);
    thirdLabel.text = @"不能兑换现金，不可以叠加使用；";
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
    view.frame = CGRectMake(0, 125, SCREEN_WIDTH, 10);
    view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1.0f];
    [self.view addSubview:view];
    
}


-(void)initViewThirdUI
{
    
    UIView *firstView = [[UIView alloc]init];
    firstView.frame = CGRectMake(0, 125+10, SCREEN_WIDTH, 145);
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.frame = CGRectMake(20, 0, firstView.frame.size.width-40, 30);
    firstLabel.text = @"具体包括：";
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

-(void)initViewFourthUI
{
    
    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 125+10+145, SCREEN_WIDTH, 2);
    view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1.0f];
    [self.view addSubview:view];
    
}

-(void)initViewFifthUI
{
    UIView *firstView = [[UIView alloc]init];
    firstView.frame = CGRectMake(0, 125+10+145+2, SCREEN_WIDTH, 225);
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.frame = CGRectMake(20, 5, firstView.frame.size.width-40, 30);
    firstLabel.text = @"全场优惠券：";
    firstLabel.tintColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f];
    firstLabel.font =[UIFont boldSystemFontOfSize:17];
    [firstView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.frame = CGRectMake(20, 45, firstView.frame.size.width-40, 20);
    secondLabel.text = @"优惠券使用限制：";
    secondLabel.alpha = 0.5;
    secondLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:secondLabel];
    
    
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.frame = CGRectMake(20, 70, firstView.frame.size.width-40, 20);
    thirdLabel.text = @"不能兑换现金，不可以叠加使用；";
    thirdLabel.alpha = 0.5;
    thirdLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:thirdLabel];
    
    
    UILabel *fourthLabel = [[UILabel alloc]init];
    fourthLabel.frame = CGRectMake(20, 95, firstView.frame.size.width-40, 20);
    fourthLabel.text = @"退款后不能退还已使用优惠券";
    fourthLabel.alpha = 0.5;
    fourthLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:fourthLabel];
    
    UILabel *fifthLabel = [[UILabel alloc]init];
    fifthLabel.frame = CGRectMake(20, 130, firstView.frame.size.width-40, 30);
    fifthLabel.text = @"具体包括：";
    fifthLabel.tintColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f];
    fifthLabel.font =[UIFont boldSystemFontOfSize:17];
    [firstView addSubview:fifthLabel];
    
    
    UILabel *sixthLabel = [[UILabel alloc]init];
    sixthLabel.frame = CGRectMake(20, 170, firstView.frame.size.width-40, 20);
    sixthLabel.text = @"订单金额实际支付达到优惠券提示面额；";
    sixthLabel.alpha = 0.5;
    sixthLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:sixthLabel];

    UILabel *seventhLabel = [[UILabel alloc]init];
    seventhLabel.frame = CGRectMake(20, 195, firstView.frame.size.width-40, 20);
    seventhLabel.text = @"包括运费及积分实际抵扣后，可使用的全场满减券。";
    seventhLabel.alpha = 0.5;
    seventhLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:seventhLabel];



}
-(void)initViewSixthUI
{


    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 125+10+145+2+225, SCREEN_WIDTH, 2);
    view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1.0f];
    [self.view addSubview:view];


}

-(void)initViewSeventhdUI
{

    UIView *firstView = [[UIView alloc]init];
    firstView.frame = CGRectMake(0, 125+10+145+2+225+2, SCREEN_WIDTH, 250);
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.frame = CGRectMake(20, 5, firstView.frame.size.width-40, 30);
    firstLabel.text = @"商品优惠券：";
    firstLabel.tintColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f];
    firstLabel.font =[UIFont boldSystemFontOfSize:17];
    [firstView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.frame = CGRectMake(20, 45, firstView.frame.size.width-40, 20);
    secondLabel.text = @"优惠券使用限制：";
    secondLabel.alpha = 0.5;
    secondLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:secondLabel];
    
    
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.frame = CGRectMake(20, 70, firstView.frame.size.width-40, 20);
    thirdLabel.text = @"不能兑换现金，不可以叠加使用；";
    thirdLabel.alpha = 0.5;
    thirdLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:thirdLabel];
    
    
    UILabel *fourthLabel = [[UILabel alloc]init];
    fourthLabel.frame = CGRectMake(20, 95, firstView.frame.size.width-40, 20);
    fourthLabel.text = @"退款后不能退还已使用优惠券";
    fourthLabel.alpha = 0.5;
    fourthLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:fourthLabel];
    
    UILabel *fifthLabel = [[UILabel alloc]init];
    fifthLabel.frame = CGRectMake(20, 130, firstView.frame.size.width-40, 30);
    fifthLabel.text = @"使用规则：";
    fifthLabel.tintColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f];
    fifthLabel.font =[UIFont boldSystemFontOfSize:17];
    [firstView addSubview:fifthLabel];
    
    
    UILabel *sixthLabel = [[UILabel alloc]init];
    sixthLabel.frame = CGRectMake(20, 170, firstView.frame.size.width-40, 20);
    sixthLabel.text = @"针对某款或某几款商品可使用的优惠券；";
    sixthLabel.alpha = 0.5;
    sixthLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:sixthLabel];
    
    UILabel *seventhLabel = [[UILabel alloc]init];
    seventhLabel.frame = CGRectMake(20, 195, firstView.frame.size.width-40, 20);
    seventhLabel.text = @"同样是订单金额实际支付达到一定面额；";
    seventhLabel.alpha = 0.5;
    seventhLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:seventhLabel];
    

    UILabel *eightLabel = [[UILabel alloc]init];
    eightLabel.frame = CGRectMake(20, 220, firstView.frame.size.width-40, 20);
    eightLabel.text = @"包括运费及积分实际抵扣后，可使用的抵扣券。";
    eightLabel.alpha = 0.5;
    eightLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:eightLabel];


}

-(void)initViewEightthUI
{

    UIView *view = [[UIView alloc]init];
    view.frame = CGRectMake(0, 125+10+145+2+225+2+250, SCREEN_WIDTH, 2);
    view.backgroundColor = [UIColor colorWithRed:244/255.0 green:245/255.0 blue:246/255.0 alpha:1.0f];
    [self.view addSubview:view];

}

-(void)initViewNinthUI
{

    UIView *firstView = [[UIView alloc]init];
    firstView.frame = CGRectMake(0, 125+10+145+2+225+2+250+2, SCREEN_WIDTH, 225);
    firstView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:firstView];
    
    UILabel *firstLabel = [[UILabel alloc]init];
    firstLabel.frame = CGRectMake(20, 5, firstView.frame.size.width-40, 30);
    firstLabel.text = @"品类优惠券：";
    firstLabel.tintColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f];
    firstLabel.font =[UIFont boldSystemFontOfSize:17];
    [firstView addSubview:firstLabel];
    
    UILabel *secondLabel = [[UILabel alloc]init];
    secondLabel.frame = CGRectMake(20, 45, firstView.frame.size.width-40, 20);
    secondLabel.text = @"优惠券使用限制：";
    secondLabel.alpha = 0.5;
    secondLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:secondLabel];
    
    
    UILabel *thirdLabel = [[UILabel alloc]init];
    thirdLabel.frame = CGRectMake(20, 70, firstView.frame.size.width-40, 20);
    thirdLabel.text = @"不能兑换现金，不可以叠加使用；";
    thirdLabel.alpha = 0.5;
    thirdLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:thirdLabel];
    
    
    UILabel *fourthLabel = [[UILabel alloc]init];
    fourthLabel.frame = CGRectMake(20, 95, firstView.frame.size.width-40, 20);
    fourthLabel.text = @"退款后不能退还已使用优惠券";
    fourthLabel.alpha = 0.5;
    fourthLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:fourthLabel];
    
    UILabel *fifthLabel = [[UILabel alloc]init];
    fifthLabel.frame = CGRectMake(20, 130, firstView.frame.size.width-40, 30);
    fifthLabel.text = @"使用规则：";
    fifthLabel.tintColor = [UIColor colorWithRed:28/255.0 green:28/255.0 blue:28/255.0 alpha:1.0f];
    fifthLabel.font =[UIFont boldSystemFontOfSize:17];
    [firstView addSubview:fifthLabel];
    
    
    UILabel *sixthLabel = [[UILabel alloc]init];
    sixthLabel.frame = CGRectMake(20, 170, firstView.frame.size.width-40, 20);
    sixthLabel.text = @"针对单一品类可使用的优惠券；";
    sixthLabel.alpha = 0.5;
    sixthLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:sixthLabel];
    
    UILabel *seventhLabel = [[UILabel alloc]init];
    seventhLabel.frame = CGRectMake(20, 195, firstView.frame.size.width-40, 20);
    seventhLabel.text = @"购买此类商品实际支付达到一定金额后可使用的优惠券。";
    seventhLabel.alpha = 0.5;
    seventhLabel.font =[UIFont boldSystemFontOfSize:13];
    [firstView addSubview:seventhLabel];



}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

//偏移量
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _tableView.contentSize = CGSizeMake(0,1250);
}
@end
