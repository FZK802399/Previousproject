//
//  MerchandiseImageList.h
//  Shop
//
//  Created by Ocean Zhang on 4/1/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseDetailModel.h"
#import "ScoreProductDetialModel.h"


@interface MerchandiseImageList : UIView<UIScrollViewDelegate>

- (void)createMerchandiseImageListWith:(MerchandiseDetailModel *)detail;

- (void)createMerchandiseImageListWithScoreProductDetialModel:(ScoreProductDetialModel *)detail;

@end
