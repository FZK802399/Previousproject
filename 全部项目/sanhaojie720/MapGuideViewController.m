    //
//  MapGuideViewController.m
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "MapGuideViewController.h"
#import "MapAnnotation.h"

@implementation MapGuideViewController
@synthesize locManager;
@synthesize mapViewWithMapGuide;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"MapGuideViewController" bundle:nil];
    if (self) {
		//self.title = @"地图导游";
		
		[self.tabBarItem initWithTitle:@"地图导游" image:[UIImage imageNamed:@"mapGuide.png"] tag:3];
        // Custom initialization.
    }
    return self;
}

- (id)init
{
	
   if (self = [super init])  {		
		allAttractionsList = [NSArray arrayWithObjects:
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.271915",@"attractionsLongitude",@"39.999084",@"attractionsLatitude", 
																		 @"颐和园", @"attractionsTitle",@"北京市海淀区新建宫门路19号", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.413021",@"attractionsLongitude",@"39.884911",@"attractionsLatitude",  
																		 @"天坛", @"attractionsTitle",@"北京市崇文区天坛路甲1号", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.303673",@"attractionsLongitude",@"39.99989",@"attractionsLatitude",  
																		 @"圆明园", @"attractionsTitle",@"北京市海淀区清华西路28号", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.397572",@"attractionsLongitude",@"39.910395",@"attractionsLatitude",  
																		 @"天安门", @"attractionsTitle",@"北京市东城区东长安街", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.3974",@"attractionsLongitude",@"39.997901",@"attractionsLatitude",  
																		 @"鸟巢", @"attractionsTitle",@"北京市朝阳区安定路甲3-3号", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.389804",@"attractionsLongitude",@"39.90516",@"attractionsLatitude",  
																		 @"国家大剧院", @"attractionsTitle",@"北京市西城区西长安街2号", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.459885",@"attractionsLongitude",@"39.911053",@"attractionsLatitude",  
																		 @"国贸三期", @"attractionsTitle",@"北京市建国门外大街1号", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.39328",@"attractionsLongitude",@"39.905523",@"attractionsLatitude",  
																		 @"前门步行街", @"attractionsTitle",@"北京市崇文区前门大栅栏步行街", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.395072",@"attractionsLongitude",@"39.883365",@"attractionsLatitude",  
																		 @"自然博物馆", @"attractionsTitle",@"北京市东城区天桥南126号", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.408644",@"attractionsLongitude",@"39.926852",@"attractionsLatitude",  
																		 @"中国美术馆", @"attractionsTitle",@"北京市东城区五四大街1号", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.407013",@"attractionsLongitude",@"39.927247",@"attractionsLatitude",  
																		 @"宣南文化博物馆", @"attractionsTitle",@"北京市宣武区长椿街", @"attractionsAddress", nil],
							  [NSDictionary dictionaryWithObjectsAndKeys:@"116.345091",@"attractionsLongitude",@"39.966596",@"attractionsLatitude",  
																		 @"大钟寺", @"attractionsTitle",@"北京市海淀区大钟寺", @"attractionsAddress", nil],
							  nil];	
		
	}
	
	[allAttractionsList retain];
	
    return self;
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];
		
	
	if (![CLLocationManager locationServicesEnabled]) {
		 NSLog(@"用户关闭了定位服务");
		return;
	} else {

		for (int i = 0; i < 12; i++) {
			location.longitude = [[[allAttractionsList objectAtIndex:i] objectForKey:@"attractionsLongitude"] doubleValue];
			location.latitude = [[[allAttractionsList objectAtIndex:i] objectForKey:@"attractionsLatitude"] doubleValue];
			
			MKCoordinateRegion region;
			MKCoordinateSpan span;
			
			span.latitudeDelta = .35;
			span.longitudeDelta = .35;
			
			region.span = span;
			region.center = location;
			
			[mapViewWithMapGuide setRegion:region animated:YES];
			[mapViewWithMapGuide regionThatFits:region];
			
			//	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
			//	[pool release];
			MapAnnotation *mapAnnotations = [[MapAnnotation alloc] initWithCoordinate:location];
			mapAnnotations.title = [[allAttractionsList objectAtIndex:i] objectForKey:@"attractionsTitle"];
			mapAnnotations.subtitle = [[allAttractionsList objectAtIndex:i] objectForKey:@"attractionsAddress"];
			[mapViewWithMapGuide addAnnotation:mapAnnotations];
			[mapAnnotations release];
		}
	}
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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


- (void)dealloc {
	[locManager stopUpdatingLocation];
	self.locManager = nil;
	self.mapViewWithMapGuide = nil;
	[allAttractionsList release];
    [super dealloc];
}

#pragma -
#pragma CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%@",[newLocation description]);
	
	/*
    location=newLocation.coordinate;  
    //One location is obtained.. just zoom to that location  
	
    MKCoordinateRegion region;  
      
    //Set Zoom level using Span  
    MKCoordinateSpan span;  
	
    span.latitudeDelta=.1;  
    span.longitudeDelta=.1;
	
    region.span=span;  
	region.center=location;
	
//	NSLog(@"Location= %d", mapViewWithMapGuide.showsUserLocation);
//	mapViewWithMapGuide.showsUserLocation = YES;
    [mapViewWithMapGuide setRegion:region animated:YES];  
	[mapViewWithMapGuide regionThatFits:region];
	
	//添加标注
	MapAnnotation *mapAnnotations = [[MapAnnotation alloc] initWithCoordinate:location];
	mapAnnotations.title = @"当前位置";
	mapAnnotations.subtitle = @"have a try";
	[mapViewWithMapGuide addAnnotation:mapAnnotations];
	[mapAnnotations release];
	*/
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@",[error description]);
	
	NSString *errorMessage;
	if ([error code] == kCLErrorDenied) {
		errorMessage = @"被拒绝访问";
	}
	if ([error code] == kCLErrorLocationUnknown) {
		errorMessage = @"无法定位到你的位置";
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:self 
										cancelButtonTitle:@"确定" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(void)checkButtonTapped:(id)sender event:(id)event {
	UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"讯息"
												  message:@"Callout测试"
												 delegate:nil
										cancelButtonTitle:@"OK"
										otherButtonTitles:nil];
	[tmp show];
	[tmp release];
}

#pragma mark MKMapDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{

	MKPinAnnotationView *pinView = nil;
	
	static NSString *defaultPinID = @"com.chuangyifengton.beijing360"; 
	pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID]; 
	if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc] 
									  initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease]; 
	pinView.pinColor = MKPinAnnotationColorRed; 
	pinView.canShowCallout = YES; 
	pinView.animatesDrop = YES; 
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	[button addTarget:self action:@selector(checkButtonTapped:event:) forControlEvents:UIControlEventTouchUpInside];
	pinView.rightCalloutAccessoryView = button;
	
	return pinView; 
}
@end
