//
//  FootMarkTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-11.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "FootMarkTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BluePrintingModel.h"

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";

@implementation FootMarkTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.rightUtilityButtons = rightUtilityButtons;
        self.leftUtilityButtons = leftUtilityButtons;
        self.height = containingTableView.rowHeight;
        self.containingTableView = containingTableView;
        self.highlighted = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initializer];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self initializer];
    }
    
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)initializer {
    // Set up scroll view that will host our cell content
    UIScrollView *cellScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height)];
    cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    cellScrollView.contentOffset = [self scrollViewContentOffset];
    cellScrollView.delegate = self;
    cellScrollView.showsHorizontalScrollIndicator = NO;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scrollViewPressed:)];
    [cellScrollView addGestureRecognizer:tapGestureRecognizer];
    
    self.cellScrollView = cellScrollView;
    
    // Set up the views that will hold the utility buttons
    SWUtilityButtonView *scrollViewButtonViewLeft = [[SWUtilityButtonView alloc] initWithUtilityButtons:_leftUtilityButtons parentCell:self utilityButtonSelector:@selector(leftUtilityButtonHandler:)];
    [scrollViewButtonViewLeft setFrame:CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewLeft = scrollViewButtonViewLeft;
    [self.cellScrollView addSubview:scrollViewButtonViewLeft];
    
    SWUtilityButtonView *scrollViewButtonViewRight = [[SWUtilityButtonView alloc] initWithUtilityButtons:_rightUtilityButtons parentCell:self utilityButtonSelector:@selector(rightUtilityButtonHandler:)];
    [scrollViewButtonViewRight setFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height)];
    self.scrollViewButtonViewRight = scrollViewButtonViewRight;
    [self.cellScrollView addSubview:scrollViewButtonViewRight];
    
    // Populate the button views with utility buttons
    [scrollViewButtonViewLeft populateUtilityButtons];
    [scrollViewButtonViewRight populateUtilityButtons];
    
    // Create the content view that will live in our scroll view
    UIView *scrollViewContentView = [[UIView alloc] initWithFrame:CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height)];
    scrollViewContentView.backgroundColor = [UIColor whiteColor];
    [self.cellScrollView addSubview:scrollViewContentView];
    self.scrollViewContentView = scrollViewContentView;
    
    
    CGFloat height = 100;
    CGFloat width = SCREEN_WIDTH;
    CGFloat originX = 6;
    CGFloat originY = 10;
    
    if(_showImage == nil){
        _showImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 80)];
        
        [self.contentView addSubview:_showImage];
    }
    
    UIColor *darkColor = [UIColor colorWithRed:124 /255.0f green:124 /255.0f blue:124 /255.0f alpha:1];
    UIFont *fontSize = [UIFont systemFontOfSize:13.0f];
    
    
    originX = originX + _showImage.frame.size.width;
    
    if(_nameLabel == nil){
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_showImage.frame) + 5, originY, SCREEN_WIDTH - CGRectGetMaxX(_showImage.frame) - 10, 40)];
        _nameLabel.textColor = [UIColor colorFromHexRGB:@"606366"];
        _nameLabel.numberOfLines = 2;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _nameLabel.font = fontSize;
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
    }
    
    if(_ShopPriceLabel == nil){
        _ShopPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_nameLabel.frame), 100, 15)];
        _ShopPriceLabel.textColor = [UIColor colorFromHexRGB:@"e32424"];
        _ShopPriceLabel.font = fontSize;
        _ShopPriceLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_ShopPriceLabel];
    }
    
    if(_MarketPriceLabel == nil){
        _MarketPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), CGRectGetMaxY(_ShopPriceLabel.frame)+20, 100, 25)];
        _MarketPriceLabel.textColor = [UIColor colorWithRed:187 /255.0f green:187 /255.0f blue:175 /255.0f alpha:1];
        _MarketPriceLabel.font = fontSize;
        _MarketPriceLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _MarketPriceLabel.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_MarketPriceLabel];
    }
    
    if(_commentPicBtn == nil){
        _commentPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _commentPicBtn.frame = CGRectMake(SCREEN_WIDTH - 95, 70, 90, 25);
        [_commentPicBtn setTitle:@"去晒单" forState:UIControlStateNormal];
        [_commentPicBtn setBackgroundColor:[UIColor barTitleColor]];
        _commentPicBtn.layer.cornerRadius = 2.0f;
//        [_commentPicBtn setBackgroundImage:[UIImage imageNamed:@"middle_red_btnbg_normal.png"] forState:UIControlStateNormal];
        [_commentPicBtn setHidden:YES];
        [self.commentPicBtn addTarget:self action:@selector(btnCommentTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_commentPicBtn];
    }
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.borderWidth = 1;
    bottomLayer.borderColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1].CGColor;
    bottomLayer.frame = CGRectMake(0, height - 1, SCREEN_WIDTH, 1);
    [self.contentView.layer addSublayer:bottomLayer];
    
//    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    
    
    // Add the cell scroll view to the cell
    UIView *contentViewParent = self;
    if (![NSStringFromClass([[self.subviews objectAtIndex:0] class]) isEqualToString:kTableViewCellContentView]) {
        // iOS 7
        contentViewParent = [self.subviews objectAtIndex:0];
    }
    NSArray *cellSubviews = [contentViewParent subviews];
    [self insertSubview:cellScrollView atIndex:0];
    for (UIView *subview in cellSubviews) {
        [self.scrollViewContentView addSubview:subview];
    }
}

- (void)hideUtilityButtonsAnimated:(BOOL)animated {
    // Scroll back to center
    [self.cellScrollView setContentOffset:CGPointMake([self leftUtilityButtonsWidth], 0) animated:animated];
    _cellState = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}

#pragma mark Selection

- (void)scrollViewPressed:(id)sender {
    if(_cellState == kCellStateCenter) {
        // Selection hack
        if ([self.containingTableView.delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]){
            NSIndexPath *cellIndexPath = [_containingTableView indexPathForCell:self];
            [self.containingTableView.delegate tableView:_containingTableView didSelectRowAtIndexPath:cellIndexPath];
        }
        // Highlight hack
        if (!self.highlighted) {
            self.scrollViewButtonViewLeft.hidden = YES;
            self.scrollViewButtonViewRight.hidden = YES;
            NSTimer *endHighlightTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(timerEndCellHighlight:) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:endHighlightTimer forMode:NSRunLoopCommonModes];
            [self setHighlighted:YES];
        }
    } else {
        // Scroll back to center
        [self hideUtilityButtonsAnimated:YES];
    }
}

- (void)timerEndCellHighlight:(id)sender {
    if (self.highlighted) {
        self.scrollViewButtonViewLeft.hidden = NO;
        self.scrollViewButtonViewRight.hidden = NO;
        [self setHighlighted:NO];
    }
}

#pragma mark UITableViewCell overrides

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    self.scrollViewContentView.backgroundColor = backgroundColor;
}



#pragma mark - Setup helpers

- (CGFloat)leftUtilityButtonsWidth {
    return [_scrollViewButtonViewLeft utilityButtonsWidth];
}

- (CGFloat)rightUtilityButtonsWidth {
    return [_scrollViewButtonViewRight utilityButtonsWidth];
}

- (CGFloat)utilityButtonsPadding {
    return ([_scrollViewButtonViewLeft utilityButtonsWidth] + [_scrollViewButtonViewRight utilityButtonsWidth]);
}

- (CGPoint)scrollViewContentOffset {
    return CGPointMake([_scrollViewButtonViewLeft utilityButtonsWidth], 0);
}



#pragma mark UIScrollView helpers

- (void)scrollToRight:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = [self utilityButtonsPadding];
    _cellState = kCellStateRight;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateRight];
    }
}

- (void)scrollToCenter:(inout CGPoint *)targetContentOffset {
    targetContentOffset->x = [self leftUtilityButtonsWidth];
    _cellState = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
    }
}

- (void)scrollToLeft:(inout CGPoint *)targetContentOffset{
    targetContentOffset->x = 0;
    _cellState = kCellStateLeft;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateLeft];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


#pragma mark - Utility buttons handling

- (void)rightUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerRightUtilityButtonWithIndex:)]) {
        [_delegate swippableTableViewCell:self didTriggerRightUtilityButtonWithIndex:utilityButtonTag];
    }
}

- (void)leftUtilityButtonHandler:(id)sender {
    UIButton *utilityButton = (UIButton *)sender;
    NSInteger utilityButtonTag = [utilityButton tag];
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:didTriggerLeftUtilityButtonWithIndex:)]) {
        [_delegate swippableTableViewCell:self didTriggerLeftUtilityButtonWithIndex:utilityButtonTag];
    }
}


#pragma mark - Overriden methods

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.cellScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), _height);
    self.cellScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds) + [self utilityButtonsPadding], _height);
    self.cellScrollView.contentOffset = CGPointMake([self leftUtilityButtonsWidth], 0);
    self.scrollViewButtonViewLeft.frame = CGRectMake([self leftUtilityButtonsWidth], 0, [self leftUtilityButtonsWidth], _height);
    self.scrollViewButtonViewRight.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, [self rightUtilityButtonsWidth], _height);
    self.scrollViewContentView.frame = CGRectMake([self leftUtilityButtonsWidth], 0, CGRectGetWidth(self.bounds), _height);
}


- (IBAction)btnCommentTouch:(id)sender{
    if(self.delegate != nil){
        if([self.delegate respondsToSelector:@selector(commentProduct:)]){
            [self.delegate commentProduct:_currentProduct];
        }
    }
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

-(void)creatFootMarkTableViewCellWithMerchandiseIntroModel:(FootMarkModel *)intro{
    UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
    [self.showImage setImageWithURL:intro.ProductImageURL placeholderImage:blankImg];
    [self.nameLabel setText:intro.ProductName];
    
    CGRect textframe = self.nameLabel.frame;
    textframe.size.height = [self heightForString:intro.ProductName fontSize:15 andWidth:self.nameLabel.frame.size.width];
//    NSLog(@"textframe.size.height = %f", textframe.size.height);
    if (textframe.size.height > 40) {
        textframe.size.height = 40;
    }
    self.nameLabel.frame = textframe;
    
    [self.ShopPriceLabel setText:[NSString stringWithFormat:@"AU$ %.2f", intro.ProductShopPrice]];
    NSString * tempStr = [NSString stringWithFormat:@"AU$ %.2f", intro.ProductMarketPrice];
    NSMutableAttributedString * MarketPriceStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
    NSRange range = {0 , tempStr.length};
    [MarketPriceStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    [self.MarketPriceLabel setAttributedText:MarketPriceStr];
    
    self.ShopPriceLabel.frame = CGRectMake(self.ShopPriceLabel.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.ShopPriceLabel.frame),  CGRectGetHeight(self.ShopPriceLabel.frame));
    
    self.MarketPriceLabel.frame = CGRectMake(self.MarketPriceLabel.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.MarketPriceLabel.frame),  CGRectGetHeight(self.MarketPriceLabel.frame));
//    [self.saleNumLabel setText:[NSString stringWithFormat:@"最近售出：%@", @"100"]];
    
}

-(void)creatCollectTableViewCellWithMerchandiseIntroModel:(MerchandiseCollectModel *)intro{
    UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
    [self.showImage setImageWithURL:intro.ProductImageURL placeholderImage:blankImg];
    [self.nameLabel setText:intro.ProductName];
    
    
    
    CGRect textframe = self.nameLabel.frame;
    textframe.size.height = [self heightForString:intro.ProductName fontSize:15 andWidth:self.nameLabel.frame.size.width];
//    NSLog(@"textframe.size.height = %f", textframe.size.height);
    if (textframe.size.height > 40) {
        textframe.size.height = 40;
    }
    self.nameLabel.frame = textframe;
    
    [self.ShopPriceLabel setText:[NSString stringWithFormat:@"AU$ %.2f", intro.ProductShopPrice]];
    NSString * tempStr = [NSString stringWithFormat:@"AU$ %.2f", intro.ProductMarketPrice];
    NSMutableAttributedString * MarketPriceStr = [[NSMutableAttributedString alloc] initWithString:tempStr];
    NSRange range = {0 , tempStr.length};
    [MarketPriceStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:range];
    [self.MarketPriceLabel setAttributedText:MarketPriceStr];
    
    self.ShopPriceLabel.frame = CGRectMake(self.ShopPriceLabel.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.ShopPriceLabel.frame),  CGRectGetHeight(self.ShopPriceLabel.frame));
    
    self.MarketPriceLabel.frame = CGRectMake(self.MarketPriceLabel.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.MarketPriceLabel.frame),  CGRectGetHeight(self.MarketPriceLabel.frame));
    
//    [self.saleNumLabel setText:[NSString stringWithFormat:@"最近售出：%@", @"100"]];
}

-(void)creatCollectTableViewCellWithOrderMerchandiseIntroModel:(OrderMerchandiseIntroModel *)intro{
    
    _currentProduct = intro;
    UIImage *blankImg = [UIImage imageNamed:@"blank_home_banner.png"];
    [self.showImage setImageWithURL:intro.ProductImg placeholderImage:blankImg];
    [self.nameLabel setText:intro.ProductName];
    
    CGRect textframe = self.nameLabel.frame;
    textframe.size.height = [self heightForString:intro.ProductName fontSize:15 andWidth:self.nameLabel.frame.size.width];
//    NSLog(@"textframe.size.height = %f", textframe.size.height);
    if (textframe.size.height > 40) {
        textframe.size.height = 40;
    }
    self.nameLabel.frame = textframe;
    
    [self.ShopPriceLabel setText:[NSString stringWithFormat:@"AU$ %.2f", intro.BuyPrice]];
    [self.MarketPriceLabel setHidden:YES];
    
    self.ShopPriceLabel.frame = CGRectMake(self.ShopPriceLabel.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.ShopPriceLabel.frame),  CGRectGetHeight(self.ShopPriceLabel.frame));
    
    self.MarketPriceLabel.frame = CGRectMake(self.MarketPriceLabel.frame.origin.x, textframe.origin.y + textframe.size.height + 2, CGRectGetWidth(self.MarketPriceLabel.frame),  CGRectGetHeight(self.MarketPriceLabel.frame));
//    [self.commentPicBtn setHidden:NO];
    
    AppConfig * appConfig = [AppConfig sharedAppConfig];
    [appConfig loadConfig];
    NSDictionary * picDic= [NSDictionary dictionaryWithObjectsAndKeys:
                            intro.ProductGuid,@"ProductGuid",
                            @"1",@"pageIndex",
                            @"10",@"pageSize",
                            appConfig.appSign, @"AppSign",
                            intro.orderNum,@"OrderNumber", nil];
    [BluePrintingModel getMerchandisePictureListByParameters:picDic andblock:^(NSArray *List, NSInteger count, NSError *error){
        if (count == 0) {
            intro.isShowComment = YES;
            [self.commentPicBtn setHidden:NO];
        }else {
            intro.isShowComment = NO;
            [self.commentPicBtn setTitle:@"已晒单" forState:UIControlStateNormal];
            [self.commentPicBtn setEnabled:NO];
            [self.commentPicBtn setHidden:NO];
        }
        
    }];

}

@end
