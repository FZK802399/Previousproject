//
//  RefundGoodView.m
//  ShopNum1V3.1
//
//  Created by yons on 15/12/1.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "RefundGoodView.h"

@implementation RefundGoodView

-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, -1, LZScreenWidth, 11)];
        line.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:229.0/255.0 blue:229.0/255.0 alpha:1];
        [self addSubview:line];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 19, LZScreenWidth, 21)];
        label.textColor = FONT_BLACK;
        label.text = @"退货原因";
        [self addSubview:label];
        
        _reasonTable = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame)+8, LZScreenWidth, 288) style:UITableViewStylePlain];
        _reasonTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _reasonTable.delegate = delegate;
        _reasonTable.dataSource = delegate;
        _reasonTable.tag = 2;
        [self addSubview:_reasonTable];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
