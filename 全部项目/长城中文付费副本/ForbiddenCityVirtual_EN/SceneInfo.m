//
//  SceneInfo.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-1.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "SceneInfo.h"

@implementation SceneInfo

@synthesize identifier = _identifier;
@synthesize nameCN = _nameCN;
@synthesize nameEN = _nameEN;
@synthesize scName = _scName;
@synthesize soundEN = _soundEN;
@synthesize soundCN = _soundCN;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;
@synthesize detlaX = _detalX;
@synthesize detlaY = _detalY;
@synthesize distance = _distance;



- (void)dealloc
{
    Release(_nameCN);
    Release(_nameEN);
    Release(_scName);
    Release(_soundEN);
    Release(_soundCN);
    
    [super dealloc];
}

- (void)display
{
//    NSLog(@"id = %d, nameCN = %@, nameEN = %@, scName = %@, soundName = %@, longitude = %f, latitude = %f, detalX = %f, detalY = %f", _identifier, _nameCN, _nameEN, _scName, _soundName, _longitude, _latitude, _detalX, _detalY);
    
    NSLog(@"%@", _nameCN);
}

@end
