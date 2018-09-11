    //
//  SubAppRecord.m
//  BeiJing360
//
//  Created by baobin on 11-5-31.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "SubAppRecord.h"

@implementation SubAppRecord

@synthesize artistDetail;
@synthesize imageURLStringDetail;
//@synthesize idDetail;	
@synthesize virtualTourURLStringDetail;
@synthesize morePanoramaURLStringDetail;
@synthesize addressDetail;
@synthesize telephoneDetail;
@synthesize siteDetail;
@synthesize mapDetail;
@synthesize businessDetail;


- (void)dealloc
{
    [businessDetail release];
   // [idDetail		release];
    [imageURLStringDetail release];
	[artistDetail		  release];
    [virtualTourURLStringDetail  release];
	[morePanoramaURLStringDetail release];
	[addressDetail   release];
	[telephoneDetail release];
	[siteDetail release];
	[mapDetail  release];
    
    [super dealloc];
}

@end