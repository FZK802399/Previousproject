//
//  HomeCycleView.h
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kHomeCycleView;
@class HomeCycleView;
@protocol HomeCycleViewDelegate <NSObject>
@optional
- (void) HomeCycleViewDidClickIndex:(NSInteger) index;

@end

@interface HomeCycleView : UICollectionReusableView
@property (nonatomic,weak)  id<HomeCycleViewDelegate> delegate;
@property (nonatomic,strong) NSArray *images;

- (void) beginScorll;
- (void) endScorll;
@end
