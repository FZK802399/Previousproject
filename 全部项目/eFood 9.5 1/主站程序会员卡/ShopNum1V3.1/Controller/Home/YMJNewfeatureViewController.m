//
//  LZNewfeatureViewController.m
//  Shop
//
//  Created by 梁泽 on 15/6/9.
//  Copyright (c) 2015年 ocean. All rights reserved.
//
#import "YMJNewfeatureViewController.h"
#import "BaseViewController.h"
static const NSInteger LZNewfeatureImageCount = 3;
@interface YMJNewfeatureViewController () <UIScrollViewDelegate>
@property (nonatomic,weak)  UIPageControl *pageControl;
@end

@implementation YMJNewfeatureViewController

- (void)viewDidLoad {
    // 隐藏状态栏
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self setupScrollView];
    
    [self setupPageControl];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupScrollView {
    
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.frame = self.view.bounds;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    
    //2..添加图片：
    CGFloat imageW = scrollView.frame.size.width;
    CGFloat imageH = scrollView.frame.size.height;
    
    for (int index = 0; index<LZNewfeatureImageCount; index++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        // 设置图片
        NSString *name = [NSString stringWithFormat:@"app_normal_%d.png",index+1];
        
        imageView.image = [UIImage imageNamed:name];
        
        // 设置frame
        CGFloat imageX = index * imageW;
        imageView.frame = CGRectMake(imageX, 0, imageW, imageH);
        
        [scrollView addSubview:imageView];
        
        // 在最后一个图片上面添加按钮
        if (index == LZNewfeatureImageCount - 1) {
            UIButton *btnStart = [UIButton buttonWithType:UIButtonTypeCustom];
            btnStart.frame = CGRectMake(index * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width , [UIScreen mainScreen].bounds.size.height);
            [btnStart addTarget:self action:@selector(btnStartTouch:) forControlEvents:UIControlEventTouchUpInside];
            [scrollView addSubview:btnStart];
        }
    }
    
    //3....设置滚动的内容尺寸
    scrollView.contentSize = CGSizeMake(imageW * LZNewfeatureImageCount, 0);
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.bounces = NO;
}
/**
 *  添加pageControl
 */
- (void)setupPageControl
{
    // 1.添加
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = LZNewfeatureImageCount;
    CGFloat centerX = self.view.frame.size.width * 0.5;
    CGFloat centerY = self.view.frame.size.height - 30;
    pageControl.center = CGPointMake(centerX, centerY);
    pageControl.bounds = CGRectMake(0, 0, 100, 30);
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    // 2.设置圆点的颜色
    pageControl.currentPageIndicatorTintColor = RGB(253, 98, 42);
    pageControl.pageIndicatorTintColor = RGB(189, 189, 189);
}

- (void)btnStartTouch:(UIButton*)sender{
    // 显示状态栏
    [UIApplication sharedApplication].statusBarHidden = NO;
    // 切换窗口的根控制器
    self.view.window.rootViewController = [[UIStoryboard storyboardWithName:@"StoryboardIOS7" bundle:nil] instantiateInitialViewController];
}

/**
 *  只要UIScrollView滚动了,就会调用
 *
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1.取出水平方向上滚动的距离
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 2.求出页码
    double pageDouble = offsetX / scrollView.frame.size.width;
    int pageInt = (int)(pageDouble + 0.5);
    self.pageControl.currentPage = pageInt;
}

@end
