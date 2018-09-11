//
//  SmipleLayout.h
//  WanJiangHui
//
//  Created by Right on 15/11/19.
//  Copyright © 2015年 Right. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SmipleLayout;
@protocol SmipleLayoutDelegate <UICollectionViewDelegate>
@optional
- (CGFloat) maxmumInteritemSpacingForSection:(NSInteger)section;

@end
@interface SmipleLayout : UICollectionViewFlowLayout

@end
