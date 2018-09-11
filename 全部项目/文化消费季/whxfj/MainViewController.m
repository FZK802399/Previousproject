//
//  MainViewController.m
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import "MainViewController.h"
#import "ListViewController.h"
#import "MeViewController.h"

#define BUTTON_WIDTH 100
#define BUTTON_HEIGHT 100
#define BUTTON_MARGIN 40

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [backgroundView setImage:[UIImage imageNamed:@"backgrond.png"]];
    [self.view addSubview:backgroundView];
    
    int heightMargin = (self.view.frame.size.height - 100 - BUTTON_HEIGHT*3)/4;
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.tag = 1;
    [button1 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button1 setFrame:CGRectMake(BUTTON_MARGIN, 100+heightMargin, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"1.png"] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.tag = 2;
    [button2 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setFrame:CGRectMake(CGRectGetMaxX(button1.frame)+BUTTON_MARGIN, 100+heightMargin, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [button2 setBackgroundImage:[UIImage imageNamed:@"2.png"] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3.tag = 3;
    [button3 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button3 setFrame:CGRectMake(BUTTON_MARGIN, CGRectGetMaxY(button1.frame)+heightMargin, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [button3 setBackgroundImage:[UIImage imageNamed:@"3.png"] forState:UIControlStateNormal];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.tag = 4;
    [button4 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button4 setFrame:CGRectMake(CGRectGetMinX(button2.frame), CGRectGetMaxY(button2.frame)+heightMargin, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [button4 setBackgroundImage:[UIImage imageNamed:@"4.png"] forState:UIControlStateNormal];
    [self.view addSubview:button4];
    
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    button5.tag = 5;
    [button5 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button5 setFrame:CGRectMake(BUTTON_MARGIN, CGRectGetMaxY(button3.frame)+heightMargin, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [button5 setBackgroundImage:[UIImage imageNamed:@"5.png"] forState:UIControlStateNormal];
    [self.view addSubview:button5];
    
    UIButton *button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    button6.tag = 6;
    [button6 addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [button6 setFrame:CGRectMake(CGRectGetMinX(button4.frame), CGRectGetMaxY(button4.frame)+heightMargin, BUTTON_WIDTH, BUTTON_HEIGHT)];
    [button6 setBackgroundImage:[UIImage imageNamed:@"6.png"] forState:UIControlStateNormal];
    [self.view addSubview:button6];
    
    UIButton *meButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [meButton setFrame:CGRectMake(self.view.frame.size.width-30-5, self.view.frame.size.height-30-5, 30, 30)];
    [meButton addTarget:self action:@selector(showMe) forControlEvents:UIControlEventTouchUpInside];
    [meButton setBackgroundImage:[UIImage imageNamed:@"me.png"] forState:UIControlStateNormal];
    [meButton setBackgroundImage:[UIImage imageNamed:@"me.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:meButton];
    
}

- (void)buttonPressed:(UIButton *)button
{
    ListViewController *listViewController;
    switch (button.tag) {
        case 1:
            listViewController = [[ListViewController alloc] initWith:LISTVIEWTYPE_WHC];
            break;
        case 2:
            listViewController = [[ListViewController alloc] initWith:LISTVIEWTYPE_HKB];
            break;
        case 3:
            listViewController = [[ListViewController alloc] initWith:LISTVIEWTYPE_HDH];
            break;
        case 4:
            listViewController = [[ListViewController alloc] initWith:LISTVIEWTYPE_ZHK];
            break;
        case 5:
            listViewController = [[ListViewController alloc] initWith:LISTVIEWTYPE_QXX];
            break;
        case 6:
            listViewController = [[ListViewController alloc] initWith:LISTVIEWTYPE_HFX];
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:listViewController animated:YES];
}

- (void)showMe
{
    MeViewController *meViewController = [[MeViewController alloc] init];
    UINavigationController *navMeViewController = [[UINavigationController alloc] initWithRootViewController:meViewController];
    [self presentViewController:navMeViewController animated:YES completion:nil];
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

@end
