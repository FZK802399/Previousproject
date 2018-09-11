//
//  AppiralViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-26.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"
#import "CommentList.h"

@interface AppiralViewController : WFSViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) CommentList *appraisalListView;
@property (strong, nonatomic) IBOutlet UIView *ViewContent;

@property (strong, nonatomic) IBOutlet UIButton *btnAppiral;
@property (strong, nonatomic) IBOutlet UIButton *btnBlueprinting;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (strong, nonatomic) NSString *ProductGuid;

- (IBAction)changeViewClick:(id)sender;

@end
