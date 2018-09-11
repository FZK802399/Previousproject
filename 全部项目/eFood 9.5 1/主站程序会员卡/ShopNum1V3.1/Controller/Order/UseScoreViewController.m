//
//  UseScoreViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-16.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "UseScoreViewController.h"

@interface UseScoreViewController ()

@end

@implementation UseScoreViewController

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
    
    self.ScoreView.layer.borderWidth = 1;
    self.ScoreView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.inputUseScore.layer.borderWidth = 1;
    self.inputUseScore.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    self.userScore.text = [NSString stringWithFormat:@"您有%d积分", self.appConfig.userScore];
    self.canUseScoreLabel.text = [NSString stringWithFormat:@"本单可用%d积分", self.canUseScore];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    // Do any additional setup after loading the view.
}

- (void)resignKeyboard {
    [self.inputUseScore resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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

- (IBAction)finishBtnClick:(id)sender {
    
    if ([self.inputUseScore.text integerValue] > self.appConfig.userScore) {
        [self showAlertWithMessage:@"现有总积分不够,快去赚积分吧"];
        return;
    }
    if ([self.inputUseScore.text integerValue] > self.canUseScore) {
        [self showAlertWithMessage:@"本单不能使用这么多的积分"];
        return;
    }
    [_partentViewController setUseScore:[self.inputUseScore.text integerValue]];
    _partentViewController.useScoreLabel.text = self.inputUseScore.text;
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
