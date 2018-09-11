//
//  ImageFooterView.m
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "ImageFooterView.h"
#import "BannerModel.h"
#import "UIImageView+AFNetworking.h"
NSString *const kImageFooterView = @"ImageFooterView";
@interface ImageFooterView ()
@property (nonatomic,strong) UIImageView *imageView;
@end
@implementation ImageFooterView

- (UIImageView*) imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
//        _imageView.layer.shadowOpacity = 0.2;
//        _imageView.layer.shadowOffset = CGSizeMake(0, 0.7);
//        _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    }
    return _imageView;
}
- (instancetype) initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        self.backgroundColor = [UIColor yellowColor];
    }
    return self;
}
- (void) setMode:(id)mode{
    _mode = mode;
    if ([mode isKindOfClass:[NSString class]]) {
        NSString *imageName = (NSString*)mode;
        self.imageView.image = [UIImage imageNamed:imageName];
    }
    if ([mode isKindOfClass:[BannerModel class]]) {
        BannerModel *model = (BannerModel*)mode;
//      [self.imageView setImageWithURL:[NSURL URLWithString:model.Value] placeholderImage:[UIImage imageNamed:@"banner2"]];
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
        NSString * name = [model.Value stringByReplacingOccurrencesOfString:@"http://www.efood7.com/ImgUpload/" withString:@""];
        NSString *imgPath=[path stringByAppendingPathComponent:name];
        
        UIImage *image = [UIImage imageWithContentsOfFile:imgPath];
        self.imageView.image = image;
        self.imageView.frame = self.bounds;
//
//        if (image == nil) {
//            NSURLSession * session = [NSURLSession sharedSession];
//            NSURLSessionTask * task = [session dataTaskWithURL:[NSURL URLWithString:model.Value] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//                UIImage * image = [UIImage imageWithData:data];
//                
//                [UIImagePNGRepresentation(image) writeToFile:imgPath atomically:YES];
//                
//                CGFloat height = LZScreenWidth/image.size.width * image.size.height;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    self.imageView.frame = self.bounds;
//                    self.imageView.image = image;
//                    if ([self.delegate respondsToSelector:@selector(imageFooterView:getHeight:section:)]) {
//                        [self.delegate imageFooterView:self getHeight:height section:self.tag];
//                    }
//                });
//            }];
//            [task resume];
//        }
//        else
//        {
//            self.imageView.frame = self.bounds;
//            self.imageView.image = image;
//            CGFloat height = LZScreenWidth/image.size.width * image.size.height;
        //            if ([self.delegate respondsToSelector:@selector(imageFooterView:getHeight:section:)]) {
        //                [self.delegate imageFooterView:self getHeight:height section:self.tag];
        //            }
        //        }
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([self.delegate respondsToSelector:@selector(didSelectImageFooterView:OfUrl:)]) {
        BannerModel *model = (BannerModel*)self.mode;
        [self.delegate didSelectImageFooterView:self OfUrl:model.Url];
    }
}


@end
