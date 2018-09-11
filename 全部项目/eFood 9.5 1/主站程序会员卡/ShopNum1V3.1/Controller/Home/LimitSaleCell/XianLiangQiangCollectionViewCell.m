//
//  XianLiangCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/12/29.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "XianLiangQiangCollectionViewCell.h"
#import "SaleProductModel.h"

@interface XianLiangQiangCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *limitInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *rmbLabel;

@property (weak, nonatomic) IBOutlet UILabel *goBuyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressConstraint;

@end

NSString *const kXianLiangQiangCellIdentifier = @"XianLiangQiangCollectionViewCell";

@implementation XianLiangQiangCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kXianLiangQiangCellIdentifier owner:nil options:nil].firstObject;
    return self;
}

- (void)awakeFromNib {
    self.goBuyLabel.layer.cornerRadius = 3.0f;
    self.goBuyLabel.clipsToBounds = YES;
}

- (void)updateViewWithModel:(SaleProductModel *)model {
    [self.imageView setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.nameLabel.text = model.Name;
    self.priceLabel.text = [NSString stringWithFormat:@"AU$%.2f", model.PanicBuyingPrice.doubleValue];
    self.rmbLabel.text = [NSString stringWithFormat:@"约¥%.2f",model.MarketPrice.doubleValue];
    self.limitInfoLabel.text = [NSString stringWithFormat:@"限 %@ 件，已抢 %@ 件", model.RestrictCount.stringValue, model.SaleNumber.stringValue];
    self.progressConstraint.constant = model.SaleNumber.doubleValue / model.RestrictCount.doubleValue *100;
    
    // 如果还未开始
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate *startTimeDate = [dateFormatter dateFromString:model.StartTime];
    NSTimeInterval startTimeSinceNow = [startTimeDate timeIntervalSinceNow];
    if (startTimeSinceNow > 0) {
        self.goBuyLabel.text = @"尚未开始";
        self.goBuyLabel.backgroundColor = [UIColor lightGrayColor];
        self.userInteractionEnabled = NO;
    } else {
        NSDate *endTimeDate = [dateFormatter dateFromString:model.EndTime];
        NSTimeInterval endTimeSinceNow = [endTimeDate timeIntervalSinceNow];
        if (endTimeSinceNow <= 0) {
            self.goBuyLabel.text = @"已结束";
            self.goBuyLabel.backgroundColor = [UIColor lightGrayColor];
            [self setUserInteractionEnabled:NO];
        } else {
            if (self.progressConstraint.constant == 100) {
                self.goBuyLabel.text = @"抢完了";
                self.goBuyLabel.backgroundColor = [UIColor lightGrayColor];
                [self setUserInteractionEnabled:NO];
            } else {
                self.goBuyLabel.text = @"马上抢购";
                self.goBuyLabel.backgroundColor = MAIN_ORANGE;
                [self setUserInteractionEnabled:YES];
            }
        }
    }
}


@end
