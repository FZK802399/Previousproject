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

#import "TextViewController.h"
#import "PhotoViewController.h"
#import "MovieViewController.h"

#import "About.h"

@implementation HomeViewController

@synthesize btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8; 
@synthesize placesOfInterestViewController,parkPlaceViewController, beijingLocationViewController,
            cultureCustomsViewController;
@synthesize txtViewController;
@synthesize photoViewController;
@synthesize movieViewController;


- (void)dealloc {
	
	[placesOfInterestViewController release];
    [parkPlaceViewController release];
    [beijingLocationViewController release];
	[cultureCustomsViewController release];
    [txtViewController release];
    [photoViewController release];
    [movieViewController release];
	[btn1, btn2, btn3, btn4, btn5, btn6, btn7, btn8 release];
	
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
        self.hidesBottomBarWhenPushed=NO;
    }
    return self;
}

-(IBAction)showAbout:(id)sender {
    About *about = [[[About alloc] initWithNibName:@"About" bundle:nil] autorelease];
    [self presentModalViewController:about animated:YES];
    
}

//Label methods
-(UILabel *)addTextLabel1:(NSString *)aTitle 
				 originX1:(CGFloat)X originY1:(CGFloat)Y 
				   width1:(CGFloat)W height1:(CGFloat)H
				fontSize1:(CGFloat)size {
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(X, Y, W, H)];
	
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
            [self.navigationController pushViewController:txtViewController animated:YES];
            break;
        case 6:
            [self.navigationController pushViewController:photoViewController animated:YES];
            break;
        case 7:
            [self.navigationController pushViewController:movieViewController animated:YES];
            backItem.title = @"关闭";
            break;
        default:
			break;
	}
	

}


-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
	self.placesOfInterestViewController = [[[SubHomeViewController alloc] initWithNibName:@"PlacesOfInterestViewController" bundle:nil] autorelease];
	self.parkPlaceViewController		= [[[SubHomeViewController alloc] initWithNibName:@"ParkPlaceViewController" bundle:nil] autorelease];
	self.beijingLocationViewController  = [[[SubHomeViewController alloc] initWithNibName:@"BeijingLocationViewController" bundle:nil] autorelease];
	self.cultureCustomsViewController   = [[[SubHomeViewController alloc] initWithNibName:@"CultureCustomsViewController" bundle:nil] autorelease];
	
    self.txtViewController = [[[TextViewController alloc]initWithNibName:@"TextViewController" bundle:nil] autorelease];
    self.photoViewController = [[[PhotoViewController alloc] initWithNibName:@"PhotoViewController" bundle:nil] autorelease];
    self.movieViewController = [[[MovieViewController alloc] initWithNibName:@"MovieViewController" bundle:nil] autorelease];
    
	//Loading context image!
	CGRect frame = [[UIScreen mainScreen] applicationFrame];
	self.view = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainBackGround.png"]] autorelease];
	self.view.userInteractionEnabled = YES;
	[self.view setFrame:frame];
	
	for (NSInteger i = 1; i <= 8; i++) {
		
		NSInteger chioce = i;
		
		switch (chioce) {
			case 1:
				
				btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn1.frame = CGRectMake(buttonOriginX1, buttonOriginY1, homeButtonWidth, homeButtonHeight);
				btn1.tag = i;
				[btn1 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn1 setBackgroundImage:[UIImage imageNamed:homeButtonIcon1] forState:UIControlStateNormal];
				[btn1 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon1] forState:UIControlStateHighlighted];
				[self.view addSubview:btn1];
				
				break;
			case 2:
				
				btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn2.frame = CGRectMake(buttonOriginX2, buttonOriginY2, homeButtonWidth, homeButtonHeight);
				btn2.tag = i;
				[btn2 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn2 setBackgroundImage:[UIImage imageNamed:homeButtonIcon2] forState:UIControlStateNormal];
				[btn2 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon2] forState:UIControlStateHighlighted];
				[self.view addSubview:btn2];
				
				break;
			case 3:
				
				btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn3.frame = CGRectMake(buttonOriginX3, buttonOriginY3, homeButtonWidth, homeButtonHeight);
				btn3.tag = i;
				[btn3 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn3 setBackgroundImage:[UIImage imageNamed:homeButtonIcon3] forState:UIControlStateNormal];
				[btn3 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon3] forState:UIControlStateHighlighted];
				[self.view addSubview:btn3];
				
				break;
			case 4:
				
				btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
				btn4.frame = CGRectMake(buttonOriginX4, buttonOriginY4, homeButtonWidth, homeButtonHeight);
				btn4.tag = i;
				[btn4 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
				[btn4 setBackgroundImage:[UIImage imageNamed:homeButtonIcon4] forState:UIControlStateNormal];
				[btn4 setBackgroundImage:[UIImage imageNamed:homeButtonHighlightIcon4] forState:UIControlStateHighlighted];
				[self.view addSubview:btn4];
				
				break;
                
            case 5:
                
                btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
                btn5.frame = CGRectMake(50, 199, 71, 37);
                btn5.tag = i;
                [btn5 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btn5 setBackgroundImage:[UIImage imageNamed:@"littleButton1.png"] forState:UIControlStateHighlighted];
                [self.view addSubview:btn5];
                
            case 6:
                
                btn6 = [UIButton buttonWithType:UIButtonTypeCustom];
                btn6.frame = CGRectMake(121.5, 199, 71, 37);
                btn6.tag = i;
                [btn6 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btn6 setBackgroundImage:[UIImage imageNamed:@"littleButton2.png"] forState:UIControlStateHighlighted];
                [self.view addSubview:btn6];

            case 7:
                
                btn7 = [UIButton buttonWithType:UIButtonTypeCustom];
                btn7.frame = CGRectMake(193, 199, 71, 37);
                btn7.tag = i;
                [btn7 addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [btn7 setBackgroundImage:[UIImage imageNamed:@"littleButton3.png"] forState:UIControlStateHighlighted];
                [self.view addSubview:btn7];
                
            case 8:
                btn8 = [UIButton buttonWithType:UIButtonTypeCustom];
                btn8.frame = CGRectMake(280, 420, 34, 33);
                btn8.tag = i;
                [btn8 addTarget:self action:@selector(showAbout:) forControlEvents:UIControlEventTouchUpInside];
                [btn8 setBackgroundImage:[UIImage imageNamed:@"i.png"] forState:UIControlStateNormal];
                [self.view addSubview:btn8];

	
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
