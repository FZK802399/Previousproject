//
//  HeadView.h
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SortModel.h"
@protocol HeadViewDelegate; 

@interface HeadView : UIView{
    
}
@property(nonatomic, assign) id<HeadViewDelegate> delegate;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL open;
@property(nonatomic, retain) UIButton* backBtn;

@property (nonatomic, strong) UILabel *lbName;

@property (nonatomic, strong) UILabel *lbDesc;

@property (nonatomic, strong) UIImageView *imgArrow;

@property (nonatomic, strong) UIImageView *imgIcon;

@property (nonatomic, strong) CALayer *bottomLayer;

- (void)createHeadViewCategoryItem:(SortModel *)category;

@end

@protocol HeadViewDelegate <NSObject>
-(void)selectedWith:(HeadView *)view;
@end
