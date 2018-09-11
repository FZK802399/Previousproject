//
//  CommentDetail.m
//  Shop
//
//  Created by Ocean Zhang on 4/12/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "CommentDetailModel.h"
#import "AFAppAPIClient.h"

@implementation CommentDetailModel

@synthesize guid = _guid;
@synthesize ProductGuid = _ProductGuid;
@synthesize comment = _comment;
@synthesize commentTime = _commentTime;
@synthesize commentTimeStr = _commentTimeStr;
@synthesize memberLoginID = _memberLoginID;
@synthesize commenttitle = _commenttitle;
@synthesize rating = _rating;

- (id)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if(self){
        _guid = [attribute objectForKey:@"Guid"];
        _rating = [attribute objectForKey:@"Rank"] == [NSNull null] ? 0 : [[attribute objectForKey:@"Rank"] integerValue];
        _comment = [attribute objectForKey:@"Content"];
        _commentTimeStr = [attribute objectForKey:@"SendTime"];
        _memberLoginID = [attribute objectForKey:@"MemLoginID"];
        _commenttitle = [attribute objectForKey:@"Title"];
        _ProductGuid = [attribute objectForKey:@"ProductGuid"];
    }
    
    return self;
}

+(void)getMerchandiseCommentListByParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebProductcommentlistPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSArray *response = [JSON objectForKey:@"Data"];
        NSMutableArray *commentList = [[NSMutableArray alloc] initWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            CommentDetailModel *detail = [[CommentDetailModel alloc] initWithAttribute:dict];
            [commentList addObject:detail];
        }
        
        if(block){
            block(commentList,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,error);
        }
    }];
}

+(void)addMerchandiseCommentListByParameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
//    NSError *testError;
//    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
//    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",testStr);
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebAddProductcommentPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
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

@end
