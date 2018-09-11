//
//  ShopCartTableViewCell.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-29.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "ShopCartTableViewCell.h"
#import "MerchandiseDetailModel.h"
#import "MerchandiseSpecificationPriceModel.h"
#import "SWUtilityButtonView.h"

static NSString * const kTableViewCellContentView = @"UITableViewCellContentView";


@interface ShopCartTableViewCell () <UIScrollViewDelegate, QCheckBoxDelegate> {
    SWCellState _cellState; // The state of the cell within the scroll view, can be left, right or middle
}

// Scroll view to be added to UITableViewCell
@property (nonatomic, weak) UIScrollView *cellScrollView;

// The cell's height
@property (nonatomic) CGFloat height;



// Views that live in the scroll view
@property (nonatomic, weak) UIView *scrollViewContentView;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewLeft;
@property (nonatomic, strong) SWUtilityButtonView *scrollViewButtonViewRight;

@property (nonatomic, strong) QCheckBox *checkButton;

@property (nonatomic, strong) UIImageView *ico_image;

@property (nonatomic, strong) UILabel *productName;

@property (nonatomic, strong) UILabel *productAttribute;

@property (nonatomic, strong) UILabel *productPrice;

@property (nonatomic, strong) UILabel *productActivity;

@property (strong, nonatomic) TextStepperField *changeBuyNumber;

@property (strong ,nonatomic) AppConfig *appConfig;

// Used for row height and selection
@property (nonatomic, weak) UITableView *containingTableView;


@end

@implementation ShopCartTableViewCell

#pragma mark Initializers

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
    
    if (_checkButton == nil) {
        _checkButton = [[QCheckBox alloc] initWithFrame:CGRectMake(12, 30, 44, 44)];
        [_checkButton setDelegate:self];
        [self.contentView addSubview:_checkButton];
    }
    
    if (_ico_image == nil) {
        _ico_image = [[UIImageView alloc] initWithFrame:CGRectMake(44, 8, 85, 85)];
        [self.contentView addSubview:_ico_image];
    }
    UIButton * btnclick = [UIButton buttonWithType:UIButtonTypeCustom];
    btnclick.frame = CGRectMake(40, 8, 85, 85);
    btnclick.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnclick];
    
    if (_productName == nil) {
        _productName = [[UILabel alloc] initWithFrame:CGRectMake(136, 8, 180, 40)];
        _productName.numberOfLines = 2;
//        _productName.topInset = 0;
        _productName.font = [UIFont systemFontOfSize:15];
        _productName.lineBreakMode = NSLineBreakByWordWrapping;
        _productName.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_productName];
    }
    UIButton * btnclick2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btnclick2.frame = self.productName.bounds;
    btnclick2.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:btnclick2];
    
    [btnclick addTarget:self action:@selector(btnClickActionGoDetail:) forControlEvents:UIControlEventTouchUpInside];
    [btnclick2 addTarget:self action:@selector(btnClickActionGoDetail:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_productAttribute == nil) {
        _productAttribute = [[UILabel alloc] initWithFrame:CGRectMake(136, 39, 169, 15)];
        _productAttribute.numberOfLines = 1;
        _productAttribute.font = [UIFont systemFontOfSize:13];
        _productAttribute.backgroundColor = [UIColor clearColor];
        _productAttribute.textColor = [UIColor textTitleColor];
        [self.contentView addSubview:_productAttribute];
    }
    
    if (_productPrice == nil) {
        _productPrice = [[UILabel alloc] initWithFrame:CGRectMake(136, 77, 150, 12)];
        _productPrice.numberOfLines = 1;
        _productPrice.font = [UIFont workListDetailFont];
        _productPrice.backgroundColor = [UIColor clearColor];
        _productPrice.textColor = [UIColor redColor];
        [self.contentView addSubview:_productPrice];
    }
    
//    if (_productActivity == nil) {
//        _productActivity = [[UILabel alloc] initWithFrame:CGRectMake(46, 100, 265, 13)];
//        _productActivity.numberOfLines = 1;
//        _productActivity.font = [UIFont workListDetailFont];
//        _productActivity.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_productPrice];
//    }
    
    if (_changeBuyNumber == nil) {
        _changeBuyNumber = [[TextStepperField alloc] initWithFrame:CGRectMake(232, 71, 75, 25)];
        [_changeBuyNumber addTarget:self action:@selector(buyNumberChange:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_changeBuyNumber];
    }
    
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

-(void)btnClickActionGoDetail:(id)sender{
    if ([_currentMerchandise isKindOfClass:[ShopCartMerchandiseModel class]]) {
        if ([self.delegate respondsToSelector:@selector(clickImageOrTitle:)]) {
            [self.delegate clickImageOrTitle:_currentMerchandise];
        }
    }else {
        
    }
    
    
}

-(void)creatShopCartTableViewCellWithShopCartScoreMerchandiseModel:(ShopCartScoreMerchandiseModel *)intro{
    
    self.appConfig = [AppConfig sharedAppConfig];
    _currentMerchandise = intro;
    
    [self.ico_image setImageWithURL:intro.originalImage placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.productName.text = [intro.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    CGRect textframe = self.productName.frame;
    textframe.size.height = [self heightForString:intro.name fontSize:15 andWidth:self.productName.frame.size.width];
    if (textframe.size.height > 45) {
        textframe.size.height = 45;
    }
    self.productName.frame = textframe;
    self.productPrice.frame = CGRectMake(self.productAttribute.frame.origin.x, self.productName.frame.origin.y + CGRectGetHeight(self.productName.frame), self.productAttribute.frame.size.width, self.productAttribute.frame.size.height);
    self.productPrice.text = [NSString stringWithFormat:@"AU$%.2f + %d积分",intro.prmo, intro.buyScore];
//    self.productAttribute.text = intro.Attributes;
    
    
    [self.changeBuyNumber setMaximum:intro.RepertoryCount];
    
    self.changeBuyNumber.Minimum = 1;
    
    //    [self.changeBuyNumber setIsEditableTextField:YES];
    
    self.changeBuyNumber.Step = 1;
    self.changeBuyNumber.Current = intro.buyNumber;
    [self.checkButton setImage:[UIImage imageNamed:@"shopcart_uncheck.png"] forState:UIControlStateNormal];
    [self.checkButton setImage:[UIImage imageNamed:@"shopcart_check.png"] forState:UIControlStateSelected];
    
    [self.checkButton setChecked:intro.isCheckForShopCart];
    
}

-(void)creatShopCartTableViewCellWithShopCartMerchandiseModel:(ShopCartMerchandiseModel *)intro{
    
    self.appConfig = [AppConfig sharedAppConfig];
    _currentMerchandise = intro;
    
    [self.ico_image setImageWithURL:intro.originalImage placeholderImage:[UIImage imageNamed:@"nopic"]];
    self.productName.text = [intro.name stringByReplacingOccurrencesOfString:@" " withString:@""];
    CGRect textframe = self.productName.frame;
    textframe.size.height = [self heightForString:intro.name fontSize:14 andWidth:self.productName.frame.size.width];
    if (textframe.size.height > 45) {
        textframe.size.height = 45;
    }
    self.productName.frame = textframe;
    self.productAttribute.frame = CGRectMake(self.productAttribute.frame.origin.x, self.productName.frame.origin.y + CGRectGetHeight(self.productName.frame), self.productAttribute.frame.size.width, self.productAttribute.frame.size.height);
    self.productPrice.text = [NSString stringWithFormat:@"AU$%.2f",intro.buyPrice];
    self.productAttribute.text = intro.Attributes;
    
    NSDictionary * detailDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                intro.productGuid,@"id",
                                kWebAppSign,@"AppSign",self.appConfig.loginName,@"MemLoginID",nil];
    [MerchandiseDetailModel getMerchandiseDetailByParamer:detailDic andblock:^(MerchandiseDetailModel *detail, NSError *error) {
        if (error) {
            //            [self showAlertWithMessage:@"网络错误"];
        }else {
            if (detail) {
                intro.procuctWeight = detail.productWeight;
            }
        }
    }];
    

    [self.changeBuyNumber setMaximum:intro.RepertoryCount];
    
    self.changeBuyNumber.Minimum = 1;
    
//    [self.changeBuyNumber setIsEditableTextField:YES];
    
    self.changeBuyNumber.Step = 1;
    self.changeBuyNumber.Current = intro.buyNumber;
    [self.checkButton setImage:[UIImage imageNamed:@"shopcart_uncheck.png"] forState:UIControlStateNormal];
    [self.checkButton setImage:[UIImage imageNamed:@"shopcart_check.png"] forState:UIControlStateSelected];
    
    [self.checkButton setChecked:intro.isCheckForShopCart];
    
}


- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

- (void)buyNumberChange:(id)sender {
    if ([_currentMerchandise isKindOfClass:[ShopCartMerchandiseModel class]]) {
        ShopCartMerchandiseModel *tempModel = (ShopCartMerchandiseModel *)_currentMerchandise;
        if (_changeBuyNumber.TypeChange == TextStepperFieldChangeKindNegative) {
            if (tempModel.buyNumber > self.changeBuyNumber.Minimum) {
                tempModel.buyNumber--;
            }else {
                tempModel.buyNumber = 1;
            }
            if ([self.delegate respondsToSelector:@selector(countSubtract:)]) {
                [self.delegate countSubtract:tempModel];
            }
            
            
        }else {
            if (tempModel.buyNumber < self.changeBuyNumber.Maximum) {
                tempModel.buyNumber++;
            }else {
                tempModel.buyNumber = self.changeBuyNumber.Maximum;
            }
            if ([self.delegate respondsToSelector:@selector(countAdd:)]) {
                [self.delegate countAdd:tempModel];
            }
        }
    }else if ([_currentMerchandise isKindOfClass:[ShopCartScoreMerchandiseModel class]]) {
        ShopCartScoreMerchandiseModel *tempModel = (ShopCartScoreMerchandiseModel *)_currentMerchandise;
        if (_changeBuyNumber.TypeChange == TextStepperFieldChangeKindNegative) {
            if (tempModel.buyNumber > self.changeBuyNumber.Minimum) {
                tempModel.buyNumber--;
            }else {
                tempModel.buyNumber = 1;
            }
            if ([self.delegate respondsToSelector:@selector(countSubtract:)]) {
                [self.delegate countSubtract:tempModel];
            }
            
            
        }else {
            if (tempModel.buyNumber < self.changeBuyNumber.Maximum) {
                tempModel.buyNumber++;
            }else {
                tempModel.buyNumber = self.changeBuyNumber.Maximum;
            }
            if ([self.delegate respondsToSelector:@selector(countAdd:)]) {
                [self.delegate countAdd:tempModel];
            }
        }
    }
}

-(void)didSelectedCheckBox:(QCheckBox *)checkbox checked:(BOOL)checked{
    if ([_currentMerchandise isKindOfClass:[ShopCartMerchandiseModel class]]) {
        ShopCartMerchandiseModel *tempModel = (ShopCartMerchandiseModel *)_currentMerchandise;
        tempModel.isCheckForShopCart = checked;
    
    }else {
        ShopCartScoreMerchandiseModel *tempModel = (ShopCartScoreMerchandiseModel *)_currentMerchandise;
        tempModel.isCheckForShopCart = checked;
    }
    
    if ([self.delegate respondsToSelector:@selector(btnCheckOrUnCheck:status:)]) {
        [self.delegate btnCheckOrUnCheck:_currentMerchandise status:checked];
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

- (void)hideUtilityButtonsAnimated:(BOOL)animated {
    // Scroll back to center
    [self.cellScrollView setContentOffset:CGPointMake([self leftUtilityButtonsWidth], 0) animated:animated];
    _cellState = kCellStateCenter;
    
    if ([_delegate respondsToSelector:@selector(swippableTableViewCell:scrollingToState:)]) {
        [_delegate swippableTableViewCell:self scrollingToState:kCellStateCenter];
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

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    switch (_cellState) {
        case kCellStateCenter:
            if (velocity.x >= 0.5f) {
                [self scrollToRight:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                [self scrollToLeft:targetContentOffset];
            } else {
                CGFloat rightThreshold = [self utilityButtonsPadding] - ([self rightUtilityButtonsWidth] / 2);
                CGFloat leftThreshold = [self leftUtilityButtonsWidth] / 2;
                if (targetContentOffset->x > rightThreshold)
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x < leftThreshold)
                    [self scrollToLeft:targetContentOffset];
                else
                    [self scrollToCenter:targetContentOffset];
            }
            break;
        case kCellStateLeft:
            if (velocity.x >= 0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else if (velocity.x <= -0.5f) {
                // No-op
            } else {
                if (targetContentOffset->x >= ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToRight:targetContentOffset];
                else if (targetContentOffset->x > [self leftUtilityButtonsWidth] / 2)
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToLeft:targetContentOffset];
            }
            break;
        case kCellStateRight:
            if (velocity.x >= 0.5f) {
                // No-op
            } else if (velocity.x <= -0.5f) {
                [self scrollToCenter:targetContentOffset];
            } else {
                if (targetContentOffset->x <= [self leftUtilityButtonsWidth] / 2)
                    [self scrollToLeft:targetContentOffset];
                else if (targetContentOffset->x < ([self utilityButtonsPadding] - [self rightUtilityButtonsWidth] / 2))
                    [self scrollToCenter:targetContentOffset];
                else
                    [self scrollToRight:targetContentOffset];
            }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x > [self leftUtilityButtonsWidth]) {
        // Expose the right button view
        self.scrollViewButtonViewRight.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - [self rightUtilityButtonsWidth]), 0.0f, [self rightUtilityButtonsWidth], _height);
    } else {
        // Expose the left button view
        self.scrollViewButtonViewLeft.frame = CGRectMake(scrollView.contentOffset.x, 0.0f, [self leftUtilityButtonsWidth], _height);
    }
}

@end


