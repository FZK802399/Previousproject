//
//  ImageInfo.m
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/8.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "ImageInfo.h"
#import "UIUtils.h"
#import "Header.h"

#define MARGIN_WIDTH 20
#define Image_Width ([UIUtils getWindowWidth]-MARGIN_WIDTH*2)

@implementation ImageInfo

- (id)initWithImage:(UIImage *)image andText:(NSString *)text
{
    self = [super init];
    if (self) {
        self.image = image;
        self.text = text;
        self.imageHeight = image.size.height/image.size.width*Image_Width;
        self.textHeight = [self getTextHeight];
        self.imageAndTextHeight = _imageHeight+_textHeight;
    }
    return self;
}

//获取text的高度
- (CGFloat)getTextHeight
{
    if ([UIUtils isBlankString:_text]) {
        return 40;
    } else {
        UITextView *textView = [[UITextView alloc] init];
        [textView setFont:[UIFont systemFontOfSize:18]];
        [textView setScrollEnabled:NO];
        [textView setText:_text];
        
        //计算出text的高度
        int textHeight=0;
        if (isIos7System) {
            CGFloat fixedWidth = Image_Width;
            CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
            textHeight = newSize.height;
        } else {
            textHeight = textView.contentSize.height;
        }
        return textHeight;
    }
}

@end
