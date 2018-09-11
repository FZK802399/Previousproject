//
//  TitleHeaderView.h
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kTitleHeaderView;
@class TitleHeaderView;
@protocol TitleHeaderViewDelegate <NSObject>

@optional
- (void) titleHeaderViewDidTouch:(TitleHeaderView*)headerView;

@end
@interface TitleHeaderView : UICollectionReusableView
@property (weak  , nonatomic) id<TitleHeaderViewDelegate> delegate;


- (void)updateHeaderViewWithModel:(id )model;

@end
