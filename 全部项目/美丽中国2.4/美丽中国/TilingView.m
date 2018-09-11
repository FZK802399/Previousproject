//
//  TilingView.m
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/29.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import "TilingView.h"
#import "Header.h"

#define Tile_Width 256

@interface TilingView ()
{
    NSString *_pinyinName;
}
@end

@implementation TilingView

//覆盖+ layerClass类方法返回一个CATiledLayer（切片layer）类 UIView的layerClass方法，可以返回主layer所使用的类，UIView的子类可以通过重载这个方法，来让UIView使用不同的CALayer来显示。
+ (Class)layerClass
{
    return [CATiledLayer class];
}

- (id)initWithFrame:(CGRect)frame andPinyinName:(NSString *)pinyinName
{
    self = [super initWithFrame:frame];
    if (self) {
        _pinyinName = pinyinName;
        
        //获取自身的layer
        CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
        //设置切片layer只有1层
        tiledLayer.levelsOfDetail = 1;
    }
    return self;
}

//设置分辨率缩放因子
- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    [super setContentScaleFactor:1.0f];
}

//iOS的绘图操作是在UIView类的drawRect方法中完成的，所以如果我们要想在一个UIView中绘图，需要写一个扩展UIView 的类，并重写drawRect方法，在这里进行绘图操作，程序会自动调用此方法进行绘图。
- (void)drawRect:(CGRect)rect
{
    CATiledLayer *tiledLayer = (CATiledLayer *)[self layer];
    CGSize tileSize = tiledLayer.tileSize;
    
    int firstCol = floorf(CGRectGetMinX(rect)/tileSize.width);
    int lastCol = floorf((CGRectGetMaxX(rect)-1)/tileSize.width);
    int firstRow = floorf(CGRectGetMinY(rect)/tileSize.height);
    int lastRow = floorf((CGRectGetMaxY(rect)-1)/tileSize.height);
  
    for (int row=firstRow; row<=lastRow; row++) {
        for (int col = firstCol; col<=lastCol; col++) {
            //取出地图切片
            UIImage *tile = [self tileForRow:row andCol:col];
            CGRect tileRect = CGRectMake(tileSize.width*col, tileSize.height*row, tileSize.width, tileSize.height);
            //返回两个Rect相交的部分的Rect
            tileRect = CGRectIntersection(self.bounds, tileRect);
            //画图
            [tile drawInRect:tileRect];
        }
    }
}

//根据row和col 取出存储到此盘中的相应地图切片
- (UIImage *)tileForRow:(int)row andCol:(int)col
{
    int width;
    int height;
    //最后一列的宽度
    if (col == (NSInteger)super.frame.size.width/Tile_Width) {
        width = (NSInteger)super.frame.size.width%Tile_Width;
    //其他列的宽度
    } else {
        width = Tile_Width;
    }
    
    //最后一行的高度
    if (row == (NSInteger)super.frame.size.height/Tile_Width) {
        height = (NSInteger)super.frame.size.height%Tile_Width;
    //其他行的高度
    } else {
        height = Tile_Width;
    }
    
    //地图切片的名字
    NSString *tileName = [NSString stringWithFormat:@"%d,%d,%d,%d,0",col*256,row*256,width,height];
    //获得地图切片的路径
    NSString *guidePath = GUIDE_PATH;
    NSString *tileImagePath = [guidePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@/view_map/%@.png",_pinyinName,_pinyinName,tileName]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:tileImagePath]) {
        NSLog(@"tileImagePath %@",tileImagePath);
    }
    UIImage *image = [UIImage imageWithContentsOfFile:tileImagePath];
    return image;
}

@end
