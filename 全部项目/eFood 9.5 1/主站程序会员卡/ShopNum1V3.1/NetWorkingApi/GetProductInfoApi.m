//
//  GetProductInfoApi.m
//  HomePage
//
//  Created by 梁泽 on 15/11/22.
//  Copyright © 2015年 right. All rights reserved.
//

#import "GetProductInfoApi.h"
#import "AFAppAPIClient.h"
@interface GetProductInfoApi()
/// 产品类型
@property (nonatomic,assign) CheckProductType type;
/// 查询方式 ModifyTime:时间   Price：价格  SaleNumber：销售量
@property (nonatomic,copy)  NSString *sorts;
/// isAsc True：升序  false：降序
@property (nonatomic,assign) NSString *isASC;
/// 第几页
@property (nonatomic,assign) NSInteger pageIndex;
/// 多少数
@property (nonatomic,assign) NSInteger pageCount;
@end
@implementation GetProductInfoApi
/// sorts=ModifyTime:时间  isASC=false：降序 默认方式
- (instancetype) initWithType:(CheckProductType)type pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount {
    return [[GetProductInfoApi alloc] initWithType:type sorts:@"ModifyTime" isASC:@"false" pageIndex:pageIndex pageCount:pageCount];
}
- (instancetype) initWithType:(CheckProductType)type sorts:(NSString*)sorts isASC:(NSString*)isASC pageIndex:(NSInteger)pageIndex pageCount:(NSInteger)pageCount {
    if (self = [super init]) {
        self.type = type;
        self.sorts = sorts;
        self.isASC = isASC;
        self.pageIndex = pageIndex;
        self.pageCount = pageCount;
    }
    return self;
}

- (NSString *) requestPath {
    return @"api/product2/type/";
}
- (NSDictionary*) requestParameters {
    return @{
             @"appsign"    : self.appsign,
             @"type"       : @(self.type),
             @"sorts"      : self.sorts,
             @"isASC"      : self.isASC,
             @"pageIndex"  : @(self.pageIndex),
             @"pageCount"  : @(self.pageCount)
             };
}
- (void) startWtihCallBackSuccess:(void(^)(NSArray *))success failure:(void(^)(NSError *))failure{
    
    [[AFAppAPIClient sharedClient] getPath:self.requestPath parameters:self.requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success && responseObject) {
            if ([responseObject[@"Data"] isKindOfClass:[NSArray class]]) {
                success([ProductInfoMode objectArrayWithKeyValuesArray:responseObject[@"Data"]]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
