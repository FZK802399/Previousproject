//
//  MessageItemTableViewCell.m
//  Shop
//
//  Created by Ocean Zhang on 4/20/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MessageItemTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SWUtilityButtonView.h"

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";



@interface MessageItemTableViewCell()<UIScrollViewDelegate> {
    MITCCellState _cellState; // The state of the cell within the scroll view, can be left, right or middle
}

@property (nonatomic, strong) UILabel *lbTitle;
@property (nonatomic, strong) UILabel *lbTime;
@property (nonatomic, strong) UILabel *lbContent;
// Scroll view to be added to UITableViewCell
@property (nonatomic, weak) UIScrollView *cellScrollView;

@property (nonatomic, weak) UIView *scrollViewContentView;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewRight;

// Used for row height and selection
@property (nonatomic, weak) UITableView *containingTableView;

// The cell's height
@property (nonatomic) CGFloat height;

@end

@implementation MessageItemTableViewCell

@synthesize lbTitle = _lbTitle;
@synthesize lbTime = _lbTime;
@synthesize lbContent = _lbContent;

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
    
    UIColor *grayColor = [UIColor colorWithRed:136 /255.0f green:136 /255.0f blue:137 /255.0f alpha:1];
    UIFont *font14 = [UIFont systemFontOfSize:14.0f];
    
    CGFloat originX = 6;
    CGFloat originY = 4;
    CGFloat titleWidth = SCREEN_WIDTH - 40;
    CGFloat titleHeight = 20;
    
    CGFloat timeWidth = 130;
    
    CALayer *toplayer = [CALayer layer];
    toplayer.frame = CGRectMake(0, 0 , SCREEN_WIDTH, 1);
    toplayer.backgroundColor = [UIColor colorWithRed:242 /255.0f green:242 /255.0f blue:242 /255.0f alpha:1].CGColor;
    //border.borderWidth = 1;
    
    [self.contentView.layer addSublayer:toplayer];
    
    CALayer *toplayer2 = [CALayer layer];
    toplayer2.frame = CGRectMake(0, 25 , SCREEN_WIDTH, 1);
    toplayer2.backgroundColor = [UIColor colorWithRed:242 /255.0f green:242 /255.0f blue:242 /255.0f alpha:1].CGColor;
    //border.borderWidth = 1;
    
    [self.contentView.layer addSublayer:toplayer2];
    
    //        UIImageView * noReadImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY + 4, 16, 16)];
    //        noReadImage.image = [UIImage imageNamed:@"newMessage_tip.png"];
    //        [self.contentView addSubview:noReadImage];
    
    UIImageView * icoImage = [[UIImageView alloc] initWithFrame:CGRectMake(originX, originY + 4, 13, 11)];
    icoImage.image = [UIImage imageNamed:@"messge_ico.png"];
    [self.contentView addSubview:icoImage];
    
    if(_lbTitle == nil){
        _lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(originX + 15, originY, titleWidth, titleHeight)];
        _lbTitle.textColor = [UIColor blackColor];
        _lbTitle.font = [UIFont systemFontOfSize:16.0f];
        _lbTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_lbTitle];
    }
    
    CALayer *bottomlayer = [CALayer layer];
    bottomlayer.frame = CGRectMake(0, 115 - 31, SCREEN_WIDTH, 1);
    bottomlayer.backgroundColor = [UIColor colorWithRed:242 /255.0f green:242 /255.0f blue:242 /255.0f alpha:1].CGColor;
    
    [self.contentView.layer addSublayer:bottomlayer];
    
    CALayer *bottomlayer2 = [CALayer layer];
    bottomlayer2.frame = CGRectMake(0, 115 - 6 , SCREEN_WIDTH, 1);
    bottomlayer2.backgroundColor = [UIColor colorWithRed:242 /255.0f green:242 /255.0f blue:242 /255.0f alpha:1].CGColor;
    //border.borderWidth = 1;
    
    [self.contentView.layer addSublayer:bottomlayer2];
    
    if(_lbTime == nil){
        _lbTime = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 6 - timeWidth, 115-28, timeWidth, titleHeight)];
        _lbTime.textColor = [UIColor colorWithRed:255 /255.0f green:154 /255.0f blue:54 /255.0f alpha:1];
        _lbTime.textAlignment = NSTextAlignmentRight;
        _lbTime.font = [UIFont systemFontOfSize:11.0f];
        _lbTime.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_lbTime];
    }
    
    originY += titleHeight;
    
    if(_lbContent == nil){
        _lbContent = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, SCREEN_WIDTH - 2 * originX, 60)];
        _lbContent.textColor = grayColor;
        _lbContent.font = font14;
        _lbContent.lineBreakMode = NSLineBreakByCharWrapping;
        _lbContent.numberOfLines = 3;
        _lbContent.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_lbContent];
    }
    
    
    CALayer *border = [CALayer layer];
    border.frame = CGRectMake(0, 115 -5 , SCREEN_WIDTH, 5);
    border.backgroundColor = [UIColor colorWithRed:234 /255.0f green:234 /255.0f blue:234 /255.0f alpha:1].CGColor;
    //border.borderWidth = 1;
    
    [self.contentView.layer addSublayer:border];
    
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [UIColor colorWithRed:242 /255.0f green:242 /255.0f blue:242 /255.0f alpha:1].CGColor;
    
    
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

- (void)createWithMessageModelMy:(MessageModelMy *)model{
    if(model.Type == 1){
        self.contentView.backgroundColor = [UIColor whiteColor];
    }else{
        self.contentView.backgroundColor = [UIColor colorWithRed:242 /255.0f green:243 /255.0f blue:245 /255.0f alpha:1];
    }
    _lbTitle.text =model.Title;
    _lbTime.text = model.SendTime;
    _lbContent.text = model.Content;
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


@end
