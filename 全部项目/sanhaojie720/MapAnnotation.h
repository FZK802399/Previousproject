//
//  MapAnnotation.h
//  BeiJing360
//
//  Created by baobin on 11-6-17.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface MapAnnotation : NSObject <MKAnnotation>{
	CLLocationCoordinate2D coordinate;
	NSString *title;
	NSString *subtitle;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;

@end
