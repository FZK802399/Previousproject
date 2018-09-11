//
//  DZYADVIew.h
//  ShopNum1V3.1
//
//  Created by yons on 16/1/13.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>
///广告视图
@interface DZYADView : UIView
@property (nonatomic,strong)NSArray * UrlList;

-(instancetype)initWithFrame:(CGRect)frame ImageUrlList:(NSArray *)UrlList;

@end
