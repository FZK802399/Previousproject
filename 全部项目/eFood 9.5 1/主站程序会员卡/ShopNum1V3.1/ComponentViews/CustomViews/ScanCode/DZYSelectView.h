//
//  DZYSelectView.h
//  selectView
//
//  Created by yons on 15/12/14.
//  Copyright (c) 2015年 ShopNum1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DZYSelectView;
@protocol SelectDelegate <NSObject>

-(void)selectWithSelectView:(DZYSelectView *)selectView btn:(UIButton *)btn;

@end

@interface DZYSelectView : UIView
///按钮的名字
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,weak)id<SelectDelegate> delegate;
@property (nonatomic,strong)NSMutableArray * btnArr;

@property (nonatomic,assign)NSInteger firstClick;

-(instancetype)initWithFrame:(CGRect)frame dataSource:(NSMutableArray *)dataSource delegate:(id<SelectDelegate>)delegate normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectColor lineColor:(UIColor *)lineColor fontNum:(NSInteger )fontNum;
@end
