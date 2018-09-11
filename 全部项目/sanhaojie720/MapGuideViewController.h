//
//  MapGuideViewController.h
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>

@interface MapGuideViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>{
	
	CLLocationManager	*locManager;
	MKMapView			*mapViewWithMapGuide;
	CLLocationCoordinate2D location;
	NSArray *allAttractionsList;
}

@property (retain) CLLocationManager	*locManager;
@property (nonatomic, retain) IBOutlet	MKMapView		*mapViewWithMapGuide;

@end
