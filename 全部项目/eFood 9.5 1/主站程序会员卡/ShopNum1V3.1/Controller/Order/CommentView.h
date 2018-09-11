//
//  CommentView.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentView;

@protocol CommentDelegate <NSObject>

-(void)startClickWithStart:(UIButton *)start CommentView:(CommentView *)view;

@end

@interface CommentView : UIView
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIButton *one;
@property (weak, nonatomic) IBOutlet UIButton *two;
@property (weak, nonatomic) IBOutlet UIButton *three;
@property (weak, nonatomic) IBOutlet UIButton *four;
@property (weak, nonatomic) IBOutlet UIButton *five;

@property (nonatomic,strong)NSMutableArray * startArr;
@property (nonatomic,weak)id<CommentDelegate> delegate;

-(void)setArr;

@end
