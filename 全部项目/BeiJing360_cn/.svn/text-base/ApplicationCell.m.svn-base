
//   
//  ApplicationCell.m
//  BeiJing360
//
//  Created by baobin on 11-6-13.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.

#import "ApplicationCell.h"

@implementation ApplicationCell

@synthesize icon, publisher, name;
/*
- (void)setUseDarkBackground:(BOOL)flag
{
    if (flag != useDarkBackground || !self.backgroundView)
    {
        useDarkBackground = flag;

        NSString *backgroundImagePath = [[NSBundle mainBundle] pathForResource:useDarkBackground ? @"DarkBackground" : @"LightBackground" ofType:@"png"];
        UIImage *backgroundImage = [[UIImage imageWithContentsOfFile:backgroundImagePath] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        self.backgroundView = [[[UIImageView alloc] initWithImage:backgroundImage] autorelease];
        self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.backgroundView.frame = self.bounds;
    }
}
*/
- (void)dealloc
{
    [icon release];
    [publisher release];
    [name release];
    
    [super dealloc];
}

@end
