//
//  MapView.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-17.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneInfo.h"
#import "Annotation.h"
@class MapScrollView;

@interface MapView : UIView<MKMapViewDelegate>
{
    MKMapView *_mapView;
    MapScrollView *_mapScroll;
    
    UIButton *_locatButton;
    UIButton *_changeButton;
    
    NSInteger _currentSceneTag;
    NSArray *_pointsInfo;
    
    CurrentLanguage _currentLanguage;
    
    Annotation *_mapAnn;
}

@property (nonatomic, strong) Annotation *mapAnn;
@property (nonatomic, retain) MKPolyline *oldLine;
@property (nonatomic, retain) MKPolyline *nweLine;

@property (nonatomic, assign) id delegate;

- (id)initWithPoints:(NSArray *)pointInfos;

- (void)addAnnotationWithSceneInfo:(SceneInfo *)info;
- (void)addAnnotationWithSceneInfos:(NSArray *)infos;

- (void)addAnnotationToMapScrollWithSceneInfo:(SceneInfo *)info;
- (void)addAnnotationToMapScrollWithSceneInfos:(NSArray *)infos;

- (void)showCalloutViewWithTag:(NSInteger)tag;

- (void)locationSceneWithTag:(NSInteger)tag;

- (void)scrollViewTapped;

- (void)updateSceneTitleAfterLanguageChanged;

@end
