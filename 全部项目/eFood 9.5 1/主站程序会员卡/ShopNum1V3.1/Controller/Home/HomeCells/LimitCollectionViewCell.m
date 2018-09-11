//
//  LimitCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/22.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "LimitCollectionViewCell.h"
#import "SaleProductModel.h"

NSString *const kLimitCollectionViewCell = @"LimitCollectionViewCell";

@interface LimitCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;
@property (weak, nonatomic) IBOutlet UILabel *Name;

@property (strong, nonatomic) SaleProductModel *model;

@end

@implementation LimitCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kLimitCollectionViewCell owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    self.buyButton.layer.cornerRadius = 3.0f;
}

+ (CGSize)XianShiCellSize {
    CGFloat width = SCREEN_WIDTH / 3.0f - 0.6f;
//    CGFloat height = width * 1.88f;
    CGFloat height = width + 105;
    return CGSizeMake(width, height);
}

- (void)updateViewWithModel:(SaleProductModel *)model {
    // 更新
    self.model = model;
    [self.imageView setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.priceLabel.text = [NSString stringWithFormat:@"AU$%.2f", model.PanicBuyingPrice.doubleValue];
    self.discountLabel.text = [NSString stringWithFormat:@"%.1f折", model.PanicBuyingPrice.doubleValue / model.ShopPrice.doubleValue * 10];
    self.rmbLabel.text = [NSString stringWithFormat:@"约¥%.2f",model.MarketPrice.doubleValue];
    self.Name.text = model.Name;
}

- (void)updateTimeLabel {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
    NSDate *endDate = [formatter dateFromString:self.model.EndTime];
    NSDate *startDate = [formatter dateFromString:self.model.StartTime];
    
    NSDateComponents  *component = [calendar components:unit fromDate:[NSDate date] toDate:endDate options:0];
    NSDateComponents  *component1 = [calendar components:unit fromDate:[NSDate date] toDate:startDate options:0];
    
    
    self.endTimeLabel.textColor = [UIColor colorWithWhite:0.236 alpha:1.000];
    self.endTimeLabel.layer.borderColor = [UIColor clearColor].CGColor;
    self.userInteractionEnabled = YES;
    self.buyButton.backgroundColor = MAIN_ORANGE;
    
    if (self.model.SaleNumber.integerValue >= self.model.RestrictCount.integerValue) {
        self.endTimeLabel.text = @"抢完了";
        self.userInteractionEnabled = NO;
        self.buyButton.backgroundColor = [UIColor lightGrayColor];
        return;
    }
    
    if (component1.day>0 || component1.hour>0 || component1.minute>0 || component1.second>0) {
        NSInteger totalMin = component1.day * 24 *60 + component1.hour * 60 + component1.minute;
        self.endTimeLabel.text = [NSString stringWithFormat:@"距离开始%zd分钟", totalMin];//@"活动尚未开始";
        self.userInteractionEnabled = NO;
        self.buyButton.backgroundColor = [UIColor lightGrayColor];
    } else {
        if(component.day<=0 && component.hour<=0 && component.minute<=0 && component.second<=0){
            self.endTimeLabel.text = @"活动已结束";
            self.userInteractionEnabled = NO;
            self.buyButton.backgroundColor = [UIColor lightGrayColor];
        }else{
            if (self.saleType == SaleTypeXianLiangGou) {
                self.endTimeLabel.text = [NSString stringWithFormat:@" 限 %@ 件 ", self.model.RestrictCount.stringValue];
                self.endTimeLabel.textColor = MAIN_GREEN;
                self.endTimeLabel.layer.borderColor = MAIN_GREEN.CGColor;
                self.endTimeLabel.layer.borderWidth = 1;
                self.endTimeLabel.layer.cornerRadius = 2.0f;
            } else if (self.saleType == SaleTypeXianShiGou) {
                self.endTimeLabel.text = [NSString stringWithFormat:@"%02ld天%02ld小时%02ld分%02ld秒",component.day,component.hour,component.minute,component.second];//倒计时显示
                self.userInteractionEnabled = YES;
                self.buyButton.backgroundColor = MAIN_ORANGE;
            }
        }
    }
}

@end
