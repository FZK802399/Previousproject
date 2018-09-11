//
//  SecondContentCell.m
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import "SecondContentCell.h"
#import "CategroyMode.h"
#import "SortModel.h"
//#import "UIImageView+WebCache.h"

#import "UIImageView+AFNetworking.h"

@interface SecondContentCell ()
@property (weak, nonatomic) IBOutlet UILabel *categrayNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@end
@implementation SecondContentCell
/*
- (instancetype) initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    self = [[NSBundle mainBundle]loadNibNamed:kSecondContentCell owner:nil options:nil].firstObject;
    return self;
}
*/
- (void)awakeFromNib {
    // Initialization code
}

- (void) setMode:(SortModel *)mode {
    _mode = mode;
    NSString *imagePath = mode.Imagestr;
    if (![imagePath hasPrefix:@"http://"]) {
        imagePath = [NSString stringWithFormat:@"%@%@",kWebMainBaseUrl,imagePath];
    }
//    [self.icon setImage:nil];
    [self.icon setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.categrayNameLabel.text = mode.Name;
    self.subtitleLabel.text = mode.Description;
    
}
@end
