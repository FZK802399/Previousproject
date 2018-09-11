//
//  ReturnProductView.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-5.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ReturnProductView.h"

@implementation ReturnProductView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self InitializationView];
    }
    return self;
}

-(void)InitializationView{
    CGFloat width = self.bounds.size.width;
    //    CGFloat height = self.bounds.size.height;
    CGFloat originX = 6;
    CGFloat originY = 6;
    CGFloat imagewidth = 90;
    CGFloat paddingwidth = 5;
    
    if (_isReturnBtn == nil) {
        _isReturnBtn = [[QCheckBox alloc] initWithFrame:CGRectMake(12, 36, 32, 32)];
        [_isReturnBtn setDelegate:self];
        [self addSubview:_isReturnBtn];
    }
    
    originX += 30;
    if (_IcoImage == nil) {
        _IcoImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, imagewidth, imagewidth)];
        [self addSubview:_IcoImage];
    }
    CGFloat productNameHeight = 40;
    
    if (_productName == nil) {
        _productName = [[UILabel alloc] initWithFrame:CGRectMake(originX + paddingwidth + imagewidth, originY, width - 130, productNameHeight)];
        _productName.numberOfLines = 2;
        _productName.textAlignment = NSTextAlignmentLeft;
        _productName.backgroundColor = [UIColor clearColor];
        _productName.lineBreakMode = NSLineBreakByCharWrapping;
        _productName.font = [UIFont systemFontOfSize:14];
        [self addSubview:_productName];
    }
    
    if (_productPrice == nil) {
        _productPrice = [[UILabel alloc] initWithFrame:CGRectMake(originX + paddingwidth + imagewidth, originY + paddingwidth + productNameHeight, 70, productNameHeight/2)];
        _productPrice.textAlignment = NSTextAlignmentLeft;
        _productPrice.backgroundColor = [UIColor clearColor];
        _productPrice.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;
        _productPrice.textColor = [UIColor textTitleColor];
        _productPrice.font = [UIFont systemFontOfSize:14];
        [self addSubview:_productPrice];
    }
    
    if (_productNumber == nil) {
        _productNumber = [[TextStepperField alloc] initWithFrame:CGRectMake(originX + paddingwidth + imagewidth - 2, originY + paddingwidth + 60 , 75, 25)];
        [_productNumber addTarget:self action:@selector(returnNumberChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_productNumber];
    }
}

- (void)returnNumberChange:(id)sender {
    if (_productNumber.TypeChange == TextStepperFieldChangeKindNegative) {
        if (_currentProductModel.ReturnCount > _productNumber.Minimum) {
            _currentProductModel.ReturnCount--;
        }else {
            _currentProductModel.ReturnCount = _productNumber.Minimum;
        }
    }else {
        if (_currentProductModel.ReturnCount < _productNumber.Maximum) {
            _currentProductModel.ReturnCount++;
        }else {
            _currentProductModel.ReturnCount = _productNumber.Maximum;
        }
    }
}

-(void)creatProductDetailViewWithReturnMerchandiseModel:(ReturnMerchandiseModel *)detail{
    _currentProductModel = detail;
    _productNumber.Current = detail.ReturnCount;
    _productNumber.Minimum = 1;
    _productNumber.Maximum = detail.buyNumer;
    
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    [self.IcoImage setImageWithURL:detail.ProductImg placeholderImage:blankImg];
    [self.productName setText:[detail.ProductName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [self.productPrice setText:[NSString stringWithFormat:@"AU$ %.2f", detail.BuyPrice]];

}


-(void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    if (checked) {
        self.currentProductModel.isCheckForReturn = YES;
    }else{
        self.currentProductModel.isCheckForReturn = NO;
    }

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
