//
//  MSMapView.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/29.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MapInfo;
@class MSAnnotation;

@interface MSMapView : UIScrollView

@property (nonatomic, assign) CGSize mapImageViewOriginalSize;

- (id)initWithFrame:(CGRect)frame andMapInfo:(MapInfo*)mapInfo;

//添加一个MSAnnotation到MapScrollView上
- (void)addAnnotation:(MSAnnotation *)msAnnotation animated:(BOOL)animate;

@end
