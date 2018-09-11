//
//  AddressViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-28.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "AddressModel.h"

typedef enum {
    AddressListForView = 0 ,
    AddressListForSelect = 1
}AddressListShowType;

@protocol AddressListViewControllerDelegate <NSObject>

- (void)selectedAddress:(AddressModel *)address;

@end

@interface AddressViewController : WFSViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *addressTableView;
@property (strong, nonatomic) NSArray * addressList;

///类型 0: 查看 1:订单选择
@property (nonatomic, assign) AddressListShowType showType;

@property (nonatomic, assign) id<AddressListViewControllerDelegate> delegate;
@end
