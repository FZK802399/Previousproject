//
//  MessageTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/6.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)heightWithMessage:(EMMessage *)msg {
    
    id<IEMMessageBody> msgBody = msg.messageBodies.firstObject;
    NSString *txt = ((EMTextMessageBody *)msgBody).text;
    
    CGFloat maxWidth = SCREEN_WIDTH - 105 - 38;
    CGRect rect = [txt boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]} context:nil];

    CGFloat heigth = CGRectGetHeight(rect);
    if (heigth < 32) {
        heigth = 60;
    } else {
        heigth += 60;
    }
    return heigth;
}

- (void)updateViewWithMessage:(EMMessage *)msg {}
@end
