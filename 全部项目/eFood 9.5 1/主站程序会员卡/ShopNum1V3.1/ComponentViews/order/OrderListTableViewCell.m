//
//  OrderListTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-3.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "PaymentModel.h"
#import "RefundOrderModel.h"

@implementation OrderListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self Initialization];
    }
    return self;
}
-(void)Initialization{
    
    UIColor *btnBorderColor = [UIColor colorWithRed:240 /255.0f green:240 /255.0f blue:240 /255.0f alpha:1];
    if (self.statueLabel == nil) {
        self.statueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 21)];
        self.statueLabel.font = [UIFont systemFontOfSize:14];
        self.statueLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.statueLabel];
    }
    
    if (self.timeLabel == nil) {
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(167, 5, 145, 21)];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
    }
    
    CALayer *topLayer = [CALayer layer];
    topLayer.borderWidth = 1;
    topLayer.borderColor = btnBorderColor.CGColor;
    topLayer.frame = CGRectMake(0, 0, 320, 1);
    [self.contentView.layer addSublayer:topLayer];
    
    CALayer *top2Layer = [CALayer layer];
    top2Layer.borderWidth = 1;
    top2Layer.borderColor = btnBorderColor.CGColor;
    top2Layer.frame = CGRectMake(0, CGRectGetHeight(self.timeLabel.frame) + 5, 320, 1);
    [self.contentView.layer addSublayer:top2Layer];

    
    if (self.nameLabel == nil) {
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(103, 34, 200, 40)];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.numberOfLines = 2;
        self.nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.nameLabel];
    }
    
    if (self.priceLabel == nil) {
        self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, 137, 90, 21)];
        self.priceLabel.font = [UIFont systemFontOfSize:11];
        self.priceLabel.textColor = [UIColor redColor];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.priceLabel];
    }
    
    UILabel * priceTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 137, 41, 21)];
    priceTitle.textAlignment = NSTextAlignmentLeft;
    priceTitle.text = @"总价：";
    priceTitle.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:priceTitle];
    
    if (self.ico_image == nil) {
        self.ico_image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 34, 85, 85)];
        [self.contentView addSubview:self.ico_image];
    }
    if (self.icon2 == nil) {
        self.icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(110, 34, 85, 85)];
        [self.icon2 setHidden:YES];
        [self.contentView addSubview:self.icon2];
    }
    if (self.icon3 == nil) {
        self.icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(210, 34, 85, 85)];
        [self.icon3 setHidden:YES];
        [self.contentView addSubview:self.icon3];
    }
    if (_moreLabel == nil) {
        _moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(300, 50, 20, 20)];
        _moreLabel.text = @"......";
        [_moreLabel setHidden:YES];
        [self.contentView addSubview:_moreLabel];
    }
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.borderWidth = 1;
    bottomLayer.borderColor = btnBorderColor.CGColor;
    bottomLayer.frame = CGRectMake(0, 125, 320, 1);
    [self.contentView.layer addSublayer:bottomLayer];
    
    if (self.lookBtn == nil) {
        self.lookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.lookBtn.frame = CGRectMake(114, 133, 93, 25);
        self.lookBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.lookBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.lookBtn setBackgroundImage:[UIImage imageNamed:@"middle_green_btnbg_normal.png"] forState:UIControlStateNormal];
        [self.lookBtn setHidden:YES];
        [self.lookBtn addTarget:self action:@selector(btnLogisticsTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.lookBtn];
    }
    
    if (self.cancelBtn == nil) {
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.cancelBtn.frame = CGRectMake(114, 133, 93, 25);
        self.cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"middle_green_btnbg_normal.png"] forState:UIControlStateNormal];
        [self.cancelBtn setHidden:YES];
        [self.cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.cancelBtn];
    }
    
    if (self.ValidationBtn == nil) {
        self.ValidationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.ValidationBtn.frame = CGRectMake(218, 133, 93, 25);
        self.ValidationBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.ValidationBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.ValidationBtn setBackgroundImage:[UIImage imageNamed:@"middle_red_btnbg_normal.png"] forState:UIControlStateNormal];
        [self.ValidationBtn setHidden:YES];
        [self.ValidationBtn addTarget:self action:@selector(btnReceiverTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.ValidationBtn];
    }
    if (self.apprialBtn == nil) {
        self.apprialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.apprialBtn.frame = CGRectMake(218, 133, 93, 25);
        self.apprialBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.apprialBtn setTitle:@"去评价" forState:UIControlStateNormal];
        [self.apprialBtn setBackgroundImage:[UIImage imageNamed:@"middle_red_btnbg_normal.png"] forState:UIControlStateNormal];
        [self.apprialBtn setHidden:YES];
        [self.apprialBtn addTarget:self action:@selector(btnCommentTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.apprialBtn];
    }
    
    if (self.payBtn == nil) {
        self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.payBtn.frame = CGRectMake(218, 133, 93, 25);
        self.payBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [self.payBtn setTitle:@"立即付款" forState:UIControlStateNormal];
        [self.payBtn setBackgroundImage:[UIImage imageNamed:@"middle_red_btnbg_normal.png"] forState:UIControlStateNormal];
        [self.payBtn setHidden:YES];
        [self.payBtn addTarget:self action:@selector(btnPayTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.payBtn];
    }
    
    CALayer *bottom2Layer = [CALayer layer];
    bottom2Layer.borderWidth = 1;
    bottom2Layer.borderColor = btnBorderColor.CGColor;
    bottom2Layer.frame = CGRectMake(0, 165, 320, 1);
    [self.contentView.layer addSublayer:bottom2Layer];
    
    UILabel *specLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 165, 320, 5)];
    specLabel.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    [self.contentView addSubview:specLabel];
}



- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

-(void)creatOrderListTableViewCellWithOrderIntroModel:(OrderIntroModel *)intro{
    _currentIntro = intro;
    [self.cancelBtn setHidden:YES];
    [self.lookBtn setHidden:YES];
    [self.ValidationBtn setHidden:YES];
    [self.payBtn setHidden:YES];
    [self.apprialBtn setHidden:YES];
    
    UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
    self.statueLabel.text = [NSString stringWithFormat:@"%@",intro.OrderStatusStr];
    self.timeLabel.text = [NSString stringWithFormat:@"下单时间：%@", [intro.CreateTime substringToIndex:10]];
    self.nameLabel.text = [[intro.ProductList objectAtIndex:0] ProductName];
    
    CGRect textframe = self.nameLabel.frame;
    textframe.size.height = [self heightForString:[[intro.ProductList objectAtIndex:0] ProductName] fontSize:15 andWidth:self.nameLabel.frame.size.width];
    if (textframe.size.height > 40) {
        textframe.size.height = 40;
    }
    self.nameLabel.frame = textframe;
    
    self.priceLabel.text = [NSString stringWithFormat:@"AU$ %.2f", intro.DispatchPrice + intro.InsurePrice + intro.ProductPrice - intro.ScorePrice];
    [self.ico_image setImageWithURL:[[intro.ProductList objectAtIndex:0] ProductImg] placeholderImage:blankImg];
    
    AppConfig * appConfig = [AppConfig sharedAppConfig];
    [appConfig loadConfig];
    
    if ([intro.ProductList count] == 2) {
        [self.nameLabel setHidden:YES];
        [self.icon2 setHidden:NO];
//        [self.icon3 setHidden:NO];
//        [_moreLabel setHidden:NO];
        [self.icon2 setImageWithURL:[[intro.ProductList objectAtIndex:1] ProductImg] placeholderImage:blankImg];
//        [self.icon3 setImageWithURL:[[intro.ProductList objectAtIndex:2] ProductImg] placeholderImage:blankImg];
    }
    
    if ([intro.ProductList count] == 3) {
        [self.nameLabel setHidden:YES];
        [self.icon2 setHidden:NO];
        [self.icon3 setHidden:NO];
        [_moreLabel setHidden:NO];
        [self.icon2 setImageWithURL:[[intro.ProductList objectAtIndex:1] ProductImg] placeholderImage:blankImg];
        [self.icon3 setImageWithURL:[[intro.ProductList objectAtIndex:2] ProductImg] placeholderImage:blankImg];
    }
//    if(intro.OrderStatus == 0){
////        [self.payBtn setHidden:NO];
//        [self.cancelBtn setHidden:NO];
//    }
//    if(intro.OrderStatus == 2){
//        
//    }
//    
//    if (intro.OrderStatus == 3) {
//        
//    }
//    
//    if(intro.OrderStatus == 5 && intro.OrderStatus != 2 && intro.OrderStatus != 3){
////        [self.apprialBtn setHidden:NO];
//    }
//    if(intro.ShipmentStatus == 0){
//        
//    }
//    if(intro.ShipmentStatus == 1 && intro.OrderStatus != 2 && intro.OrderStatus != 3){
//        
//        NSDictionary *returnDic= [NSDictionary dictionaryWithObjectsAndKeys:
//                                  appConfig.appSign,@"AppSign",
//                                  appConfig.loginName, @"MemLoginID",
//                                  intro.Guid, @"OrderGuid", nil];
//        [RefundOrderModel getReturnOrderDetailWithparameters:returnDic andblock:^(RefundOrderModel *model, NSError *error) {
//            if (error) {
//                
//            }else {
//                if (model) {
//                    if (model.returnOrderStatue == 1){
//                        intro.OrderStatus = 5;
//                        self.statueLabel.text = @"订单状态：已完成";
//                        [self.ValidationBtn setHidden:YES];
//                        [self.lookBtn setHidden:YES];
//                    }else if (model.returnOrderStatue == 4){
//                        intro.OrderStatus = 5;
//                        self.statueLabel.text = @"订单状态：已完成";
//                        [self.ValidationBtn setHidden:YES];
//                        [self.lookBtn setHidden:YES];
//                    }else{
//                        self.statueLabel.text = @"订单状态：退货中";
//                        [self.ValidationBtn setHidden:YES];
//                        [self.lookBtn setHidden:YES];
//                    }
//                }else {
//                    
//                    [self.ValidationBtn setHidden:NO];
//                    [self.lookBtn setHidden:NO];
//                }
//            }
//        }];
//        
//        
//        
//    }
//    if(intro.ShipmentStatus == 2){
//        
//    }
//    if(intro.ShipmentStatus == 3){
//        
//    }
//    if(intro.ShipmentStatus == 4){
//        self.statueLabel.text = @"订单状态：已退货";
//    }
//    if(intro.PaymentStatus == 0 && intro.OrderStatus != 2 && intro.OrderStatus != 3){
//        
//        NSDictionary *paydic = [NSDictionary dictionaryWithObjectsAndKeys:
//                                appConfig.appSign, @"AppSign", nil];
//        [PaymentModel getPaymentwithParameters:paydic andbolock:^(NSArray *list, NSError *error) {
//            if (error) {
//                
//            }else{
//                NSString *PaymentType;
//                for (PaymentModel *model in list) {
//                    if ([intro.PaymentGuid isEqualToString:model.Guid]) {
//                        PaymentType = model.PaymentType;
//                    }
//                }
//                if ([PaymentType isEqualToString:@"Alipay.aspx"]) {
//                    [self.payBtn setHidden:NO];
//                }else{
//                    self.cancelBtn.frame = CGRectMake(218, 133, 93, 25);
//                }
    //            }
    //        }];
    //        [self.cancelBtn setHidden:NO];
    //    }
    if (intro.OrderStatus == 0) {// 未确定
//        OrderStatus = "待付款";
        self.cancelBtn.hidden = NO;
        self.payBtn.hidden = NO;
    }
    else if (intro.OrderStatus == 1)
    { //已确认
        if (intro.PaymentStatus == 0)
        { //未付款
//            OrderStatus = "待付款";
            self.cancelBtn.hidden = NO;
            self.payBtn.hidden = NO;
        }
        else if (intro.PaymentStatus == 2)
        {//付款中
            if (intro.ShipmentStatus == 0)
            {//发货状态 未发货
//                OrderStatus = "待发货";
                self.cancelBtn.hidden = NO;
                //加个退款
            }
            else if (intro.ShipmentStatus == 1)
            {// 已发货
                //退货状态
                if([intro.ReturnOrderStatus isEqualToString:@""])
                {
//                    OrderStatus = "待收货";
                    self.ValidationBtn.hidden = NO;
                    //加个退货
                }
                else{
                    //退款状态中
//                    OrderStatus = returnOrderStatus;
                }
            } else if (intro.ShipmentStatus == 2) {//已收货
//                OrderStatus = "已收货";
                self.apprialBtn.hidden = NO;
                //加个退货
                
            } else if (intro.ShipmentStatus == 3) {//配货中
//                OrderStatus = "配货中";
                self.cancelBtn.hidden = NO;
            } else if (intro.ShipmentStatus == 4) {//退货
//                OrderStatus = "已退货";
                //新加
            } else if (intro.ShipmentStatus == 5) {//完成
//                OrderStatus = "完成";
            }
        }
        else if (intro.PaymentStatus == 3)
        {
            if([intro.ReturnOrderStatus isEqualToString:@""]){
//                OrderStatus = "已退款";
            }else{
//                OrderStatus = returnOrderStatus;
            }
        }
    }
    else if (intro.OrderStatus == 2)
    {//已取消
        if (intro.PaymentStatus == 0)
        {//未付款
//            OrderStatus = "已取消";
        }
        else if (intro.PaymentStatus == 2)
        {//已付款
            if (intro.ShipmentStatus == 0)
            {//未发货
//                OrderStatus = "退款审核中";
            } else if(intro.ShipmentStatus == 1){//已发货
                
            }
        }else if(![intro.ReturnOrderStatus isEqualToString:@""]){
//            OrderStatus = returnOrderStatus;
        }
    }
    else if (intro.OrderStatus == 5)
    {
        if (intro.PaymentStatus == 2)
        {
            if (intro.ShipmentStatus == 2) {
//                OrderStatus = "交易成功";
            }
            else if (intro.ShipmentStatus == 4) {
//                OrderStatus = "已退货";
            }
        }
    }
}


-(void)creatOrderListTableViewCellWithScoreOrderIntroModel:(ScoreOrderIntroModel *)intro{
    _currentIntro = intro;
    [self.cancelBtn setHidden:YES];
    [self.lookBtn setHidden:YES];
    [self.ValidationBtn setHidden:YES];
    [self.payBtn setHidden:YES];
    [self.apprialBtn setHidden:YES];
    
    UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
    self.statueLabel.text = [NSString stringWithFormat:@"%@",intro.OrderStatusStr];
    self.timeLabel.text = [NSString stringWithFormat:@"下单时间：%@", [intro.CreateTime substringToIndex:10]];
    self.nameLabel.text = [[intro.ScoreProductList objectAtIndex:0] Name];
    
    CGRect textframe = self.nameLabel.frame;
    textframe.size.height = [self heightForString:[[intro.ScoreProductList objectAtIndex:0] Name] fontSize:15 andWidth:self.nameLabel.frame.size.width];
    if (textframe.size.height > 40) {
        textframe.size.height = 40;
    }
    self.nameLabel.frame = textframe;
    
    self.priceLabel.text = [NSString stringWithFormat:@"AU$ %.2f", intro.TotaltPrice];
    [self.ico_image setImageWithURL:[[intro.ScoreProductList objectAtIndex:0] ProductImg] placeholderImage:blankImg];
    
    AppConfig * appConfig = [AppConfig sharedAppConfig];
    [appConfig loadConfig];
    
    if ([intro.ScoreProductList count] == 2) {
        [self.nameLabel setHidden:YES];
        [self.icon2 setHidden:NO];
        //        [self.icon3 setHidden:NO];
        //        [_moreLabel setHidden:NO];
        [self.icon2 setImageWithURL:[[intro.ScoreProductList objectAtIndex:1] ProductImg] placeholderImage:blankImg];
        //        [self.icon3 setImageWithURL:[[intro.ProductList objectAtIndex:2] ProductImg] placeholderImage:blankImg];
    }
    
    if ([intro.ScoreProductList count] == 3) {
        [self.nameLabel setHidden:YES];
        [self.icon2 setHidden:NO];
        [self.icon3 setHidden:NO];
        [_moreLabel setHidden:NO];
        [self.icon2 setImageWithURL:[[intro.ScoreProductList objectAtIndex:1] ProductImg] placeholderImage:blankImg];
        [self.icon3 setImageWithURL:[[intro.ScoreProductList objectAtIndex:2] ProductImg] placeholderImage:blankImg];
    }
    
    
    if(intro.OrderStatus == 0){
        //        [self.payBtn setHidden:NO];
        [self.cancelBtn setHidden:NO];
    }
    if(intro.OrderStatus == 2){
        
    }
    
    if (intro.OrderStatus == 3) {
        
    }
    
    if(intro.OrderStatus == 5 && intro.OrderStatus != 2 && intro.OrderStatus != 3){
        //        [self.apprialBtn setHidden:NO];
    }
    if(intro.ShipmentStatus == 0){
        
    }
    if(intro.ShipmentStatus == 1 && intro.OrderStatus != 2 && intro.OrderStatus != 3){
        
        [self.ValidationBtn setHidden:NO];
//        [self.lookBtn setHidden:NO];
    }
    if(intro.ShipmentStatus == 2){
        
    }
    if(intro.ShipmentStatus == 3){
        
    }
    if(intro.ShipmentStatus == 4){
        self.statueLabel.text = @"订单状态：已退货";
    }
    if(intro.PaymentStatus == 0 && intro.OrderStatus != 2 && intro.OrderStatus != 3){
        
        NSDictionary *paydic = [NSDictionary dictionaryWithObjectsAndKeys:
                                appConfig.appSign, @"AppSign", nil];
        [PaymentModel getPaymentwithParameters:paydic andbolock:^(NSArray *list, NSError *error) {
            if (error) {
                
            }else{
                NSString *PaymentType;
                for (PaymentModel *model in list) {
                    if ([intro.PaymentGuid isEqualToString:model.Guid]) {
                        PaymentType = model.PaymentType;
                    }
                }
                if ([PaymentType isEqualToString:@"Alipay.aspx"]) {
                    [self.payBtn setHidden:NO];
                }else{
                    self.cancelBtn.frame = CGRectMake(218, 133, 93, 25);
                }
            }
        }];
        [self.cancelBtn setHidden:NO];
    }
}


- (void)btnPayTouch:(id)sender{
    
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(viewPayWith:)]){
            [self.delegate viewPayWith:_currentIntro];
        }
    }
}

-(void)cancelBtnClick:(id)sender{
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(cancelOrder:)]){
            [self.delegate cancelOrder:_currentIntro];
        }
    }

}

- (IBAction)btnLogisticsTouch:(id)sender{
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(viewWuliuWith:)]){
            [self.delegate viewWuliuWith:_currentIntro];
        }
    }
}


- (IBAction)btnReceiverTouch:(id)sender{
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(confirmReceiver:)]){
            [self.delegate confirmReceiver:_currentIntro];
        }
    }
}

- (IBAction)btnCommentTouch:(id)sender{
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(commentProduct:)]){
            [self.delegate commentProduct:_currentIntro];
        }
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
