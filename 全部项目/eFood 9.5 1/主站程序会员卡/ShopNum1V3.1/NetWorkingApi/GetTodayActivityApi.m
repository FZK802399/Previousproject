//
//  SearchProductsApi.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/24.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "GetTodayActivityApi.h"
@interface GetTodayActivityApi()
//@property (copy  , nonatomic) NSString *BrandGuid; 文档中没这个参数
/// isAsc True：升序  false：降序
@property (nonatomic,assign) NSString *isASC;
/// 传-1是搜全局
@property (strong, nonatomic) NSString *ProductCategoryID;
/// 查询方式 ModifyTime:时间(综合就用它)    Price：价格  SaleNumber：销售量
@property (nonatomic,copy)  NSString *sorts;
/// 第几页
@property (nonatomic,assign) NSInteger pageIndex;
/// 多少数
@property (nonatomic,assign) NSInteger pageCount;
@end
@implementation GetTodayActivityApi
///
- (instancetype) init{
    return [self initWithSorts:@"ModifyTime" isASC:@"false" ProductCategoryID:@"1" pageIndex:1 pageCount:3];
}
- (instancetype) initWithSorts:(NSString*)sorts isASC:(NSString*)isASC ProductCategoryID:(NSString*)ID  pageIndex:(NSInteger)index pageCount:(NSInteger)count{
    if (self = [super init]) {
        self.isASC = isASC;
        self.ProductCategoryID = ID;
        self.sorts = sorts;
        self.pageIndex = index;
        self.pageCount = count;
        
    }
    return self;
}

- (NSString*) requestPath {
    return @"api/product2/list";
}
- (NSDictionary*) requestParameters {
    return @{
             @"AppSign"   : self.appsign,
             @"isASC"     : self.isASC,
             @"ProductCategoryID" : self.ProductCategoryID,
             @"sorts"     : self.sorts,
             @"pageIndex" : @(self.pageIndex),
             @"pageCount" : @(self.pageCount)
             };
}
/// 返回装有ProductInfoMode 的数组
- (void) startWithCallBack:(void(^)(NSArray* DATA))success failuer:(void(^)(NSError *error))failure{
    NSLog(@"%@",self.requestPath);
    [[AFAppAPIClient sharedClient] getPath:self.requestPath parameters:self.requestParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success && responseObject) {
            if ([responseObject objectForKey:@"Data"]) {
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


//http://fxv811app.groupfly.cn/api/product2/list?pageIndex=1&pageCount=3&sorts=ModifyTime&isASC=false&AppSign=9991fa8f663fe072a54ba7cce6341e4b&ProductCategoryID=1
/*fxv811app.groupfly.cn/api/product2/search/
?AppSign=cf4288006b9d1b36bf86ead24ee32430
&BrandGuid=
&isASC=true
&name=
&pageCount=10
&pageIndex=1
&ProductCategoryID=2
&sorts=ModifyTime

*/

