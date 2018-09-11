//
//  GetCatgroyApi.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/23.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "SortModel.h"
#import "GetCatgroyApi.h"
@interface GetCatgroyApi()
@property (strong, nonatomic) NSNumber *code;
@end
@implementation GetCatgroyApi

- (instancetype) initWith:(NSNumber*)code{
    if (self = [super init]) {
        self.code = code;
    }
    return self;
}
- (NSString*) requestPath{
    return @"api/productcatagory/";
}

- (NSDictionary*) requestParameters{
    return @{
             @"AppSign" : self.appsign,
             @"id"      : self.code
             };
}
/// 返回装有CategoryMode的数组
- (void) startWithCallBack:(void(^)(NSArray*))success failuer:(void(^)(NSError *))failure {
    [[AFAppAPIClient sharedClient] getPath:self.requestPath parameters:self.requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success && responseObject) {
            if ([responseObject[@"Data"] isKindOfClass:[NSArray class]]) {
                NSMutableArray * dataArr = [NSMutableArray array];
                NSArray * arr = [responseObject objectForKey:@"Data"];
                for (NSDictionary * dict in arr) {
                    SortModel * model = [[SortModel alloc]initWithAttributes:dict];
                    [dataArr addObject:model];
                }
                success([NSArray arrayWithArray:dataArr]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
//http: //fxv811app.groupfly.cn/api/productcatagory/?AppSign=e96ab4d8dda0e825b028be86d57d3a83&id=92







