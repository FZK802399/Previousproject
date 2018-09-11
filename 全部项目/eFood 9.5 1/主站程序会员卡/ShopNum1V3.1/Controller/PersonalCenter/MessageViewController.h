//
//  MessageViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-9.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "MessageList.h"
///我的消息
@interface MessageViewController : WFSViewController <MessageListDelegate>

@property (strong, nonatomic) IBOutlet UIView *messageView;

@property (nonatomic, strong) MessageList *messageList;

+ (instancetype) create;
@end
