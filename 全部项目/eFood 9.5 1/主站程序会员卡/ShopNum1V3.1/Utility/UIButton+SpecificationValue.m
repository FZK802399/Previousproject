//
//  UIButton+SpecificationValue.m
//  Shop
//
//  Created by Ocean Zhang on 4/13/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "UIButton+SpecificationValue.h"
#import <objc/runtime.h>

@implementation UIButton (SpecificationValue)

static char UIB_SpecificationValue_KEY;

@dynamic SpecificationValue;

- (void)setSpecificationValue:(NSObject *)SpecificationValue
{
    objc_setAssociatedObject(self, &UIB_SpecificationValue_KEY, SpecificationValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)SpecificationValue
{
    return (NSString*)objc_getAssociatedObject(self, &UIB_SpecificationValue_KEY);
}

@end
