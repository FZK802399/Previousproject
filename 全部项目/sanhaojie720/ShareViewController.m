    //
//  ShareViewController.m
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "ShareViewController.h"

@implementation ShareViewController

-(id)init {
	if (self = [super init]) {
		
		self.view.backgroundColor = [UIColor whiteColor];
		
		self.title = @"分享";
		
		self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
		
		[self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:4];
	}
	
	return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	
	UIImageView *bgImgShare = [[UIImageView alloc] initWithFrame:frame];
	
	[bgImgShare setImage:[UIImage imageNamed:@"HomeContext.png"]];
	
	[self.view addSubview:bgImgShare];
	
	[bgImgShare release];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
