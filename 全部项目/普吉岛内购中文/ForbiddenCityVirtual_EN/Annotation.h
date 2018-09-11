//
//  Annotation.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-17.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Annotation : NSObject<MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *nameCn;
@property (nonatomic, copy) NSString *nameEn;

@property (nonatomic, assign) NSInteger identifier;

@end
