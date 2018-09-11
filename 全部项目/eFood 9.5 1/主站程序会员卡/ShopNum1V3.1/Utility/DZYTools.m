//
//  DZYTools.m
//  支付宝测试
//
//  Created by yons on 15/12/2.
//  Copyright (c) 2015年 ShopNum1. All rights reserved.
//

#import "DZYTools.h"
#warning
//#import "SDImageCache.h"
@implementation DZYTools

+(CGSize )getSizeWithString:(NSString *)string FontNum:(CGFloat )num
{
    return [string boundingRectWithSize:CGSizeMake(DZYWIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:num]} context:nil].size;
}

+(void)showMessageWithStr:(NSString *)string
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

+(void)addShopCartFromGoods:(UIImageView *)Goods ToCart:(UIImageView *)Cart
{
    CGPoint one = Goods.center;
    CGPoint two = Cart.center;
    CGRect bounds = Goods.bounds;
    CGRect toBounds = CGRectMake(0, 0, 30, 30);
    
    CAAnimationGroup * group = [CAAnimationGroup animation];
    
    CABasicAnimation * move = [[CABasicAnimation alloc]init];
    move.keyPath = @"transform";
    move.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(two.x-one.x,two.y-one.y, 0)];
    
    CABasicAnimation * scale = [CABasicAnimation animation];
    scale.keyPath = @"bounds";
    scale.fromValue = [NSValue valueWithCGRect:bounds];
    scale.toValue = [NSValue valueWithCGRect:toBounds];
    
    CABasicAnimation * rotate = [CABasicAnimation animation];
    rotate.keyPath = @"transform.rotation.z";
    rotate.toValue = @(-M_PI*4);
    
    group.animations = @[move,scale,rotate];
    group.duration = 1;
    group.removedOnCompletion=NO;
    [Goods.layer addAnimation:group forKey:nil];
    
    CGPoint po = Cart.layer.position;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CAKeyframeAnimation * cart = [CAKeyframeAnimation animation];
        cart.keyPath = @"position";
        NSValue * value1 = [NSValue valueWithCGPoint:CGPointMake(po.x-2, po.y+1)];
        NSValue * value2 = [NSValue valueWithCGPoint:CGPointMake(po.x+2, po.y-1)];
        cart.values = @[value1,value2];
        cart.duration = 0.1;
        cart.repeatCount = 2;
        [Cart.layer addAnimation:cart forKey:nil];
    });
}

+(float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size/1024.0/1024.0;
    }
    return 0;
}

+(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    float folderSize;
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            folderSize +=[DZYTools fileSizeAtPath:absolutePath];
        }
        //SDWebImage框架自身计算缓存的实现
#warning
//        folderSize+=[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0;
        return folderSize;
    }
    return 0;
}

+(void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *absolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
#warning
//    [[SDImageCache sharedImageCache] cleanDisk];
}

+(UIImage *)getImageWithView:(UIView*)view
{
    UIImage* img=nil;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    img=UIGraphicsGetImageFromCurrentImageContext();
    //        NSNotificationCenter* center=[NSNotificationCenter defaultCenter];
    //        NSMutableDictionary* dict=[NSMutableDictionary dictionary];
    //        dict[@"img"]=img;
    //        [center postNotificationName:@"finish" object:self userInfo:dict];
    UIGraphicsEndImageContext();
    return img;
}

///创建数据库 并插入数据
+(void)createTableWithName:(NSString *)Name andInsertJSON:(id)JSON DB:(FMDatabase *)DB
{
    [DB open];
    NSString * create = [NSString stringWithFormat:@"create table if not exists %@ (dict);",Name];
    [DB executeUpdate:create];
    ///清空
    NSString * delete = [NSString stringWithFormat:@"delete from %@",Name];
    [DB executeUpdate:delete];
    NSData * data = [NSJSONSerialization dataWithJSONObject:JSON options:NSJSONWritingPrettyPrinted error:nil];
    NSString * jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSString * insert = [NSString stringWithFormat:@"insert into %@ (dict) values (?);",Name];
    [DB executeUpdate:insert,jsonStr];
    [DB close];
}

+(NSDictionary *)loadDictWithName:(NSString *)Name DB:(FMDatabase *)DB
{
    NSString * select = [NSString stringWithFormat:@"select * from %@;",Name];
    FMResultSet *set= [DB executeQuery:select];
    NSString * jsonString;
    while (set.next) {
        jsonString = [set stringForColumn:@"dict"];
    }
    if (jsonString) {
        NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        return dict;
    }
    return nil;
}

@end

#pragma mark - DZYImageView

@implementation DZYImageView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imgClick:)];
        tap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:tap];
    }
    return self;
}

+(DZYImageView *)DZYImageViewWithFrame:(CGRect)frame Img:(UIImage *)img
{
    DZYImageView * imgView = [[DZYImageView alloc]initWithFrame:frame];
    imgView.image = img;
    return imgView;
}

-(void)imgClick:(UITapGestureRecognizer *)tap
{
    if ([self.delegate respondsToSelector:@selector(DZYImageViewDidClickWith:)]) {
        [self.delegate DZYImageViewDidClickWith:self];
    }
}

@end



