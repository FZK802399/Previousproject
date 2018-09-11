//
//  SecondContentCell.h
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortModel.h"
static NSString * kSecondContentCell = @"SecondContentCell";
@interface SecondContentCell : UICollectionViewCell
@property (nonatomic,strong) SortModel * mode;
@end
