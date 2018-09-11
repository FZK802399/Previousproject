//
//  ChongZhiViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/28.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "AdvanceController.h"
@class ChongZhiViewController;
@protocol ChongZhiDelegate <NSObject>

-(void) ChongZhiDidAddEndWithVC:(ChongZhiViewController *)vc;

@end
@interface ChongZhiViewController : WFSViewController
@property (nonatomic,weak)id<ChongZhiDelegate> delegate;
@end
