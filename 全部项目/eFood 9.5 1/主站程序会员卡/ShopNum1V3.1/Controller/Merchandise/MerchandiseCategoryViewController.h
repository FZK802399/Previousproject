//
//  MerchandiseCategoryViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-11-28.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "HeadView.h"

@interface MerchandiseCategoryViewController : WFSViewController<UITableViewDataSource, UITableViewDelegate, HeadViewDelegate>{
    NSInteger _currentSection;
    NSInteger _currentRow;
    

}
@property (strong, nonatomic) IBOutlet UITableView *categoryTableView;

@property(nonatomic, retain) NSMutableArray* headViewArray;

@property (nonatomic, assign) NSInteger rootID;

@end
