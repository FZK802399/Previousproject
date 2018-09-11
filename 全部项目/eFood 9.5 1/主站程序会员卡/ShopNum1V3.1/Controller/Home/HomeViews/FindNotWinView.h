//
//  FindNotWinView.h
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/9.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FindNotWinViewDelegate <NSObject>

@optional
- (void)didSelectComfirm;
@end

@interface FindNotWinView : UIView

@property (weak, nonatomic) id<FindNotWinViewDelegate> delegate;

@end
