//  AFAppAPIClient.m
//  Shop
//
//  Created by Ocean Zhang on 3/23/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "AFAppAPIClient.h"
#import "AFJSONRequestOperation.h"


//static NSString * const nRqiangAPIBaseUrlbeta = @"http://fxv86.groupfly.cn";
//static NSString * const nRqiangAPIBaseUrl1 = @"http://fxiosv81.groupfly.cn";
//static NSString * const nRqiangAPIBaseUrlTest =@"http://fxandroidv81.groupfly.cn";
//static NSString * const nRqiangAPIBaseUrl2 = @"http://ceshiweixin.nrqiang.com";
  static NSString * const nRqiangAPIBaseUrl3 = @"http://www.kinguv.com/";

@implementation AFAppAPIClient

+ (AFAppAPIClient *)sharedClient {
    static AFAppAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedClient = [[AFAppAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWebAppBaseUrl]];
    });
    
    return _sharedClient;
}

///http://fxmhv811.groupfly.cn
+ (AFAppAPIClient *)sharedClient2{
    static AFAppAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedClient = [[AFAppAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWebMainBaseUrl]];
    });
    
    return _sharedClient;
}

+ (AFAppAPIClient *)sharedClient3{
    static AFAppAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _sharedClient = [[AFAppAPIClient alloc] initWithBaseURL:[NSURL URLWithString:nRqiangAPIBaseUrl3]];
    });
    //http://senghongapp.efood7.com/api/addCards.action/？cardNum=2&amount=500&status=0
    return _sharedClient;
}


- (id)initWithBaseURL:(NSURL *)url{
    self = [super initWithBaseURL:url];
    if(!self){
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    return self;
}

@end
