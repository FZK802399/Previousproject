//
//  ShortCutPopView.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-10.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ShortCutPopView.h"

@interface ShortCutPopTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *iconImage;
@property (strong, nonatomic) UILabel *numberLabel;

@end

@implementation ShortCutPopTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGFloat height = 50;
        CGFloat originX = 10;
        CGFloat originY = 6;
        if (_nameLabel == nil) {
            _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 50, originY + 4, 260, height - 22)];
            _nameLabel.textAlignment = NSTextAlignmentLeft;
            _nameLabel.font = [UIFont systemFontOfSize:15];
            _nameLabel.backgroundColor = [UIColor clearColor];
            //            _nameLabel.textColor = [UIColor textTitleColor];
            [self.contentView addSubview:_nameLabel];
        }
        
        if (_iconImage == nil) {
            _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX+20 , originY + 5, 22, 22)];
            [self.contentView addSubview:_iconImage];
        }
        
        if (_numberLabel == nil) {
            _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX + 135, originY + 4, 260, height - 22)];
            _numberLabel.textAlignment = NSTextAlignmentLeft;
            _numberLabel.font = [UIFont systemFontOfSize:15];
            _numberLabel.backgroundColor = [UIColor clearColor];
            //            _nameLabel.textColor = [UIColor textTitleColor];
            [self.contentView addSubview:_numberLabel];
        }
        CALayer *bottomLayer = [CALayer layer];
        bottomLayer.frame = CGRectMake(0, height - 1, 320, 1);
        bottomLayer.backgroundColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
        [self.contentView.layer addSublayer:bottomLayer];
    }
    return self;
}

@end

//-------------------------------------------------------------------------------



@implementation ShortCutPopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initTheInterface];
    }
    return self;
}

- (void)initTheInterface
{
    AppConfig *appconfig = [AppConfig sharedAppConfig];
    [appconfig loadConfig];
//    200 200  宽高   50行高
    self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    self.layer.borderWidth = 1.0f;
//    self.layer.cornerRadius = 10.0f;
    self.clipsToBounds = TRUE;
    
    CGRect tableFrame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _PopoverListView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.PopoverListView.dataSource = self;
    self.PopoverListView.delegate = self;
    self.PopoverListView.backgroundColor = [UIColor whiteColor];
    self.PopoverListView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.PopoverListView];
    
    _imageArray = [NSArray arrayWithObjects:@"shortcut_home.png",@"shortcut_shopcart.png",@"shortcut_personal.png", nil];
    _titleArray = [NSArray arrayWithObjects:@"首页",@"购物车",@"个人中心", nil];
    _numArray = [NSArray arrayWithObjects:@"0",@"0",@"0", nil];

}

- (void)refreshTheUserInterface
{
    if (nil == _controlForDismiss)
    {
        _controlForDismiss = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _controlForDismiss.backgroundColor = [UIColor colorWithRed:.16 green:.17 blue:.21 alpha:0.5];
        [_controlForDismiss addTarget:self action:@selector(touchForDismissSelf:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)touchForDismissSelf:(id)sender
{
    [self animatedOut];
}


#pragma mark - show or hide self
- (void)show
{
    [self refreshTheUserInterface];
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    if (self.controlForDismiss)
    {
        [keywindow addSubview:self.controlForDismiss];
    }
    [keywindow addSubview:self];
    
//    self.center = CGPointMake(keywindow.bounds.size.width/2.0f,
//                              keywindow.bounds.size.height/2.0f);
    [self animatedIn];
}

- (void)dismiss
{
    [self animatedOut];
}

#pragma mark - Animated Mthod
- (void)animatedIn
{
//    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:0 animations:^{
        self.alpha = 1;
//        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
}

- (void)animatedOut
{
    [UIView animateWithDuration:0 animations:^{
//        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.controlForDismiss)
            {
                [self.controlForDismiss removeFromSuperview];
            }
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - UITableViewDatasource

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellIdentifier";
    ShortCutPopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ShortCutPopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.iconImage.image = [UIImage imageNamed:[_imageArray objectAtIndex:indexPath.row]];
        cell.nameLabel.text = [_titleArray objectAtIndex:indexPath.row];
        if ([[_numArray objectAtIndex:indexPath.row] intValue] == 0) {
            [cell.numberLabel setHidden:YES];
        }else{
            cell.numberLabel.text = [_numArray objectAtIndex:indexPath.row];
            [cell.numberLabel setHidden:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didSelectRowAtIndexPath:)]) {
            [self.delegate didSelectRowAtIndexPath:indexPath.row];
        }
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
