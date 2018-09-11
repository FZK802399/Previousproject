//
//  VirtualTour.m
//  BeiJing360
//
//  Created by lin yuxin on 12-2-10.
//  Copyright (c) 2012年 __ChuangYiFengTong__. All rights reserved.
//

#import "VirtualTour.h"

@implementation VirtualTour

@synthesize whichView;
@synthesize vtLabel;

@synthesize webView;
@synthesize activityIndicator;
@synthesize opaqueView;

-(void)dealloc {
    [webView release];
    [activityIndicator release];
    [opaqueView release];
    
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    vtLabel.text = [NSString stringWithFormat:@"%d",whichView];
    [super viewDidLoad];
    
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    [self.view setFrame:frame];
    self.view.userInteractionEnabled = YES;
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    [webView setUserInteractionEnabled:YES];
    [webView setDelegate:self];
    [webView setOpaque:NO];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
    switch (whichView) {
        case 1:
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pano.720a.com/demo/sanhaojie_vtour/iphone_IT.html"]]];
            break;
        case 2:
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pano.720a.com/demo/sanhaojie_vtour/iphone_culture.html"]]];
            break;
        case 3:
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pano.720a.com/demo/sanhaojie_vtour/iphone_serve.html"]]];
            break;
        case 4:
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pano.720a.com/demo/sanhaojie_vtour/iphone_building.html"]]];
            break;
            break;
        default:
            break;
    }
   // [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.720a.com/iphone/manyou.html"]]];
    opaqueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activityIndicator.center = CGPointMake(opaqueView.bounds.size.width/2.0f, opaqueView.bounds.size.height-200.0f);
    [opaqueView setBackgroundColor:[UIColor blackColor]];
    [opaqueView setAlpha:0.6];
    [self.view addSubview:opaqueView];
    [opaqueView addSubview:activityIndicator];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark UIWebView Delegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
    opaqueView.hidden = NO;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
    opaqueView.hidden = YES;
}

@end
