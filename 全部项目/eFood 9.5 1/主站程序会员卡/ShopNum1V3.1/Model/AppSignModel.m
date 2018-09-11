//
//  AppConfigModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-6.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "AppSignModel.h"
#import "AFAppAPIClient.h"


#define AppID @"0a79e84478e6"
#define AppKey @"324fa4d296cf4369a098"

//测试
//#define AppID @"7862eae87f52"
//#define AppKey @"a087ada428d645629667"

@implementation AppSignModel

+ (void)getAppSignandBlocks:(void(^)(NSString *appSign,NSError *error))block{    
    [[AFAppAPIClient sharedClient] getPath:kWebAppGetAppSignPath parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON){
//        NSLog(@"sing -- %@",JSON);
        NSString *appConfigStr = [JSON objectForKey:@"AppSign"];
        if(block){
            block(appConfigStr,nil);
        }
    }failure:^(AFHTTPRequestOperation *operation,NSError *error){
        if(block){
            block(@"",error);
        }
    }];
}

@end
