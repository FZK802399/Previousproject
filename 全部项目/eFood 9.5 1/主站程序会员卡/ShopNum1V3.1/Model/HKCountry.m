//
//  HKCountry.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/6/6.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "HKCountry.h"

@implementation HKCountry
-(instancetype)initWithDict:(NSDictionary *)Dict
{
    self = [super init];
    if (self) {
        _ID = [Dict objectForKey:@"ID"];
        _Code = [Dict objectForKey:@"Code"];
        _country = [Dict objectForKey:@"country"];
        _FristCode = [Dict objectForKey:@"FristCode"];
      
    }
    return self;
}

+ (void)getCountryListWithBlock:(void(^)(NSArray<HKCountry *> * arr,NSError * error))block
{
    [[AFAppAPIClient sharedClient]getPath:@"api/mobilecodegetbyfristcode/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"mobilecode"] isKindOfClass:[NSArray class]]) {
            NSArray<HKCountry *> * dataArr = [responseObject objectForKey:@"mobilecode"];
            NSMutableArray<HKCountry *> * arr = [NSMutableArray array];
            for (NSDictionary * dict in dataArr) {
                HKCountry * model = [[HKCountry alloc] initWithDict:dict];
                [arr addObject:model];
            }
//            NSArray<HKCountry *> *arr2 = [arr sortedArrayUsingComparator:^NSComparisonResult(HKCountry*  _Nonnull obj1, HKCountry*  _Nonnull obj2) {
//                NSComparisonResult result = [obj1.FristCode compare:obj2.FristCode];
//                return result;
//            }];
            if (block) {
                block([NSArray arrayWithArray:arr],nil);
            }
        }
        else
        {
            if (block) {
                block(nil,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(nil,error);
        }
    }];
}


//- (NSComparisonResult)compareCountry:(HKCountry *)country
//{
//    NSComparisonResult result = [self.FristCode compare:country.FristCode];
//    return result;
//}
@end
