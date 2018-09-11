//
//  GetXiangshiQiang.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/25.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "GetXiangshiQiang.h"

@interface GetXiangshiQiang()
@property (assign, nonatomic) NSInteger pageIndex;
@property (assign, nonatomic) NSInteger pageSize;
@end
@implementation GetXiangshiQiang
- (instancetype) initWithPageIndex:(NSInteger)index count:(NSInteger)count{
    if (self = [super init]) {
        self.pageIndex  = index;
        self.pageSize   = count;
    }
    return self;
}
- (NSString *) requestPath  {
    return @"api/panicbuyinglist/";
}
- (NSDictionary*) requestParameters{
    return @{
             @"AppSign"  : self.appsign,
             @"pageIndex": @(self.pageIndex),
             @"pageSize" : @(self.pageSize)
             };
}
- (void) startWtihCallBackSuccess:(void(^)(NSArray *DATA))success failure:(void(^)(NSError *error))failure{
    [[AFAppAPIClient sharedClient] getPath:self.requestPath parameters:self.requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success && responseObject) {
            if([responseObject[@"Data"] isKindOfClass:[NSArray class]]){
                 success([XianShiQiangMode objectArrayWithKeyValuesArray:responseObject[@"Data"]]);
            }else{
                 success(@[]);
            }
           
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
///api/panicbuyinglist/?pageIndex=1&pageSize=20&AppSign=095cb1439affb255992fbff273eba56c