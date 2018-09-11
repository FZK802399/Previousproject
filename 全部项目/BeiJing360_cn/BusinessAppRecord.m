    //
//  BusinessAppRecord.m
//  BeiJing360
//
//  Created by baobin on 11-6-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "BusinessAppRecord.h"

@implementation BusinessAppRecord

@synthesize appNameBusiness;
@synthesize appIconBusiness;
@synthesize imageURLStringBusiness;
@synthesize artistBusiness;
@synthesize imageURLString;
@synthesize peripheryBusinessDetailURLString;
//@synthesize appID;

- (void)dealloc
{
	[imageURLString release];
    [appNameBusiness release];
    [appIconBusiness release];
    [imageURLStringBusiness release];
	[artistBusiness release];
	[peripheryBusinessDetailURLString release];
	//   [appID release];
    
    [super dealloc];
}

@end

