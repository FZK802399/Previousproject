//
//  UseScoreViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-16.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "SubmitOrderViewController.h"

@interface UseScoreViewController : WFSViewController<UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *ScoreView;
@property (strong, nonatomic) IBOutlet UILabel *canUseScoreLabel;
@property (strong, nonatomic) IBOutlet UITextField *inputUseScore;
@property (strong, nonatomic) IBOutlet UILabel *userScore;

@property (assign, nonatomic) NSInteger canUseScore;
@property (strong, nonatomic) SubmitOrderViewController *partentViewController;

- (IBAction)finishBtnClick:(id)sender;

@end
