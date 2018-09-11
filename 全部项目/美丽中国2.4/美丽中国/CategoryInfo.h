//
//  CategoryInfo.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryInfo : NSObject

@property (nonatomic, strong) NSString *categoryName;
@property (nonatomic, strong) NSString *categoryId;

- (id)initWithDictionay:(NSDictionary *)dictionary;

@end
