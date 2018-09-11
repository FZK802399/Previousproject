//
//  FloorProductModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/23.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "FloorProductModel.h"

@implementation FloorProductModel

- (NSURL *)OriginalImgeURL {
    NSURL *imageURL = nil;
    
    if (![_OriginalImge hasPrefix:@"http://"]) {
        if (_OriginalImge.length > 0) {
            imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, _OriginalImge]];
        }
    } else {
        imageURL = [NSURL URLWithString:_OriginalImge];
    }
    return imageURL;
}


@end
