//
//  PostTypeModel.h
//  Shop
//
//  Created by Ocean Zhang on 4/16/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostTypeModel : NSObject

@property (nonatomic, assign) NSInteger PostTypeID;

@property (nonatomic, strong) NSString *PostTypeName;

@property (nonatomic, assign) CGFloat PostTypeValue;

@end
