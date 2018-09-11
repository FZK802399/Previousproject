//
//  ProductOneLineListCell.h
//  ShopNum1V3.1
//
//  Created by Right on 15/11/26.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString  *kProductOneLineListCell;
@interface ProductOneLineListCell : UICollectionViewCell
@property (strong, nonatomic) id mode;
- (void) beginTimerFire:(NSString*)timeStr;
- (void) updateTimeLabel;
@end
