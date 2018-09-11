//
//  AddressModel.m
//  Shop
//
//  Created by Ocean Zhang on 4/4/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "AddressModel.h"
#import "AFAppAPIClient.h"
#import "AppConfig.h"

@implementation AddressModel

@synthesize guid = _guid;
@synthesize name = _name;
@synthesize email = _email;
@synthesize address = _address;
@synthesize Province = _Province;
@synthesize  City = _City;
@synthesize  Area = _Area;
@synthesize postalcode = _postalcode;
@synthesize tel = _tel;
@synthesize mobile = _mobile;
@synthesize isDefault = _isDefault;
@synthesize createTime = _createTime;
@synthesize createTimeStr = _createTimeStr;
@synthesize addressCode = _addressCode;
@synthesize MemberI=_MemberI;
- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _guid = [attributes objectForKey:@"Guid"];
        _name = [attributes objectForKey:@"NAME"];
        _email = [attributes objectForKey:@"Email"] == [NSNull null] ? @"" : [attributes objectForKey:@"Email"];
        _address = [attributes objectForKey:@"Address"];
        
        _Province = [attributes objectForKey:@"Province"];
        _City = [attributes objectForKey:@"City"];
        _Area = [attributes objectForKey:@"Area"];
        _postalcode = [attributes objectForKey:@"Postalcode"];
        
        _tel = [attributes objectForKey:@"Tel"];
        _mobile = [attributes objectForKey:@"Mobile"];
        _isDefault = [[attributes objectForKey:@"IsDefault"] boolValue];
        _createTimeStr = [attributes objectForKey:@"CreateTime"];
        _addressCode = [attributes objectForKey:@"Code"];
        _IdCardFront = [attributes objectForKey:@"IdCardFront"] == [NSNull null] ? @"" : [attributes objectForKey:@"IdCardFront"];
        _IdCardVerso = [attributes objectForKey:@"IdCardVerso"] == [NSNull null] ? @"" : [attributes objectForKey:@"IdCardVerso"];
        
        _IDCard = [attributes objectForKey:@"IDCard"] == [NSNull null] ? @"" : [attributes objectForKey:@"IDCard"];
    }
    return self;
}

+ (void)addAddressWithParameters:(NSDictionary *)parameters andlbock:(void (^)(NSInteger, NSError *))block{
    
//    NSError *testError;
//    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
//    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",testStr);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebAddAddressPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        //        BOOL isSucceed = NO;
        //        if(result == 201){
        //            isSucceed = YES;
        //        }
        if(block){
            block(result, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block(NO, error);
        }
    }];
}

+ (void)getLoginUserAddressListByParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{

    [[AFAppAPIClient sharedClient] getPath:kWebGetAddressListPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *response = [JSON objectForKey:@"Data"];
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            AddressModel *address = [[AddressModel alloc] initWithAttributes:dict];
            [list addObject:address];
        }
        
        if(block){
            block(list,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}

+ (void)deleteAddressWithParameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebDeleteAddressPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        if(block){
            block(result, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(NO,error);
        }
    }];
}

+(void)editAddressWithParameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
//    NSLog(@"%@", parameters);
//    NSError *testError;
//    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
//    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",testStr);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebEditAddressPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        if(block){
            block(result, nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block(NO,error);
        }
    }];
}

@end
