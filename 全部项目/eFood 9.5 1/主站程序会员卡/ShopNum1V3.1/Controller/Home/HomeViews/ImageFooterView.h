//
//  ImageFooterView.h
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kImageFooterView;
@class ImageFooterView;
@protocol ImageFooterViewDelegate <NSObject>

@optional
- (void)didSelectImageFooterView:(ImageFooterView *)imageFooterView OfUrl:(NSString *)url;
@end

@interface ImageFooterView : UICollectionReusableView
@property (weak, nonatomic) id<ImageFooterViewDelegate> delegate;
@property (nonatomic,strong) id mode;
@end
