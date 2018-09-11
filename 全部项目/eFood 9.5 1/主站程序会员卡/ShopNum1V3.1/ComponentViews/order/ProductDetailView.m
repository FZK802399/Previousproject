//
//  ProductDetailView.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-29.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ProductDetailView.h"

@implementation ProductDetailView

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
    if (_IcoImage == nil) {
        _IcoImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY, imagewidth, imagewidth)];
        [self addSubview:_IcoImage];
    }
    CGFloat productNameHeight = 40;
    
    if (_productName == nil) {
        _productName = [[UILabel alloc] initWithFrame:CGRectMake(originX + paddingwidth*2 + imagewidth, originY, width - 4*paddingwidth - imagewidth, productNameHeight)];
        _productName.numberOfLines = 2;
        _productName.textAlignment = NSTextAlignmentLeft;
        _productName.backgroundColor = [UIColor clearColor];
        _productName.lineBreakMode = NSLineBreakByCharWrapping;
        _productName.font = [UIFont systemFontOfSize:15];
        [self addSubview:_productName];
    }
    
    if (_productPrice == nil) {
        _productPrice = [[UILabel alloc] initWithFrame:CGRectMake(originX + paddingwidth*2+ imagewidth, originY + paddingwidth + productNameHeight, 150, productNameHeight/2)];
        _productPrice.textAlignment = NSTextAlignmentLeft;
        _productPrice.backgroundColor = [UIColor clearColor];
        _productPrice.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;
        _productPrice.textColor = [UIColor textTitleColor];
        _productPrice.font = [UIFont systemFontOfSize:14];
        [self addSubview:_productPrice];
    }
    
    if (_productNum == nil) {
        _productNum = [[UILabel alloc] initWithFrame:CGRectMake(originX + paddingwidth*2 + imagewidth, originY + paddingwidth*2 + 50 , 70, productNameHeight/2)];
        _productNum.textAlignment = NSTextAlignmentLeft;
        _productNum.backgroundColor = [UIColor clearColor];
        _productNum.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;
        _productNum.textColor = [UIColor textTitleColor];
        _productNum.font = [UIFont systemFontOfSize:12];
        [self addSubview:_productNum];
    }
    if (_productColor == nil) {
        _productColor = [[UILabel alloc] initWithFrame:CGRectMake(originX + paddingwidth*2 + imagewidth, originY + paddingwidth*3 + 60 , 70, productNameHeight/2)];
        _productColor.textAlignment = NSTextAlignmentLeft;
        _productColor.backgroundColor = [UIColor clearColor];
        _productColor.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;
        _productColor.textColor = [UIColor textTitleColor];
        _productColor.font = [UIFont systemFontOfSize:12];
        [self addSubview:_productColor];
    }
    
    if (_productActivity == nil) {
        _productActivity = [[UILabel alloc] initWithFrame:CGRectMake(originX + paddingwidth + imagewidth, originY + paddingwidth*3 + productNameHeight + productNameHeight, 70, productNameHeight/2)];
        _productActivity.textAlignment = NSTextAlignmentLeft;
        _productActivity.backgroundColor = [UIColor clearColor];
        _productActivity.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;
        _productActivity.textColor = [UIColor whiteColor];
        _productActivity.font = [UIFont timeDetailFont];
        _productActivity.backgroundColor = [UIColor textTitleBackGroundColor];
//        [self addSubview:_productActivity];
    }
}

//-(void)creatProductDetailViewWithShopCartMerchandiseModel:(ShopCartMerchandiseModel *)detail{
//    
//    UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
//    [self.IcoImage setImageWithURL:detail.originalImage placeholderImage:blankImg];
//    [self.productName setText:[detail.name stringByReplacingOccurrencesOfString:@" " withString:@""]];
//    [self.productPrice setText:[NSString stringWithFormat:@"AU$ %.2f", detail.buyPrice]];
//    [self.productNum setText:[NSString stringWithFormat:@"数量：%d",detail.buyNumber]];
//
//
//}



-(void)creatProductDetailViewWithSubmitOrderViewController:(OrderMerchandiseSubmitModel *)detail{
    UIImage *blankImg = [UIImage imageNamed:@"nopic"];
    if (detail.Score > 0) {
        [self.IcoImage setImageWithURL:[NSURL URLWithString:detail.OriginalImge] placeholderImage:blankImg];
        [self.productName setText:[detail.Name stringByReplacingOccurrencesOfString:@" " withString:@""]];
        CGRect textframe = self.productName.frame;
        textframe.size.height = [self heightForString:detail.Name fontSize:15 andWidth:self.productName.frame.size.width];
        if (textframe.size.height > 40) {
            textframe.size.height = 40;
        }
        self.productName.frame = textframe;
        
        [self.productPrice setText:[NSString stringWithFormat:@"AU$ %.2f +%d积分", detail.BuyPrice, detail.Score]];
        [self.productNum setText:[NSString stringWithFormat:@"数量：%d",detail.BuyNumber]];
        [self.productColor setText:[NSString stringWithFormat:@"%@", detail.Attributes]];
        self.productPrice.frame = CGRectMake(self.productPrice.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.productPrice.frame),  CGRectGetHeight(self.productPrice.frame));
        
        self.productNum.frame = CGRectMake(self.productNum.frame.origin.x, self.productPrice.frame.origin.y + self.productPrice.frame.size.height, CGRectGetWidth(self.productNum.frame),  CGRectGetHeight(self.productNum.frame));
    
    }else {
        [self.IcoImage setImageWithURL:[NSURL URLWithString:detail.OriginalImge] placeholderImage:blankImg];
        [self.productName setText:[detail.Name stringByReplacingOccurrencesOfString:@" " withString:@""]];
        CGRect textframe = self.productName.frame;
        textframe.size.height = [self heightForString:detail.Name fontSize:15 andWidth:self.productName.frame.size.width];
        if (textframe.size.height > 40) {
            textframe.size.height = 40;
        }
        self.productName.frame = textframe;
        
        [self.productPrice setText:[NSString stringWithFormat:@"AU$ %.2f", detail.BuyPrice]];
        [self.productNum setText:[NSString stringWithFormat:@"数量：%d",detail.BuyNumber]];
        [self.productColor setText:[NSString stringWithFormat:@"%@", detail.Attributes]];
        self.productPrice.frame = CGRectMake(self.productPrice.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.productPrice.frame),  CGRectGetHeight(self.productPrice.frame));
        
        self.productNum.frame = CGRectMake(self.productNum.frame.origin.x, self.productPrice.frame.origin.y + self.productPrice.frame.size.height, CGRectGetWidth(self.productNum.frame),  CGRectGetHeight(self.productNum.frame));
    
    }

}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByCharWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

-(void)creatProductDetailViewWithMerchandiseIntroModel:(OrderMerchandiseIntroModel *)detail{
    
    if (detail.BuyScore > 0) {
        UIImage *blankImg = [UIImage imageNamed:@"nopic"];
        [self.IcoImage setImageWithURL:detail.ProductImg placeholderImage:blankImg];
        [self.productName setText:[detail.Name stringByReplacingOccurrencesOfString:@" " withString:@""]];
        CGRect textframe = self.productName.frame;
        textframe.size.height = [self heightForString:detail.Name fontSize:15 andWidth:self.productName.frame.size.width];
        if (textframe.size.height > 40) {
            textframe.size.height = 40;
        }
        self.productName.frame = textframe;
        [self.productPrice setText:[NSString stringWithFormat:@"AU$ %.2f + %d积分", detail.BuyPrice, detail.BuyScore]];
        [self.productNum setText:[NSString stringWithFormat:@"数量：%d",detail.BuyNumber]];
        self.productPrice.frame = CGRectMake(self.productPrice.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.productPrice.frame),  CGRectGetHeight(self.productPrice.frame));
        
        self.productNum.frame = CGRectMake(self.productNum.frame.origin.x, self.productPrice.frame.origin.y + self.productPrice.frame.size.height, CGRectGetWidth(self.productNum.frame),  CGRectGetHeight(self.productNum.frame));
    }else {
    
        UIImage *blankImg = [UIImage imageNamed:@"nopic"];
        [self.IcoImage setImageWithURL:detail.ProductImg placeholderImage:blankImg];
        [self.productName setText:[detail.ProductName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        CGRect textframe = self.productName.frame;
        textframe.size.height = [self heightForString:detail.ProductName fontSize:15 andWidth:self.productName.frame.size.width];
        if (textframe.size.height > 40) {
            textframe.size.height = 40;
        }
        self.productName.frame = textframe;
        [self.productPrice setText:[NSString stringWithFormat:@"AU$ %.2f", detail.BuyPrice]];
        [self.productNum setText:[NSString stringWithFormat:@"数量：%d",detail.BuyNumber]];
        self.productPrice.frame = CGRectMake(self.productPrice.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.productPrice.frame),  CGRectGetHeight(self.productPrice.frame));
        
        self.productNum.frame = CGRectMake(self.productNum.frame.origin.x, self.productPrice.frame.origin.y + self.productPrice.frame.size.height, CGRectGetWidth(self.productNum.frame),  CGRectGetHeight(self.productNum.frame));
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
