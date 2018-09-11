//
//  InfoViewController.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-2.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController<UITextViewDelegate>
{
    UIButton *_closeButton;
    
    UILabel *_titleLabel;
    UITextView *_info;
    
    NSInteger _tag;
}

@property (nonatomic, assign) id delegate;

- (id)initWithSceneTag:(NSInteger)tag;


@end
