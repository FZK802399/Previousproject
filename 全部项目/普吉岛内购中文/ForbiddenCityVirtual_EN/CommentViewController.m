//
//  CommentViewController.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-22.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()
{
    UIImageView *_backgrandImage;
}
@end

@implementation CommentViewController

- (void)dealloc
{
    [_imageView release];
    _imageView = nil;
    
    [_closeButton release];
    _closeButton = nil;
    Release(_backgrandImage);
    
    [super dealloc];
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
	// Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:68.0f/255.0f green:104.0f/255.0f blue:220.0f/255.0f alpha:1.0]];
    _backgrandImage = [[UIImageView alloc] init];
    if (kDEVICE_VERSION >= 7.0)
    {
        [_backgrandImage setFrame:CGRectMake(0, 20, kLCDH, kLCDW - 20)];
    }
    else
    {
        [_backgrandImage setFrame:CGRectMake(0, 0, kLCDH, kLCDW - 20)];
    }
    [self.view addSubview:_backgrandImage];
    
    
    if ([USER_DEFAULTS boolForKey:kCurrent_Language] == English)
    {
        [_backgrandImage setImage:[UIImage imageNamed:@"comment_en.jpg"]];

        UIButton *comment = [[UIButton alloc] initWithFrame:CGRectMake(kLCDH / 2 - 226 / 2, 181, 226, 53)];
        [comment setImage:[UIImage imageNamed:@"toComment_h.png"] forState:UIControlStateNormal];
        [comment setImage:[UIImage imageNamed:@"toComment.png"] forState:UIControlStateHighlighted];
        [comment addTarget:self action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:comment];
        if (kDEVICE_VERSION >= 7.0f)
        {
            [comment setFrame:CGRectMake(kLCDH / 2 - 226 / 2, 181 + 20, 226, 53)];
        }

        [comment release];
    }
    else
    {
        [_backgrandImage setImage:[UIImage imageNamed:@"comment_cn.jpg"]];
        UIButton *comment = [[UIButton alloc] initWithFrame:CGRectMake(kLCDH / 2 - 146 / 2, 181, 146, 53)];
        [comment setImage:[UIImage imageNamed:@"tocomment_cn_h.png"] forState:UIControlStateNormal];
        [comment setImage:[UIImage imageNamed:@"tocomment_cn.png"] forState:UIControlStateHighlighted];
        [comment addTarget:self action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:comment];
        if (kDEVICE_VERSION >= 7.0f)
        {
            [comment setFrame:CGRectMake(kLCDH / 2 - 146 / 2, 181 + 20, 146, 53)];
        }

        [comment release];
    }
    
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(kLCDH - 61, 0, 61, 56)];
    [_closeButton setImage:[UIImage imageNamed:@"phclose.png"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"phclose_h.png"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        [_closeButton setFrame:CGRectMake(kLCDH - 61, 20, 61, 56)];
        [self setNeedsStatusBarAppearanceUpdate];
    }

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)toComment
{
    [USER_DEFAULTS setBool:YES forKey:kWasComment];
    [USER_DEFAULTS synchronize];
    [MobClick event:@"goToComment"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=710213978"]];
    [self dismissSelf];
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         [_delegate performSelector:@selector(viewRelease)];
     }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
