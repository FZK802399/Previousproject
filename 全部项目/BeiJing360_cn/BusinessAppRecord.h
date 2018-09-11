//
//  BusinessAppRecord.h
//  BeiJing360
//
//  Created by baobin on 11-6-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface BusinessAppRecord : NSObject
{
    NSString *appNameBusiness;
    UIImage	 *appIconBusiness;
    NSString *artistBusiness;
	NSString *imageURLString;
    NSString *imageURLStringBusiness;
	NSString *peripheryBusinessDetailURLString;
	//   NSString *appID;
}

@property (nonatomic, retain) NSString *appNameBusiness;
@property (nonatomic, retain) UIImage *appIconBusiness;
@property (nonatomic, retain) NSString *artistBusiness;
@property (nonatomic, retain) NSString *imageURLString;
@property (nonatomic, retain) NSString *imageURLStringBusiness;
@property (nonatomic, retain) NSString *peripheryBusinessDetailURLString;
//@property (nonatomic, retain) NSString *appID;

@end