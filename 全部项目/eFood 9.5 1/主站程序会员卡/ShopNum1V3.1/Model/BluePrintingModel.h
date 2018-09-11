//
//  BluePrintingModel.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-10.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BluePrintingModel : NSObject

//{
//    "Guid": "3cdc3bf3-9e07-4dea-af26-efa2b05619e8",
//    "MemLoginID": "jerry",
//    "ProductGuid": "0c06ac6c-c074-46bc-87b4-cbf9b72bd390",
//    "OrderNumber": "201409050733944",
//    "Name": "华为 荣耀 3X pro （白色）3G手机 TD-SCDMA/WCDMA/GSM 双卡双待",
//    "Title": "手机不错很喜欢哦，功能机型都很赞。",
//    "Content": "终于找到家好店，服务好，质量不错，下次有机会再来买",
//    "Image": "/ImgUpload/201409050612545.jpg",
//    "IsAudit": 1,
//    "CreateTime": "2014/09/05 18:13:21",
//    "CreateUser": "jerry",
//    "ModifyUser": "jerry",
//    "ModifyTime": "2014/09/05 18:13:21",
//    "IsDeleted": 0,
//    "IsAgentId": ""
//}

@property (nonatomic, readonly) NSString *guid;

@property (nonatomic, readonly) NSString *ProductGuid;

@property (nonatomic, readonly) NSString *comment;

@property (nonatomic, readonly) NSDate *commentTime;

@property (nonatomic, readonly) NSString *commentTimeStr;

@property (nonatomic, readonly) NSString *memberLoginID;

@property (nonatomic, readonly) NSString *commentImageStr;

@property (nonatomic, readonly) NSString *commenttitle;

@property (nonatomic, strong) NSArray *commentImages;

- (id)initWithAttribute:(NSDictionary *)attribute;


///获取晒单列表
+ (void)getMerchandisePictureListByParameters:(NSDictionary *)parameters andblock:(void(^)(NSArray *List,NSInteger count, NSError *error))block;

///添加晒单列表
+ (void)addBluePrintingByParameters:(NSDictionary *)parameters andblock:(void(^)(NSInteger result, NSError *error))block;

+ (void)uploadData:(NSArray *)datas withNameID:(NSString *)nameID;

@end
