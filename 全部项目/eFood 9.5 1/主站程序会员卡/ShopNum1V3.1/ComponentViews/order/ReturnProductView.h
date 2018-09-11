//
//  ReturnProductView.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReturnMerchandiseModel.h"

@interface ReturnProductView : UIView<QCheckBoxDelegate>

@property (strong, nonatomic) ReturnMerchandiseModel * currentProductModel;
@property (strong ,nonatomic) QCheckBox * isReturnBtn;
@property (strong ,nonatomic) UIImageView * IcoImage;
@property (strong ,nonatomic) UILabel * productName;
@property (strong ,nonatomic) UILabel * productPrice;
@property (strong ,nonatomic) TextStepperField * productNumber;

///选择数量
@property (nonatomic, assign) NSInteger selectCount;

-(void)creatProductDetailViewWithReturnMerchandiseModel:(ReturnMerchandiseModel *)detail;

@end
