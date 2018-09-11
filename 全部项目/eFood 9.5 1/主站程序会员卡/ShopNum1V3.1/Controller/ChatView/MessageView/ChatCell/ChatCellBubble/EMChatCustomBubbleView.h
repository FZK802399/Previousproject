//
//  EMChatCustomBubbleView.h
//  CustomerSystem-ios
//
//  Created by dhc on 15/3/30.
//  Copyright (c) 2015年 easemob. All rights reserved.
//

#import "EMChatBaseBubbleView.h"
///商品信息cell
@interface EMChatCustomBubbleView : EMChatBaseBubbleView
{
    UILabel *_topLabel;
    UILabel *_titleLabel;
    UILabel *_nameLabel;
    UIImageView *_cimageView;
    UILabel *_priceLabel;
}

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *cimageView;
@property (strong, nonatomic) UILabel *priceLabel;

@end
