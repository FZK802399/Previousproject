    //
//  MySingleton.m
//  BeiJing360
//
//  Created by baobin on 11-6-1.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "MySingleton.h"

@implementation MySingleton
@synthesize subHomeDetailGlobal;
@synthesize subHomeDetailVirtualTourURLString;
@synthesize morePanoramoURLString;
@synthesize morePanoramoVirtualTourURLString;
//@synthesize subHomeDetailMapURLString;
@synthesize peripheryBusinessURLString;
@synthesize peripheryBusinessDetailGlobal;
@synthesize peripheryBusinessDidSelectRow;
@synthesize peripheryBusinessMapDetailURLString;

@synthesize currentFlagWithVirtualTour, currentFlagWithperipheryBusiness;
@synthesize currentLatitude, currentLogitude;
@synthesize whichSubDetailView;

@synthesize soundID;

+ (MySingleton *)sharedSingleton
{
	static MySingleton *sharedSingleton;
	
	@synchronized(self)
	{
		if (!sharedSingleton)
			sharedSingleton = [[MySingleton alloc] init];
		
		return sharedSingleton;
	}
}

@end
