    //
//  CurrentMapGuideViewController.m
//  BeiJing360
//
//  Created by baobin on 11-6-3.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//
#import "CurrentMapGuideViewController.h"
#import "MySingleton.h"
#import "MapAnnotation.h"

#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]


@implementation CurrentMapGuideViewController
@synthesize theMap, locManagerCurrent;


- (void)dealloc {
	self.theMap = nil;
	[locManagerCurrent stopUpdatingLocation];
	self.locManagerCurrent = nil;
	locateMe = 0;
    [super dealloc];
}

-(void)viewWillDisappear:(BOOL)animated
{
	NSLog(@"view exit!!");
	locateMe = 0;
}
- (void) tick: (NSTimer *) timer
{
	
	locManagerCurrent = [[[CLLocationManager alloc] init] autorelease];
	locManagerCurrent.delegate=self;//设置代理
	locManagerCurrent.desiredAccuracy=kCLLocationAccuracyBest;//指定需要的精度级别
	locManagerCurrent.distanceFilter=1000.0f;//设置距离筛选器
	[locManagerCurrent startUpdatingLocation];//启动位置管理器
	//[locManagerCurrent release];
	
	if (theMap.userLocation)
	{
		[theMap setCenterCoordinate:theMap.userLocation.location.coordinate animated:YES];
		[theMap setRegion:MKCoordinateRegionMake(theMap.userLocation.location.coordinate, MKCoordinateSpanMake(0.25f, 0.25f)) animated:YES];
		[theMap regionThatFits:MKCoordinateRegionMake(theMap.userLocation.location.coordinate, MKCoordinateSpanMake(0.25f, 0.25f))];
	}
	
}

-(void)findme
{
	
	theMap.showsUserLocation = YES;
	if (!locateMe) {
		NSLog(@"i= %d", locateMe);
		[NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(tick:) userInfo:nil repeats:YES];
		locateMe++;
	} else {
		NSLog(@"i count= %d", locateMe);
		[self tick:nil];
	}

	
 	
	
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	locateMe = 0 ;
	//显示当前位置 
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"定位", @selector(findme));
	
	//设置地图显示模式
/*	NSArray *buttonNames = [NSArray arrayWithObjects:@"地图", @"卫星", @"混合", nil];
	
	UISegmentedControl* segmentedControl = [[UISegmentedControl alloc] initWithItems:buttonNames];
	
	segmentedControl.frame = CGRectMake(70 , 7, 180, 30);  
	
	segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar; 
	
	[segmentedControl addTarget:self action:@selector(changeMapType:) forControlEvents:UIControlEventValueChanged];
	
	segmentedControl.selectedSegmentIndex = 0;
	
	self.navigationItem.titleView = segmentedControl;
	
	[segmentedControl release];			*/
	
	//当前景区地图定位
	//	theMap.showsUserLocation = YES;
	//	theMap.zoomEnabled	= YES;

	[theMap setMapType:MKMapTypeStandard];
	
	CLLocationCoordinate2D coords;
	
	coords.latitude = [MySingleton sharedSingleton].currentLatitude;
	coords.longitude = [MySingleton sharedSingleton].currentLogitude;
	
	[theMap setCenterCoordinate:coords animated:YES];
	
	MKCoordinateSpan span = MKCoordinateSpanMake(0.2f, 0.2f);
	
	MKCoordinateRegion region = MKCoordinateRegionMake(coords, span);
	[theMap setRegion:region animated:YES];
	[theMap regionThatFits:region];
	/*
	 //添加地图标注
	 self.geoCoder = [[MKReverseGeocoder alloc] initWithCoordinate:coords];
	 [geoCoder setDelegate:self];
	 [geoCoder start];
	 */
	
	//添加注解
	MapAnnotation *annotation = [[[MapAnnotation alloc] initWithCoordinate:coords] autorelease];
	[theMap addAnnotation:annotation];
		
}

-(IBAction)changeMapType:(id)sender
{
	UISegmentedControl *control = (UISegmentedControl *)sender;
	
	[theMap setMapType:control.selectedSegmentIndex];
}

/*
-(IBAction)backWithCurrentMap:(id)sender
{
	[self.navigationController popViewControllerAnimated:YES];
}
*/
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark MKReverseGeocoderDelegate
/*
- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark {
	[theMap addAnnotation:placemark];
	NSLog(@"%@", placemark.addressDictionary);
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error {
	UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" 
													 message:@"Unable to get address" 
													delegate:nil 
										   cancelButtonTitle:@"OK" 
										   otherButtonTitles:nil];
	[alert show];
	[alert release];
}
*/
#pragma -
#pragma CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
	locationCurrent = newLocation.coordinate;
    NSLog(@"%@",[newLocation description]);
	/*
	
	 locationCurrent=newLocation.coordinate;  
	 //One location is obtained.. just zoom to that location  
	 
	 MKCoordinateRegion region;  
	 
	 //Set Zoom level using Span  
	 MKCoordinateSpan span;  
	 
	 span.latitudeDelta=.15;  
	 span.longitudeDelta=.15;
	 
	 region.span=span;  
	 region.center=locationCurrent;
	 
	 [theMap setCenterCoordinate:locationCurrent animated:YES];
	
	 region = MKCoordinateRegionMake(locationCurrent, span);
	 [theMap setRegion:region animated:YES];  
	 [theMap regionThatFits:region];
	 */
}

#pragma mark MKMapViewDelegate
/*
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	MKPinAnnotationView *aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location"];
	aView.animatesDrop = YES;
	aView.pinColor = MKPinAnnotationColorGreen;
	return aView;
}
*/

#pragma mark MKMapViewDelegate

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
	MKPinAnnotationView *  view = nil; 
	//判断是否是自己  
	if ([annotation isKindOfClass:[MapAnnotation class]]==YES)  
    {  
         

        if (view==nil)  
        {  
            view=[[[MKPinAnnotationView  alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title]  autorelease];  
        }  else   {  
            view.annotation=annotation;  
        }  
		
      //  view.canShowCallout=TRUE;
		view.pinColor = MKPinAnnotationColorRed;
		view.animatesDrop = YES;
		
        return   view;  
    } else {  
	//	MKPinAnnotationView *aView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotation.title] autorelease];
		view.animatesDrop = YES;
		view.pinColor = MKPinAnnotationColorGreen;
		return view;
    }  
}

@end

