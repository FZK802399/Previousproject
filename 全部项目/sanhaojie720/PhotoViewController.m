//
//  PhotoViewController.m
//  BeiJing360
//
//  Created by lin yuxin on 12-2-9.
//  Copyright (c) 2012年 __ChuangYiFengTong__. All rights reserved.
//

#import "PhotoViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotoViewController
@synthesize scrView1;

-(void)dealloc {
    [scrView1 release];
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

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}



- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    self.title = @"三好街图片简介";
    [self.view setBackgroundColor:[UIColor grayColor]];
    for (int i = 1; i < 51; i++) {
        UIView *tview = [[UIView alloc] initWithFrame:CGRectMake(10+(i-1)*320, 30, 300, 330)];
        tview.layer.contents = (id)[UIImage imageNamed:[NSString stringWithFormat:@"img_%i.png",i]].CGImage;
        [tview.layer setMasksToBounds:YES];
        tview.layer.cornerRadius = 20.0;
        tview.layer.borderWidth = 3.0;
        tview.multipleTouchEnabled = YES;
        tview.userInteractionEnabled = YES;

         [scrView1 addSubview:tview];
        [tview release];
        
    }
    [scrView1 setContentSize:CGSizeMake(50*320, 330)];
    [scrView1 setShowsHorizontalScrollIndicator:NO];
    scrView1.pagingEnabled = YES;
    [scrView1 setMinimumZoomScale:YES];
       [super viewDidLoad];
}


- (void)viewDidUnload
{
    self.scrView1 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
