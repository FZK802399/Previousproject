//
//  CurrentMapGuideViewController.h
//  BeiJing360
//
//  Created by baobin on 11-6-3.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CurrentMapGuideViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate> {
	CLLocationManager *locManagerCurrent;
	MKMapView *theMap;
	CLLocationCoordinate2D locationCurrent;
	NSInteger locateMe;
}

@property (nonatomic, retain) IBOutlet MKMapView *theMap;
@property (retain) CLLocationManager *locManagerCurrent;

-(IBAction)changeMapType:(id)sender;


@end
