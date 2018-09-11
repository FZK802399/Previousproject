//
//  SwitchBottomView.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/19.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>

//SwitchBottomView的代理方法
@protocol SBVDelegate <NSObject>

- (void)sbvGuideButtonPress;
- (void)sbvCategoryButtonPress;
- (void)sbvWaterFlowButtonPress;

@end

@interface SwitchBottomView : UIView

@property (nonatomic, assign) id delegate;

@end
