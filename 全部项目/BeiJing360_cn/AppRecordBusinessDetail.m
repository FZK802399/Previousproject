    //
//  AppRecordBusinessDetail.m
//  BeiJing360
//
//  Created by baobin on 11-6-9.
//  Copyright 2011 v. All rights reserved.
//


#import "AppRecordBusinessDetail.h"

@implementation AppRecordBusinessDetail
@synthesize artistBusinessDetail;
@synthesize imageURLStringBusinessDetail;
//@synthesize idBusinessDetail;	
@synthesize virtualTourURLStringBusinessDetail;
@synthesize addressBusinessDetail;
@synthesize telephoneBusinessDetail;
@synthesize siteBusinessDetail;
@synthesize mapBusinessDetail;


- (void)dealloc
{
 //   [idBusinessDetail release];
    [imageURLStringBusinessDetail release];
	[artistBusinessDetail release];
    [virtualTourURLStringBusinessDetail release];
	[addressBusinessDetail	 release];
	[telephoneBusinessDetail release];
	[siteBusinessDetail release];
	[mapBusinessDetail  release];
    
    [super dealloc];
}

@end