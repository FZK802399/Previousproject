//
//  MerchandiseDetailCollectionViewCell.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/21.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kMerchandiseDetailCellIdentifier;

//extern NSString *const kActivityBtnsCell;

@interface MerchandiseDetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
