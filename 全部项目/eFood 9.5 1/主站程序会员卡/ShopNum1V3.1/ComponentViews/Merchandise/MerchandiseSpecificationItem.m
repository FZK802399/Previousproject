 //
//  MerchandiseSpecification.m
//  Shop
//
//  Created by Ocean Zhang on 4/2/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MerchandiseSpecificationItem.h"
#import "BorderLabel.h"
#import "UIButton+Guid.h"
#import "UIButton+SpecificationID.h"
#import "UIButton+SpecificationName.h"
#import "UIButton+SpecificationValue.h"
#import <QuartzCore/QuartzCore.h>


@interface MerchandiseSpecificationItem()

@property (nonatomic, strong) UIScrollView *allScrollView;

@property (nonatomic, strong) UILabel *productName;

@property (nonatomic, strong) UILabel *shoppriceLabel;

@property (nonatomic, strong) UILabel *marketPriceLabel;

@property (nonatomic, strong) UILabel *repertoryCountLabel;

@property (nonatomic, strong) UILabel *lbTitle;

@property (nonatomic, strong) AppConfig *appConfig;

@property (nonatomic, strong) BorderLabel *lbTitleOrange;

@property (nonatomic, strong) UIImageView *imgIco;

@property (nonatomic, strong) NSMutableArray *specificationViews;

@property (nonatomic, strong) MerchandiseDetailModel *currentDetail;

@property (nonatomic, strong) UILabel *lbCountInfo;

@property (nonatomic, strong) TextStepperField *chooseCount;

@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIButton *OKButton;

@property (nonatomic, strong) NSMutableDictionary *dictName;

@property (nonatomic, strong) NSMutableDictionary *dictValue;

@end

@implementation MerchandiseSpecificationItem

@synthesize lbTitle = _lbTitle;
@synthesize lbTitleOrange = _lbTitleOrange;
@synthesize imgIco = _imgIco;
@synthesize specificationViews = _specificationViews;
@synthesize currentDetail = _currentDetail;
@synthesize selectCount = _selectCount;
@synthesize lbCountInfo = _lbCountInfo;
@synthesize delegate = _delegate;

@synthesize dictName = _dictName;
@synthesize dictValue = _dictValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.allScrollView = [[UIScrollView alloc] init];
        self.allScrollView.scrollEnabled = YES;
        CGFloat height = 40;
        CGFloat fullWidth = self.frame.size.width;
        CGFloat originY = 5;
        CGFloat originX = 5;
        CGFloat imagehight = 60;
        CGFloat imagewidth = 60;
        
        if (_imgIco == nil) {
            _imgIco = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, imagewidth, imagehight)];
            _imgIco.layer.borderWidth = 1;
            _imgIco.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
            [self addSubview:_imgIco];
        }
        
        if (_productName == nil) {
            _productName = [[UILabel alloc] initWithFrame:CGRectMake(originX + _imgIco.frame.size.width + 5, originY, fullWidth - originX*8- _imgIco.frame.size.width - 10, 36)];
            _productName.numberOfLines = 2;
            _productName.font = [UIFont systemFontOfSize:13.0f];
            _productName.textAlignment = NSTextAlignmentLeft;
            _productName.lineBreakMode = NSLineBreakByTruncatingTail;
            _productName.textColor = [UIColor colorWithWhite:0.236 alpha:1.000];
            _productName.backgroundColor = [UIColor clearColor];
            [self addSubview:_productName];
        }
        
        if (_shoppriceLabel == nil) {
            _shoppriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + _imgIco.frame.size.width + 5, originY + _productName.frame.size.height + 5, 70, height-25)];
            _shoppriceLabel.numberOfLines = 1;
            _shoppriceLabel.font = [UIFont systemFontOfSize:12.0f];
            _shoppriceLabel.textAlignment = NSTextAlignmentLeft;
            _shoppriceLabel.textColor = [UIColor redColor];
            _shoppriceLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_shoppriceLabel];
        }
        
        if (_marketPriceLabel == nil) {
            _marketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_shoppriceLabel.frame)+5/*originX + _imgIco.frame.size.width + 10 + _shoppriceLabel.frame.size.width*/, originY + _productName.frame.size.height + 5, (fullWidth - originX*2 - _imgIco.frame.size.width - 10)/3, height-25)];
            _marketPriceLabel.textAlignment = NSTextAlignmentCenter;
            _marketPriceLabel.font = [UIFont systemFontOfSize:12.0f];
            _marketPriceLabel.textColor = [UIColor textTitleColor];
            _marketPriceLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_marketPriceLabel];
        }
        
        if (_repertoryCountLabel == nil) {
            _repertoryCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_marketPriceLabel.frame)+5/*originX + _imgIco.frame.size.width + 10 + _shoppriceLabel.frame.size.width*/, originY + _productName.frame.size.height + 5, (fullWidth - originX*2 - _imgIco.frame.size.width - 10)/3, height-25)];
            _repertoryCountLabel.numberOfLines = 1;
            _repertoryCountLabel.font = [UIFont systemFontOfSize:12.0f];
            _repertoryCountLabel.textAlignment = NSTextAlignmentLeft;
            _repertoryCountLabel.textColor = [UIColor textTitleColor];
            _repertoryCountLabel.backgroundColor = [UIColor clearColor];
            [self addSubview:_repertoryCountLabel];
        }
        
        
//        CGFloat titleWidth = 60;
//        UIFont *font = [UIFont systemFontOfSize:14.0f];
//        if(_lbTitle == nil){
//            _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, titleWidth, height)];
//            _lbTitle.textAlignment = NSTextAlignmentRight;
//            _lbTitle.font = font;
//            _lbTitle.textColor = [UIColor colorWithRed:121 /255.0f green:121 /255.0f blue:121 /255.0f alpha:1];
//            _lbTitle.text = @"请选择";
//            _lbTitle.backgroundColor = [UIColor clearColor];
//            [self addSubview:_lbTitle];
//        }
//        
//        if(_lbTitleOrange == nil){
//            _lbTitleOrange = [[BorderLabel alloc] init];
//            _lbTitleOrange.leftInset = titleWidth;
//            _lbTitleOrange.textAlignment = NSTextAlignmentLeft;
//            _lbTitleOrange.text = @"商品规格属性";
//            _lbTitleOrange.textColor = [UIColor orangeColor];
//            _lbTitleOrange.backgroundColor = [UIColor clearColor];
//            _lbTitleOrange.frame = CGRectMake(0, 110, fullWidth, height);
//            _lbTitleOrange.font = font;
//            CALayer *bottomLayer = [CALayer layer];
//            bottomLayer.borderWidth = 1;
//            bottomLayer.borderColor = [UIColor colorWithRed:207 /255.0f green:207 /255.0f blue:207 /255.0f alpha:1].CGColor;
//            bottomLayer.frame = CGRectMake(5, height - 1, fullWidth - 10, 1);
//            [_lbTitleOrange.layer addSublayer:bottomLayer];
//
//            [self addSubview:_lbTitleOrange];
//        }
        
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.borderWidth = 1;
        bottomLayer.borderColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
        bottomLayer.frame = CGRectMake(0, CGRectGetMaxY(_repertoryCountLabel.frame) + 10, fullWidth, 1);
        [self.layer addSublayer:bottomLayer];
        
        if (_closeButton == nil) {
            _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _closeButton.frame = CGRectMake(SCREEN_WIDTH - 44, 0, 44, 44);
            [_closeButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [_closeButton addTarget:self action:@selector(dismissSpecificationItem) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_closeButton];
        }
        
       
        
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
        self.backgroundColor = [UIColor whiteColor];
        [self.layer setCornerRadius:0];
        
        _specificationViews = [[NSMutableArray alloc] init];
        
        _dictName = [[NSMutableDictionary alloc] init];
        _dictValue = [[NSMutableDictionary alloc] init];
        
        _selectCount = 1;
        
        self.clipsToBounds = YES;
    }
    return self;
}
//隐藏规格视图
-(void)dismissSpecificationItem{
    if(_delegate != nil){
        if([_delegate respondsToSelector:@selector(closeFinished)]){
            [_delegate closeFinished];
        }
    }
    [self removeFromSuperview];
}


- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}


- (void)createSpecification:(MerchandiseDetailModel *)intro{
    _currentDetail = intro;
    if(_currentDetail.repertoryCount <= 0){
        _selectCount = 0;
    }
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [_imgIco setImageWithURL:intro.originalImage placeholderImage:blankImg];
    _productName.text = intro.name;
    
    CGRect textframe = self.productName.frame;
    textframe.size.height = [self heightForString:intro.name fontSize:14 andWidth:self.productName.frame.size.width];

    if (textframe.size.height > 36) {
        textframe.size.height = 36;
    }
    self.productName.frame = textframe;
    
    _shoppriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",intro.shopPrice];
    _marketPriceLabel.text = [NSString stringWithFormat:@"约¥%.2f",intro.marketPrice];
    _repertoryCountLabel.text = [NSString stringWithFormat:@"库存：%ld", intro.repertoryCount];
    _appConfig = [AppConfig sharedAppConfig];
    NSDictionary * SpecificationDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       intro.guid,@"id",
                                       kWebAppSign,@"Appsign",nil];
    //获取商品规格
    [MerchandiseSpecificationListModel getMerchandiseSpecificationListByParameters:SpecificationDic andblock:^(NSArray *list, NSError *error) {
        if(error){
            
        }else{
            CGFloat originY = 0;
            CGFloat originX = 10;
            CGFloat fullWidth = self.frame.size.width;
            CGFloat titleHeight = 40;
            
            CGFloat btnWidth = 78;
            CGFloat btnHeight = 30;
            CGFloat btnLeftPadding = 14;
            CGFloat btnTopPadding = 5;
            UIColor *btnBorderColor = [UIColor colorWithRed:207 /255.0f green:207 /255.0f blue:207 /255.0f alpha:1];
            UIFont *btnFontSize = [UIFont systemFontOfSize:12.0f];
            UIColor *btnBackColor = [UIColor colorWithRed:250 /255.0f green:250 /255.0f blue:250 /255.0f alpha:1];
            
            UIColor *fontColor = [UIColor colorWithRed:121 /255.0f green:121 /255.0f blue:121 /255.0f alpha:1];
            UIFont *fontSize = [UIFont systemFontOfSize:14.0f];
            
            int orderIndex = 0;
            for (MerchandiseSpecificationListModel *item in list) {
                
                UIView *containter = [[UIView alloc] initWithFrame:CGRectMake(0, originY, fullWidth, 0)];
                containter.backgroundColor = [UIColor clearColor];
                [self.allScrollView addSubview:containter];
                [_specificationViews addObject:containter];
                
                CGFloat inContainterOriginY = 0;
                
                //规格名称 eg:尺码
                UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(originX, inContainterOriginY, fullWidth - originX, titleHeight)];
                lbName.text = [NSString stringWithFormat:@"%@:", item.specValueName];
                lbName.textColor = fontColor;
                lbName.font = fontSize;
                
                //[self addSubview:lbName];
                [containter addSubview:lbName];
                
                //originY += titleHeight;
                inContainterOriginY += titleHeight;
                
                NSArray *specificiationItems = item.specification;
                
                int i = 0;
                int y = 0;
                for (MerchandiseSpecificationModel *specificationItem in specificiationItems) {
                    
                    if(i != 0 && i  % 3 == 0){
                        y = 0;
                        //originY += btnHeight + btnTopPadding;
                        inContainterOriginY += btnHeight + btnTopPadding;
                    }
                    
                    //规格按钮
                    UIButton *btnSpecification = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnSpecification.frame = CGRectMake((y + 1) * btnLeftPadding + y * btnWidth, inContainterOriginY, btnWidth, btnHeight);
                    [btnSpecification setTitle:specificationItem.specValueName forState:UIControlStateNormal];
                    btnSpecification.titleLabel.font = btnFontSize;
                    [btnSpecification setTitleColor:fontColor forState:UIControlStateNormal];
                    btnSpecification.tag = specificationItem.specid;
                    
                    [btnSpecification.layer setCornerRadius:2];
                    btnSpecification.layer.borderWidth = 1;
                    btnSpecification.backgroundColor = btnBackColor;
                    btnSpecification.layer.borderColor = btnBorderColor.CGColor;
                    [btnSpecification addTarget:self action:@selector(btnSpecificationTouch:) forControlEvents:UIControlEventTouchUpInside];
                    
                    btnSpecification.SpecificationName = item.specValueName;
                    btnSpecification.SpecificationValue = specificationItem.specValueName;
                    btnSpecification.SpecificationID = [NSString stringWithFormat:@"%d",specificationItem.specValueid];
                    
                    [containter addSubview:btnSpecification];
                    
                    if(i == 0){
                        //默认选择第一个
                        [self btnSpecificationTouch:btnSpecification];
                    }
                    
                    i ++;
                    y ++;
                    
                    if(i == [specificiationItems count]){
                        //originY += btnHeight + btnTopPadding;
                        inContainterOriginY += btnHeight + btnTopPadding;
                        
                        CGRect containterRect = containter.frame;
                        containterRect.size.height = inContainterOriginY;
                        containter.frame = containterRect;
                        
                        originY += inContainterOriginY;
                    }
                }
                
                orderIndex ++;
            }
            
            //规格信息不存在
            if([list count] == 0){
                _lbTitle.hidden = YES;
                _lbTitleOrange.hidden = YES;
                
//                originY -= 40;
            }
            
            //数量
            BorderLabel *lbCount = [[BorderLabel alloc] initWithFrame:CGRectMake(0, originY, fullWidth, titleHeight)];
            lbCount.leftInset = 15;
            lbCount.text = @"数量:";
            lbCount.font = fontSize;
            lbCount.textColor = fontColor;
            lbCount.backgroundColor = [UIColor clearColor];
            [self.allScrollView addSubview:lbCount];
            
            //            if([list count] == 0){
            //                CALayer *bottomLayer = [CALayer layer];
            //                bottomLayer.borderWidth = 1;
            //                bottomLayer.borderColor = btnBorderColor.CGColor;
            //                bottomLayer.frame = CGRectMake(5, titleHeight - 7, fullWidth - 10, 1);
            //                [lbCount.layer addSublayer:bottomLayer];
            //            }else{
            //                CALayer *topBorder = [CALayer layer];
            //                topBorder.borderWidth = 1;
            //                topBorder.borderColor = btnBorderColor.CGColor;
            //                topBorder.frame = CGRectMake(5, 0, fullWidth - 10, 1);
            //                [lbCount.layer addSublayer:topBorder];
            //            }
            
            if (_chooseCount == nil) {
                _chooseCount = [[TextStepperField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 80, originY + 8, 75, 25)];
                _chooseCount.Minimum = 1;
                if (_currentDetail.IDRestrictCount > 0) {
                    _chooseCount.Maximum = _currentDetail.IDRestrictCount;
                } else {
                    _chooseCount.Maximum = _currentDetail.repertoryCount;
                }
                _chooseCount.Step = 1;
                _chooseCount.Current = 1;
                _chooseCount.backgroundColor = [UIColor clearColor];
                [_chooseCount addTarget:self action:@selector(buyNumberChange:) forControlEvents:UIControlEventValueChanged];
                [self.allScrollView addSubview:_chooseCount];
            }
            
            
            originY += titleHeight + 20;
            
            
            CGRect rect = self.frame;
//            NSLog(@"Init : %@", NSStringFromCGRect(rect));
            
//            originY > rect.size.height - 160
            if (originY > rect.size.height - 200) {
                self.allScrollView.frame = CGRectMake(0, 70, self.frame.size.width, self.frame.size.height - 200);
                [self.allScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, originY)];
                rect.size.height = self.frame.size.height - 200 + 25 + 85;
                self.frame = rect;
            }else{
                self.allScrollView.frame = CGRectMake(0, 70, self.frame.size.width, self.frame.size.height - 130);
                rect.size.height = originY + 25 + 85;
                self.frame = rect;
            }
            self.allScrollView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
            [self addSubview:self.allScrollView];
            CGFloat okbtnCountWidth = SCREEN_WIDTH - 30;
            CGFloat okbtnCountHeight = 35;
            
            self.backgroundColor = [UIColor whiteColor];
            
            UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 60, SCREEN_WIDTH, 60)];
            btnView.backgroundColor = [UIColor whiteColor];
            btnView.layer.borderWidth = 1;
            btnView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
            
            _OKButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _OKButton.frame = CGRectMake(15, 10, okbtnCountWidth, okbtnCountHeight);
            _OKButton.backgroundColor = [UIColor barTitleColor];
            _OKButton.layer.cornerRadius = 3.0f;
//            [_OKButton setBackgroundImage:[UIImage imageNamed:@"bigButtonbg_normal.png"] forState:UIControlStateNormal];
            [_OKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_OKButton setTitle:@"确定" forState:UIControlStateNormal];
            _OKButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
            [_OKButton addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:_OKButton];
            [self addSubview:btnView];
//            if(_delegate != nil){
//                if([_delegate respondsToSelector:@selector(createFinished)]){
//                    [_delegate createFinished];
//                }
//            }
        }
    }];
    self.backgroundColor = [UIColor redColor];
}

- (void)createScoreProductSpecification:(ScoreProductDetialModel *)intro{
//    _currentDetail = intro;
    if(intro.RepertoryCount <= 0){
        _selectCount = 0;
    }
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [_imgIco setImageWithURL:intro.originalImage placeholderImage:blankImg];
    _productName.text = intro.name;
    
    CGRect textframe = self.productName.frame;
    textframe.size.height = [self heightForString:intro.name fontSize:14 andWidth:self.productName.frame.size.width];
    
    if (textframe.size.height > 36) {
        textframe.size.height = 36;
    }
    self.productName.frame = textframe;
    
    _shoppriceLabel.text = [NSString stringWithFormat:@"AU$%.2f",intro.prmo];
    _marketPriceLabel.text = [NSString stringWithFormat:@"%d",intro.ExchangeScore];
    _repertoryCountLabel.text = [NSString stringWithFormat:@"库存：%d", intro.RepertoryCount];
    _appConfig = [AppConfig sharedAppConfig];
    NSDictionary * SpecificationDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       intro.guid,@"id",
                                       kWebAppSign,@"Appsign",nil];
    //获取商品规格
    [MerchandiseSpecificationListModel getMerchandiseSpecificationListByParameters:SpecificationDic andblock:^(NSArray *list, NSError *error) {
        if(error){
            
        }else{
            CGFloat originY = 10;
            CGFloat originX = 10;
            CGFloat fullWidth = self.frame.size.width;
            CGFloat titleHeight = 40;
            
            CGFloat btnWidth = 78;
            CGFloat btnHeight = 30;
            CGFloat btnLeftPadding = 14;
            CGFloat btnTopPadding = 10;
            UIColor *btnBorderColor = [UIColor colorWithRed:207 /255.0f green:207 /255.0f blue:207 /255.0f alpha:1];
            UIFont *btnFontSize = [UIFont systemFontOfSize:12.0f];
            UIColor *btnBackColor = [UIColor colorWithRed:250 /255.0f green:250 /255.0f blue:250 /255.0f alpha:1];
            
            UIColor *fontColor = [UIColor colorWithRed:121 /255.0f green:121 /255.0f blue:121 /255.0f alpha:1];
            UIFont *fontSize = [UIFont systemFontOfSize:12.0f];
            
            int orderIndex = 0;
            for (MerchandiseSpecificationListModel *item in list) {
                
                UIView *containter = [[UIView alloc] initWithFrame:CGRectMake(0, originY, fullWidth, 0)];
                containter.backgroundColor = [UIColor clearColor];
                [self.allScrollView addSubview:containter];
                [_specificationViews addObject:containter];
                
                CGFloat inContainterOriginY = 0;
                
                //规格名称 eg:尺码
                UILabel *lbName = [[UILabel alloc] initWithFrame:CGRectMake(originX, inContainterOriginY, fullWidth - originX, titleHeight)];
                lbName.text = [NSString stringWithFormat:@"%@:", item.specValueName];
                lbName.textColor = fontColor;
                lbName.font = fontSize;
                
                //[self addSubview:lbName];
                [containter addSubview:lbName];
                
                //originY += titleHeight;
                inContainterOriginY += titleHeight;
                
                NSArray *specificiationItems = item.specification;
                
                int i = 0;
                int y = 0;
                for (MerchandiseSpecificationModel *specificationItem in specificiationItems) {
                    
                    if(i != 0 && i  % 3 == 0){
                        y = 0;
                        //originY += btnHeight + btnTopPadding;
                        inContainterOriginY += btnHeight + btnTopPadding;
                    }
                    
                    //规格按钮
                    UIButton *btnSpecification = [UIButton buttonWithType:UIButtonTypeCustom];
                    btnSpecification.frame = CGRectMake((y + 1) * btnLeftPadding + y * btnWidth, inContainterOriginY, btnWidth, btnHeight);
                    [btnSpecification setTitle:specificationItem.specValueName forState:UIControlStateNormal];
                    btnSpecification.titleLabel.font = btnFontSize;
                    [btnSpecification setTitleColor:fontColor forState:UIControlStateNormal];
                    btnSpecification.tag = specificationItem.specid;
                    
                    [btnSpecification.layer setCornerRadius:2];
                    btnSpecification.layer.borderWidth = 1;
                    btnSpecification.backgroundColor = btnBackColor;
                    btnSpecification.layer.borderColor = btnBorderColor.CGColor;
                    [btnSpecification addTarget:self action:@selector(btnSpecificationTouch:) forControlEvents:UIControlEventTouchUpInside];
                    
                    btnSpecification.SpecificationName = item.specValueName;
                    btnSpecification.SpecificationValue = specificationItem.specValueName;
                    btnSpecification.SpecificationID = [NSString stringWithFormat:@"%d",specificationItem.specValueid];
                    
                    [containter addSubview:btnSpecification];
                    
                    if(i == 0){
                        //默认选择第一个
                        [self btnSpecificationTouch:btnSpecification];
                    }
                    
                    i ++;
                    y ++;
                    
                    if(i == [specificiationItems count]){
                        //originY += btnHeight + btnTopPadding;
                        inContainterOriginY += btnHeight + btnTopPadding;
                        
                        CGRect containterRect = containter.frame;
                        containterRect.size.height = inContainterOriginY;
                        containter.frame = containterRect;
                        
                        originY += inContainterOriginY;
                    }
                }
                
                orderIndex ++;
            }
            
            //规格信息不存在
            if([list count] == 0){
                _lbTitle.hidden = YES;
                _lbTitleOrange.hidden = YES;
                
                //                originY -= 40;
            }
            
            //数量
            BorderLabel *lbCount = [[BorderLabel alloc] initWithFrame:CGRectMake(0, originY, fullWidth, titleHeight)];
            lbCount.leftInset = 15;
            lbCount.text = @"数量:";
            lbCount.font = fontSize;
            lbCount.textColor = fontColor;
            lbCount.backgroundColor = [UIColor clearColor];
            [self.allScrollView addSubview:lbCount];
            
            //            if([list count] == 0){
            //                CALayer *bottomLayer = [CALayer layer];
            //                bottomLayer.borderWidth = 1;
            //                bottomLayer.borderColor = btnBorderColor.CGColor;
            //                bottomLayer.frame = CGRectMake(5, titleHeight - 7, fullWidth - 10, 1);
            //                [lbCount.layer addSublayer:bottomLayer];
            //            }else{
            //                CALayer *topBorder = [CALayer layer];
            //                topBorder.borderWidth = 1;
            //                topBorder.borderColor = btnBorderColor.CGColor;
            //                topBorder.frame = CGRectMake(5, 0, fullWidth - 10, 1);
            //                [lbCount.layer addSublayer:topBorder];
            //            }
            
            if (_chooseCount == nil) {
                _chooseCount = [[TextStepperField alloc] initWithFrame:CGRectMake(200, originY + 8, 75, 25)];
                _chooseCount.Minimum = 1;
                _chooseCount.Maximum = intro.RepertoryCount;
                _chooseCount.Step = 1;
                _chooseCount.Current = 1;
                _chooseCount.backgroundColor = [UIColor clearColor];
                [_chooseCount addTarget:self action:@selector(buyNumberChange:) forControlEvents:UIControlEventValueChanged];
                [self.allScrollView addSubview:_chooseCount];
            }
            
            
            originY += titleHeight + 20;
            
            
            CGRect rect = self.frame;
            if (originY > rect.size.height - 160) {
                self.allScrollView.frame = CGRectMake(0, 110, self.frame.size.width, self.frame.size.height - 160);
                [self.allScrollView setContentSize:CGSizeMake(SCREEN_WIDTH, originY + 10)];
            }else{
                self.allScrollView.frame = CGRectMake(0, 110, self.frame.size.width, self.frame.size.height - 130);
                rect.size.height = originY + 25 + 130;
                self.frame = rect;
            }
            self.allScrollView.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
            [self addSubview:self.allScrollView];
            CGFloat okbtnCountWidth = 300;
            CGFloat okbtnCountHeight = 40;
            
            self.backgroundColor = [UIColor whiteColor];
            
            UIView * btnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 60, SCREEN_WIDTH, 60)];
            btnView.backgroundColor = [UIColor whiteColor];
            btnView.layer.borderWidth = 1;
            btnView.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
            
            _OKButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _OKButton.frame = CGRectMake(10, 10, okbtnCountWidth, okbtnCountHeight);
            [_OKButton setBackgroundImage:[UIImage imageNamed:@"bigButtonbg_normal.png"] forState:UIControlStateNormal];
            [_OKButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_OKButton setTitle:@"确定" forState:UIControlStateNormal];
            _OKButton.titleLabel.font = [UIFont boldSystemFontOfSize:18];
            [_OKButton addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [btnView addSubview:_OKButton];
            [self addSubview:btnView];
            if(_delegate != nil){
                if([_delegate respondsToSelector:@selector(createFinished)]){
                    [_delegate createFinished];
                }
            }
        }
    }];
}



- (void)buyNumberChange:(id)sender {
    if (_chooseCount.TypeChange == TextStepperFieldChangeKindNegative) {
        if (_selectCount > self.chooseCount.Minimum) {
            _selectCount--;
        }else {
            [MBProgressHUD showMessage:@"低于最小购买数量" hideAfterTime:1.0f];
            _selectCount = self.chooseCount.Minimum;
        }
    }else {
        if (_selectCount < self.chooseCount.Maximum) {
            _selectCount++;
        }else {
            [MBProgressHUD showMessage:@"超过最大购买数量" hideAfterTime:1.0f];
            _selectCount = self.chooseCount.Maximum;
        }
    }
}


-(void)sureBtnClick:(id)sender{
    if (_delegate != nil) {
        if([_delegate respondsToSelector:@selector(sureBtnFinished)]){
            [_delegate sureBtnFinished];
        }
    }
    
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
     [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        return;
    }
    CGFloat orginY = SCREEN_HEIGHT - self.frame.size.height;
//    NSLog(@"Inside : %@", NSStringFromCGRect(self.frame));
    if (kCurrentSystemVersion < 7.0) {
        orginY -= 64;
    }
    
    CGRect afterFrame = CGRectMake(0, orginY, SCREEN_WIDTH, self.frame.size.height);
//    NSLog(@"afterFrame : %@", NSStringFromCGRect(afterFrame));
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        //        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
    } completion:^(BOOL finished) {
        
    }];
   
    
}

- (void)removeFromSuperview
{
    CGRect afterFrame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, self.frame.size.height);
    [UIView animateWithDuration:0.35f delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        
    } completion:^(BOOL finished) {
    }];
    [super removeFromSuperview];
}

//选中规格
- (IBAction)btnSpecificationTouch:(id)sender{
    
    UIColor *btnBorderColor = [UIColor lightGrayColor];
    UIColor *btnBackColor = [UIColor colorWithWhite:0.975 alpha:1.000];
    UIColor *btnNormalBorderColor = [UIColor colorWithWhite:0.823 alpha:1.000];
    for (UIView *view in _specificationViews) {
        if([sender superview] == view){
            for(id subView in view.subviews){
                if([subView isKindOfClass:[UIButton class]]){
                    UIButton *btnTemp = (UIButton *)subView;
                    [btnTemp setBackgroundImage:nil forState:UIControlStateNormal];
                    [btnTemp setTitleColor:[UIColor colorWithRed:121 /255.0f green:121 /255.0f blue:121 /255.0f alpha:1] forState:UIControlStateNormal];
                    [btnTemp.layer setCornerRadius:2.0f];
                    btnTemp.layer.borderWidth = 1;
                    btnTemp.backgroundColor = btnBackColor;
                    btnTemp.layer.borderColor = [btnNormalBorderColor CGColor];
                    
                }
            }
        }
    }
    
    UIButton *btn = (UIButton *)sender;
//    [btn setBackgroundImage:[UIImage imageNamed:@"bg_btn_selected.png"] forState:UIControlStateNormal];
    btn.backgroundColor = MAIN_GREEN;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.borderWidth = 0;
    [btn.layer setCornerRadius:2.f];
//    btn.layer.borderColor = btnBorderColor.CGColor;
    
    //KeyName ^:^
    NSString *keyAndOrder = [NSString stringWithFormat:@"%d^:^%@",btn.tag,btn.SpecificationName];
    
    //Value ^:^ ID
    NSString *valueAndID = [NSString stringWithFormat:@"%@^:^%@",btn.SpecificationValue,btn.SpecificationID];
    
    [_dictName setObject:valueAndID forKey:keyAndOrder];
    
    if(_delegate != nil){
        if([_delegate respondsToSelector:@selector(chooseSpec)]){
            [_delegate chooseSpec];
        }
    }
}

- (NSString *)specificationName {
    _specificationName = nil;
    
    NSArray *allKey = [_dictName allKeys];
    NSArray *sortKey = [allKey sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    int i = 0;
    for(NSString *keyAndOrder in sortKey){
        NSArray *keyAndOrderArr = [keyAndOrder componentsSeparatedByString:@"^:^"];
        NSString *keyName = [keyAndOrderArr objectAtIndex:0];
        
        NSArray *valueAndValueIDArr = [[_dictName objectForKey:keyAndOrder] componentsSeparatedByString:@"^:^"];
        NSString *value = [valueAndValueIDArr lastObject];
        
        NSString *str;
        if(i == [sortKey count] - 1){
            str = [NSString stringWithFormat:@"%@:%@",keyName,value];
        }else{
            str = [NSString stringWithFormat:@"%@:%@;",keyName,value];
        }
        
        if(_specificationName ==nil){
            _specificationName = [NSString stringWithString:str];
        }else{
            _specificationName = [_specificationName stringByAppendingString:str];
        }
        
        i ++;
    }
    
    if(_specificationName == nil){
        _specificationName = @"";
    }
    
    return _specificationName;
}

- (NSString *)specificationValue{
    _specificationValue = nil;
    
    NSArray *allKey = [_dictName allKeys];
    NSArray *sortKey = [allKey sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    int i = 0;
    for(NSString *keyAndOrder in sortKey){
        NSArray *keyAndOrderArr = [keyAndOrder componentsSeparatedByString:@"^:^"];
        NSString *value = [keyAndOrderArr lastObject];
        NSArray *valueAndValueIDArr = [[_dictName objectForKey:keyAndOrder] componentsSeparatedByString:@"^:^"];
        //        NSString *value = [valueAndValueIDArr objectAtIndex:0];
        NSString *valueID = [valueAndValueIDArr objectAtIndex:0];
        
        NSString *str;
        if(i == [sortKey count] - 1){
            str = [NSString stringWithFormat:@"%@,%@",value,valueID];
        }else{
            str = [NSString stringWithFormat:@"%@,%@|",value,valueID];
        }
        
        if(_specificationValue ==nil){
            _specificationValue = [NSString stringWithString:str];
        }else{
            _specificationValue = [_specificationValue stringByAppendingString:str];
        }
        
        i ++;
    }
    
    if(_specificationValue == nil){
        _specificationValue = @"";
    }
    
    return _specificationValue;
}

- (void)setRepertoryCount:(NSInteger)count{
    _selectCount = 1;
    _repertoryCountLabel.text = [NSString stringWithFormat:@"库存：%d", count];
//    _chooseCount.Maximum = count;
    
    if (_currentDetail.IDRestrictCount > 0) {
        _chooseCount.Maximum = _currentDetail.IDRestrictCount;
    } else {
        _chooseCount.Maximum = count;
    }

    
    if (count == 0) {
        [_OKButton setEnabled:NO];
    }else {
        [_OKButton setEnabled:YES];
    }
    //_currentDetail.repertoryCount = count;
}

-(void)setShopPrice:(CGFloat)price{
    _currentDetail.shopPrice = price;
    _shoppriceLabel.text = [NSString stringWithFormat:@"AU$%.2f", price];
}

@end
