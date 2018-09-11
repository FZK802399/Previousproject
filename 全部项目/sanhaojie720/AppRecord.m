/*
 *  AppRecord.m
 *  BeiJing360
 *
 *  Created by baobin on 11-5-23.
 *  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
 *
 */

#import "AppRecord.h"

@implementation AppRecord

@synthesize appName;
@synthesize appIcon;
@synthesize imageURLString;
@synthesize artist;
@synthesize appID;

- (void)dealloc
{
    [appName release];
    [appIcon release];
    [imageURLString release];
	[artist release];
    [appID release];
    
    [super dealloc];
}

@end

