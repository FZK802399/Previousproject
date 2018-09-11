//
//  CommentViewController.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-8-30.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)dealloc
{
    [_imageView release];
    _imageView = nil;
    
    [_closeButton release];
    _closeButton = nil;
    
    Release(_commentNow);
    
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
	
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"comment_bg.jpg"]];
    
//    if ([USER_DEFAULTS boolForKey:kCurrent_Language] == English)
//    {
//        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"comment_en.jpg"]]];
//        UIButton *comment = [[UIButton alloc] initWithFrame:CGRectMake(726, 254, 226, 53)];
//        [comment setImage:[UIImage imageNamed:@"toComment_h.png"] forState:UIControlStateNormal];
//        [comment setImage:[UIImage imageNamed:@"toComment.png"] forState:UIControlStateHighlighted];
//        [comment addTarget:self action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:comment];
//        [comment release];
//    }
//    else
//    {
//        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"comment_cn.jpg"]]];
//        UIButton *comment = [[UIButton alloc] initWithFrame:CGRectMake(807, 263, 146, 53)];
//        [comment setImage:[UIImage imageNamed:@"tocomment_cn_h.png"] forState:UIControlStateNormal];
//        [comment setImage:[UIImage imageNamed:@"tocomment_cn.png"] forState:UIControlStateHighlighted];
//        [comment addTarget:self action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:comment];
//        [comment release];
//    }
    
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(kLCDH - 61, 0, 61, 56)];
    [_closeButton setImage:[UIImage imageNamed:@"phclose.png"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"phclose_h.png"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    _commentNow = [[UIButton alloc] initWithFrame:CGRectMake(440, 178, 146, 53)];
    [_commentNow setImage:[UIImage imageNamed:@"commentnow.png"] forState:UIControlStateNormal];
    [_commentNow setImage:[UIImage imageNamed:@"commentnow_h.png"] forState:UIControlStateHighlighted];
    [_commentNow addTarget:self action:@selector(toComment) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_commentNow];
}

- (void)toComment
{
    [USER_DEFAULTS setBool:YES forKey:kWasComment];
    [USER_DEFAULTS synchronize];
    [MobClick event:@"goToComment"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=694990692"]];
}

- (void)dismissSelf
{
    [self dismissViewControllerAnimated:YES completion:^
     {
//         [_delegate performSelector:@selector(viewRelease)];
     }];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
