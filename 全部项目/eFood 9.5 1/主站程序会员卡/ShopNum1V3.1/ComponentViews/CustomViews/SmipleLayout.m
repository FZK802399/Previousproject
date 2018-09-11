//
//  SmipleLayout.m
//  WanJiangHui
//
//  Created by Right on 15/11/19.
//  Copyright © 2015年 Right. All rights reserved.
//

#import "SmipleLayout.h"
@interface SmipleLayout()
@property (weak  , nonatomic) id<SmipleLayoutDelegate> delegate;
@end
@implementation SmipleLayout
- (void) prepareLayout
{
    [super prepareLayout];
    
    self.delegate = (id <SmipleLayoutDelegate> )self.collectionView.delegate;
}
//-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    //从第二个循环到最后一个
//    NSMutableArray* attributes = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
//    
//    for(int i = 1; i < [attributes count]; ++i) {
//        //当前attributes
//        UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes[i];
//        //上一个attributes
//        UICollectionViewLayoutAttributes *prevLayoutAttributes = attributes[i - 1];
////        NSLog(@"%@----%@",NSStringFromCGRect(prevLayoutAttributes.frame),NSStringFromCGRect(currentLayoutAttributes.frame));
//    
//        //我们想设置的最大间距，可根据需要改
//        CGFloat maximumSpacing = .0;
//        
//        if ([self.delegate respondsToSelector:@selector(maxmumInteritemSpacingForSection:)]) {
//            maximumSpacing = [self.delegate maxmumInteritemSpacingForSection:currentLayoutAttributes.indexPath.section];
//        }
//        
//        //前一个cell的最右边
//        CGFloat oldorigin = CGRectGetMaxX(prevLayoutAttributes.frame);
//        NSInteger origin = (NSInteger)oldorigin;
//        if(origin + maximumSpacing + currentLayoutAttributes.frame.size.width < self.collectionViewContentSize.width) {
//            CGRect frame = currentLayoutAttributes.frame;
//            frame.origin.x = origin + maximumSpacing;
//            frame.size.width += oldorigin-origin;
//            currentLayoutAttributes.frame = frame;
//        }
//        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
//        //不加这个判断的后果是，UICollectionView只显示一行，原因是下面所有cell的x值都被加到第一行最后一个元素的后面了
//    }
//    return attributes;
//}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    //从第二个循环到最后一个
    NSArray* attributes = [super layoutAttributesForElementsInRect:rect];
    
    [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL *stop) {
        //我们想设置的最大间距，可根据需要改
        CGFloat maximumSpacing = 0;
        NSInteger count = LZScreenWidth/obj.frame.size.width;
        if ([self.delegate respondsToSelector:@selector(maxmumInteritemSpacingForSection:)]) {
            maximumSpacing = [self.delegate maxmumInteritemSpacingForSection:obj.indexPath.section];
        }
        CGFloat width = (LZScreenWidth - (count-1)*maximumSpacing)/count;
        CGRect frame = obj.frame;
        frame.origin.x = (width + maximumSpacing)*(idx%count);
        frame.size.width = width;
        obj.frame = frame;
    }];
    
    
    return attributes;
}
@end
