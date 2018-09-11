//
//  AppDelegate.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-6-24.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#define UMENG_APPKEY @""

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    AVAudioPlayer *_player;
    
    UIImageView *_splash;
}

@property (strong, nonatomic) UIWindow *window;

@end
