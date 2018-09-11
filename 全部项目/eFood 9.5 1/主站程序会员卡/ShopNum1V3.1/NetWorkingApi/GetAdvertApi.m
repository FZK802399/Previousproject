//
//  GetAdvertApi.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/23.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "GetAdvertApi.h"
@interface GetAdvertApi()

@property (assign, nonatomic) CheckType Type;
@property (strong, nonatomic) FMDatabase * db;
@end
@implementation GetAdvertApi
- (instancetype) initWithDataType:(CheckType)Type{
    if (self = [super init]) {
        self.Type   = Type;
        NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"home.sqlite"];
        NSLog(@"path - %@",path);
        self.db = [FMDatabase databaseWithPath:path];
    }
    return self;
}



- (NSString*) requestPath{
    return @"api/ShopGGlist/";
}

- (NSDictionary*) requestParameters {
    return @{
             @"AppSign" : self.appsign,
             @"shopid"  : self.shopID,
             @"Type"    : @(self.Type)
             };
}

- (void) startWtihCallBackSuccess:(void(^)(NSArray *DATA))success failure:(void(^)(NSError *error))failure{
    [[AFAppAPIClient sharedClient] getPath:self.requestPath parameters:self.requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success && responseObject) {
            ///缓存数据
            [DZYTools createTableWithName:@"ShopGGlist" andInsertJSON:responseObject DB:self.db];
            if ([responseObject[@"ImageList"] isKindOfClass:[NSArray class]]) {
                success([BannerModel objectArrayWithKeyValuesArray:responseObject[@"ImageList"]]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
//ht tp://fxv811app.groupfly.cn/api/ShopGGlist/?AppSign=151f76fff0412ed0658ef44d6e0a4f96&shopid=shopnum1_administrators&Type=1
