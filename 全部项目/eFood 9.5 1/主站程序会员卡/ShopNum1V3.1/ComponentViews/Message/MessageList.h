//
//  MessageList.h
//  Shop
//
//  Created by Ocean Zhang on 5/8/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "EGORefreshView.h"
#import "MessageModelMy.h"

@protocol MessageListDelegate <NSObject>

@optional
- (void)selectedMessage:(MessageModelMy *)model;

@end

@interface MessageList : EGORefreshView

@property (nonatomic, assign) id<MessageListDelegate> delegate;

@property (nonatomic, strong) UIViewController *parentVc;

@property (nonatomic, strong) AppConfig *appConfig;

- (void)refreshList;

@end
