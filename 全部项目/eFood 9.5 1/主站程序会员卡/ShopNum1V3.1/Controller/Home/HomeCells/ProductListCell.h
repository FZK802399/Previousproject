//
//  ProductListCell.h
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kProductListCell;
@interface ProductListCell : UICollectionViewCell
@property (nonatomic,strong) id mode;
/// 商品列表 多少列 和间隙 算size
+ (CGSize) itemSizeForColumn:(NSInteger)column padding:(CGFloat)padding;
@end
