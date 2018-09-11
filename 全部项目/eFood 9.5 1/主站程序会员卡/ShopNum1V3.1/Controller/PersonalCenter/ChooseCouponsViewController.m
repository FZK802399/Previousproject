//
//  ChooseCouponsViewController.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/16.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "ChooseCouponsViewController.h"
#import "UseDetailsViewController.h"
#import "ChooseCanCouponsViewController.h"
#import "NoMakeCouponsViewController.h"
#import "UIView+Frame.h"
#import "LZButton.h"
#import "DetailCouponsTableViewController.h"

NSString * const LZTitleNotification;
@interface ChooseCouponsViewController ()<UIScrollViewDelegate,ChooseCanVCDelegate>

//下划线
@property (nonatomic,weak) UIView *underline;
//被点击的按钮
@property (nonatomic,weak) UIButton *clickedButton;
//标题栏
@property (nonatomic,weak) UIView *titlesView;
//用来存放两个子控制器view的ScrollView
@property (nonatomic,weak) UIScrollView *scrollView;

@property (nonatomic,assign)NSInteger num;
@property (nonatomic,assign)NSInteger numb;

@end

@implementation ChooseCouponsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的优惠券";
    
    [self setupScrollView];
    [self setupTitlesView];
    [self setupChilds];
   
    NSLog(@"%@",self.postArray);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
}


-(void)setupChilds
{//新增
    ChooseCanCouponsViewController *chooseCanVC = [[ChooseCanCouponsViewController alloc]init];
    chooseCanVC.shopArray = [NSMutableArray arrayWithArray:self.postArray];
    chooseCanVC.shoopMoney=self.postShoopMoney;
    chooseCanVC.aDelegate = self;
    [self addChildViewController:chooseCanVC];
    
    NoMakeCouponsViewController *NoMakeCVC=[[NoMakeCouponsViewController alloc] init];
    NoMakeCVC.shoopMoney=self.postShoopMoney;
    NoMakeCVC.shopArray=[NSMutableArray arrayWithArray:self.postArray];
    [self addChildViewController:NoMakeCVC];
    
    // 内容大小
    self.scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.scrollView.bounds.size.width, 0);
    // scrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    // 默认添加第0个子控制器view
    [self addChildVcViewIntoScrollView:0];
}


//新增
#pragma mark- ====================delegate====================

- (void)setChooseCanViewControllerDataInfo:(NSDictionary *)dataInfo andDisCount:(NSString *)disCount{
    
    NSLog(@"------------------dataInfo--------");
    if (self.couponsDelegate && [self.couponsDelegate respondsToSelector:@selector(setChooseCouponsViewControllerDataInfo:andDiscount:)]) {
        [self.couponsDelegate setChooseCouponsViewControllerDataInfo:dataInfo andDiscount:disCount];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    //设置分页
    scrollView.pagingEnabled = YES;
    
    scrollView.delegate = self;
    //水平滚动条
    scrollView.showsHorizontalScrollIndicator = NO;
    //垂直滚动条
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

//标题栏
- (void)setupTitlesView
{
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
    titlesView.frame = CGRectMake(0, 64, LZScreenWidth, 45);
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    // 标题按钮
    [self setupTitleButtons];
    
    // 下划线
    [self setupUnderline];
}

- (void)setupTitleButtons
{
    // 文字
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _num = [[defaults objectForKey:@"num"]integerValue];
    NSLog(@"可用优惠券的个数%ld",_num);
    _numb = [[defaults objectForKey:@"numb"]integerValue];
    
    NSArray *titles = @[[NSString stringWithFormat:@"可使用优惠券(%lu)",_num],[NSString stringWithFormat:@"不可使用优惠券(%lu)",_numb]];

    NSUInteger count = titles.count;
    
    // 标题的宽高
    CGFloat titleW = self.titlesView.LZ_width / count;
    CGFloat titleH = self.titlesView.LZ_height;
    
    for (NSUInteger i = 0; i < count; i++) {
        // 创建添加
        LZButton *titleButton = [LZButton buttonWithType:UIButtonTypeCustom];
        titleButton.tag = i;
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.titlesView addSubview:titleButton];
        
        // frame
        CGFloat titleX = titleW * i;
        titleButton.frame = CGRectMake(titleX, 0, titleW, titleH);
        
        [titleButton setTitle:titles[i] forState:UIControlStateNormal];
    }
}

- (void)setupUnderline
{
    // 第一个按钮
    LZButton *firstTitleButton = self.titlesView.subviews.firstObject;
    
    // 下划线
    UIView *underline = [[UIView alloc] init];
    underline.backgroundColor = [UIColor colorWithRed:61/255.0 green:163/255.0 blue:171/255.0 alpha:1.000];
    underline.LZ_height = 2;
    underline.LZ_y = self.titlesView.LZ_height - underline.LZ_height;
    [self.titlesView addSubview:underline];
    self.underline = underline;
    
    // 改变按钮状态
    firstTitleButton.selected = YES;
    self.clickedButton = firstTitleButton;
    
    [firstTitleButton.titleLabel sizeToFit];
    
    underline.LZ_width = firstTitleButton.titleLabel.LZ_width + 60;
    // 下划线中心点x
    underline.LZ_centerX = firstTitleButton.center.x;
}
#pragma mark - 监听
- (void)game
{
    
}
//监听标题按钮点击
- (void)titleClick:(LZButton *)titleButton
{
    // 监听重复点击
    if (self.clickedButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LZTitleNotification object:nil];
    }
    
    // 改变按钮状态
    self.clickedButton.selected = NO;
    titleButton.selected = YES;
    self.clickedButton = titleButton;
    
    // 按钮的索引
    NSInteger index = titleButton.tag;
    
    // 移动下划线
    [UIView animateWithDuration:0.25 animations:^{
        
        self.underline.LZ_width = titleButton.titleLabel.LZ_width + 60;
        
        // 中心点x
        self.underline.LZ_centerX = titleButton.LZ_centerX;
        
        CGPoint offset = self.scrollView.contentOffset;
        
        offset.x = index * self.scrollView.LZ_width;
        
        self.scrollView.contentOffset = offset;
        
    } completion:^(BOOL finished) {
        
        // 添加对应的子控制器view到scrollView上面
        [self addChildVcViewIntoScrollView:index];
    }];
}


#pragma mark - <UIScrollViewDelegate>
//scrollView停止滚动的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x / scrollView.LZ_width;
    // 点击对应的按钮
    LZButton *titleButton = self.titlesView.subviews[index];
    [self titleClick:titleButton];
}

#pragma mark - 其他
//添加第index个子控制器view到scrollView中
- (void)addChildVcViewIntoScrollView:(NSInteger)index
{
    // 添加对应的子控制器view到scrollView上面
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果这个子控制器view已经显示在上面, 就直接返回
    if (childVc.view.superview) return;
    
    [self.scrollView addSubview:childVc.view];
    
    // 子控制器view的frame
    childVc.view.LZ_x = index * self.scrollView.LZ_width;
    childVc.view.LZ_y = 0;
    childVc.view.LZ_width = self.scrollView.LZ_width;
    childVc.view.LZ_height = self.scrollView.LZ_height;
}


-(void)UseDetails
{
    //    UseDetailsViewController *userderail = [[UseDetailsViewController alloc]init];
    DetailCouponsTableViewController *userderail = [[DetailCouponsTableViewController alloc]init];
    [self.navigationController pushViewController:userderail animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
