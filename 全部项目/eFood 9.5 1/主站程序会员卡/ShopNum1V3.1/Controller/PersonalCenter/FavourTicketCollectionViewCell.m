//
//  FavourTicketCollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/12.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "FavourTicketCollectionViewCell.h"
#import "FavourTicketModel.h"

NSString *const kFavourTicketCollectionViewCellIdentifier = @"FavourTicketCollectionViewCell";

@interface FavourTicketCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *amountLabel; // 金额
@property (weak, nonatomic) IBOutlet UILabel *limitAmountLabel; // 限制使用金额  满100用
@property (weak, nonatomic) IBOutlet UILabel *useDateLabel; // 使用期限
@end

@implementation FavourTicketCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateViewWithFavourTicketModel:(FavourTicketModel *)model {
    self.amountLabel.text = model.FaceValue.stringValue;
    self.limitAmountLabel.text = [NSString stringWithFormat:@"满%@元即可使用", model.MinimalCost.stringValue];
    self.useDateLabel.text = [NSString stringWithFormat:@"使用期限:%@ - %@", model.StartDate, model.EndDate];
}

@end
