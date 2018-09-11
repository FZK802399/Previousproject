//
//  CustomMorePanoViewCell.h
//  BeiJing360
//
//  Created by baobin on 11-6-13.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomMorePanoViewController;

@interface CustomMorePanoViewCell : UITableViewCell {
	
	CustomMorePanoViewController *customMorePanoViewController;
	
}

@property (readonly) IBOutlet CustomMorePanoViewController *customMorePanoViewController;

@end