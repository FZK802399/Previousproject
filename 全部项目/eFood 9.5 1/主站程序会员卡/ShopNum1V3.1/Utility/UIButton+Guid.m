//
//  UIButton+Guid.m
//  Shop
//
//  Created by Ocean Zhang on 3/23/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "UIButton+Guid.h"
#import <objc/runtime.h>

@implementation UIButton (Guid)

static char UIB_Guid_KEY;

@dynamic Guid;

- (void)setGuid:(NSObject *)Guid
{
    objc_setAssociatedObject(self, &UIB_Guid_KEY, Guid, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)Guid
{
    return (NSString*)objc_getAssociatedObject(self, &UIB_Guid_KEY);
}

@end
