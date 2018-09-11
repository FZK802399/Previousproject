//
//  MessageModelMy.m
//  Shop
//
//  Created by Ocean Zhang on 4/17/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MessageModelMy.h"
#import "AFAppAPIClient.h"
#import "AppConfig.h"

@implementation MessageModelMy

@synthesize Guid = _Guid;
@synthesize Title = _Title;
@synthesize Type = _Type;
@synthesize Content = _Content;
@synthesize SendTime = _SendTime;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _Guid = [attributes objectForKey:@"Guid"];
        _Title = [attributes objectForKey:@"Title"];
        _Type = [[attributes objectForKey:@"IsRead"] intValue];
        _Content = [attributes objectForKey:@"Content"];
        _SendTime = [attributes objectForKey:@"CreateTime"];
    }
    return self;
}

+ (void)getMessageListWithParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebmembermessagelistPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *response = [JSON objectForKey:@"Data"];
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            MessageModelMy *model = [[MessageModelMy alloc] initWithAttributes:dict];
            [list addObject:model];
        }
        
        if(block){
            block(list, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil, error);
        }
    }];
}

+ (void)deleteMessageWithParameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebmembermessagedeletePath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSInteger result = [[JSON objectForKey:@"return"] intValue];
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(-1, error);
        }
    }];
}

+ (void)setReadMessageWithParameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebmembermessageReadPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSInteger result = [[JSON objectForKey:@"return"] intValue];
        
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(-1, error);
        }
    }];
}

@end
