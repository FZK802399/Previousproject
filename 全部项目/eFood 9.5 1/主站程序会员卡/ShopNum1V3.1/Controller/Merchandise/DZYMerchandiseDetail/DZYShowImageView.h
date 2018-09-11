//
//  DZYShowImageView.h
//  ShopNum1V3.1
//
//  Created by mini on 16/5/3.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DZYShowImageView : UIView

@property (nonatomic,strong)NSString * url;
-(instancetype)initWithFrame:(CGRect)frame url:(NSString *)url;
-(void)show;
-(void)dismiss;
@end
