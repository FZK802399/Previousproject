//
//  NavTitleView.m
//  ShopNum1V3.1
//
//  Created by 梁泽 on 15/11/24.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "NavTitleView.h"
@interface NavTitleView()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic,strong) UIButton *blurBtn;
@property (nonatomic,strong) UIVisualEffectView *blurView;
@end
///   系统版本号
#define kCurrentSystemVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
@implementation NavTitleView
static NavTitleView *shareInstance = nil;
+ (instancetype) getInstance {
    return shareInstance;
}
+ (instancetype) create {
    NavTitleView *titleView = [[NSBundle mainBundle]loadNibNamed:@"NavTitleView" owner:nil options:nil].firstObject;
    titleView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    shareInstance = titleView;
    return titleView;
}
- (void) awakeFromNib{
    [[[[ self.searchBar.subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    [self.searchBar setBackgroundColor :[ UIColor clearColor ]];
}

+ (void) showBlurEffectOnView:(UIView*)view; {
    if (kCurrentSystemVersion >= 8.0) {
        [view addSubview:[NavTitleView getInstance].blurView];
    }
    
}
+ (void) dismissBlure {
    [[NavTitleView getInstance].searchBar resignFirstResponder];
    if (kCurrentSystemVersion >= 8.0) {
        [[NavTitleView getInstance].blurView removeFromSuperview];
    }
    [NavTitleView getInstance].searchBar.text = @"";
}

- (void) clickBackground {
    [NavTitleView dismissBlure];
}

- (UIVisualEffectView *) blurView{
    if (!_blurView) {
        //  创建需要的毛玻璃特效类型
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃view 视图
        _blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //添加到要有毛玻璃特效的控件中
        _blurView.frame = [UIScreen mainScreen].bounds;
        
        UIButton *btn = [[UIButton alloc] initWithFrame:_blurView.bounds];
        [btn addTarget:self action:@selector(clickBackground) forControlEvents:UIControlEventTouchUpInside];
        [_blurView addSubview:btn];
        //设置模糊透明度
        _blurView.alpha = .92f;
    }
    return _blurView;
}

#pragma mark - 监听事件

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(navTitleView:searchText:)]) {
        [self.delegate navTitleView:self searchText:searchBar.text];
    }
    [NavTitleView dismissBlure];
}

// 扫一扫
- (IBAction)clickLeftBtn:(UIButton *)sender {
    [NavTitleView dismissBlure];
    if ([self.delegate respondsToSelector:@selector(navTitleViewDidClickLeftBtn:)]) {
        [self.delegate navTitleViewDidClickLeftBtn:self];
    }
}

// 搜索
- (IBAction)clcikRightBtn:(UIButton *)sender {
    [NavTitleView dismissBlure];
    if ([self.delegate respondsToSelector:@selector(navTitleViewDidClickRightBtn:)]) {
        [self.delegate navTitleViewDidClickRightBtn:self];
    }
}



@end
