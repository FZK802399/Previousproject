//
//  RefundGoodView.h
//  ShopNum1V3.1
//
//  Created by yons on 15/12/1.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefundGoodView : UIView
//@property (weak, nonatomic) IBOutlet UITableView *reasonTable;
@property (nonatomic,strong)UITableView * reasonTable;

-(instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;
@end
