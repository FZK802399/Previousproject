//
//  HeadView.m
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView
@synthesize delegate = _delegate;
@synthesize section,open,backBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if(_imgIcon == nil){
            _imgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(6, 12, 20, 20)];
            //            _imgIcon.image = [UIImage imageNamed:@"btn_detail_normal.png"];
            [self addSubview:_imgIcon];
        }
        
        
        if(_lbName == nil){
            _lbName = [[UILabel alloc] initWithFrame:CGRectMake(6, 12, 260, 20)];
            _lbName.font = [UIFont boldSystemFontOfSize:16.0f];
            _lbName.textColor = [UIColor colorWithRed:109 /255.0f green:109 /255.0f blue:109 /255.0f alpha:1];
            [self addSubview:_lbName];
        }
        
//        if(_lbDesc == nil){
//            _lbDesc = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 280, 40)];
//            _lbDesc.font = [UIFont systemFontOfSize:12.0f];
//            _lbDesc.textColor = [UIColor colorWithRed:187 /255.0f green:187 /255.0f blue:187 /255.0f alpha:1];
//            _lbDesc.lineBreakMode = NSLineBreakByCharWrapping;
//            _lbDesc.numberOfLines = 2;
//            [self addSubview:_lbDesc];
//        }
        
        if(_imgArrow == nil){
            _imgArrow = [[UIImageView alloc] initWithFrame:CGRectMake(290, 10, 24, 24)];
            _imgArrow.image = [UIImage imageNamed:@"ico_arrow_down.png"];
            [self addSubview:_imgArrow];
        }
        
        if(_bottomLayer == nil){
            _bottomLayer = [CALayer layer];
            _bottomLayer.frame = CGRectMake(0, 43, 320, 1.0f);
            // _bottomLayer.frame = CGRectMake(0, 57,self.contentView.frame.size.width, 1.0f);
            _bottomLayer.backgroundColor = [UIColor colorWithRed:245 /255.0f green:245 /255.0f blue:245 /255.0f alpha:1].CGColor;
            [self.layer addSublayer:_bottomLayer];
        }
        
        self.backgroundColor = [UIColor whiteColor];
        
        open = NO;
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 340, 80);
        [btn addTarget:self action:@selector(doSelected) forControlEvents:UIControlEventTouchUpInside];

//        [btn setBackgroundImage:[UIImage imageNamed:@"btn_momal"] forState:UIControlStateNormal];
//        [btn setBackgroundImage:[UIImage imageNamed:@"btn_on"] forState:UIControlStateHighlighted];
        [self addSubview:btn];
        self.backBtn = btn;

    }
    return self;
}

-(void)doSelected{
    //    [self setImage];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
     	[_delegate selectedWith:self];
    }
}

-(void)createHeadViewCategoryItem:(SortModel *)category{
//    [_imgIcon setImageWithURL:category.BackgroundImage];
    _lbName.text = category.Name;
//    _lbDesc.text = category.categoryName;
}
@end
