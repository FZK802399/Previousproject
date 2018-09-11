//
//  CustomerPicker.m
//  Shop
//
//  Created by Ocean Zhang on 4/3/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "CustomerPicker.h"
#import "RegionModel.h"
#import "PayTypeModel.h"
#import "PostTypeModel.h"

@interface CustomerPicker()

@property (nonatomic, strong) MyPickerView *pickerView;

@property (nonatomic, strong) UIView *btnContainter;

@property (nonatomic, strong) UIButton *btnCancel;

@property (nonatomic, strong) UIButton *btnOk;

@property (nonatomic, strong) id selectitem;

@end


@implementation CustomerPicker

@synthesize pickerView = _pickerView;
@synthesize btnContainter = _btnContainter;
@synthesize btnCancel = _btnCancel;
@synthesize btnOk = _btnOk;
@synthesize selectitem = _selectitem;

@synthesize dataSource = _dataSource;

@synthesize delegate = _delegate;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat pickerWidth = 320;
        
        CGFloat containterWidth = 320;
        CGFloat containterHeight = 30;
        
        if(_btnContainter == nil){
            _btnContainter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, containterWidth, containterHeight)];
            _btnContainter.backgroundColor = [UIColor colorWithRed:0 /255.0f green:0 /255.0f blue:0 /255.0f alpha:1];
            [self addSubview:_btnContainter];
        }
        
        CGFloat btnOrignX = 10;
        CGFloat btnHeight = 25;
        CGFloat btnWidth = 50;
        
        UIFont *fontSize = [UIFont systemFontOfSize:12.0f];
        
        if(_btnCancel == nil){
            _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnCancel.frame = CGRectMake(btnOrignX, (containterHeight - btnHeight) / 2, btnWidth, btnHeight);
            [_btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnCancel.backgroundColor = [UIColor clearColor];
            [_btnCancel addTarget:self action:@selector(btnCancelTouch:) forControlEvents:UIControlEventTouchUpInside];
            [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
            _btnCancel.titleLabel.font = fontSize;
            [_btnContainter addSubview:_btnCancel];
        }
        
        if(_btnOk == nil){
            _btnOk = [UIButton buttonWithType:UIButtonTypeCustom];
            _btnOk.frame = CGRectMake(containterWidth - btnWidth, (containterHeight - btnHeight) / 2, btnWidth, btnHeight);
            [_btnOk setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _btnOk.backgroundColor = [UIColor clearColor];
            [_btnOk addTarget:self action:@selector(btnOKTouch:) forControlEvents:UIControlEventTouchUpInside];
            [_btnOk setTitle:@"确定" forState:UIControlStateNormal];
            _btnOk.titleLabel.font = fontSize;
            [_btnContainter addSubview:_btnOk];
        }
        
        if(_pickerView == nil){
            _pickerView = [[MyPickerView alloc] initWithFrame:CGRectMake(0, containterHeight, pickerWidth, 216)];
            _pickerView.dataSource = self;
            _pickerView.delegate = self;
//            _pickerView.backgroundColor = [UIColor whiteColor];
//            _pickerView.showsSelectionIndicator = YES;
            [_pickerView update];
            [self addSubview:_pickerView];
        }
        
//        CGRect pickerViewRect = _pickerView.frame;
//        pickerViewRect.size.height += btnHeight;
//        self.frame = pickerViewRect;
    }
    return self;
}

- (void)refreshPickerDataSource{
    
    [_pickerView reloadData];
    [_pickerView update];
    if([_dataSource count] > 0){
        _selectitem = [_dataSource objectAtIndex:0];
//        [_pickerView selectRow:0 inComponent:0 animated:YES];
    }
}

- (IBAction)btnCancelTouch:(id)sender{
    [self setHidden:YES];
}

- (IBAction)btnOKTouch:(id)sender{
    if([self.delegate respondsToSelector:@selector(touchPickerOk:)]){
        [self.delegate touchPickerOk:_selectitem];
    }
    [self setHidden:YES];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)pickerView:(MyPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(_dataSource == nil)
        return 0;
    
    return [_dataSource count];
}

- (NSInteger)numberOfComponentsInPickerView:(MyPickerView *)pickerView{
    return 1;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(MyPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if(row < [_dataSource count]){
        _selectitem = [_dataSource objectAtIndex:row];
    }
}

- (NSString *)pickerView:(MyPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(_dataSource == nil)
        return @"";
    
    id pickerValue = [_dataSource objectAtIndex:row];
    if([pickerValue isKindOfClass:[NSString class]]){
        return pickerValue;
    }else if ([pickerValue isKindOfClass:[RegionModel class]]){
        return ((RegionModel *)pickerValue).name;
    }else if([pickerValue isKindOfClass:[PayTypeModel class]]){
        return ((PayTypeModel *)pickerValue).name;
    }else if ([pickerValue isKindOfClass:[PostTypeModel class]]){
        //运费
        PostTypeModel *postType =(PostTypeModel *)pickerValue;
        
        return [NSString stringWithFormat:@"%@  AU$%.2f",postType.PostTypeName,postType.PostTypeValue];
    }
    
    return @"";
}
@end
