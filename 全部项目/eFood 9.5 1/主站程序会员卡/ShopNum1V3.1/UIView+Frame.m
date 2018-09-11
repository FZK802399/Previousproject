

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setLZ_centerX:(CGFloat)LZ_centerX
{
    CGPoint center = self.center;
    center.x = LZ_centerX;
    self.center = center;
}

- (CGFloat)LZ_centerX
{
    return self.center.x;
}

- (void)setLZ_centerY:(CGFloat)LZ_centerY
{
    CGPoint center = self.center;
    center.y = LZ_centerY;
    self.center = center;
}

- (CGFloat)LZ_centerY
{
    return self.center.y;
}


- (void)setLZ_width:(CGFloat)LZ_width{
    CGRect frame = self.frame;
    frame.size.width = LZ_width;
    self.frame = frame;
}

- (CGFloat)LZ_width
{
    return self.frame.size.width;
}

- (void)setLZ_height:(CGFloat)LZ_height
{
    CGRect frame = self.frame;
    frame.size.height = LZ_height;
    self.frame = frame;
}
- (CGFloat)LZ_height
{
     return self.frame.size.height;
}

- (void)setLZ_x:(CGFloat)LZ_x
{
    CGRect frame = self.frame;
    frame.origin.x = LZ_x;
    self.frame = frame;
}

- (CGFloat)LZ_x
{
    return self.frame.origin.x;
}

- (void)setLZ_y:(CGFloat)LZ_y
{
    CGRect frame = self.frame;
    frame.origin.y = LZ_y;
    self.frame = frame;
}

- (CGFloat)LZ_y
{
    return self.frame.origin.y;
}

@end
