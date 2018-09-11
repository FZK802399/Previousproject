//
//  EditViewCell.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/9.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageInfo;

@protocol EditViewCellDelegate <NSObject>

//cell中的图片被点击
- (void)editViewCellImageViewTapWithIndex:(int)index;
//cell中的文字被点击
- (void)editViewCellTextViewTapWithIndex:(int)index;

@end

@interface EditViewCell : UITableViewCell

@property(nonatomic, assign) id delegate;

//设置内容视图中显示的内容
- (void)setContentView:(ImageInfo *)imageInfo;

@end
