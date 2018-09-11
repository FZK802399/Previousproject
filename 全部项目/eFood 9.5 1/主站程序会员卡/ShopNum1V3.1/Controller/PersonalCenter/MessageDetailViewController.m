//
//  MessageDetailViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "MessageDetailViewController.h"

@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController

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
    if (_MessageDeatil) {
        self.TitleLabel.text = _MessageDeatil.Title;
        self.TimeLabel.text = _MessageDeatil.SendTime;
        self.ContentLabel.text = _MessageDeatil.Content;
        NSDictionary * readDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                  _MessageDeatil.Guid,@"id",
                                  kWebAppSign,@"AppSign",
                                  self.appConfig.loginName,@"memLoginID", nil];
        [MessageModelMy setReadMessageWithParameters:readDic andblock:^(NSInteger result, NSError *error) {
            if (error) {
                
            }else {
                if (result == 202) {

                }
            
            }
        }];
        
    }
//    CGSize maximumLabelSize = CGSizeMake(320 - nameWidth, 1000);
//    CGSize expectedLabelSize = [_lbComment.text sizeWithFont:_lbComment.font
//                                           constrainedToSize:maximumLabelSize
//                                               lineBreakMode:_lbComment.lineBreakMode];
    // Do any additional setup after loading the view.
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
