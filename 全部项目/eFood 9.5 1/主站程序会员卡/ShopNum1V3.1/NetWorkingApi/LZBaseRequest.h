//
//  LZBaseRequest.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/23.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LZBaseRequest : NSObject
/// 接口路径
@property (nonatomic,copy)  NSString *requestPath;
/// 请求参数
@property (nonatomic,strong) NSDictionary *requestParameters;


/// 通用 封装
@property (nonatomic,copy)  NSString *appsign;
/// 商家id
@property (copy  , nonatomic) NSString *shopID;
@end
