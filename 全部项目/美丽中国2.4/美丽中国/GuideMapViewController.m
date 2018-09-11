//
//  GuideMapViewController.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/29.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "GuideMapViewController.h"
#import "Header.h"
#import "GuideInfo.h"
#import "MSMapView.h"
#import "MapInfo.h"
#import "MSAnnotation.h"

@interface GuideMapViewController ()
{
    GuideInfo *_guideInfo;//导游对象
    MSMapView *_msMapView;//自定义地图
    MapInfo *_mapInfo;//地图对象
    NSArray *_pointInfoArray;//承载PointInfo对象的数组
}
@end

@implementation GuideMapViewController

- (void)dealloc
{
    NSLog(@"GuideMapViewController dealloc");
}

- (id)initWithGuideInfo:(GuideInfo *)guideInfo
{
    self = [super init];
    if (self) {
        _guideInfo = guideInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.title = _guideInfo.guideName;
    
    //设置导航栏
    [self setNavigationBar];
    
    //获取MapInfo对象和承载PointInfo对象的数组
    [self getMapInfoAndPointInfoArray];

}

//获取MapInfo对象和承载PointInfo对象的数组
- (void)getMapInfoAndPointInfoArray
{
    //获取导游路径
    NSString *guidePath = GUIDE_PATH;
    //获取单个导游的存储路径
    NSString *guideDataPath = [guidePath stringByAppendingPathComponent:_guideInfo.namePath];
    //单个导游 配置文件的存储路径
    NSString *jsonPath = [guideDataPath stringByAppendingPathComponent:@"config.json"];
    //去除json文件
    NSData *jsonData = [NSData dataWithContentsOfFile:jsonPath];
    //解析json文件
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    //从解析出的json文件中得到地图信息 存放到MapInfo对象中
    NSArray *mapJsonArray = [[dictionary objectForKey:@"view"] objectForKey:@"map"];
    NSDictionary *mapJsonDictionary = [mapJsonArray objectAtIndex:0];
    CGSize boundsSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height-44-20);
    //初始化_mapInfo对象
    _mapInfo = [[MapInfo alloc] initWithDictionary:mapJsonDictionary andBoundsSize:boundsSize];
    
    //从解析出的json文件中得到景点信息 存放到PointInfo对象中
    NSArray *pointJsonArray = [[dictionary objectForKey:@"view"] objectForKey:@"points"];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:20];
    for (NSDictionary *pointJsonDictionary in pointJsonArray) {
        PointInfo *pointInfo = [[PointInfo alloc] initWithDictionary:pointJsonDictionary andZoomScale:_mapInfo.zoomScale];
        [mutableArray addObject:pointInfo];
    }
    
    //根据PointInfo对象的y属性进行排序 并且用来初始化数组sortedPointInfoArray
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"y" ascending:YES];
    _pointInfoArray = [mutableArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    //添加地图视图
    [self addMapView];
}

//添加地图视图
- (void)addMapView
{
    //初始化_msMapView
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height-44-20;
    _msMapView = [[MSMapView alloc] initWithFrame:frame andMapInfo:_mapInfo];
    [self.view addSubview:_msMapView];
    
    //添加注解到地图
    [self addAnnotationToMapView];
}

//添加注解到地图
- (void)addAnnotationToMapView
{
    for (int i=0; i<_pointInfoArray.count; i++) {
        PointInfo *pointInfo = _pointInfoArray[i];
        NSLog(@"pointInfo %d %d",pointInfo.x,pointInfo.y);
        MSAnnotation *msAnnotation = [[MSAnnotation alloc] initWithPoint:CGPointMake(pointInfo.x, pointInfo.y)];
        msAnnotation.pinState = PinState_Red;
        msAnnotation.tag = i;
        msAnnotation.title = pointInfo.pointName;
        msAnnotation.subtitle = @"(观看3D实景)";
        msAnnotation.sceneName = pointInfo.pointScene;
        UIButton *rightCalloutAccessoryButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightCalloutAccessoryButton addTarget:self action:@selector(rightCalloutAccessoryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        rightCalloutAccessoryButton.tag = i;
        msAnnotation.rightCalloutAccessoryButton = rightCalloutAccessoryButton;
        [_msMapView addAnnotation:msAnnotation animated:YES];
    }
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

@end
