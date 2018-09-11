//
//  MessageSendTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/6.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "MessageSendTableViewCell.h"

@interface MessageSendTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIView *messageView;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (strong, nonatomic) AppConfig *appConfig;

@end

@implementation MessageSendTableViewCell

- (void)awakeFromNib {
//    self.messageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Message-bubble"]];
    self.appConfig = [AppConfig sharedAppConfig];
    [self.appConfig loadConfig];
    
    self.iconImageView.layer.cornerRadius = CGRectGetWidth(self.iconImageView.frame) / 2.0f;
    self.iconImageView.clipsToBounds = YES;
    
    
    
}

- (void)updateViewWithMessage:(EMMessage *)msg {
    [super updateViewWithMessage:msg];
    id<IEMMessageBody> msgBody = msg.messageBodies.firstObject;
    NSString *txt = ((EMTextMessageBody *)msgBody).text;
    
    self.messageLabel.text = txt;
    
    self.userNameLabel.text = self.appConfig.loginName;
    
    [self.iconImageView setImageWithURL:[NSURL URLWithString:self.appConfig.userUrlStr] placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.backImageView.image = [UIImage imageNamed:@"Message-send"];

//    NSLog(@"Image : %@", self.appConfig.userUrlStr);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
