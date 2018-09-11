//
//  DZYShowImageView.m
//  ShopNum1V3.1
//
//  Created by mini on 16/5/3.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "DZYShowImageView.h"
#import "SDWebImageManager.h"
@interface DZYShowImageView ()<UIScrollViewDelegate>
@property (nonatomic,weak)UIImageView * imgView;
@property (nonatomic,weak)UIScrollView * scrollView;
@end

@implementation DZYShowImageView

-(instancetype)initWithFrame:(CGRect)frame url:(NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        _url = url;
        [self bastcStep];
    }
    return self;
}

-(void)bastcStep
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    UIActivityIndicatorView * hud = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self addSubview:hud];
    hud.center = self.center;
    [hud startAnimating];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:self.url]
                          options:0
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             // progression tracking code
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            [hud stopAnimating];
                            if (image) {
                                [self setViewWithImage:image];
                            }
                        }];
}

- (void)setViewWithImage:(UIImage *)image
{
    CGSize size = image.size;
    CGFloat x = size.height/size.width;
    CGFloat width = DZYWIDTH;
    CGFloat height = width * x;
    
    UIScrollView * scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self addSubview:scrollView];
    scrollView.center = self.center;
    scrollView.contentSize = CGSizeMake(width, height);
    scrollView.contentInset = UIEdgeInsetsMake((DZYHEIGHT - height)/2.0, 0, 0, 0);
    scrollView.delegate = self;
    scrollView.maximumZoomScale = 2.5f;
    scrollView.minimumZoomScale = 1.0;
    self.scrollView = scrollView;
    
    UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    imgView.image = image;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    [scrollView addSubview:imgView];
    self.imgView = imgView;
    
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    [self addGestureRecognizer:tap];
}
 
-(void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    self.imgView.alpha = 0;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        self.imgView.alpha = 1;
    }];
}

-(void)dismiss
{
    [self removeFromSuperview];
}

#pragma mark - scrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imgView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGSize size = self.imgView.frame.size;
    self.scrollView.contentInset = UIEdgeInsetsMake((DZYHEIGHT - size.height)/2.0, 0, 0, 0);
}

-(void)dealloc
{
    
}


@end
