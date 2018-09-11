//
//  Banner.h
//  Shop
//
//  Created by Ocean Zhang on 3/23/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"

typedef enum {
    HomeBanner= 0,
    ShopBanner = 1
}BannerType;

@interface BannerComponent : UIView<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIPageControl *scrollPage;

@property (nonatomic, strong) UIImageView *placeholderImg;

@property (nonatomic, assign) CGFloat scrollPagePositionOffset;

- (void)createBanner:(NSDictionary *)CityStr withType:(BannerType)type;

@end
