//
//  OrderIntroModel.m
//  Shop
//
//  Created by Ocean Zhang on 4/17/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "OrderIntroModel.h"
#import "AFAppAPIClient.h"
#import "AppConfig.h"

@implementation OrderIntroModel

@synthesize Guid = _Guid;
@synthesize OrderNumber = _OrderNumber;
@synthesize OrderStatus = _OrderStatus;
@synthesize StatusName = _StatusName;
@synthesize OrderStatusStr = _OrderStatusStr;
@synthesize Name = _Name;
@synthesize ProductPrice = _ProductPrice;
@synthesize ShouldPayPrice = _ShouldPayPrice;
@synthesize CreateTime = _CreateTime;
@synthesize PayTime = _PayTime;
@synthesize ProductList = _ProductList;
@synthesize ShopName = _ShopName;
@synthesize ShipmentStatus = _ShipmentStatus;
@synthesize LogisticsCompanyCode = _LogisticsCompanyCode;
@synthesize ShipmentNumber = _ShipmentNumber;
@synthesize IsBuyComment = _IsBuyComment;
@synthesize RefundStatus = _RefundStatus;
@synthesize RefundStatusStr = _RefundStatusStr;
@synthesize DispatchPrice = _DispatchPrice;
@synthesize ScorePrice = _ScorePrice;


- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        
        _Guid = [attributes objectForKey:@"Guid"];
        _OrderNumber = [attributes objectForKey:@"OrderNumber"];
        _OrderStatus = [[attributes objectForKey:@"OderStatus"] intValue];
        _StatusName = [attributes objectForKey:@"StatusName"];
        _Name = [attributes objectForKey:@"Name"];
        _ProductPrice = [[attributes objectForKey:@"ProductPrice"] doubleValue];
        _ShouldPayPrice = [[attributes objectForKey:@"ShouldPayPrice"] doubleValue] == 0 ? [[attributes objectForKey:@"AlreadPayPrice"] floatValue] : [[attributes objectForKey:@"ShouldPayPrice"] floatValue];
        _InsurePrice = [attributes objectForKey:@"InsurePrice"] == [NSNull null] ? 0 :[[attributes objectForKey:@"InsurePrice"] doubleValue];
        _DispatchPrice = [attributes objectForKey:@"DispatchPrice"] == [NSNull null] ? 0 :[[attributes objectForKey:@"DispatchPrice"] doubleValue];
        _ScorePrice = [attributes objectForKey:@"ScorePrice"] == [NSNull null] ? 0 :[[attributes objectForKey:@"ScorePrice"] doubleValue];
        _CreateTime = [attributes objectForKey:@"CreateTime"];
        _PayTime = [attributes objectForKey:@"PayTime"];
        NSArray *tempArr = [attributes objectForKey:@"ProductList"];
        _ProductList = [[NSMutableArray alloc] initWithCapacity:[tempArr count]];
        _ShopName = [attributes objectForKey:@"ShopName"];
        _ShipmentStatus = [[attributes objectForKey:@"ShipmentStatus"] intValue];
        _LogisticsCompanyCode = [attributes objectForKey:@"LogisticsCompanyCode"]  == [NSNull null] ? @"" : [attributes objectForKey:@"LogisticsCompanyCode"];
        _ShipmentNumber = [attributes objectForKey:@"ShipmentNumber"] == [NSNull null] ? @"" : [attributes objectForKey:@"ShipmentNumber"];
        
//        _IsBuyComment = [attributes objectForKey:@"IsComment"] == [NSNull null] ? 0 : [[attributes objectForKey:@"IsBuyComment"] integerValue];
        NSNumber * num = [attributes objectForKey:@"IsComment"];
        _IsBuyComment = num.boolValue;
        _RefundStatus = [attributes objectForKey:@"RefundStatus"] == [NSNull null] ? -1 : [[attributes objectForKey:@"RefundStatus"] intValue];
        
        _PaymentStatus = [attributes objectForKey:@"PaymentStatus"] == [NSNull null] ? -1 :[[attributes objectForKey:@"PaymentStatus"] intValue];
        
         _PayType = [attributes objectForKey:@"PayType"] == [NSNull null] ? -1 :[[attributes objectForKey:@"PayType"] intValue];
        
        _PaymentGuid = [attributes objectForKey:@"PaymentGuid"];
        
        _PayTypeName = [attributes objectForKey:@"PayTypeName"];
        
        _ReturnOrderStatus = [attributes objectForKey:@"ReturnOrderStatus"];
        
        _AlreadPayPrice = [[attributes objectForKey:@"AlreadPayPrice"] doubleValue];
        _SurplusPrice = [[attributes objectForKey:@"SurplusPrice"] doubleValue];
        
        for (NSDictionary *dict in tempArr) {
            OrderMerchandiseIntroModel *merchandise = [[OrderMerchandiseIntroModel alloc] initWithAttributes:dict andOrderNum:_OrderNumber];
            [_ProductList addObject:merchandise];
        }
    }
    return self;
}

- (NSString *)RefundStatusStr{
    switch (_RefundStatus) {
        case -1:
            return @"申请退货/退款";
        case 0:
            return @"正在进行退货/退款";
         case 2:
            return @"退货/退款失败";
        default:
            return @"";
    }
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

+ (void)getOrderListWithParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebGetOrderListPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSArray *response = [JSON objectForKey:@"Data"];
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            OrderIntroModel *order = [[OrderIntroModel alloc] initWithAttributes:dict];
            [list addObject:order];
        }
        
        if(block){
            block(list, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil, error);
        }
    }];
}

+(void)UpdateOrderStatueWithParameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebUpdateShipmentStatusPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(-1, error);
        }
    }];

}

@end
