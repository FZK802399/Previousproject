//
//  PostProgressView.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostProgressView : UIView

- (void)showInView:(UIView *)view;//展示postProgressView
- (void)removeView;//移除postProgressView
- (void)updateWithValue:(float)progressValue;//更新postProgressView进度

@end
