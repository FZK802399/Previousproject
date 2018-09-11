//
//  MoreAppViewController.m
//  BeiJing360
//
//  Created by lin yuxin on 12-4-10.
//  Copyright (c) 2012年 __ChuangYiFengTong__. All rights reserved.
//

#import "MoreAppViewController.h"

@implementation MoreAppViewController

@synthesize webView;

-(void)dealloc {
    [webView release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:@"MoreAppViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"更多应用";
        [self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemMore tag:6];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURL *url = [NSURL URLWithString:@"http://pano.720a.com/iphone/iphone.html"];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
