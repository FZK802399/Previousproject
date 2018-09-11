//
//  Instructions CollectionViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/16.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "InstructionsCollectionViewCell.h"

NSString *const kInstructionsCollectionViewCellIdentifier = @"InstructionsCollectionViewCell";

@interface InstructionsCollectionViewCell ()

//@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (weak, nonatomic) IBOutlet UIWebView *instructionsWeb;

@end

@implementation InstructionsCollectionViewCell

- (void)awakeFromNib {
    
}

- (void)updateViewWithInstructionsString:(NSString *)instructions {
//    self.instructionsLabel.text = instructions;
    [self.instructionsWeb loadHTMLString:instructions baseURL:[NSURL URLWithString:kWebMainBaseUrl]];
}

+ (CGSize)cellSizeWithInstructions:(NSString *)instructions {
    CGRect rect = [instructions boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13.0f]} context:nil];
    return rect.size;
}


@end
