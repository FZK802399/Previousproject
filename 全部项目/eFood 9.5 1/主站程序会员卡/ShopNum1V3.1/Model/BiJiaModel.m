//
//  BiJiaModel.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/23.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "BiJiaModel.h"

@implementation BiJiaModel
///名称
//@property (nonatomic,strong)NSString * titleName;
/////价格
//@property (nonatomic,strong)NSString * price;
/////销量
//@property (nonatomic,strong)NSString * sellNumber;
/////详情
//@property (nonatomic,strong)NSString * infoUrl;
/////来源
//@property (nonatomic,strong)NSString * source;

-(instancetype)initWithDict:(NSDictionary *)Dict
{
    self = [super init];
    if (self) {
        _titleName = [Dict objectForKey:@"titleName"] == [NSNull null] ? @"" : [Dict objectForKey:@"titleName"];
        _price = [Dict objectForKey:@"price"] == [NSNull null] ? @"" : [Dict objectForKey:@"price"];
        _sellNumber = [Dict objectForKey:@"sellNumber"] == [NSNull null] ? @"" : [Dict objectForKey:@"sellNumber"];
        _infoUrl = [Dict objectForKey:@"infoUrl"] == [NSNull null] ? @"" : [Dict objectForKey:@"infoUrl"];
        _source = [Dict objectForKey:@"source"] == [NSNull null] ? @"" : [Dict objectForKey:@"source"];
    }
    return self;
}


+(instancetype)modelWithDict:(NSDictionary *)Dict
{
    return [[BiJiaModel alloc]initWithDict:Dict];
}

@end

