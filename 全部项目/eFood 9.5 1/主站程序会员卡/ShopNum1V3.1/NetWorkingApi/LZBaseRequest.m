//
//  LZBaseRequest.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/23.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "LZBaseRequest.h"

@implementation LZBaseRequest
- (NSString*) appsign{
    return [AppConfig sharedAppConfig].appSign;
    //        @"82b514b89232e32e9f6017b0826b26a6"
}
- (NSString*) shopID{
    return @"shopnum1_administrators";
}
@end
