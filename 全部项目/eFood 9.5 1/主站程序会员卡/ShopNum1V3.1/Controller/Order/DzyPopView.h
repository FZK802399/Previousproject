//
//  DzyPopView.h
//  Shop
//
//  Created by yons on 15/11/3.
//  Copyright (c) 2015年 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DzyPopView;
@protocol DzyPopDelegate <NSObject>

-(void)payMoneyWithView:(DzyPopView *)view str:(NSString *)str section:(NSInteger )section;

@end

@interface DzyPopView : UIView
@property (nonatomic,assign)NSInteger section;
@property (nonatomic,weak)id<DzyPopDelegate> delegate;
-(void)show;
-(void)dismiss;
@end
