//
//  CommentDetail.h
//  Shop
//
//  Created by Ocean Zhang on 4/12/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentDetailModel : NSObject

@property (nonatomic, readonly) NSString *guid;

@property (nonatomic, readonly) NSString *ProductGuid;

@property (nonatomic, readonly) NSString *comment;

@property (nonatomic, readonly) NSDate *commentTime;

@property (nonatomic, readonly) NSString *commentTimeStr;

@property (nonatomic, readonly) NSString *memberLoginID;

@property (nonatomic, readonly) NSInteger rating;

@property (nonatomic, readonly) NSString *commenttitle;

- (id)initWithAttribute:(NSDictionary *)attribute;

//0全部 1好评 2中评  3差评
+ (void)getMerchandiseCommentListByParameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *commentList, NSError *error))block;

+ (void)addMerchandiseCommentListByParameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result, NSError *error))block;




@end
