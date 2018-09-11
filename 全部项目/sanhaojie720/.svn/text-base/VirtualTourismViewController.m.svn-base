    //
//  VirtualTourismViewController.m
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "VirtualTourismViewController.h"

@implementation VirtualTourismViewController

@synthesize webview01;
@synthesize activityIndiator01;
@synthesize opaqueView01;

-(id)init {
	if (self = [super init]) {
		
		self.view.backgroundColor = [UIColor whiteColor];
		
		//self.title = @"虚拟漫游";
		
		[self.tabBarItem initWithTitle:@"虚拟漫游" image:[UIImage imageNamed:@"virtualTour.png"] tag:2];
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//load context image
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	
	self.view.userInteractionEnabled = YES;
	[self.view setFrame:frame];
	
	webview01 = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
	[webview01 setUserInteractionEnabled:YES];
	[webview01 setDelegate:self];
	[webview01 setOpaque:NO];
	webview01.scalesPageToFit = YES;
	[self.view addSubview:webview01];
	
	[self.webview01 loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.720a.com/iphone/manyou.html"]]];
	
	opaqueView01 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	activityIndiator01 = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	activityIndiator01.center = CGPointMake(opaqueView01.bounds.size.width/2.0f, opaqueView01.bounds.size.height-280.0f);
	[opaqueView01 setBackgroundColor:[UIColor blackColor]];
	[opaqueView01 setAlpha:0.6];
	[self.view addSubview:opaqueView01];
	[opaqueView01 addSubview:activityIndiator01];
	
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
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[webview01 release];
	[activityIndiator01 release];
	[opaqueView01 release];
	
    [super dealloc];
}

#pragma mark UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[activityIndiator01 startAnimating];
	
	opaqueView01.hidden = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[activityIndiator01 stopAnimating];
	
	opaqueView01.hidden = YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	NSLog(@"web Thumbs Error: %@", error);
	
	if ([error code] == -1003) {
		
		[webView removeFromSuperview];
	}
}

@end
