//
//  Industry.m
//  BeiJing360
//
//  Created by lin yuxin on 12-2-10.
//  Copyright (c) 2012年 __ChuangYiFengTong__. All rights reserved.
//

#import "Industry.h"

@implementation Industry

@synthesize whichView;
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
*/
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImage *image = [UIImage alloc];
    switch (whichView) {
        case 1:
            self.title = @"IT产业介绍";
            image = [UIImage imageNamed:@"industry1.png"];
            break;
        case 2:
            self.title = @"文化产业介绍";
            image = [UIImage imageNamed:@"industry2.png"];
            break;
        case 3:
            self.title = @"服务产业介绍";
            image = [UIImage imageNamed:@"industry3.png"];
            break;
        case 4:
            self.title = @"楼宇产业介绍";
            image = [UIImage imageNamed:@"industry4.png"];
            break;
        default:
            break;
    }
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:imageView];
    [image release];
    [imageView release];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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
