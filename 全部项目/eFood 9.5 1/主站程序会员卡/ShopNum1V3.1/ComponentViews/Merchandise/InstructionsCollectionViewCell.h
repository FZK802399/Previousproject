//
//  Instructions CollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/16.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kInstructionsCollectionViewCellIdentifier;

@interface InstructionsCollectionViewCell : UICollectionViewCell

- (void)updateViewWithInstructionsString:(NSString *)instructions;
+ (CGSize)cellSizeWithInstructions:(NSString *)instructions;

@end
