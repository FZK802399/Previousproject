//
//  BiJiaModel.h
//  ShopNum1V3.1
//
//  Created by yons on 16/1/23.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BiJiaModel : NSObject
///名称
@property (nonatomic,strong)NSString * titleName;
///价格
@property (nonatomic,strong)NSString * price;
///销量
@property (nonatomic,strong)NSString * sellNumber;
///详情
@property (nonatomic,strong)NSString * infoUrl;
///来源
@property (nonatomic,strong)NSString * source;

-(instancetype)initWithDict:(NSDictionary *)Dict;
+(instancetype)modelWithDict:(NSDictionary *)Dict;
@end

//    commentNumber = "\U6570\U636e\U5f02\U5e38";
//    date = "<null>";
//    infoUrl = "\U6570\U636e\U5f02\U5e38";
//    price = "0.00";
//    sellNumber = "<null>";
//    source = "\U888b\U9f20\U8d2d";
//    titleName = "\U6570\U636e\U5f02\U5e38";