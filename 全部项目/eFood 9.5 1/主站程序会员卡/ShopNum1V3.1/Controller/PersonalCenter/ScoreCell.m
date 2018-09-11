//
//  ScoreCell.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/25.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "ScoreCell.h"

@implementation ScoreCell

-(void)setModel:(DzyScoreModel *)model
{
    _model = model;
    self.title.text = model.Memo;
    self.time.text = model.Date;
    self.time.textColor = FONT_DARKGRAY;
    if (model.OperateType == 1||model.OperateType == 2 ||model.OperateType == 3) {
        //添加
        self.price.text = [NSString stringWithFormat:@"+%.0f",model.OperateScore];
        self.price.textColor = MYRED;
    }
    else
    {   //减少
        self.price.text = [NSString stringWithFormat:@"-%.0f",model.OperateScore];
        self.price.textColor = FONT_DARKGRAY;
    }
}

-(void)setAdvanceModel:(AdvancePaymentModel *)advanceModel
{
    _advanceModel = advanceModel;
    if (advanceModel.OperateType == 1||advanceModel.OperateType == 2 ||advanceModel.OperateType == 3){
        //添加
        self.price.text = [NSString stringWithFormat:@"+%.2f",advanceModel.OperateMoney];
        self.price.textColor = MYRED;
    }
    else
    {   //减少
        self.price.text = [NSString stringWithFormat:@"-%.2f",advanceModel.OperateMoney];
        self.price.textColor = FONT_DARKGRAY;
    }
    self.title.text = advanceModel.Memo;
    self.time.text = advanceModel.CreateTime;
    self.time.textColor = FONT_DARKGRAY;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
