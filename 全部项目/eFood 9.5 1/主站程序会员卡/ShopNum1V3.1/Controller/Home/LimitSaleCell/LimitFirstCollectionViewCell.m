//
//  LimitFirstCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/24.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "LimitFirstCollectionViewCell.h"
#import "SaleProductModel.h"
#import "LZCycleScrollView.h"

NSString *const kLimitFirstCellIdentifier = @"LimitFirstCollectionViewCell";

@interface LimitFirstCollectionViewCell ()<LZCycleScrollViewDatasource,LZCycleScrollViewDelegate>


@property (nonatomic,strong) LZCycleScrollView *cycleView;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel; // 售出

// 时间
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UILabel *collectLabel;


@property (weak, nonatomic) IBOutlet UILabel *saleInfoLabel; // 限时和限量文字显示

@property (weak, nonatomic) IBOutlet UILabel *shengYuCountLabel; //剩余件数
@property (weak, nonatomic) IBOutlet UIView *timeView; // 倒计时的View

@property (weak, nonatomic) IBOutlet UIView *shengYuTimeView; // 倒计时的View-限量详情用
@property (weak, nonatomic) IBOutlet UILabel *shengYuTimeLabel; // 限量剩余时间
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *width;
///剩余件数 （限时时使用）
@property (weak, nonatomic) IBOutlet UILabel *num;
///剩余件数 （四个字）
@property (weak, nonatomic) IBOutlet UILabel *numName;

@property (strong, nonatomic) SaleProductModel *model;


@end

@implementation LimitFirstCollectionViewCell

- (void)awakeFromNib {
    self.dayLabel.layer.cornerRadius = 2.0f;
    self.dayLabel.clipsToBounds = YES;
    self.hourLabel.layer.cornerRadius = 2.0f;
    self.hourLabel.clipsToBounds = YES;
    self.minuteLabel.layer.cornerRadius = 2.0f;
    self.minuteLabel.clipsToBounds = YES;
    self.secondLabel.layer.cornerRadius = 2.0f;
    self.secondLabel.clipsToBounds = YES;
}

- (void)updateViewWithModel:(SaleProductModel *)model {
    self.model = model;
    if (self.isCollect) {
        [self.collectButton setImage:[UIImage imageNamed:@"detail_collect02"] forState:UIControlStateNormal];
        self.collectLabel.text = @"已收藏";
        [self.collectLabel setTextColor:[UIColor colorWithRed:0.914 green:0.163 blue:0.185 alpha:1.000]];
    } else {
        [self.collectButton setImage:[UIImage imageNamed:@"detail_collect"] forState:UIControlStateNormal];
        self.collectLabel.text = @"收藏";
    }
    self.salePriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", model.PanicBuyingPrice.doubleValue];
    self.marketPriceLabel.text = [NSString stringWithFormat:@"约¥%.2f", model.MarketPrice.doubleValue];
    self.nameLabel.text = model.Name;
    self.soldLabel.text = [NSString stringWithFormat:@"已售出%@件", model.SaleNumber.stringValue];
    self.shengYuTimeView.hidden = NO;
    self.shengYuTimeLabel.text = [NSString stringWithFormat:@"每人限购:%ld件",model.IDRestrictCount.integerValue];
    if (self.saleType == SaleTypeXianShiGou) {
        self.width.constant = 150;
        self.num.text = [NSString stringWithFormat:@"%d", model.RestrictCount.integerValue - model.SaleNumber.integerValue];
        self.num.hidden = NO;
        self.numName.hidden = NO;
    } else if (self.saleType == SaleTypeXianLiangGou) {
        self.width.constant = 100;
        self.saleInfoLabel.text = @"剩余件数";
        self.shengYuCountLabel.text = [NSString stringWithFormat:@"%d", model.RestrictCount.integerValue - model.SaleNumber.integerValue];
        self.shengYuCountLabel.hidden = NO;
        self.timeView.hidden = YES;
//        // 如果时间结束
//        if (self.isEndTime) {
//            self.shengYuTimeLabel.text = @"来晚了,下次早点来吧~";
//        }
    }
    
    [self.cycleView removeFromSuperview];
    self.cycleView = [self createCycleView];
    [self.topView addSubview:self.cycleView];
    [self.cycleView reloadData];
}

- (void)updateTimeLabelWithComponent:(NSDateComponents *)component {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    int unit =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
//    formatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
//    NSDate *endDate = [formatter dateFromString:self.model.EndTime];
//    
//    NSDateComponents  *component = [calendar components:unit fromDate:[NSDate date] toDate:endDate options:0];
    
    if (self.saleType == SaleTypeXianShiGou) {
        if (self.isEndTime) {
            component.day = 0;
            component.hour = 0;
            component.minute = 0;
            component.second = 0;
        }
        self.dayLabel.text = [NSString stringWithFormat:@"%02d", component.day];
        self.hourLabel.text = [NSString stringWithFormat:@"%02d", component.hour];
        self.minuteLabel.text = [NSString stringWithFormat:@"%02d", component.minute];
        self.secondLabel.text = [NSString stringWithFormat:@"%02d", component.second];
    } else if (self.saleType == SaleTypeXianLiangGou) {        
//        if (self.isEndTime) {
//            self.shengYuTimeLabel.text = @"来晚了,下次早点来吧~";
//        } else {
//            self.shengYuTimeLabel.text = [NSString stringWithFormat:@"剩余时间:%02d天%02d小时%02d分%02d秒",component.day,component.hour,component.minute,component.second];//倒计时显示
//        }
    }
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

- (void)beginScorll {
    
    if (self.model.OriginalImgeStrs.count <= 1) {
        [self.cycleView endAutoScroll];
    } else {
        [self.cycleView endAutoScroll];
        [self.cycleView beginAutoScroll];
    }
}

- (void)endScorll {
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
    return imageView;
}

@end
