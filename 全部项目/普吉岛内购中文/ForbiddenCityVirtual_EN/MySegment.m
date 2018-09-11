//
//  MySegment.m
//  ForbiddenCityVirtual_EN
//
//  Created by Heramerom on 13-7-23.
//  Copyright (c) 2013年 Duke Douglas. All rights reserved.
//

#import "MySegment.h"

@implementation MySegment

@synthesize value = _value;

- (id)initWithTag:(id)object andSelect:(SEL)select andEvent:(UIControlEvents)event
{
    if (self = [super init])
    {
        CGRect rc = CGRectMake(kLCDH - 10 - 89 * 2, 11, 89 * 2, 32);
        self.frame = rc;
        
        _value = [[USER_DEFAULTS objectForKey:kCurrent_Language] intValue];
        
        _chineseButton = [[UIButton alloc] initWithFrame:CGRectMake(89, 0, 89, 32)];
        [_chineseButton setImage:[UIImage imageNamed:@"chinese.png"] forState:UIControlStateNormal];
        [_chineseButton addTarget:object action:select forControlEvents:event];
        _chineseButton.tag = 0;
        [_chineseButton addTarget:self action:@selector(changeButtonImage:) forControlEvents:UIControlEventTouchUpInside];
        
        _englishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 89, 32)];
        [_englishButton setImage:[UIImage imageNamed:@"english.png"] forState:UIControlStateNormal];
        _englishButton.tag = 1;
        [_englishButton addTarget:self action:@selector(changeButtonImage:) forControlEvents:UIControlEventTouchUpInside];
        [_englishButton addTarget:object action:select forControlEvents:event];
        
        [self setButtonImageWithTag:_value];
        
        [self addSubview:_chineseButton];
        [self addSubview:_englishButton];
    }
    return self;
}


- (void)dealloc
{
    [_chineseButton release];
    _chineseButton = nil;
    [_englishButton release];
    _englishButton = nil;
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setButtonImageWithTag:(NSInteger)tag
{
    if (tag == English)
    {
        [_chineseButton setImage:[UIImage imageNamed:@"chinese.png"] forState:UIControlStateNormal];
        [_englishButton setImage:[UIImage imageNamed:@"english_h.png"] forState:UIControlStateNormal];
        [_chineseButton setUserInteractionEnabled:YES];
        [_englishButton setUserInteractionEnabled:NO];
    }
    else
    {
        [_chineseButton setImage:[UIImage imageNamed:@"chinese_h.png"] forState:UIControlStateNormal];
        [_englishButton setImage:[UIImage imageNamed:@"english.png"] forState:UIControlStateNormal];
        [_englishButton setUserInteractionEnabled:YES];
        [_chineseButton setUserInteractionEnabled:NO];
    }
}

- (void)changeButtonImage:(UIButton *)sender
{
    _value = sender.tag;
    if (_value == English)
    {
        [_chineseButton setImage:[UIImage imageNamed:@"chinese.png"] forState:UIControlStateNormal];
        [_englishButton setImage:[UIImage imageNamed:@"english_h.png"] forState:UIControlStateNormal];
        [_englishButton setUserInteractionEnabled:NO];
        [_chineseButton setUserInteractionEnabled:YES];
        [MobClick event:@"englishButtonPress"];
    }
    else
    {
        [_chineseButton setImage:[UIImage imageNamed:@"chinese_h.png"] forState:UIControlStateNormal];
        [_englishButton setImage:[UIImage imageNamed:@"english.png"] forState:UIControlStateNormal];
        [_englishButton setUserInteractionEnabled:YES];
        [_chineseButton setUserInteractionEnabled:NO];
        [MobClick event:@"chineseButtonPress"];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
