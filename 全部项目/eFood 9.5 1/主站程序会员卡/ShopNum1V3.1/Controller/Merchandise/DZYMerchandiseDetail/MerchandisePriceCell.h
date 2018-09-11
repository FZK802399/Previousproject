//
//  MerchandisePriceCell.h
//  ShopNum1V3.1
//
//  Created by yons on 16/1/13.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseDetailModel.h"
@class MerchandisePriceCell;
@protocol MerchandisePriceCellDeleagte <NSObject>
-(void)merchandisePriceCell:(MerchandisePriceCell *)cell favoBtnDidClick:(UIButton *)btn;
-(CGFloat )getContentOffsetY;
@end

@interface MerchandisePriceCell : UITableViewCell

@property (nonatomic,weak)id<MerchandisePriceCellDeleagte>delegate;
@property (nonatomic,strong)MerchandiseDetailModel * model;

-(void)favoSuccess;
@end
