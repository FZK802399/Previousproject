//
//  MerchandiseSpecification.h
//  Shop
//
//  Created by Ocean Zhang on 4/2/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseDetailModel.h"
#import "MerchandiseSpecificationListModel.h"
#import "ScoreProductDetialModel.h"

@protocol MerchandiseSpecficationItemDelegate <NSObject>

- (void)createFinished;

- (void)closeFinished;

- (void)sureBtnFinished;

- (void)chooseSpec;

@end

@interface MerchandiseSpecificationItem : UIView

@property (nonatomic, assign) id<MerchandiseSpecficationItemDelegate> delegate;

///选择数量
@property (nonatomic, assign) NSInteger selectCount;

@property (nonatomic, strong) NSString *specificationName;

@property (nonatomic, strong) NSString *specificationValue;

- (void)createSpecification:(MerchandiseDetailModel *)intro;

- (void)createScoreProductSpecification:(ScoreProductDetialModel *)intro;

///设置库存量
- (void)setRepertoryCount:(NSInteger)count;

//设置规格价格
- (void)setShopPrice:(CGFloat)price;

@end
