//
//  SWUtilityButtonView.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-17.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUtilityButtonsWidthMax 260
#define kUtilityButtonWidthDefault 60

@interface SWUtilityButtonView : UIView

- (id)initWithUtilityButtons:(NSArray *)utilityButtons parentCell:(UITableViewCell *)parentCell utilityButtonSelector:(SEL)utilityButtonSelector;

- (void)populateUtilityButtons;

- (CGFloat)calculateUtilityButtonWidth;

- (CGFloat)utilityButtonsWidth;

@end
