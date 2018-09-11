//
//  MessageReceiveTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/6.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "MessageReceiveTableViewCell.h"

@interface MessageReceiveTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation MessageReceiveTableViewCell

- (void)awakeFromNib {
    
    self.iconImageView.layer.cornerRadius = CGRectGetWidth(self.iconImageView.frame) / 2.0f;
    self.iconImageView.clipsToBounds = YES;
    
}

- (void)updateViewWithMessage:(EMMessage *)msg {
    [super updateViewWithMessage:msg];
    
    id<IEMMessageBody> msgBody = msg.messageBodies.firstObject;
    NSString *txt = ((EMTextMessageBody *)msgBody).text;
    
    self.messageLabel.text = txt;

    self.userNameLabel.text = msg.from;
    self.iconImageView.image = [UIImage imageNamed:@"user_pre"];
    self.backImageView.image = [UIImage imageNamed:@"Message-recevie"];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
