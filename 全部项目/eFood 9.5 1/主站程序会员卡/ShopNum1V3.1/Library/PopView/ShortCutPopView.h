//
//  ShortCutPopView.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-10.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShortCutPopViewDelegate;

@interface ShortCutPopView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic ,assign) id<ShortCutPopViewDelegate> delegate;

@property (nonatomic, strong) UITableView *PopoverListView;                 //主的选择列表视图

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) NSArray *numArray;

@property (nonatomic, retain) UIControl *controlForDismiss;                     //没有按钮的时候，才会使用这个

//展示界面
- (void)show;

//消失界面
- (void)dismiss;

@end

@protocol ShortCutPopViewDelegate <NSObject>

@optional
-(void)didSelectRowAtIndexPath:(NSInteger)indexRow;

@end
