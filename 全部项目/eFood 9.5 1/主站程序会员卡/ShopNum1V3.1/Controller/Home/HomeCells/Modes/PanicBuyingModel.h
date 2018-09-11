//
//  PanicBuyingModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 一元购  限时抢购  限量抢购的参与和抢购名单
@interface PanicBuyingModel : NSObject

@property (copy, nonatomic) NSString *ProductGuid;
@property (copy, nonatomic) NSString *SnapType;
@property (copy, nonatomic) NSString *MemLoginID;
@property (copy, nonatomic) NSString *Photo;
@property (copy, nonatomic) NSString *Message;
@property (copy, nonatomic) NSString *ConfirmTime;

@property (copy, nonatomic) NSURL *photoURL;



//ProductGuid: "9968e978-8945-41c5-8e19-08471afb9225",
//SnapType: "3",
//Photo: "/ImgUpload/201512210417233.jpg",
//MemLoginID: "jerry",
//Message: "未中奖",
//ConfirmTime: "2015/08/18 10:48:08"

+ (void)fetchPanicBuyingListWithParameter:(NSDictionary *)parameter block:(void(^)(NSArray *list, NSError *error))block;

@end
