//
//  ProductOneLineListCell.m
//  ShopNum1V3.1
//
//  Created by Right on 15/11/26.
//  Copyright © 2015年 WFS. All rights reserved.
//

#import "ProductOneLineListCell.h"
#import "ProductInfoMode.h"
#import "UIImageView+AFNetworking.h"
#import "XianShiQiangMode.h"
NSString  *kProductOneLineListCell = @"ProductOneLineListCell";
@interface ProductOneLineListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pricePaddingForBottom;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@property (weak, nonatomic) IBOutlet UILabel *qiangGouLabel;
@end
@implementation ProductOneLineListCell
- (instancetype) initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kProductOneLineListCell owner:nil options:nil].firstObject;
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void) setMode:(id)mode{
    _mode = mode;
    if ([mode isKindOfClass:[ProductInfoMode class]]) {
        ProductInfoMode *model = mode;
        self.qiangGouLabel.hidden = YES;
        //        setImageWithURL:intro.OriginalImge placeholderImage
        [self.iconView setImageWithURL:[NSURL URLWithString:model.OriginalImge] placeholderImage:[UIImage imageNamed:@"nopic"]];
        self.titleLabel.text = model.Name;
        self.priceLabel.text = [NSString stringWithFormat:@"AU$%.2f",model.ShopPrice.doubleValue];
        self.rmbLabel.text = [NSString stringWithFormat:@"约¥%.2f",model.MarketPrice.doubleValue];
    }
    if ([mode isKindOfClass:[XianShiQiangMode class]]) {
        XianShiQiangMode *model = mode;
        self.qiangGouLabel.hidden = NO;
        self.pricePaddingForBottom.constant = 30;

        [self.iconView setImageWithURL:[NSURL URLWithString:model.OriginalImge] placeholderImage:[UIImage imageNamed:@"nopic"]];
        self.titleLabel.text = model.Name;
        self.priceLabel.text = [NSString stringWithFormat:@"AU$%.2f",model.PanicBuyingPrice.doubleValue];
    }
}
- (void) updateTimeLabel{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit =  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"YYYY/MM/dd HH:mm:ss";
    XianShiQiangMode *mode = (XianShiQiangMode*)self.mode;
    NSDate *endDate = [formatter dateFromString:mode.EndTime];
    NSDateComponents  *component = [calendar components:unit fromDate:[NSDate date] toDate:endDate options:0];
    if(component.day==0 && component.hour==0 && component.minute==0 && component.second==0){
        self.qiangGouLabel.text = @"活动已结束";
    }else{
        self.qiangGouLabel.text = [NSString stringWithFormat:@"剩余时间:%ld天%ld小时%ld分%ld秒",component.day,component.hour,component.minute,component.second];//倒计时显示
    }
}

@end
