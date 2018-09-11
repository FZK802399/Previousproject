//
//  ScoreOrderDetailModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-27.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ScoreOrderDetailModel.h"
#import "OrderMerchandiseIntroModel.h"

@implementation ScoreOrderDetailModel

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _Guid = [attributes objectForKey:@"Guid"];
        _OrderNumber = [attributes objectForKey:@"OrderNumber"];
        _OrderStatus = [[attributes objectForKey:@"OderStatus"] intValue];
        _Name = [attributes objectForKey:@"Name"];
        _TotaltPrice = [[attributes objectForKey:@"TotaltPrice"] floatValue];
        _prmo = [[attributes objectForKey:@"prmo"] floatValue] ;
        _InsurePrice = [attributes objectForKey:@"InsurePrice"] == [NSNull null] ? 0 :[[attributes objectForKey:@"InsurePrice"] floatValue];
        _DispatchPrice = [attributes objectForKey:@"DispatchPrice"] == [NSNull null] ? 0 :[[attributes objectForKey:@"DispatchPrice"] floatValue];
        _PaymentPrice = [attributes objectForKey:@"PaymentPrice"] == [NSNull null] ? 0 :[[attributes objectForKey:@"PaymentPrice"] floatValue];
        _CreateTime = [attributes objectForKey:@"CreateTime"];
        _PayTime = [attributes objectForKey:@"PayTime"];
        NSArray *tempArr = [attributes objectForKey:@"ScoreOrderProductList"];
        _ScoreProductList = [[NSMutableArray alloc] initWithCapacity:[tempArr count]];
        _CostTotalScore = [[attributes objectForKey:@"CostTotalScore"] integerValue];
        _ShipmentStatus = [[attributes objectForKey:@"ShipmentStatus"] intValue];
        _LogisticsCompanyCode = [attributes objectForKey:@"LogisticsCompanyCode"]  == [NSNull null] ? @"" : [attributes objectForKey:@"LogisticsCompanyCode"];
        _ShipmentNumber = [attributes objectForKey:@"ShipmentNumber"] == [NSNull null] ? @"" : [attributes objectForKey:@"ShipmentNumber"];
        _DispatchModeName = [attributes objectForKey:@"DispatchModeName"];
        _SellerToClientMsg = [attributes objectForKey:@"SellerToClientMsg"];
        _ClientToSellerMsg = [attributes objectForKey:@"ClientToSellerMsg"];
        
        _Email = [attributes objectForKey:@"Email"];
        _Address = [attributes objectForKey:@"Address"];
        _PostalCode = [attributes objectForKey:@"PostalCode"];
        _Tel = [attributes objectForKey:@"Tel"];
        _Mobile = [attributes objectForKey:@"Mobile"];
        
        _RefundStatus = [attributes objectForKey:@"RefundStatus"] == [NSNull null] ? -1 : [[attributes objectForKey:@"RefundStatus"] intValue];
        
        _PaymentStatus = [attributes objectForKey:@"PaymentStatus"] == [NSNull null] ? -1 :[[attributes objectForKey:@"PaymentStatus"] intValue];
        
        
        _PaymentGuid = [attributes objectForKey:@"PaymentGuid"];
        _PaymentName = [attributes objectForKey:@"PaymentName"];
        
        for (NSDictionary *dict in tempArr) {
            OrderMerchandiseIntroModel *merchandise = [[OrderMerchandiseIntroModel alloc] initWithAttributes:dict andOrderNum:_OrderNumber];
            [_ScoreProductList addObject:merchandise];
        }
    }
    return self;
}

- (NSString *)OrderStatusStr{
    
    //    NSString * currentOrderStatus = @"";
    //
    //    switch (_ShipmentStatus) {
    //        case 0:
    //            currentOrderStatus = @"订单状态：待发货";
    //            break;
    //        case 1:
    //            currentOrderStatus = @"订单状态：已发货";
    //            break;
    //        case 2:
    //            currentOrderStatus = @"订单状态：已完成";
    //            break;
    //        case 3:
    //            currentOrderStatus = @"订单状态：配货中";
    //            break;
    //        case 4:
    //            currentOrderStatus = @"订单状态：已退货";
    //            break;
    //        default:
    //            break;
    //    }
    //
    //    switch (_RefundStatus) {
    //        case 0:
    //            currentOrderStatus = @"订单状态：退货审核中";
    //            break;
    //        case 2:
    //            currentOrderStatus = @"订单状态：同意退货";
    //            break;
    //        case 3:
    //            currentOrderStatus = @"订单状态：退货中";
    //            break;
    //        default:
    //            break;
    //    }
    //
    //    if(_PaymentStatus == 0){
    //        if(_PayType == 0){
    //            if(_OrderStatus == 1){
    //                currentOrderStatus = @"订单状态：待发货";
    //            } else {
    //                currentOrderStatus = @"订单状态：商家确认";
    //            }
    //        } else {
    //            currentOrderStatus = @"订单状态：未付款";
    //        }
    //    }
    //
    //    switch (_OrderStatus) {
    //        case 2:
    //            currentOrderStatus = @"订单状态：已取消";
    //            break;
    //        case 3:
    //            currentOrderStatus = @"订单状态：已取消";
    //            break;
    //        case 4:
    //            currentOrderStatus = @"订单状态：已完成";
    //            break;
    //        case 5:
    //            currentOrderStatus = @"订单状态：已完成";
    //            break;
    //        default:
    //            break;
    //    }
    //
    //    if (_ShipmentStatus == 4) {
    //        currentOrderStatus = @"订单状态：已退货";
    //    }
    //
    //
    //    return currentOrderStatus;
    
    if(_OrderStatus == 0)
        return @"订单状态：未确认";
    if(_ShipmentStatus == 4)
        return @"订单状态：已退货";
    if(_OrderStatus == 2)
        return @"订单状态：已取消";
    if(_OrderStatus == 3)
        return @"订单状态：已取消";
    if(_OrderStatus == 5)
        return @"订单状态：已完成";
    if(_PaymentStatus == 0)
        return @"订单状态：未付款";
    if(_ShipmentStatus == 0)
        return @"订单状态：待发货";
    if(_ShipmentStatus == 1)
        return @"订单状态：已发货";
    if(_ShipmentStatus == 2)
        return @"订单状态：已收货";
    if(_ShipmentStatus == 3)
        return @"订单状态：配货中";
    return @"";
}



+(void)getScoreOrderDetailWithparameters:(NSDictionary *)parameters andblock:(void (^)(ScoreOrderDetailModel *, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebServiceGetScoreOrderDetailPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSDictionary *response = [JSON objectForKey:@"DATA"];
        
        ScoreOrderDetailModel *model = [[ScoreOrderDetailModel alloc] initWithAttributes:response];
        
        if(block){
            block(model, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil, error);
        }
    }];

}



@end
