//
//  UICityPicker.h
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>
#import "RegionModel.h"
#import "AppConfig.h"

@interface TSLocateView : UIActionSheet<UIPickerViewDelegate, UIPickerViewDataSource> {
@private

}

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
//省市区选择
@property (strong, nonatomic) IBOutlet UIPickerView *locationPicker;
@property (strong, nonatomic) NSArray *provinces;//省
@property (strong, nonatomic) NSArray *citys;//市
@property (strong, nonatomic) NSArray *regions;//区
@property (strong, nonatomic) RegionModel *procinelocate;
@property (strong, nonatomic) RegionModel *citylocate;
@property (strong, nonatomic) RegionModel *regionlocate;
@property (strong, nonatomic) AppConfig *appConfig;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate;

- (void)showInView:(UIView *)view;

@end
