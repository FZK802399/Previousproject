//
//  Banner.h
//  Shop
//
//  Created by Ocean Zhang on 3/23/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
     "ImageList": [
         {
             "ID": 1,
             "ShopID": 0,
             "Value": "http://mall.nrqiang.com/ImgUpload/shopImage/2012/shop10001//img_201401171004512.jpg",
             "Url": "www",
             "ConfigType": 10
         }
     ]
 }
 */

@interface BannerModel : NSObject

@property (assign, nonatomic) NSInteger ID;

@property (assign, nonatomic) NSInteger ShopID;

@property (copy, nonatomic) NSString *Value;

@property (copy, nonatomic) NSString *Url;

@property (assign, nonatomic) NSInteger ConfigType;

@property (copy, nonatomic) NSString *ImageUrl;

///广告的高度
@property (nonatomic,assign)CGFloat height;



- (id)initWithAttributes:(NSDictionary *)attributes;

+ (void)getBannersWithParamer:(NSDictionary *)parameters andBlocks:(void(^)(NSArray *banners,NSError *error))block;

@end
