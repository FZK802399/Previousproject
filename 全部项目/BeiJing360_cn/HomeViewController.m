    //
//  HomeViewController.m
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "HomeViewController.h"
#import "SubHomeViewController.h"
#import "Global.h"

@implementation HomeViewController

@synthesize btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9; 
@synthesize placesOfInterestViewController,parkPlaceViewController, beijingLocationViewController,
			cultureCustomsViewController, museumViewController, suburbSceneryViewController,
			alleyStreetscapeViewController, shoppingCenterViewController, barViewController;


- (void)dealloc {
	
	[placesOfInterestViewController,parkPlaceViewController, beijingLocationViewController release];
	[cultureCustomsViewController, museumViewController, suburbSceneryViewController release];
	[alleyStreetscapeViewController, shoppingCenterViewController, barViewController release];
	[btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8, btn9 release];
	
    [super dealloc];
}


//Home init
-(id)init {
	if (self = [super init]) {
		
		self.title = @"全景游北京"; 
		
		[self.tabBarItem initWithTitle:@"首页" image:[UIImage imageNamed:@"home_update.png"] tag:1];
	}
	
	return self;
}

//TabBar hidden
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) 
	{
        self.hidesBottomBarWhenPushed = NO;
    }
    return self;
}

//Label methods
-(UILabel *)addTextLabel1:(NSString *)aTitle 
				 originX1:(CGFloat)X originY1:(CGFloat)Y 
				   width1:(CGFloat)W height1:(CGFloat)H
				fontSize1:(CGFloat)size {
	//3.26内存泄露的改动
	UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(X, Y, W, H)] autorelease];
	
	[label setText:aTitle];
	
	label.font = [UIFont systemFontOfSize:size];
	
	[self.view addSubview:label];
	
	return label;
}

//Home Button methods!
-(void)btnClicked:(UIButton *)myButton
{
	UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
	backItem.title = @"首页";
	[self.navigationItem setBackBarButtonItem:backItem];
	[backItem release];
	
	switch (myButton.tag) {
		case 1:
			placesOfInterestViewController.whichView = myButton.tag;
			[self.navigationController pushViewController:placesOfInterestViewController animated:YES];
			break;
		case 2:
			parkPlaceViewController.whichView = myButton.tag;
			[self.navigationController pushViewController:parkPlaceViewController animated:YES];
			break;
		case 3:
			beijingLocationViewController.whichView = myButton.tag;
			[self.navigationController pushViewController:beijingLocationViewController animated:YES];
			break;
		case 4:
			cultureCustomsViewController.whichView = myButton.tag;
			[self.navigationController pushViewController:cultureCustomsViewController animated:YES];
			break;
		case 5:
			museumViewController.whichView = myButton.tag;
			[self.navigationController pushViewController:museumViewController animated:YES];
			break;
		case 6:
			suburbSceneryViewController.whichView = myButton.tag;
			[self.navigationController pushViewController:suburbSceneryViewController animated:YES];
			break;
		case 7:
			alleyStreetscapeViewController.whichView = myButton.tag;
			/*UIAlertView *alertForalleyStreets = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"内容组建中...敬请期待！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alertForalleyStreets show];
			[alertForalleyStreets release];*/
			[self.navigationController pushViewController:alleyStreetscapeViewController animated:YES];
			break;
		case 8:
			shoppingCenterViewController.whichView = myButton.tag;
			[self.navigationController pushViewController:shoppingCenterViewController animated:YES];
			break;
		case 9:
			barViewController.whichView = myButton.tag;
			[self.navigationController pushViewController:barViewController animated:YES];
			break;
		default:
			break;
	}
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//ViewController init
	self.placesOfInterestViewController = [[[SubHomeViewController alloc] initWithNibName:@"PlacesOfInterestViewController" bundle:nil] autorelease];
	self.parkPlaceViewController		= [[[SubHomeViewController alloc] initWithNibName:@"ParkPlaceViewController" bundle:nil] autorelease];
	self.beijingLocationViewController  = [[[SubHomeViewController alloc] initWithNibName:@"BeijingLocationViewController" bundle:nil] autorelease];
	self.cultureCustomsViewController   = [[[SubHomeViewController alloc] initWithNibName:@"CultureCustomsViewController" bundle:nil] autorelease];
	self.museumViewController			= [[[SubHomeViewController alloc] initWithNibName:@"MuseumViewController" bundle:nil] autorelease];
	self.suburbSceneryViewController    = [[[SubHomeViewController alloc] initWithNibName:@"SuburbSceneryViewController" bundle:nil] autorelease];
	self.alleyStreetscapeViewController = [[[SubHomeViewController alloc] initWithNibName:@"AlleyStreetscapeViewController" bundle:nil] autorelease];
	self.shoppingCenterViewController   = [[[SubHomeViewController alloc] initWithNibName:@"ShoppingCenterViewController" bundle:nil] autorelease];
	self.barViewController				= [[[SubHomeViewController alloc] initWithNibName:@"BarViewController" bundle:nil] autorelease];
	
	//Loading context image!
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	self.view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"HomeContext.png"]] autorelease];
	self.view.userInteractionEnabled = YES;
	[self.view setFrame:frame];
	
	for (NSInteger i = 1; i <= 9; i++) {
		
		NSInteger chioce = i;
		
		switch (chioce) {
			case 1:
				
				btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn1.frame = CGRectMake(buttonOriginX1, buttonOriginY1, homeButtonWidth, homeButtonWidth);
				btn1.tag = i;
				[btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn1 setBackgroundImage:[UIImage imageNamed:homeButtonIcon1] forState:UIControlStateNormal];
				[btn1 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon1] forState:UIControlStateHighlighted];
				[self.view addSubview:btn1];
				
                //3.26内存泄露改动
//				UILabel *label1 = [[UILabel alloc] init];
				UILabel *label1 = [self addTextLabel1:@"名胜古迹" originX1:labelOriginX1 originY1:labelOriginY1 width1:homeLabelWidth height1:homeLabelHeight fontSize1:homeButtonFontSize];
				[label1 setTextColor:[UIColor blackColor]];
				[label1 setBackgroundColor:[UIColor	clearColor]];
//				[label1 release];
				break;
			case 2:
				
				btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn2.frame = CGRectMake(buttonOriginX2, buttonOriginY2, homeButtonWidth, homeButtonHeight);
				btn2.tag = i;
				[btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn2 setBackgroundImage:[UIImage imageNamed:homeButtonIcon2] forState:UIControlStateNormal];
				[btn2 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon2] forState:UIControlStateHighlighted];
				[self.view addSubview:btn2];
				
//				UILabel *label2 = [[UILabel alloc] init];
				UILabel *label2 = [self addTextLabel1:@"公园广场" originX1:labelOriginX2 originY1:labelOriginY2 width1:homeLabelWidth height1:homeLabelHeight fontSize1:homeButtonFontSize];
				[label2 setTextColor:[UIColor blackColor]];
				[label2 setBackgroundColor:[UIColor	clearColor]];
//				[label2 release];
				break;
			case 3:
				
				btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn3.frame = CGRectMake(buttonOriginX3, buttonOriginY3, homeButtonWidth, homeButtonHeight);
				btn3.tag = i;
				[btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn3 setBackgroundImage:[UIImage imageNamed:homeButtonIcon3] forState:UIControlStateNormal];
				[btn3 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon3] forState:UIControlStateHighlighted];
				[self.view addSubview:btn3];
				
//				UILabel *label3 = [[UILabel alloc] init];
				UILabel *label3 = [self addTextLabel1:@"北京地标" originX1:labelOriginX3 originY1:labelOriginY3 width1:homeLabelWidth height1:homeLabelHeight fontSize1:homeButtonFontSize];
				[label3 setTextColor:[UIColor blackColor]];
				[label3 setBackgroundColor:[UIColor	clearColor]];
//				[label3 release];
				break;
			case 4:
				
				btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn4.frame = CGRectMake(buttonOriginX4, buttonOriginY4, homeButtonWidth, homeButtonHeight);
				btn4.tag = i;
				[btn4 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn4 setBackgroundImage:[UIImage imageNamed:homeButtonIcon4] forState:UIControlStateNormal];
				[btn4 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon4] forState:UIControlStateHighlighted];
				[self.view addSubview:btn4];
				
//				UILabel *label4 = [[UILabel alloc] init];
				UILabel *label4 = [self addTextLabel1:@"文化民俗" originX1:labelOriginX4 originY1:labelOriginY4 width1:homeLabelWidth height1:homeLabelHeight fontSize1:homeButtonFontSize];
				[label4 setTextColor:[UIColor blackColor]];
				[label4 setBackgroundColor:[UIColor	clearColor]];
//				[label4 release];
				break;
			case 5:
				
				btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn5.frame = CGRectMake(buttonOriginX5, buttonOriginY5, homeButtonWidth, homeButtonHeight);
				btn5.tag = i;
				[btn5 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn5 setBackgroundImage:[UIImage imageNamed:homeButtonIcon5] forState:UIControlStateNormal];
				[btn5 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon5] forState:UIControlStateHighlighted];
				[self.view addSubview:btn5];
				
//				UILabel *label5 = [[UILabel alloc] init];
				UILabel *label5 = [self addTextLabel1:@"博物展馆" originX1:labelOriginX5 originY1:labelOriginY5 width1:homeLabelWidth
																	height1:homeLabelHeight fontSize1:homeButtonFontSize];
				[label5 setTextColor:[UIColor blackColor]];
				[label5 setBackgroundColor:[UIColor	clearColor]];
//				[label5 release];
				break;
			case 6:
				
				btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn6.frame = CGRectMake(buttonOriginX6, buttonOriginY6, homeButtonWidth, homeButtonHeight);
				btn6.tag = i;
				[btn6 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn6 setBackgroundImage:[UIImage imageNamed:homeButtonIcon6] forState:UIControlStateNormal];
				[btn6 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon6] forState:UIControlStateHighlighted];
				[self.view addSubview:btn6];
				
//				UILabel *label6 = [[UILabel alloc] init];
				UILabel *label6  = [self addTextLabel1:@"京郊风光" originX1:labelOriginX6 originY1:labelOriginY6 width1:homeLabelWidth height1:homeLabelHeight fontSize1:homeButtonFontSize];
				[label6 setTextColor:[UIColor blackColor]];
				[label6 setBackgroundColor:[UIColor	clearColor]];
//				[label6 release];
				break;
			case 7:
				
				btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn7.frame = CGRectMake(buttonOriginX7, buttonOriginY7, homeButtonWidth, homeButtonHeight);
				btn7.tag = i;
				[btn7 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn7 setBackgroundImage:[UIImage imageNamed:homeButtonIcon7] forState:UIControlStateNormal];
				[btn7 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon7] forState:UIControlStateHighlighted];
				[self.view addSubview:btn7];
				
//				UILabel *label7 = [[UILabel alloc] init];
				UILabel *label7 = [self addTextLabel1:@"胡同街景" originX1:labelOriginX7 originY1:labelOriginY7 width1:homeLabelWidth height1:homeLabelHeight fontSize1:homeButtonFontSize];
				[label7 setTextColor:[UIColor blackColor]];
				[label7 setBackgroundColor:[UIColor	clearColor]];
//				[label7 release];
				
				break;
			case 8:
				
				btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn8.frame = CGRectMake(buttonOriginX8, buttonOriginY8, homeButtonWidth, homeButtonHeight);
				btn8.tag = i;
				[btn8 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn8 setBackgroundImage:[UIImage imageNamed:homeButtonIcon8] forState:UIControlStateNormal];
				[btn8 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon8] forState:UIControlStateHighlighted];
				[self.view addSubview:btn8];
				
//				UILabel *label8 = [[UILabel alloc] init];
				UILabel *label8 = [self addTextLabel1:@"购物中心" originX1:labelOriginX8 originY1:labelOriginY8 width1:homeLabelWidth height1:homeLabelHeight fontSize1:homeButtonFontSize];
				[label8 setTextColor:[UIColor blackColor]];
				[label8 setBackgroundColor:[UIColor	clearColor]];
//				[label8 release];
				break;
			case 9:
				
				btn9 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn9.frame = CGRectMake(buttonOriginX9, buttonOriginY9, homeButtonWidth, homeButtonHeight);
				btn9.tag = i;
				[btn9 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn9 setBackgroundImage:[UIImage imageNamed:homeButtonIcon9] forState:UIControlStateNormal];	
				[btn9 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon9] forState:UIControlStateHighlighted];
				[self.view addSubview:btn9];
				
//				UILabel *label9 = [[UILabel alloc] init];
				UILabel *label9 = [self addTextLabel1:@"酒吧娱乐" originX1:labelOriginX9 originY1:labelOriginY9 width1:homeLabelWidth height1:homeLabelHeight fontSize1:homeButtonFontSize];
				[label9 setTextColor:[UIColor blackColor]];
				[label9 setBackgroundColor:[UIColor	clearColor]];
//				[label9 release];
				break;

			default:
				break;
		}
	}

}

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

@end
