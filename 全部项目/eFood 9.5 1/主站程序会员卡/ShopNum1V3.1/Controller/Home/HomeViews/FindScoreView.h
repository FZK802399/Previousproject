//
//  FindScoreView.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/4.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FindScoreView;

@protocol FindScoreViewDelegate <NSObject>

@required
- (void)didSelectComfirm;

@end

@interface FindScoreView : UIView

@property (weak, nonatomic) id<FindScoreViewDelegate> delegate;

- (void)updateViewWithScore:(NSString *)score;

@end
