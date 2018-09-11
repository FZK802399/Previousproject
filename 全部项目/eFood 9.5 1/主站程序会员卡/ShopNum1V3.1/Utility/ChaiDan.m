//
//  ChaiDan.m
//  拆单
//
//  Created by yons on 16/1/20.
//  Copyright (c) 2016年 dzy_PC. All rights reserved.
//

#import "ChaiDan.h"

@interface ChaiDan ()
@property (nonatomic,strong)NSMutableArray * singleArr;
///拆完后的订单列表
@property (nonatomic,strong)NSMutableArray * resultArr;

///临时的 (当剩余订单里面的任两个订单都不超过500时)
@property (nonatomic,strong)NSMutableArray * linshiArr;
@property (nonatomic,assign)BOOL LS;
@property (nonatomic,assign)CGFloat lsPrice;

@end

@implementation ChaiDan

+(NSMutableArray *)ChanDanWithArr:(NSMutableArray *)firstArr Rate:(CGFloat)rate
{
    ChaiDan * chaiDan = [[ChaiDan alloc]initWithFirstArr:firstArr Rate:rate];
    return chaiDan.resultArr;
}

-(instancetype)initWithFirstArr:(NSMutableArray *)firstArr Rate:(CGFloat)rate
{
    self = [super init];
    if (self) {
        _firstArr = firstArr;
        _rate = rate;
        [self chaiDan];
    }
    return self;
}


-(void)chaiDan
{
    _resultArr = [NSMutableArray array];
    _linshiArr = [NSMutableArray array];
    
    BOOL ChaiDan = [self firstStepWithArr:_firstArr];
    
    if (ChaiDan) {
        //过滤出单价大于1000的
        [self secondStepWithArr:_firstArr];
        if (_singleArr.count > 0) {
            [self singleGoodsWithArr:_singleArr];
        }
        if (_firstArr.count > 0) {
            //多个商品
            [self thirdStepWithArr:_firstArr];
        }
    }
    else
    {
        //提交
        _resultArr = [NSMutableArray arrayWithObject:_firstArr];
    }
}


///判断是否需要拆单
-(BOOL )firstStepWithArr:(NSMutableArray *)arr
{
    CGFloat total = 0;
    for (GoodsModel * model in arr) {
        total += (CGFloat)model.BuyNumber * model.BuyPrice;
    }
    if (total > _rate) {
        return YES;
    }
    else{
        return NO;
    }
}

///过滤掉单价大于1000的商品
-(void)secondStepWithArr:(NSMutableArray *)arr
{
    NSMutableArray * dataArr = [NSMutableArray array];
    NSMutableArray * resultArr = [NSMutableArray array];
    for (GoodsModel * model in arr) {
        if (model.BuyPrice > _rate) {
            [resultArr addObject:model];
        }
        else
        {
            [dataArr addObject:model];
        }
    }
    _firstArr = [NSMutableArray arrayWithArray:dataArr];
    _singleArr = [NSMutableArray arrayWithArray:resultArr];
}

///剩余商品的拆单
-(void)thirdStepWithArr:(NSMutableArray *)arr
{
    NSMutableArray * newArr = [NSMutableArray array];
    for (GoodsModel * model in arr) {
        if (/*(CGFloat)*/model.BuyNumber * model.BuyPrice > _rate) {
            NSInteger Max = (NSInteger)(_rate*100)/(NSInteger)(model.BuyPrice*100);
            if ((NSInteger)(_rate*100)%(NSInteger)(model.BuyPrice*100) == 0) {
                for (int i = 0; i < model.BuyNumber/Max; i++) {
                    GoodsModel * model2 = [[GoodsModel alloc]init];
                    [self setMyModel:model2 WithModel:model andBuyNum:Max];
                    [newArr addObject:model2];
                }
            }
            else
            {
                for (int i = 0; i < model.BuyNumber/Max; i++) {
                    GoodsModel * model2 = [[GoodsModel alloc]init];
                    [self setMyModel:model2 WithModel:model andBuyNum:Max];
                    [newArr addObject:model2];
                }
//MARK: 有点问题 不知道为什么会产生0
                NSInteger num = model.BuyNumber - (model.BuyNumber/Max * Max);
                if (num > 0) {
                    GoodsModel* model2 = [[GoodsModel alloc]init];
                    [self setMyModel:model2 WithModel:model andBuyNum:num];
                    [newArr addObject:model2];
                }
            }
        }
        else
        {
            [newArr addObject:model];
        }
    }
    NSArray * sorted = [newArr sortedArrayUsingComparator:^NSComparisonResult(GoodsModel * obj1, GoodsModel * obj2) {
        if (obj1.BuyNumber * obj1.BuyPrice > obj2.BuyNumber * obj2.BuyPrice) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if (obj1.BuyNumber * obj1.BuyPrice < obj2.BuyNumber * obj2.BuyPrice) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSMutableArray * sortedArr = [NSMutableArray arrayWithArray:sorted];
    [self combinationWithArr:sortedArr];
    
}

-(void)combinationWithArr:(NSMutableArray *)arr
{
    NSLog(@"%ld",arr.count);
    
    if (arr.count == 0) {
        return;
    }
    if (_LS) {
        if (arr.count == 1) {
            GoodsModel * model = arr[0];
            if (_lsPrice + model.BuyNumber*model.BuyPrice > _rate) {
                [_resultArr addObject:[NSArray arrayWithArray:_linshiArr]];
                [_resultArr addObject:[NSArray arrayWithObject:model]];
            }
            else
            {
                [_linshiArr addObject:model];
                [_resultArr addObject:[NSArray arrayWithArray:_linshiArr]];
            }
            [_linshiArr removeAllObjects];
            [arr removeObject:model];
            _lsPrice = 0;
            _LS = NO;
        }
        else
        {
            BOOL X = NO;
            NSMutableArray * dataArr = [NSMutableArray arrayWithArray:arr];
            for (GoodsModel * model in dataArr) {
                NSInteger i = [dataArr indexOfObject:model];
                if (_lsPrice + model.BuyNumber*model.BuyPrice >_rate) {
                    X = YES;
                    if (i == 0) {
                        [_resultArr addObject:[NSArray arrayWithArray:_linshiArr]];
                        [_linshiArr removeAllObjects];
                        _lsPrice = 0;
                        _LS = NO;
                    }
                    else
                    {
                        GoodsModel * mo = arr[i-1];
                        _lsPrice += mo.BuyPrice*mo.BuyNumber;
                        [_linshiArr addObject:mo];
                        [arr removeObject:mo];
                    }
                }
            }
            if (X == NO) {
                GoodsModel * mo = arr[arr.count-1];
                _lsPrice += mo.BuyPrice*mo.BuyNumber;
                [_linshiArr addObject:mo];
                [arr removeObject:mo];
            }
        }
    }
    else
    {
        if ([self firstStepWithArr:arr] == NO) {
            [_resultArr addObject:[NSArray arrayWithArray:arr]];
            [arr removeAllObjects];
            return;
        }
        if (arr.count == 1) {
            [_resultArr addObject:[NSArray arrayWithObject:arr[0]]];
            [arr removeObject:arr[0]];
            return;
        }
        if (arr.count == 2) {
            GoodsModel * model1 = arr[0];
            GoodsModel * model2 = arr[1];
            if ((model1.BuyNumber * model1.BuyPrice + model2.BuyNumber * model2.BuyPrice)>_rate) {
                [_resultArr addObject:[NSArray arrayWithObject:model1]];
                [_resultArr addObject:[NSArray arrayWithObject:model2]];
                [arr removeAllObjects];
            }
            else
            {
                NSArray * list = [NSArray arrayWithObjects:model1,model2,nil];
                [_resultArr addObject:list];
                [arr removeAllObjects];
            }
            return;
        }
        NSMutableArray * arrData = [NSMutableArray arrayWithArray:arr];
        BOOL X = NO;
        for (int i = 0; i < arrData.count -1; i++) {
            GoodsModel * model1 = arrData.lastObject;
            GoodsModel * model2 = arrData[i];
            if (model1.BuyNumber * model1.BuyPrice+ model2.BuyNumber * model2.BuyPrice > _rate) {
                X = YES;
                if (i == 0) {
                    [_resultArr addObject:[NSArray arrayWithObject:model1]];
                    [arr removeObject:arr.lastObject];
                    break;
                }
                else
                {
                    NSArray * list = [NSArray arrayWithObjects:model1,arrData[i-1], nil];
                    [_resultArr addObject:list];
                    [arr removeObject:arr.lastObject];
                    [arr removeObject:arr[i-1]];
                    break;
                }
            }
        }
        if (X == NO) {
            GoodsModel * model1 = arr.lastObject;
            GoodsModel * model2 = arr[arr.count-2];
            _lsPrice = model1.BuyNumber*model1.BuyPrice + model2.BuyNumber*model2.BuyPrice;
            _LS = YES;
            [_linshiArr addObject:model1];
            [_linshiArr addObject:model2];
            [arr removeObject:model1];
            [arr removeObject:model2];
        }
    }

    [self combinationWithArr:arr];
}


///单件商品的拆单
-(void)singleGoodsWithArr:(NSMutableArray *)arr
{
    for (GoodsModel * model1 in arr) {
        //单价大于1000时
        for (int i = 0 ; i < model1.BuyNumber; i++) {
            GoodsModel * model2 = [[GoodsModel alloc]init];
            [self setMyModel:model2 WithModel:model1 andBuyNum:1];
            [_resultArr addObject:[NSArray arrayWithObject:model2]];
        }
    }
}

-(void)setMyModel:(GoodsModel *)myModel WithModel:(GoodsModel *)model andBuyNum:(NSInteger )buyNum;
{
    myModel.BuyNumber = buyNum;
    
    myModel.Attributes = model.Attributes;
    myModel.Name = model.Name;
    myModel.BuyPrice = model.BuyPrice;
    myModel.Guid = model.Guid;
    myModel.MarketPrice = model.MarketPrice;
    myModel.MemLoginID = model.MemLoginID;
    myModel.OriginalImge = model.OriginalImge;
    myModel.ProductGuid = model.ProductGuid;
    myModel.SpecificationName = model.SpecificationName;
    myModel.IncomeTax = model.IncomeTax;
    myModel.SpecificationValue = @"";
    myModel.ShopID = @"0";
    myModel.ShopName = @"";
    myModel.CreateTime = [NSDate date];
    myModel.IsJoinActivity = 0;
    myModel.IsPresent = 0;
    myModel.RepertoryNumber = @"JK";
    myModel.ExtensionAttriutes = @"M";
}

@end
