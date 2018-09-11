//
//  ActivityBtnsCell.m
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "ActivityBtnsCell.h"
#import "ProductInfoMode.h"
#import "FloorProductModel.h"
#import "UIImageView+AFNetworking.h"
NSString *const kActivityBtnsCell = @"ActivityBtnsCell";

@interface ActivityBtnsCell ()
@property (nonatomic,strong) NSMutableArray *btns;
@property (weak, nonatomic) IBOutlet UIImageView *left0;
@property (weak, nonatomic) IBOutlet UIImageView *right1;
@property (weak, nonatomic) IBOutlet UIImageView *right2;
@end

@implementation ActivityBtnsCell
- (NSMutableArray *) btns   {
    if (!_btns) {
        _btns = [NSMutableArray arrayWithObjects:self.left0,self.right1,self.right2, nil];
    }
    return _btns;
}
- (instancetype) initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kActivityBtnsCell owner:nil options:nil].firstObject;
    return self;
}



- (void) setDatas:(NSArray *)datas {
    _datas = datas;
    if (!datas.count) return ;
    [datas enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImageView *btn = self.btns[idx];
        if ([obj isKindOfClass:[NSString class]]) {
            btn.image = [UIImage imageNamed:obj];
        } else if([obj isKindOfClass:[ProductInfoMode class]]){// 拿到数据填
            ProductInfoMode *mode = obj;
            [btn setImageWithURL:[NSURL URLWithString:mode.OriginalImge] placeholderImage:[UIImage imageNamed:@"nopic"]];
        } else if ([obj isKindOfClass:[FloorProductModel class]]) {
            FloorProductModel *model = obj;
            [btn setImageWithURL:model.OriginalImgeURL placeholderImage:[UIImage imageNamed:@"nopic"]];
        }
    }];

 
    
}
- (IBAction)click:(UITapGestureRecognizer *)sender {
    if ([self.delegate respondsToSelector:@selector(activityBtnsCell:didClickAtIndex:)]) {
        [self.delegate activityBtnsCell:self didClickAtIndex:sender.view.tag-100];
    }
}

@end
