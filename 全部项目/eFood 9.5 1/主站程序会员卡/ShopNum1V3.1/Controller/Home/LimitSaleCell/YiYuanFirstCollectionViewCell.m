//
//  YiYuanFirstCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/29.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "YiYuanFirstCollectionViewCell.h"
#import "LZCycleScrollView.h"
#import "YiYuanGouModel.h"

NSString *const kYiYuanFirstCellIdentifier = @"YiYuanFirstCollectionViewCell";

@interface YiYuanFirstCollectionViewCell ()<LZCycleScrollViewDatasource,LZCycleScrollViewDelegate>

@property (nonatomic,strong) LZCycleScrollView *cycleView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;

@property (weak, nonatomic) IBOutlet UILabel *yiGouLabel;
@property (weak, nonatomic) IBOutlet UILabel *allGouLabel;
@property (weak, nonatomic) IBOutlet UIImageView *amountImageView;


@property (weak, nonatomic) IBOutlet UILabel *yiGouRenLabel;
@property (weak, nonatomic) IBOutlet UILabel *allGouRenLabel;

@property (weak, nonatomic) IBOutlet UILabel *winNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *winPeopleLabel;

@property (strong, nonatomic) YiYuanGouModel *model;

@end

@implementation YiYuanFirstCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateViewWithModel:(YiYuanGouModel *)model {
    self.model = model;
    if (self.isCollect) {
        [self.collectButton setImage:[UIImage imageNamed:@"detail_collect02"] forState:UIControlStateNormal];
        self.collectLabel.text = @"已收藏";
        [self.collectLabel setTextColor:[UIColor colorWithRed:0.914 green:0.163 blue:0.185 alpha:1.000]];
    } else {
        [self.collectButton setImage:[UIImage imageNamed:@"detail_collect"] forState:UIControlStateNormal];
        self.collectLabel.text = @"收藏";
    }
    
    if (model.LuckyCode.length > 0) {
        // 相等则表示开奖
        self.yiGouLabel.hidden = YES;
        self.allGouLabel.hidden = YES;
        self.amountImageView.hidden = YES;
        self.yiGouRenLabel.hidden = YES;
        self.allGouRenLabel.hidden = YES;
        self.winNumberLabel.hidden = NO;
        self.winPeopleLabel.hidden = NO;
        
        self.bottomView.backgroundColor = [UIColor colorWithRed:0.999 green:0.946 blue:0.917 alpha:1.000];
        
        // 中奖号码
        NSString *winNumber = model.LuckyCode;
        NSString *winText = [NSString stringWithFormat:@"本期中奖号码：%@", winNumber];

        NSMutableAttributedString *showAttributeStr = [[NSMutableAttributedString alloc] initWithString:winText];
        [showAttributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:[winText rangeOfString:winNumber]];
        
        self.winNumberLabel.attributedText = showAttributeStr;
        // 中奖人信息
        self.winPeopleLabel.text = [NSString stringWithFormat:@"中奖人信息：%@",model.LuckyMen];
        
    } else {
        self.yiGouLabel.text = [NSString stringWithFormat:@"%d", model.RestrictCount.integerValue - model.ResidueNumber.integerValue];
        self.allGouLabel.text = model.RestrictCount.stringValue;
        self.yiGouRenLabel.text = [NSString stringWithFormat:@"已购人次：%d", model.RestrictCount.integerValue - model.ResidueNumber.integerValue];
        self.allGouRenLabel.text = [NSString stringWithFormat:@"所需人次：%@", model.RestrictCount.stringValue];
    }
    
    self.nameLabel.text = model.Name;
    [self.cycleView removeFromSuperview];
    self.cycleView = [self createCycleView];
    [self addSubview:self.cycleView];
    [self.cycleView reloadData];
}



// 收藏
- (IBAction)collect:(id)sender {
    if (!self.isCollect) {
        if ([self.delegate respondsToSelector:@selector(didSelectCollect)]) {
            [self.delegate didSelectCollect];
        }
    }
}

- (LZCycleScrollView *) createCycleView {
    
    CGRect frame = self.topView.bounds;
    frame.size.width = CGRectGetWidth(self.frame);
    
    LZCycleScrollView *cycle = [[LZCycleScrollView alloc]initWithFrame:frame];
    cycle.datasource = self;
    cycle.delegate = self;
    return cycle;
}

- (void) beginScorll {
    if (self.model.OriginalImgeStrs.count <= 1) {
        [self.cycleView endAutoScroll];
    } else {
        [self.cycleView endAutoScroll];
        [self.cycleView beginAutoScroll];
    }
}
- (void) endScorll {
    [self.cycleView endAutoScroll];
}


#pragma mark - cycleview代理
- (NSInteger) CycleScrollViewnumberOfPages{
    return self.model.OriginalImgeStrs.count;
}

- (UIView*) CycleScrollViewpageAtIndex:(NSInteger)index{
    
    CGRect frame = self.topView.bounds;
    frame.size.width = CGRectGetWidth(self.frame);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:frame];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView setImageWithURL:[NSURL URLWithString:self.model.OriginalImgeStrs[index%self.model.OriginalImgeStrs.count]] placeholderImage:[UIImage imageNamed:@"nopic"]];
//    NSLog(@"Image : %@", NSStringFromCGRect(frame));
    return imageView;
}


@end
