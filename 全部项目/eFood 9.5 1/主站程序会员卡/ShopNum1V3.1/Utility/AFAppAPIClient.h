//
//  AFAppAPIClient.h
//  Shop
//
//  Created by Ocean Zhang on 3/23/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPClient.h"

@interface AFAppAPIClient : AFHTTPClient

+ (AFAppAPIClient *)sharedClient;

+ (AFAppAPIClient *)sharedClient2;

+ (AFAppAPIClient *)sharedClient3;

@end
