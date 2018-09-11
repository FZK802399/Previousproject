//
//  ProductCategoryTableViewCell.h
//  Shop
//
//  Created by Ocean Zhang on 4/1/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortModel.h"

@interface ProductCategoryTableViewCell : UITableViewCell

- (void)createCategoryItem:(SortModel *)category;

@end
