//
//  BeiJing360AppDelegate.m
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "BeiJing360AppDelegate.h"
#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation BeiJing360AppDelegate

@synthesize window;

@synthesize connectionTimer;

- (void)dealloc {
	
	self.connectionTimer = nil;
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
	 
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];	

    // Override point for customization after application launch.
	
	HomeViewController *homeViewController = [[HomeViewController alloc] init];
	UINavigationController *homeNavController= [[UINavigationController alloc] initWithRootViewController:homeViewController];
	homeNavController.navigationBar.barStyle = UIBarStyleDefault; 
    homeNavController.navigationBar.tintColor = [UIColor colorWithRed:19.0f/255.0f green:134.0f/255.0f blue:200.0f/255.0f alpha:0.5f]; 
    
    [homeNavController setNavigationBarHidden:YES animated:NO];
    
    self.window.rootViewController = homeNavController;
    [homeNavController release];
	[homeViewController release];
	
	[self.window makeKeyAndVisible];
   // [application setDeviceOrientation:UIInterfaceOrientationIsLandscapeRight];

    return YES;
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    //return  YES;
    //    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
    return (UIInterfaceOrientationIsLandscape(toInterfaceOrientation));
}
@end
