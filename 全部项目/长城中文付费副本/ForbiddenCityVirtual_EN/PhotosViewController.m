//
//  PhotosViewController.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-2.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "PhotosViewController.h"

#define kPhotosc_X 125.0f
#define kPhotosc_Y 125.0f
#define kPhotosc_W 776.0f
#define kPhotosc_H 506.0f

#define kPageControll_W 300.0f
#define kPageControll_H 30.0f
#define kPageControll_X (kLCDW / 2 - kPageControll_W / 2)
#define kPageControll_Y (kLCDW - 20 - 90)

@interface PhotosViewController ()
{
    UIImageView *_bigImageView;
}

@end

@implementation PhotosViewController

@synthesize imageInfos = _imageInfos;

- (void)dealloc
{
    Release(_closeButton);
    Release(_pageControl);
    Release(_photosScroll);
    Release(_infoText);
    Release(_infoLabel);
    Release(_infoView);
    Release(_textButton);
    Release(_imageInfos);
    Release(_infoBackView);
    Release(_bigImageView);
    
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"image_bg.jpg"]]];
    [self loadImageInfos];
    _wasTextViewShow = NO;
    
    _closeButton = [[UIButton alloc] initWithFrame:CGRectMake(kLCDH - 61, 0, 61, 56)];
    [_closeButton setImage:[UIImage imageNamed:@"phclose.png"] forState:UIControlStateNormal];
    [_closeButton setImage:[UIImage imageNamed:@"phclose_h.png"] forState:UIControlStateHighlighted];
    [_closeButton addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_closeButton];
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLCDH / 2 - kPhotosc_W / 2, 64, kPhotosc_W, 55)];
    [_infoLabel setBackgroundColor:[UIColor clearColor]];
    [_infoLabel setText:[[_imageInfos objectAtIndex:0] objectForKey:@"title"]];
    [_infoLabel setFont:[UIFont fontWithName:kFont_Name size:24.0f]];
    [_infoLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_infoLabel];
    
    
    _photosScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(kPhotosc_X, kPhotosc_Y, kPhotosc_W, kPhotosc_H)];
    for (NSDictionary *dic in _imageInfos)
    {
        int identifier = [[dic objectForKey:@"id"] intValue];
//        NSLog(@"id = %d", identifier);
        NSString *imageName = [NSString stringWithFormat:@"%d", identifier];
        NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:path]];
        [imageView setFrame:CGRectMake(776 * (identifier - 1), 0, 776, 506)];
        [_photosScroll addSubview:imageView];
        [imageView release];
        imageView = nil;
    }
    [_photosScroll setContentSize:CGSizeMake(776 * 6, 506)];
    _photosScroll.showsHorizontalScrollIndicator = NO;
    _photosScroll.showsVerticalScrollIndicator = NO;
    [_photosScroll setPagingEnabled:YES];
    [_photosScroll setDelegate: self];
    [_photosScroll setBounces:NO];
    [_photosScroll setContentOffset:CGPointMake(_currentPage * 776, 0)];
    [self.view addSubview:_photosScroll];
    
    _infoBackView = [[UIView alloc] initWithFrame:CGRectMake(kPhotosc_X, kPhotosc_Y + kPhotosc_H - 30, kPhotosc_W, 30)];
    [_infoBackView setBackgroundColor:[UIColor clearColor]];
    [_infoBackView setClipsToBounds:YES];
    [self.view addSubview:_infoBackView];
    _infoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kPhotosc_W, 30)];
    [_infoView setBackgroundColor:[UIColor blackColor]];
    [_infoView setAlpha:0.75f];
    [_infoBackView addSubview:_infoView];
    
    _infoText = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, 700, 140)];
    [_infoText setBackgroundColor:[UIColor whiteColor]];
    [_infoView addSubview:_infoText];
    [_infoText setFont:[UIFont fontWithName:kFont_Name size:20.0f]];
    _infoText.showsVerticalScrollIndicator = NO;
    _infoText.showsHorizontalScrollIndicator = NO;
    _infoText.textColor = [UIColor whiteColor];
    _infoText.backgroundColor = [UIColor clearColor];
    [_infoText setDelegate:self];
    [self updateImageTitleAndInfo];
    _textButton = [[UIButton alloc] initWithFrame:CGRectMake(kPhotosc_X + kPhotosc_W - 55, kPhotosc_Y + kPhotosc_H - 55, 49, 49)];
    [_textButton setImage:[UIImage imageNamed:@"textbtn.png"] forState:UIControlStateNormal];
    [_textButton addTarget:self action:@selector(showOrHiddenTextView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_textButton];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(kPageControll_X, kPageControll_Y, kPageControll_W, kPageControll_H)];
    [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [_pageControl setNumberOfPages:6];
    _pageControl.currentPage = _currentPage;
    [_pageControl setUserInteractionEnabled:NO];
    [self.view addSubview:_pageControl];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [tap setDelegate:self];
    [self.view addGestureRecognizer:tap];
    [tap release];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeScrollerImage)];
    [imageTap setDelegate:self];
    [_photosScroll addGestureRecognizer:imageTap];
    [imageTap release];
    
    if (![USER_DEFAULTS boolForKey:kWas_First_Launch_Photo])
    {
        UIButton *guide = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kLCDH, kLCDW)];
        [guide setImage:[UIImage imageNamed:@"photohelp.png"] forState:UIControlStateNormal];
        [guide addTarget:self action:@selector(hiddenHelpView:) forControlEvents:UIControlEventAllEvents];
        [self.view addSubview:guide];
        [guide release];
    }

}

- (void)hiddenHelpView:(UIButton *)sender
{
    [sender setHidden:YES];
    [sender removeFromSuperview];
    [USER_DEFAULTS setBool:YES forKey:kWas_First_Launch_Photo];
    [USER_DEFAULTS synchronize];
}



- (void)tapped:(UIGestureRecognizer *)tap
{
    [self dismissSelf];
}

- (void)changeScrollerImage
{
    _bigImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kPhotosc_X, kPhotosc_Y, kPhotosc_W, kPhotosc_H)];
    NSString *imageName = [NSString stringWithFormat:@"gugong%d.JPG", _pageControl.currentPage + 1];
    [_bigImageView setImage:[UIImage imageNamed:imageName]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBigImage)];
    [_bigImageView setUserInteractionEnabled:YES];
    [_bigImageView addGestureRecognizer:tap];
    [tap release];
    [self.view addSubview:_bigImageView];
    [_bigImageView release];
    
    [UIView animateWithDuration:0.35f animations:^{
        [_bigImageView setFrame:CGRectMake(0, 0, kLCDH, kLCDW - 20)];
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)updateImageTitleAndInfo
{
    _currentLanguage = [[USER_DEFAULTS objectForKey:kCurrent_Language] integerValue];
    int page = _photosScroll.contentOffset.x / 776;
    NSDictionary *dic = [_imageInfos objectAtIndex:page];
    if (_currentLanguage == English)
    {
        _infoText.text = [dic objectForKey:@"info_en"];
        _infoLabel.text = [dic objectForKey:@"title_en"];
    }
    else
    {
        _infoText.text = [dic objectForKey:@"info_cn"];
        _infoLabel.text = [dic objectForKey:@"title_cn"];
    }
}

- (void)scrollToPageWithPageNumber:(NSInteger)number
{
    _currentPage = number;
}

- (void)hiddenBigImage
{
    [UIView animateWithDuration:0.35f animations:^{
        [_bigImageView setFrame:CGRectMake(kPhotosc_X, kPhotosc_Y, kPhotosc_W, kPhotosc_H)];
    } completion:^(BOOL finished) {
        [_bigImageView removeFromSuperview];
        _bigImageView = nil;
    }];
}

- (void)loadImageInfos
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"imageInfos" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    _imageInfos = [[NSArray alloc] initWithArray:array];
    [data release];
    data = nil;
}

- (void)dismissSelf
{
    [_delegate performSelector:@selector(setPhotoPage:) withObject:[NSNumber numberWithInt:_pageControl.currentPage]];
    [_delegate performSelector:@selector(viewRelease)];
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
}

- (void)showOrHiddenTextView:(id)sender
{
    if (_wasTextViewShow)
    {        
        [UIView animateWithDuration:0.5f animations:^{
            [_infoBackView setFrame:CGRectMake(kPhotosc_X, kPhotosc_Y + kPhotosc_H - 30, kPhotosc_W, 30)];
            [_infoView setFrame:CGRectMake(0, 0, kPhotosc_W, 30)];
            _textButton.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
        } completion:^(BOOL finished) {
            nil;
        }];
    }
    else
    {
        [UIView animateWithDuration:0.5f animations:^{
            [_infoBackView setFrame:CGRectMake(kPhotosc_X, kPhotosc_Y + kPhotosc_H - 170, kPhotosc_W, 170)];
            [_infoView setFrame:CGRectMake(0, 0, kPhotosc_W, 170)];
            _textButton.layer.transform = CATransform3DMakeRotation(M_PI / 4, 0, 0, 1);
        } completion:^(BOOL finished) {
            nil;
        }];
    }
    _wasTextViewShow = !_wasTextViewShow;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / 776;    
    [_pageControl setCurrentPage:page];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:NSClassFromString(@"UITextView")])
    {
        return;
    }
    else
    {
        int page = scrollView.contentOffset.x / 776;        
        [_pageControl setCurrentPage:page];
        [self updateImageTitleAndInfo];
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
