//
//  UIButton+SpecificationID.m
//  Shop
//
//  Created by Ocean Zhang on 4/13/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "UIButton+SpecificationID.h"
#import <objc/runtime.h>

@implementation UIButton (SpecificationID)

static char UIB_SpecificationID_KEY;

@dynamic SpecificationID;

- (void)setSpecificationID:(NSObject *)SpecificationID
{
    objc_setAssociatedObject(self, &UIB_SpecificationID_KEY, SpecificationID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)SpecificationID
{
    return (NSString*)objc_getAssociatedObject(self, &UIB_SpecificationID_KEY);
}


@end
