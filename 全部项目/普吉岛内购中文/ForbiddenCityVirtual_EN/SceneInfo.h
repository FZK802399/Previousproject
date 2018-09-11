//
//  SceneInfo.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-1.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneInfo : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, strong) NSString *nameCN;
@property (nonatomic, strong) NSString *nameEN;
@property (nonatomic, strong) NSString *scName;
@property (nonatomic, strong) NSString *soundEN;
@property (nonatomic, strong) NSString *soundCN;
@property (nonatomic, assign) float longitude;
@property (nonatomic, assign) float latitude;
@property (nonatomic, assign) float detlaX;
@property (nonatomic, assign) float detlaY;
@property (nonatomic, assign) float distance;

- (void)display;

@end
