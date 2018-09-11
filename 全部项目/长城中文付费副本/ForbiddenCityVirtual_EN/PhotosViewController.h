//
//  PhotosViewController.h
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-2.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosViewController : UIViewController<UIScrollViewDelegate, UITextViewDelegate, UIGestureRecognizerDelegate>
{
    UIPageControl *_pageControl;
    UIScrollView *_photosScroll;
    UITextView *_infoText;
    UIButton *_closeButton;
    UILabel *_infoLabel;
    UIView *_infoView;
    UIButton *_textButton;
    UIView *_infoBackView;
    
    NSInteger _currentPage;
    
    CurrentLanguage _currentLanguage;
    
    BOOL _wasTextViewShow;
}


@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSArray *imageInfos;

- (void)scrollToPageWithPageNumber:(NSInteger)number;

@end
