//
//  CustomerPicker.h
//  Shop
//
//  Created by Ocean Zhang on 4/3/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPickerView.h"

@protocol CustomerPickerDelegate <NSObject>

- (void)touchPickerOk:(id)selectedItem;

@end

@interface CustomerPicker : UIView<MyPickerViewDataSource,MyPickerViewDelegate>

@property (nonatomic, assign) id<CustomerPickerDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)refreshPickerDataSource;

@end
