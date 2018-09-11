//
//  PayMentListModel.h
//  ShopNum1V3.1
//
//  Created by yons on 15/11/19.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>
/// 支付方式
@interface PayMentListModel : NSObject
@property(nonatomic,strong)NSString * Guid;
///支付方式
@property(nonatomic,strong)NSString * PaymentType;
///中文名
@property(nonatomic,strong)NSString * NAME;
///商业代码
@property(nonatomic,strong)NSString * MerchantCode;
@property(nonatomic,strong)NSString * IsCOD;
@property(nonatomic,strong)NSString * ForAdvancePayment;
@property(nonatomic,strong)NSString * OrderID;
@property(nonatomic,strong)NSString * IsPercent;
@property(nonatomic,strong)NSString * Charge;
///公钥
@property(nonatomic,strong)NSString * Public_Key;
///私钥
@property(nonatomic,strong)NSString * Private_Key;
///合作身份者ID
@property(nonatomic,strong)NSString * Partner;
@property(nonatomic,strong)NSString * Email;
@property(nonatomic,strong)NSString * SecretKey;
//@property(nonatomic,strong)NSString * Support_Wap;
//@property(nonatomic,strong)NSString * Support_WeiXin;
//@property(nonatomic,strong)NSString * Support_IOS;
//@property(nonatomic,strong)NSString * Support_Android;
///是否选中
@property(nonatomic,assign)BOOL isSelected;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)modelWithDict:(NSDictionary *)dict;
///获取支付方式列表
+(void)getListWithBlock:(void(^)(NSArray * List,NSError * error))block;
///更改支付类型
+(void)upDatePayMentWithDict:(NSDictionary *)dict block:(void(^)(NSInteger result,NSError * error))block;
@end

//"Guid": "b34fd9b0-cce1-418a-8ef5-11f3f0df06cd",
//"PaymentType": "AlipaySDK.aspx",
//"NAME": "支付宝SDK支付",
//"MerchantCode": "2088911093365661",
//"IsCOD": 0,
//"ForAdvancePayment": 1,
//"OrderID": 58,
//"IsPercent": 0,
//"Charge": 0.00,
//"Public_Key": "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCzxWH2MAl7YNQ5GxKsJrjJfYzkMzTb/NVa8PCbjtVJ7L2+bKvP+1aDjd3LfDybVP+SHN1cnOxLT6rk0TdEU08zCN6EbQIl6qrN+ByfYwppNwdz4g5abV/TClHWaZzZE7FNO1gBeR9H2qJ/N2nujztOVMNOKqyD3VW1ttJtyBaPPQIDAQAB",
//"Private_Key": "MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALPFYfYwCXtg1DkbEqwmuMl9jOQzNNv81Vrw8JuO1Unsvb5sq8/7VoON3ct8PJtU/5Ic3Vyc7EtPquTRN0RTTzMI3oRtAiXqqs34HJ9jCmk3B3PiDlptX9MKUdZpnNkTsU07WAF5H0faon83ae6PO05Uw04qrIPdVbW20m3IFo89AgMBAAECgYEAmzOZc3XdecsK7ZJV+JIljq756DndNN9/Q1goIeSad4wP9ErVumV/N2xPQ9IqcOBdFMQeyEoiJpLNM2b8k9xozm5hvro7r2o+QpPRA5VGg59i0sSjJb3t5TRCspOVakCcFBqFAZX6atdy366ui3jX7VVZR9BBKYs8DlwQLATLgPECQQDtC/Rg6QRJeT2ERTBmMvoT0mECILSkD+XFrJUTkOHjaQCPzmhNCi5u9E1NM1jU8syWg2qAGS7DC+/L26VeuliPAkEAwiURUsLQMmNwe0giWWeZ0p9tcN5hR5E/VYN4lG53VVGr0apfslp7/lKtDGirz3Fc46o6v4wH24QiAFObxuBJcwJANQDdTeYMfVlMtgy6e7+eR1xdMJqbiau8Vuz2EH/u4miSJZWjoMZMB6c8uaxnioYX1Pfhkm8PE7HRlqWwXnQQZQJALfYOitQ566Pk7hqenyHKpbU+eHj8+K9nGfx84E7ii11BWuqFqziGoCe8dfKVsg95WSBkthIVjh9S2VbxyvwwBwJBAIOCsJtNWmbB9F1zcz2S/8e7DkJMfqqlpdIuB7Hcyt6ZTcd6/nJwc9WttkJPMHkSvV3vu/jtOmjqFBVosiaiOLY=",
//"Partner": "1",
//"Email": "gdjlgf@126.com",
//"SecretKey": "dk0rm06i5jh8d0nlwqr1h3l34hjmpdun",
//"Support_Wap": 0,
//"Support_WeiXin": 1,
//"Support_IOS": 1,
//"Support_Android": 1