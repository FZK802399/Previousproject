//
//  UIButton+SpecificationName.m
//  Shop
//
//  Created by Ocean Zhang on 4/13/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "UIButton+SpecificationName.h"
#import <objc/runtime.h>

@implementation UIButton (SpecificationName)

static char UIB_SpecificationName_KEY;

@dynamic SpecificationName;

- (void)setSpecificationName:(NSObject *)SpecificationName
{
    objc_setAssociatedObject(self, &UIB_SpecificationName_KEY, SpecificationName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)SpecificationName
{
    return (NSString*)objc_getAssociatedObject(self, &UIB_SpecificationName_KEY);
}
@end
