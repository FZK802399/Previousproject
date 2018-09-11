//
//  MapViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/23.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "MapViewController.h"
#import "PanoInfo.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"

@interface MapViewController ()<MKMapViewDelegate>
{
    PanoInfo *_panoInfo;
    MKMapView *_mapView;
}
@end

@implementation MapViewController

- (void)dealloc
{
    NSLog(@"MapViewController dealloc");
    _mapView.delegate = nil;
}

- (id)initWithPanoInfo:(PanoInfo*)panoInfo
{
    self = [super init];
    if (self) {
        _panoInfo = panoInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"地图";
    //设置导航栏
    [self setNavigationBar];
    
    //添加地图视图
    [self addMapView];
}

//添加地图视图
- (void)addMapView
{
    //初始化地图视图_mapView
    _mapView = [[MKMapView alloc] initWithFrame:self.view.frame];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    //地图显示的跨度
    MKCoordinateSpan span;
    //设置跨度的精度 精度越小越精准
    span.latitudeDelta = 0.1;
    span.longitudeDelta = 0.1;
    
    //显示地图的区域
    MKCoordinateRegion region;
    //区域的中心点为坐标
    region.center = _panoInfo.coordinate;
    //设置区域的跨度
    region.span = span;
    
    //设置地图的显示区域
    [_mapView setRegion:region];
    
    //给_mapView添加标注annotation
    MapAnnotation *annotation = [[MapAnnotation alloc] initWithCoordinate:_panoInfo.coordinate title:_panoInfo.name subtitle:_panoInfo.address];
    [_mapView addAnnotation:annotation];
    //选中地图_mapView上的标注annotation 并带有动画效果
    [_mapView selectAnnotation:annotation animated:YES];
}

//设置导航栏
- (void)setNavigationBar
{
    //设置返回按钮
    UIImage *backImageNormal = [UIImage imageNamed:@"nav_back_button_normal.png"];
    UIImage *backImageHighlight = [UIImage imageNamed:@"nav_back_button_highlight.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(15.0f, 5.0f, backImageNormal.size.width/1.8, backImageNormal.size.height/1.8);
    [backButton setBackgroundImage:backImageNormal forState:UIControlStateNormal];
    [backButton setBackgroundImage:backImageHighlight forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem=backBarButton;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MKMapViewDelegate
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id )annotation
{
    //大头针标示符
    static NSString *pinIdentifier = @"pinIdentifier";
    
    //重用大头针视图
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
    //如果大头针视图对象pinView为空则创建新的对象
    if (!pinView){
        pinView = [[MKPinAnnotationView alloc]
                                      initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
    }
    //设置大头针颜色
    pinView.pinColor = MKPinAnnotationColorRed;
    //设置是否显示大头针上面的弹出框
    pinView.canShowCallout = YES;
    //设置大头针显示的时候是否有下落的动画
    pinView.animatesDrop = YES;
    return pinView;
}

@end
