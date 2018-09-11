//
//  BeiJing360AppDelegate.h
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeiJing360AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow			*window;
	NSTimer				*connectionTimer;
	BOOL				done;
}

@property (nonatomic, retain) IBOutlet	UIWindow			*window;
@property (nonatomic, retain)			NSTimer				*connectionTimer;

-(void)timerFired:(NSTimer *)timer;

@end

 