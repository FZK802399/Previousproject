//
//  TextStepperField.m
//
//  Created by Manuel Garcia Lopez 24-1-2011.
//

#import "TextStepperField.h"

@interface TextStepperField ()

@property (nonatomic, retain, readonly) UIButton *plusButton;
@property (nonatomic, retain, readonly) UIButton *minusButton;
@property (nonatomic, retain, readonly) UIImageView *middleImage;
@property (nonatomic, retain, readonly) UITextField  *textField;

- (void)      initializeControl;
- (NSString*) getPlaceholderText;
- (void)      didChangeTextField;
@end

@implementation TextStepperField

@synthesize plusButton = _plusButton,
minusButton = _minusButton,
middleImage = _middleImage,
TypeChange = _value, 
textField = _textField,
Current,
NumDecimals=_NumDecimals, 
Maximum=_Maximum, 
Minimum=_Minimum, 
Step= _Step, 
IsEditableTextField= _IsEditableTextField;

TextStepperFieldChangeKind _longTapLoopValue;


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeControl];
    }
    return self;
}

- (void)awakeFromNib {
    [self initializeControl];
}

- (void)initializeControl {
    self.NumDecimals=0;
    self.Step=1;
    self.Maximum = INFINITY;
    self.Minimum = INFINITY*-1;
    self.autoresizesSubviews=YES;
    self.IsEditableTextField = NO;
    self.backgroundColor = [UIColor clearColor];
    self.multipleTouchEnabled = NO;
    self.clipsToBounds = YES;
    
    UIColor *btnBorderColor = [UIColor colorWithRed:207 /255.0f green:207 /255.0f blue:207 /255.0f alpha:1];
    CGSize BFStepperButton = CGSizeMake(22, 25);
    
    // button minus in to left
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.minusButton.frame = CGRectMake(0.0, 0.0, BFStepperButton.width, BFStepperButton.height);
    [self.minusButton setBackgroundImage:[UIImage imageNamed:@"UIStepperMinus.png"] forState:UIControlStateNormal];
    [self.minusButton addTarget:self action:@selector(didPressMinusButton) forControlEvents:UIControlEventTouchUpInside];
    [self.minusButton addTarget:self action:@selector(didBeginMinusLongTap) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self.minusButton addTarget:self action:@selector(didEndLongTap) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
    self.minusButton.autoresizingMask = UIViewAutoresizingNone; // push tu none
    self.minusButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin| UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
    [self.minusButton.layer setMasksToBounds:YES];
    self.minusButton.layer.borderWidth = 1;
    self.minusButton.layer.borderColor = [btnBorderColor CGColor];
    [self addSubview:self.minusButton];
    
    // button plus in to right
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.plusButton.frame = CGRectMake(self.frame.size.width - BFStepperButton.width, 0.0, BFStepperButton.width, BFStepperButton.height);
    [self.plusButton setBackgroundImage:[UIImage imageNamed:@"UIStepperPlus.png"] forState:UIControlStateNormal];
    [self.plusButton addTarget:self action:@selector(didPressPlusButton) forControlEvents:UIControlEventTouchUpInside];
    [self.plusButton addTarget:self action:@selector(didBeginPlusLongTap) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self.plusButton addTarget:self action:@selector(didEndLongTap)  forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside | UIControlEventTouchCancel | UIControlEventTouchDragExit];
    self.plusButton.autoresizingMask = UIViewAutoresizingNone; // push to none
    self.plusButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight |UIViewAutoresizingFlexibleBottomMargin;
    [self.plusButton.layer setMasksToBounds:YES];
    self.plusButton.layer.borderWidth = 1;
    self.plusButton.layer.borderColor = [btnBorderColor CGColor];
    [self addSubview:self.plusButton];
    
    
    //TextField the number
    _textField = [[UITextField alloc] init];
    self.textField.textAlignment = NSTextAlignmentCenter;
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.clearButtonMode = UITextFieldViewModeNever;
    self.textField.borderStyle = UITextBorderStyleNone;
    self.textField.placeholder = [self getPlaceholderText];
    self.textField.inputView = nil;
    [self.textField setEnabled:NO];
    [self.textField setFont:[UIFont systemFontOfSize:14]];
    self.textField.textColor = [UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1];
    [self.textField setKeyboardType:UIKeyboardTypeDecimalPad];
//    CGSize sizeField= [self.textField sizeThatFits:BFStepperButton];
    self.textField.frame = CGRectMake(BFStepperButton.width, 3 ,self.frame.size.width - (BFStepperButton.width*2), BFStepperButton.height - 6);
    [self.textField addTarget:self action:@selector(didChangeTextField) forControlEvents: UIControlEventEditingChanged];
//    self.textField.layer.borderColor = btnBorderColor.CGColor;
//    self.textField.layer.borderWidth = 1;
//    CALayer *topLabelBorder = [CALayer layer];
//    topLabelBorder.borderWidth = 1;
//    topLabelBorder.borderColor = btnBorderColor.CGColor;
//    topLabelBorder.frame = CGRectMake(0, 0, self.textField.frame.size.width, 1);
//    [self.textField.layer addSublayer:topLabelBorder];
//    
//    CALayer *bottomLabelBorder = [CALayer layer];
//    bottomLabelBorder.borderWidth = 1;
//    bottomLabelBorder.borderColor = btnBorderColor.CGColor;
//    bottomLabelBorder.frame = CGRectMake(0, BFStepperButton.height - 1, self.textField.frame.size.width, 1);
//    [self.textField.layer addSublayer:bottomLabelBorder];
    
    self.textField.autoresizingMask = UIViewAutoresizingNone; // push to none
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin;
    [self addSubview:self.textField];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = btnBorderColor.CGColor;
}


-(float) Current
{    
    return [self.textField.text floatValue];
}

-(void) setCurrent:(float)pflValue
{
    if (pflValue  <= self.Minimum) {
        [self.minusButton setEnabled:NO];
    }
    if (pflValue  >= self.Maximum) {
        [self.plusButton setEnabled:NO];
    }
    self.textField.text = [NSString stringWithFormat:[@"%.Xf" stringByReplacingOccurrencesOfString:@"X" withString:[NSString stringWithFormat:@"%d", self.NumDecimals]], pflValue];
}

- (NSString*)getPlaceholderText
{
    NSMutableString *lstrDato = [NSMutableString stringWithString: @"0"];
    for (int i=0; i<self.NumDecimals; i++) 
    {
        if (lstrDato.length ==1) // is first time
        {
            [lstrDato appendString:@"."];
        }
        [lstrDato appendString:@"0"];
    }
    return lstrDato;
}

-(void) setIsEditableTextField:(BOOL)pIsEditableTextField
{
    _IsEditableTextField = pIsEditableTextField;
    
    self.textField.enabled = _IsEditableTextField;
}

-(void) setNumDecimals:(int)pNumDecimals
{
    if (_NumDecimals<0) {
        _NumDecimals =0;
    }
    
    _NumDecimals = pNumDecimals;
    
    self.textField.placeholder = [self getPlaceholderText]; // to correctly display the decimal number when deleting all charaters
    
    self.Current = self.Current; // to re-display it correctly
}


-(void) didChangeTextField
{
    [self.minusButton setEnabled:YES];
    [self.plusButton setEnabled:YES];
    if ( self.Current < self.Minimum) 
        self.Current = self.Minimum;
    
    if ( self.Current > self.Maximum) 
        self.Current = self.Maximum;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}


-(void) setTypeChange:(TextStepperFieldChangeKind)pTypeChange
{
    _value = pTypeChange;
    
    if (self.TypeChange ==TextStepperFieldChangeKindNegative )
    { // push -
        if ( self.Current > self.Minimum) {
            [self.plusButton setEnabled:YES];
            self.Current = self.Current- self.Step;
        }else{
            self.Current = self.Minimum;
            [self.minusButton setEnabled:NO];
        }
        
    }
    else
    { // push +
        if ( self.Current < self.Maximum) {
            self.Current = self.Current+ self.Step;
            [self.minusButton setEnabled:YES];
        }
        else{
            [self.plusButton setEnabled:NO];
            self.Current = self.Maximum;
        }
        
    }
}

#pragma mark - Button Events

#pragma mark Plus Button Events

- (void)didPressPlusButton {
    [self.textField resignFirstResponder];
    self.TypeChange = TextStepperFieldChangeKindPositive;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didBeginPlusLongTap {
    [self.textField resignFirstResponder];
    _longTapLoopValue = TextStepperFieldChangeKindPositive;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(backgroundLongTapLoop) object:nil];
    [self performSelector:@selector(backgroundLongTapLoop) withObject:nil afterDelay:0.5];
}

#pragma mark Minus Button Events

- (void)didPressMinusButton {
    [self.textField resignFirstResponder];
    self.TypeChange = TextStepperFieldChangeKindNegative;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didBeginMinusLongTap {
    [self.textField resignFirstResponder];
    _longTapLoopValue = TextStepperFieldChangeKindNegative;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(backgroundLongTapLoop) object:nil];
    [self performSelector:@selector(backgroundLongTapLoop) withObject:nil afterDelay:0.5];
}

#pragma mark Long Tap Loop

- (void)didEndLongTap {
    [self.textField resignFirstResponder];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(backgroundLongTapLoop) object:nil];
}

- (void)backgroundLongTapLoop {
    [self.textField resignFirstResponder];
    [self performSelectorOnMainThread:@selector(longTapLoop) withObject:nil waitUntilDone:YES];
    [self performSelector:@selector(backgroundLongTapLoop) withObject:nil  afterDelay:0.1];
}

- (void)longTapLoop {
    [self.textField resignFirstResponder];
    self.TypeChange= _longTapLoopValue;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
