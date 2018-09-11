//
//  ActivityBtnsCell.h
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kActivityBtnsCell;
@class ActivityBtnsCell;
@protocol ActivityBtnsCellDelegate <NSObject>
@optional
- (void) activityBtnsCell:(ActivityBtnsCell*)cell didClickAtIndex:(NSInteger)index;

@end
@interface ActivityBtnsCell : UICollectionViewCell
@property (weak  , nonatomic) id<ActivityBtnsCellDelegate> delegate;
@property (strong, nonatomic) NSArray *datas;
@end
