//
//  MapView.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-17.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "MapView.h"
#import "Annotation.h"
#import "MapScrollView.h"
#import "SceneInfo.h"
#import "MSPinAnnotationView.h"

@implementation MapView

@synthesize delegate = _delegate;
@synthesize mapAnn = _mapAnn;
@synthesize oldLine = _oldLine;


- (void)dealloc
{
    [_mapView release];
    [_locatButton release];
    [_changeButton release];
    Release(_pointsInfo);
    Release(_mapScroll);
    Release(_mapAnn);
    Release(_oldLine);
    Release(_nweLine);
    
    [super dealloc];
}

- (id)initWithPoints:(NSArray *)pointInfos
{
    if (_pointsInfo)
    {
        [_pointsInfo release];
        _pointsInfo = nil;
    }
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"detlaY" ascending:YES] autorelease];
    NSArray *sortDescriptorArray = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray = [pointInfos sortedArrayUsingDescriptors:sortDescriptorArray];
    _pointsInfo = [[NSArray alloc] initWithArray:sortedArray];    
    return [self initWithFrame:CGRectMake(0, 0, 0, 0)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:36.0f/255.0f green:36.0f/255.0f blue:36.0f/255.0f alpha:1.0f];
        
        [self setUserInteractionEnabled:YES];
        
        CGRect rc = CGRectMake(kLCDH - 365 - 76, kLCDW - 82.0f - 561 - 4 - 20, 365, 561);
        CGRect maskRC = CGRectMake(0, 0, 365, 561);
        self.frame = rc;
        
        CALayer *mask = [CALayer layer];
        mask.contents = (id)[[UIImage imageNamed:@"map_bg.png"] CGImage];
        mask.frame = maskRC;
        self.layer.mask = mask;
        self.layer.masksToBounds = YES;
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, 365, 561 - 15)];
        [_mapView setDelegate:self];
                
        CLLocationCoordinate2D mapCenter;
        mapCenter.longitude = 116.01434290409088;
        mapCenter.latitude = 40.355215170062344;
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        
        //设定显示范围
        span.latitudeDelta = 0.02f;
        span.longitudeDelta = 0.02f;
        region.span = span;
        region.center = mapCenter;
        [_mapView setRegion:region animated:YES];
        [_mapView regionThatFits:region];
        [_mapView setShowsUserLocation:YES];
        [self addSubview:_mapView];
        [_mapView setHidden:YES];
        [self addAnnotationWithSceneInfos:_pointsInfo];
        
        _mapScroll = [[MapScrollView alloc] initWithFrame:maskRC];
        [_mapScroll displayMapImage:[UIImage imageNamed:@"mapimage.jpg"]];
        [self addAnnotationToMapScrollWithSceneInfos:_pointsInfo];
        [_mapScroll setMapDelegate:self];
        [self addSubview:_mapScroll];
        //调整大头针的语言
        [self updateSceneTitleAfterLanguageChanged];
        _locatButton = [[UIButton alloc] initWithFrame:CGRectMake(365 - 70, 561 - 86, 64, 64)];
        [_locatButton setImage:[UIImage imageNamed:@"change.png"] forState:UIControlStateNormal];
        [_locatButton setImage:[UIImage imageNamed:@"change_h.png"] forState:UIControlStateHighlighted];
        [_locatButton addTarget:self action:@selector(locatCurrentScene) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_locatButton];
        
        _changeButton = [[UIButton alloc] initWithFrame:CGRectMake(365 - 70 - 74, 561 - 86, 64, 64)];
        [_changeButton setImage:[UIImage imageNamed:@"locat.png"] forState:UIControlStateNormal];
        [_changeButton setImage:[UIImage imageNamed:@"locat_h.png"] forState:UIControlStateHighlighted];
        [_changeButton addTarget:self action:@selector(changeMap) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_changeButton];
        
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"map_mask.png"]];
        [image setFrame:maskRC];
        [self addSubview:image];
        [image release];
        
    }
    return self;
}

- (void)changeMap
{
    [MobClick event:@"changeMaps"];
    if (_mapView.isHidden)
    {
        _mapView.hidden = NO;
        _mapScroll.hidden = YES;
    }
    else
    {
        _mapScroll.hidden = NO;
        _mapView.hidden = YES;
    }
}

- (void)loadSceenWithTag:(NSNumber *)tag
{
    if (tag.intValue == _currentSceneTag)
    {
        return;
    }
    [_delegate performSelector:@selector(loadSceneWithTag:) withObject:tag];
    _currentSceneTag = tag.intValue;
    [self displaySysMapAfterCurrentSceneChange];
}

- (void)locationSceneWithTag:(NSInteger)tag
{
    
    
}

- (void)addAnnotationToMapScrollWithSceneInfo:(SceneInfo *)info
{
    MSAnnotation *ann = [[MSAnnotation alloc] initWithPoint:CGPointMake(info.detlaX, info.detlaY)];
    ann.title = info.nameCN;
    ann.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    ann.rightCalloutAccessoryView.tag = info.identifier;
    ann.tag = info.identifier;
    ann.nameEn = info.nameEN;
    ann.nameCn = info.nameCN;
    [_mapScroll addAnnotation:ann animated:YES];
    [ann release];
}
- (void)addAnnotationToMapScrollWithSceneInfos:(NSArray *)infos
{
    for (SceneInfo *info in infos)
    {
        [self addAnnotationToMapScrollWithSceneInfo:info];
    }
}

- (void)locatCurrentScene
{
    [_mapScroll showCallOutViewWithTag:_currentSceneTag];
    for (Annotation *ann in _mapView.annotations)
    {
        if ([ann isKindOfClass:NSClassFromString(@"MKUserLocation")])
        {
            [self displaySysMapAfterCurrentSceneChange];
            MKCoordinateRegion region;
            MKCoordinateSpan span;
            
            //设定显示范围
            span.latitudeDelta = 0.005f;
            span.longitudeDelta = 0.005f;
            region.span = span;
            region.center = ann.coordinate;
            [_mapView setRegion:region animated:YES];
            [_mapView selectAnnotation:ann animated:YES];
            return;
        }
    }
    [MobClick event:@"userLocation"];
}

- (void)showCalloutViewWithTag:(NSInteger)tag
{
    if (_currentSceneTag == tag)
    {
        return;
    }
    [_mapScroll showCallOutViewWithTag:tag];
    for (Annotation * ann in _mapView.annotations)
    {
        if (ann.identifier == tag)
        {
            _currentSceneTag = tag;
            [self displaySysMapAfterCurrentSceneChange];
            [_mapView selectAnnotation:ann animated:YES];
            return;
        }
    }
}

- (void)updateSceneTitleAfterLanguageChanged
{
    _currentLanguage = [[USER_DEFAULTS objectForKey:kCurrent_Language] integerValue];
    for (MSPinAnnotationView *pin in _mapScroll.pinAnnotations)
    {
        MSAnnotation *ann = [pin annotation];
        if (_currentLanguage == English)
        {
            ann.title = [ann nameEn];
        }
        else
        {
            ann.title = [ann nameCn];
        }
    }
    
    for (Annotation *ann in _mapView.annotations)
    {
        
        if ([ann isKindOfClass:NSClassFromString(@"MKUserLocation")])
        {
            continue;
        }
        if (_currentLanguage == English)
        {
            ann.title = ann.nameEn;
        }
        else
        {
            ann.title = ann.nameCn;
        }
    }
    [self displaySysMapAfterCurrentSceneChange];
    [_mapScroll showCallOutViewWithTag:1];
}


- (void)addAnnotationWithSceneInfo:(SceneInfo *)info
{
    _currentLanguage = [[USER_DEFAULTS objectForKey:kCurrent_Language] integerValue];
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = info.latitude;
    coordinate.longitude = info.longitude;
    Annotation *ann = [[Annotation alloc] init];
    ann.coordinate = coordinate;
    ann.identifier = info.identifier;
    ann.nameCn = info.nameCN;
    ann.nameEn = info.nameEN;
    [_mapView addAnnotation:ann];
    [ann release];
}
- (void)addAnnotationWithSceneInfos:(NSArray *)infos
{
    for (SceneInfo *info in infos)
    {
        [self addAnnotationWithSceneInfo:info];
    }
}


- (void)displaySysMapAfterCurrentSceneChange
{
    for (Annotation * ann in _mapView.annotations)
    {
        if ([ann isKindOfClass:[MKUserLocation class]])
        {
            continue;
        }
        if (ann.identifier == _currentSceneTag)
        {
            CLLocation *location = [[[CLLocation alloc] initWithLatitude:ann.coordinate.latitude longitude:ann.coordinate.longitude] autorelease];
            MKCoordinateRegion region = [self makeRegionWithUserLocation:_mapView.userLocation.location andCurrentSceneLocation:location];
            [_mapView setRegion:region animated:YES];
            [_mapView regionThatFits:region];
            MKMapPoint points[2];
            CLLocationCoordinate2D coord1 = _mapView.userLocation.location.coordinate;
            CLLocationCoordinate2D coord2 = ann.coordinate;
            points[0] = MKMapPointForCoordinate(coord1);
            points[1] = MKMapPointForCoordinate(coord2);
            MKPolyline *line = [MKPolyline polylineWithPoints:points count:2];
            self.nweLine = line;
            if (self.oldLine)
            {
                [_mapView removeOverlay:self.oldLine];
                [_mapView addOverlay:self.nweLine];
                self.oldLine = self.nweLine;
            }
            else
            {
                [_mapView addOverlay:self.nweLine];
                self.oldLine = self.nweLine;
            }
            MKUserLocation *userlocation = [_mapView.annotations objectAtIndex:_mapView.annotations.count - 1];
            CLLocationDistance distance = [_mapView.userLocation.location distanceFromLocation:location];
            NSString *string = nil;
            if ([USER_DEFAULTS boolForKey:kCurrent_Language] == English)
            {
                if (distance > 1000.0f)
                {
                    string = [NSString stringWithFormat:@"%.2fkm away from the attraction.", distance / 1000.0f];
                }
                else
                {
                    string = [NSString stringWithFormat:@"%.0fm away from the attraction.", distance];
                }
            }
            else
            {
                if (distance > 1000.0f)
                {
                    string = [NSString stringWithFormat:@"当前位置距离景点%.2f km", distance / 1000.0f];
                }
                else
                {
                    string = [NSString stringWithFormat:@"当前位置距离景点%.0f m", distance];
                }
            }
            userlocation.title = string;
        }
    }
    
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:NSClassFromString(@"MKUserLocation")])
    {
        return nil;
    }
    static NSString *free = @"free";
    
    MKPinAnnotationView *pin;
    Annotation *ann = (Annotation *)annotation;
    
    pin = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:free];
    if (!pin)
    {
        pin = [[[MKPinAnnotationView alloc] initWithAnnotation:ann reuseIdentifier:free] autorelease];
    }
    pin.pinColor = MKPinAnnotationColorGreen;

    
    pin.canShowCallout = YES;
    pin.animatesDrop = NO;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	pin.rightCalloutAccessoryView = button;
    
    return pin;
    
}
- (void)scrollViewTapped
{
    
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    Annotation *ann = (Annotation *)view.annotation;
    [self loadSceenWithTag:[NSNumber numberWithInt:ann.identifier]];

}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineView *lineview=[[[MKPolylineView alloc] initWithOverlay:overlay] autorelease];
        lineview.strokeColor=[[UIColor blueColor] colorWithAlphaComponent:0.75f];
        lineview.lineWidth=2.0;
        return lineview;
    }
    return nil;
}


- (MKCoordinateRegion)makeRegionWithUserLocation:(CLLocation *)userLocation andCurrentSceneLocation:(CLLocation *)currentLocation
{
    MKCoordinateRegion region;
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:userLocation.coordinate.latitude longitude:0];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:currentLocation.coordinate.latitude longitude:0];
    double distance = [location1 distanceFromLocation:location2];
    [location1 release];
    [location2 release];
    float delta = distance / 100000.0f;
    MKCoordinateSpan span;
    span.longitudeDelta = delta;
    span.latitudeDelta = delta;
    double latitude = (userLocation.coordinate.latitude + currentLocation.coordinate.latitude) / 2.0f;
    double longitude = (userLocation.coordinate.longitude + currentLocation.coordinate.longitude) / 2.0f;
    region.center.latitude = latitude;
    region.center.longitude = longitude;
    region.span = span;
    return region;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [self displaySysMapAfterCurrentSceneChange];
}


@end
