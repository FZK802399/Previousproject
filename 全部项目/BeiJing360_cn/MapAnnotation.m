    //
//  MapAnnotation.m
//  BeiJing360
//
//  Created by baobin on 11-6-17.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "MapAnnotation.h"


@implementation MapAnnotation
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;

- (void)dealloc {
	
	self.title = nil;
	self.subtitle = nil;
	
    [super dealloc];
}

-(id)initWithCoordinate:(CLLocationCoordinate2D) temp_coordinate
{
	if ([super init]) {
		coordinate = temp_coordinate;
	}
	return self;
}

@end
