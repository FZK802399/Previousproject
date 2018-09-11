    //
//  AboutViewController.m
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "AboutViewController.h"
#import "Global.h"

@implementation AboutViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"AboutViewController" bundle:nil];
    if (self) {
	//	self.title = @"关于我们";
				self.tabBarItem.title = @"关于";
		[self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:5];
        // Custom initialization.
    }
    return self;
}
/*
-(id)init {
	if (self = [super init]) {
		self.title = @"关于";
		self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
		[self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:5];
	}
	return self;
}
*/

-(UILabel *)addTextLabel:(NSString *)aTitle 
				 originX:(CGFloat)X originY:(CGFloat)Y 
				   width:(CGFloat)W height:(CGFloat)H
				fontSize:(CGFloat)size {
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X, Y, W, H)];
	[label setText:aTitle];
	label.font = [UIFont systemFontOfSize:size];
	[self.view addSubview:label];

	return label;
	[label release];
}

-(void)gotoDail
{
	UIAlertView *alertForDial = [[UIAlertView alloc] initWithTitle:@"提示" 
													 message:@"您确定要拨打此电话!" 
													delegate:self 
										   cancelButtonTitle:@"取消" 
										   otherButtonTitles:@"拨号", nil];
	alertForDial.tag = 1;
	[alertForDial show];
	[alertForDial release];
	
}

-(void)gotoWWW
{
	UIAlertView *alertForWWW = [[UIAlertView alloc] initWithTitle:@"Safari"  
												message:@"你需要EDGE,3G或WIFI连线于Safari观看网页!" 
												delegate:self 
												cancelButtonTitle:@"取消" 
												otherButtonTitles:@"确定", nil];
	alertForWWW.tag = 2;
	[alertForWWW show];
	[alertForWWW release];
//	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.720a.com"]];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIImage *image = [UIImage imageNamed:@"about.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.userInteractionEnabled = YES;
	
  //  CGRect applicationFrame = [[UIScreen mainScreen] bounds];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    [scrollView addSubview:imageView];
	
    scrollView.contentSize = image.size;
    scrollView.bounces = NO;
    scrollView.maximumZoomScale = 1.0;
    scrollView.minimumZoomScale = 1.0;
    scrollView.delegate = self;
    
    [self.view addSubview:scrollView];
    
    // Override point for customization after application launch.
    
   
    

	
	/*
	//load context image
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	self.view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeContext.png"]] autorelease];
	self.view.userInteractionEnabled = YES;
	[self.view setFrame:frame];
	
	UILabel *textLabel1 = [[UILabel alloc] init];
	textLabel1 = [self addTextLabel:@"全景看北京 1.0" originX:120 originY:190 width:80 height:aboutLabelHeight fontSize:aboutFontSize ];
	[textLabel1 setTextColor:[UIColor blackColor]];
	[textLabel1 setBackgroundColor:[UIColor	clearColor]];
	[textLabel1 release];
	
	UILabel *textLabel2 = [[UILabel alloc] init];
	textLabel2 = [self addTextLabel:@"版本号：1.0.1 Build 20110523" originX:79 originY:215 width:190 height:aboutLabelHeight fontSize:aboutFontSize];
	[textLabel2 setTextColor:[UIColor blackColor]];
	[textLabel2 setBackgroundColor:[UIColor	clearColor]];
	[textLabel2 release];
	
	UILabel *textLabel3 = [[UILabel alloc] init];
	textLabel3 = [self addTextLabel:@"客户服务电话：(86)10-62684649" originX:71 originY:241 width:190 height:aboutLabelHeight fontSize:aboutFontSize ];
	[textLabel3 setTextColor:[UIColor blackColor]];
	[textLabel3 setBackgroundColor:[UIColor	clearColor]];
	[textLabel3 release];
	
	UILabel *textLabel4 = [[UILabel alloc] init];
	textLabel4 = [self addTextLabel:@"版权所有©2010北京创艺丰通信息技术有限公司" originX:37 originY:266 width:270 height:aboutLabelHeight fontSize:aboutFontSize];
	[textLabel4 setTextColor:[UIColor blackColor]];
	[textLabel4 setBackgroundColor:[UIColor	clearColor]];
	[textLabel4 release];
	
	UILabel *textLabel5 = [[UILabel alloc] init];
	textLabel5 = [self addTextLabel:@"技术支持:" originX:75 originY:290 width:164 height:aboutLabelHeight fontSize:aboutFontSize ];
	[textLabel5 setTextColor:[UIColor blackColor]];
	[textLabel5 setBackgroundColor:[UIColor	clearColor]];
	[textLabel5 release];
	
	//company logo
	UIImageView *uivLogo=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"720a_logo.png"]];
	uivLogo.frame = CGRectMake(125, 60, 72, 69);
	[self.view addSubview:uivLogo];
	[uivLogo release];
	*/
	UIButton *myButtonTelphone = [[UIButton alloc] init];
	[myButtonTelphone setTitle:@"(86)010-62684649" forState:UIControlStateNormal];
	[myButtonTelphone setBackgroundColor:[UIColor clearColor]];
	[myButtonTelphone.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
	[myButtonTelphone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[myButtonTelphone setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[myButtonTelphone setFrame:CGRectMake(115, 731, 120, 15)];
	[myButtonTelphone addTarget:self action:@selector(gotoDail) forControlEvents:UIControlEventTouchUpInside];
	[myButtonTelphone setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[myButtonTelphone setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
	
	UIButton *myButtonWWW = [[UIButton alloc] init];
	[myButtonWWW setTitle:@"http://www.720a.com" forState:UIControlStateNormal];
	[myButtonWWW setBackgroundColor:[UIColor clearColor]];
	[myButtonWWW.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
	[myButtonWWW setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[myButtonWWW setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[myButtonWWW setFrame:CGRectMake(115, 758, 140, 15)];
	[myButtonWWW addTarget:self action:@selector(gotoWWW) forControlEvents:UIControlEventTouchUpInside];
	[myButtonWWW setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	[myButtonWWW setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
//
	[imageView addSubview:myButtonWWW];
	[imageView addSubview:myButtonTelphone];
	[myButtonWWW release];
	[myButtonTelphone release];
	[scrollView release];
	[imageView release];
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
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1) {
		if (buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://010-62684649"]];
		}
	
	} else if (alertView.tag == 2) {
		if (buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.720a.com"]];
		} 
	}

}

@end
