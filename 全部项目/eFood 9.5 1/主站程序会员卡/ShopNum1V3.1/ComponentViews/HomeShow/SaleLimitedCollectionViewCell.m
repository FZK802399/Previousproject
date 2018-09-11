//
//  SaleLimitedCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-14.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "SaleLimitedCollectionViewCell.h"

@implementation SaleLimitedCollectionViewCell
{

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        CGFloat height = 100;
        CGFloat width = SCREEN_WIDTH;
        CGFloat originX = 10;
        CGFloat originY = 10;
        if (self.showImage == nil) {
            self.showImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, height-20, height-20)];
            [self.contentView addSubview:self.showImage];
        }
        
        // 50
        if (self.NameLabel == nil) {
            self.NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.showImage.frame) + 10, originY, width - CGRectGetWidth(self.showImage.frame) - 25, 40)];
            self.NameLabel.numberOfLines = 2;
            //            self.NameLabel.lineBreakMode = NSLineBreakByWordWrapping;
//            self.NameLabel.textAlignment = NSTextAlignmentCenter;
            self.NameLabel.textColor = [UIColor colorWithWhite:0.236 alpha:1.000];
            self.NameLabel.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.NameLabel];
        }
        // 15
        if (self.priceLabel == nil) {
            self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.NameLabel.frame), CGRectGetMaxY(self.NameLabel.frame), CGRectGetWidth(self.NameLabel.frame)/2.5, 20)];
//            self.priceLabel.textAlignment = NSTextAlignmentCenter;
            self.priceLabel.textColor = MAIN_ORANGE;
            self.priceLabel.font = [UIFont systemFontOfSize:14.0f];
            [self.contentView addSubview:self.priceLabel];            
        }
        
        if (self.rmbLabel == nil) {
            self.rmbLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame)+5, CGRectGetMaxY(self.NameLabel.frame), CGRectGetWidth(self.NameLabel.frame)/2.5, 20)];
            self.rmbLabel.textColor = FONT_LIGHTGRAY;
            self.rmbLabel.font = [UIFont systemFontOfSize:12.0f];
            [self.contentView addSubview:self.rmbLabel];
        }
        
        if (self.timeImage == nil) {
            self.timeImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.NameLabel.frame), CGRectGetMaxY(self.priceLabel.frame), 20, 20)];
            self.timeImage.contentMode = UIViewContentModeCenter;
            self.timeImage.image = [UIImage imageNamed:@"shengyu_clock"];
            [self.contentView addSubview:self.timeImage];
        }
        
        // 15
        if (self.TimeLabel == nil) {
            self.TimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.timeImage.frame), CGRectGetMaxY(self.priceLabel.frame), CGRectGetWidth(self.NameLabel.frame), 20)];
//            self.TimeLabel.textAlignment = NSTextAlignmentCenter;
            self.TimeLabel.textColor = [UIColor darkGrayColor];
//            self.TimeLabel.backgroundColor = [UIColor blackColor];
//            self.TimeLabel.alpha = 0.6;
            self.TimeLabel.font = [UIFont systemFontOfSize:12.0f];
            [self.contentView addSubview:self.TimeLabel];
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)awakeFromNib {
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.5;
}

-(void)creatSaleLimitedCollectionViewCellWithMerchandiseIntroModel:(SaleProductModel *)intro{
    
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [self.showImage setImageWithURL:intro.OriginalImgeURL placeholderImage:blankImg];
    self.priceLabel.text = [NSString stringWithFormat:@"AU$ %.2f", intro.PanicBuyingPrice.doubleValue];
    self.rmbLabel.text = [NSString stringWithFormat:@"约¥%.2f",intro.MarketPrice.doubleValue];
    self.NameLabel.text = intro.Name;
    
    // 如果还未开始
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *startTimeDate = [dateFormatter dateFromString:intro.StartTime];
    NSTimeInterval startTimeSinceNow = [startTimeDate timeIntervalSinceNow];
    
    if (intro.SaleNumber.integerValue >= intro.RestrictCount.integerValue) {
        self.TimeLabel.text = @"抢完了，下次早点来哟~";
        self.userInteractionEnabled = NO;
        return;
    }
    
    if (startTimeSinceNow > 0) {
        NSInteger *minNum = (NSInteger)(startTimeSinceNow / 1000 * 60);
        self.TimeLabel.text = @"活动尚未开始";
        self.userInteractionEnabled = NO;
    } else {
        NSString * showTime = [self getTimeDifferenceWithTimeInterval:round(intro.RemainingTime)];
        self.TimeLabel.text = showTime;
    }
}



-(NSString *)getTimeDifferenceWithTimeInterval:(NSInteger) remainingTime{
    NSString * timeStr;
    if (remainingTime <= 0) {
        timeStr = @"活动已结束";
        self.userInteractionEnabled = NO;
    } else {
        NSInteger dayNum = remainingTime / 86400;
        NSInteger hourNum = remainingTime % 86400 / 3600;
        NSInteger minuteNum = remainingTime % 3600 / 60;
        NSInteger secondNum = remainingTime % 60;
        timeStr = [NSString stringWithFormat:@"剩余时间:%d天%d小时%d分%d秒",dayNum, hourNum, minuteNum, secondNum];
        self.userInteractionEnabled = YES;
    }
    return timeStr;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
