//
//  BeiJing360AppDelegate.m
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "BeiJing360AppDelegate.h"
#import "HomeViewController.h"
#import "VirtualTourismViewController.h"
#import "MapGuideViewController.h"
#import "AboutViewController.h"
#import "MoreAppViewController.h"
#import "IAPManager.h"

@implementation BeiJing360AppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize connectionTimer;

- (void)dealloc {
	
	self.connectionTimer = nil;
	[tabBarController release];
    [window release];
	
    [super dealloc];
}

#pragma mark -
#pragma mark Application lifecycle

-(void)timerFired:(NSTimer *)timer{
    done = YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {  

	//enter Home after 1s
    self.connectionTimer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
   
	[[NSRunLoop currentRunLoop] addTimer:self.connectionTimer forMode:NSDefaultRunLoopMode];
   
	do{
       
		[[NSRunLoop currentRunLoop]runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
   
	}while (!done);    
	
	//statusBar
	[application setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
	
//    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
    // Override point for customization after application launch.

	NSMutableArray *controllerArray = [[NSMutableArray alloc] init];
	
	HomeViewController *homeViewController = [[HomeViewController alloc] init];
	UINavigationController *homeNavController= [[UINavigationController alloc] initWithRootViewController:homeViewController];
	homeNavController.navigationBar.barStyle = UIBarStyleDefault;
	[controllerArray addObject:homeNavController];
	[homeNavController release];
	[homeViewController release];
	
	VirtualTourismViewController *virtualTourismViewController = [[VirtualTourismViewController alloc] init];
	UINavigationController *virtualTourismNavController = [[UINavigationController alloc] initWithRootViewController:virtualTourismViewController];
	virtualTourismNavController.navigationBar.barStyle = UIBarStyleDefault;
	virtualTourismNavController.navigationBar.hidden = YES;
	[controllerArray addObject:virtualTourismNavController];
	[virtualTourismNavController release];
	[virtualTourismViewController release];
	
	MapGuideViewController *mapGuideViewController = [[MapGuideViewController alloc] init];
	UINavigationController *mapGuideNavController= [[UINavigationController alloc] initWithRootViewController:mapGuideViewController];
	mapGuideNavController.navigationBar.hidden = YES;
	[controllerArray addObject:mapGuideNavController];
	[mapGuideNavController release];
	[mapGuideViewController release];
	
/*	ShareViewController *shareViewController = [[ShareViewController alloc] init];
	UINavigationController *shareNavController = [[UINavigationController alloc] initWithRootViewController:shareViewController];
	shareNavController.navigationBar.barStyle = UIBarStyleDefault;
	[controllerArray addObject:shareNavController];
	[shareNavController release];
	[shareViewController release];*/
	
	AboutViewController *aboutViewController = [[AboutViewController alloc] init];
	UINavigationController *aboutNavController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
	//aboutNavController.navigationBar.barStyle = UIBarStyleDefault;
	aboutNavController.navigationBar.hidden = YES;

	[controllerArray addObject:aboutNavController];
	[aboutNavController release];
	[aboutViewController release];
	
	
	MoreAppViewController *moreAppViewController = [[MoreAppViewController alloc] init];
	UINavigationController *moreAppNavController = [[UINavigationController alloc] initWithRootViewController:moreAppViewController];
	moreAppNavController.navigationBar.hidden = YES;
	[controllerArray addObject:moreAppNavController];
	[moreAppNavController release];
	[moreAppViewController release];
	
	tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:controllerArray];
	[controllerArray release];
	
//    [self.window makeKeyAndVisible];
//    [self.window addSubview:tabBarController.view];
    
    
    self.window.rootViewController = tabBarController;//加在这里！
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];


    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


@end
