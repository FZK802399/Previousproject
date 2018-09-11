//
//  OrderDetailModel.m
//  Shop
//
//  Created by Ocean Zhang on 5/2/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "OrderDetailModel.h"
#import "AFAppAPIClient.h"
#import "AppConfig.h"

@implementation OrderDetailModel

@synthesize Guid = _Guid;
@synthesize OrderNumber = _OrderNumber;
@synthesize OrderStatus = _OrderStatus;
@synthesize OrderStatusStr = _OrderStatusStr;
@synthesize ShipmentStatus = _ShipmentStatus;
@synthesize ShipmentStatusStr = _ShipmentStatusStr;
@synthesize PaymentStatus = _PaymentStatus;
@synthesize PaymentStatusStr = _PaymentStatusStr;
@synthesize Name = _Name;
@synthesize Email = _Email;
@synthesize Address = _Address;
@synthesize PostalCode = _PostalCode;
@synthesize Tel = _Tel;
@synthesize Mobile = _Mobile;
@synthesize PaymentName = _PaymentName;
@synthesize PaymentGuid = _PaymentGuid;
@synthesize paymentModel = _paymentModel;
@synthesize ProductPrice = _ProductPrice;
@synthesize ShouldPayPrice = _ShouldPayPrice;
@synthesize CreateTime = _CreateTime;
@synthesize PayTime = _PayTime;
@synthesize ProductList = _ProductList;
@synthesize ReturnProductList = _ReturnProductList;
@synthesize ShopName = _ShopName;
@synthesize ShopID = _ShopID;
@synthesize PostType = _PostType;
@synthesize PostTypeStr = _PostTypeStr;
@synthesize LogisticsCompanyCode = _LogisticsCompanyCode;
@synthesize ShipmentNumber = _ShipmentNumber;
@synthesize ShopID2 = _ShopID2;
@synthesize DispatchPrice = _DispatchPrice;
@synthesize RefundStatus = _RefundStatus;
@synthesize RefundStatusStr = _RefundStatusStr;

- (id)initWithAttributes:(NSDictionary *)attributes{
    self = [super init];
    if(self){
        _Guid = [attributes objectForKey:@"Guid"];
        _OrderNumber = [attributes objectForKey:@"OrderNumber"];
        _OrderStatus = [[attributes objectForKey:@"OderStatus"] intValue];
        _ShipmentStatus = [[attributes objectForKey:@"ShipmentStatus"] intValue];
        _PaymentStatus = [[attributes objectForKey:@"PaymentStatus"] intValue];
        _Name = [attributes objectForKey:@"Name"];
        _Email = [attributes objectForKey:@"Email"];
        _Address = [attributes objectForKey:@"Address"];
        _PostalCode = [attributes objectForKey:@"Postalcode"];
        _Tel = [attributes objectForKey:@"Tel"];
        _Mobile = [attributes objectForKey:@"Mobile"];
        _PaymentName = [attributes objectForKey:@"PaymentName"];
        _PayTypeName = [attributes objectForKey:@"PayTypeName"];
        _PaymentGuid = [attributes objectForKey:@"PaymentGuid"];
        _ProductPrice = [[attributes objectForKey:@"ProductPrice"] doubleValue];
        _ScorePrice = [[attributes objectForKey:@"ScorePrice"] doubleValue];
        
        _ShouldPayPrice = [[attributes objectForKey:@"ShouldPayPrice"] doubleValue] == 0 ? [[attributes objectForKey:@"AlreadPayPrice"] doubleValue] : [[attributes objectForKey:@"ShouldPayPrice"] doubleValue];;
        _AlreadPayPrice = [[attributes objectForKey:@"AlreadPayPrice"] doubleValue];
        _SurplusPrice = [[attributes objectForKey:@"SurplusPrice"] doubleValue];
        
        _CreateTime = [attributes objectForKey:@"CreateTime"];
        _PayTime = [attributes objectForKey:@"PayTime"];
        NSArray *tempArr = [attributes objectForKey:@"ProductList"];
        _ProductList = [[NSMutableArray alloc] initWithCapacity:[tempArr count]];
        _ReturnProductList = [[NSMutableArray alloc] initWithCapacity:[tempArr count]];
        _ShopName = [attributes objectForKey:@"ShopName"];
        _ShopID = [attributes objectForKey:@"ShopID"];
        _PostType = [[attributes objectForKey:@"PostType"] intValue];
        _LogisticsCompanyCode = [attributes objectForKey:@"LogisticsCompanyCode"];
        _ShipmentNumber = [attributes objectForKey:@"ShipmentNumber"];
        _ShopID2 = [attributes objectForKey:@"ShopID2"];
        for (NSDictionary *dict in tempArr) {
            OrderMerchandiseIntroModel *merchandise = [[OrderMerchandiseIntroModel alloc] initWithAttributes:dict andOrderNum:_OrderNumber];
            [_ProductList addObject:merchandise];
            ReturnMerchandiseModel * returnModel = [[ReturnMerchandiseModel alloc] initWithAttributes:dict];
            [_ReturnProductList addObject:returnModel];
        }
        _PostModel = [attributes objectForKey:@"DispatchMode"] == [NSNull null] ? nil:[[PostageModel alloc] initWithAttribute:[attributes objectForKey:@"DispatchMode"]];
        _paymentModel = [attributes objectForKey:@"Payment"] == [NSNull null] ? nil:[[PaymentModel alloc] initWithAttribute:[attributes objectForKey:@"Payment"]];
        _DispatchPrice = [attributes objectForKey:@"DispatchPrice"]== [NSNull null] ? 0 : [[attributes objectForKey:@"DispatchPrice"] floatValue];
        _InsurePrice = [attributes objectForKey:@"InsurePrice"]== [NSNull null] ? 0 :[[attributes objectForKey:@"InsurePrice"] floatValue];
        _RefundStatus = [attributes objectForKey:@"RefundStatus"] == [NSNull null] ? -1 : [[attributes objectForKey:@"RefundStatus"] intValue];
        
        _ClientToSellerMsg = [attributes objectForKey:@"ClientToSellerMsg"] == [NSNull null] ?@"":[attributes objectForKey:@"ClientToSellerMsg"];
        _InvoiceType = [attributes objectForKey:@"InvoiceType"] == [NSNull null] ? 0 : [[attributes objectForKey:@"InvoiceType"] integerValue];;
        _InvoiceTitle = [attributes objectForKey:@"InvoiceTitle"] == [NSNull null] ? @"" : [attributes objectForKey:@"InvoiceTitle"];
        _InvoiceContent = [attributes objectForKey:@"InvoiceContent"] == [NSNull null] ? @"" : [attributes objectForKey:@"InvoiceContent"];
                
        //"InvoiceType": "0",
        //"InvoiceTitle": "",
        //"InvoiceContent": "",
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
    if(_OrderStatus == 0)
        return @"订单状态：未确认";
    if(_OrderStatus == 2)
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
    if(_ShipmentStatus == 4)
        return @"订单状态：已退货";
    
    
    return @"";
}

- (NSString *)ShipmentStatusStr{
    switch (_ShipmentStatus) {
        case 0:
            return @"未发货";
        case 1:
            return @"已发货";
        case 2:
            return @"已收货";
        case 3:
            return @"退货";
        default:
            return @"";
    }
}

- (NSString *)PaymentStatusStr{
    switch (_PaymentStatus) {
        case 0:
            return @"未付款";
        case 1:
            return @"已付款";
        case 2:
            return @"已收货";
        case 3:
            return @"退款成功";
        case 4:
            return @"卖家拒绝退款";
        default:
            return @"";
    }
}

- (NSString *)PostTypeStr{
    switch (_PostType) {
        case 0:
            return [NSString stringWithFormat:@"AU$%.2f",_DispatchPrice];
        case 1:
            return [NSString stringWithFormat:@"平邮 AU$%.2f",_DispatchPrice];
        case 2:
            return [NSString stringWithFormat:@"快递 AU$%.2f",_DispatchPrice];
        case 3:
            return [NSString stringWithFormat:@"EMS AU$%.2f",_DispatchPrice];
        default:
            return @"";
    }
}

///获取订单详情
+ (void)getOrderDetailWithparameters:(NSDictionary *)parameters andblock:(void (^)(OrderDetailModel *, NSError *))block{
    
    [[AFAppAPIClient sharedClient] getPath:kWebGetOrderDetailPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        NSDictionary *response = [JSON objectForKey:@"Orderinfo"];
        
        OrderDetailModel *model = [[OrderDetailModel alloc] initWithAttributes:response];
        
        if(block){
            block(model, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil, error);
        }
    }];
}

+ (void)cancelOrderWithparameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebCancelOrderPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
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

+ (void)confirmReceiptWithGuid:(NSString *)orderGuid orderNum:(NSString *)orderNum andblock:(void (^)(BOOL, NSError *))block{
    AppConfig *config = [AppConfig sharedAppConfig];
    [config loadConfig];
    
    NSString *url = [NSString stringWithFormat:@"api/order/UpdateShipmentStatus/%@/%@?OrderNumber=%@",orderGuid,config.loginName,orderNum];
    NSString *utfUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFAppAPIClient sharedClient2] getPath:utfUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON){
        BOOL result = [[JSON objectForKey:@"return"] boolValue];
        
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(-1, error);
        }
    }];
}


+(void)AddReturnOrderWithParameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
//    NSError *testError;
//    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
//    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",testStr);
    
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    //    @"/api/orderpricecaculate/"
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebaddreturnorderPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
        
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation,NSError *error){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        if(block){
            block(NO, error);
        }
    }];
}

@end
