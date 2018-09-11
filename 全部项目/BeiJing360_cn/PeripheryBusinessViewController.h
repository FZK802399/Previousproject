//
//  PeripheryBusinessViewController.h
//  BeiJing360
//
//  Created by baobin on 11-6-8.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessAppRecord.h"
#import "BusinessParseOperation.h"

@class PeripheryBusinessDetailViewController;

@interface PeripheryBusinessViewController : UIViewController
<UIScrollViewDelegate,UITableViewDelegate, UITableViewDataSource, BusinessParseOperationDelegate>{
	
	IBOutlet UITableView	*peripheryBusinessTableView;
	
	NSArray					*entriesBusiness;   
	NSMutableArray          *appRecordsBusiness;
    NSOperationQueue		*queueBusiness;
    NSURLConnection         *appListFeedConnectionBusiness;
    NSMutableData           *appListDataBusiness;
	NSArray					*visblePathsBusiness;
	UITableViewCell			*cellDisplayBusiness;
	
	PeripheryBusinessDetailViewController *peripheryBusinessDetailViewController;
}

@property (nonatomic, retain) UITableView			*peripheryBusinessTableView;


@property (nonatomic, retain) NSArray				*entriesBusiness;
@property (nonatomic, retain) NSMutableArray		*appRecordsBusiness;
@property (nonatomic, retain) NSOperationQueue		*queueBusiness;
@property (nonatomic, retain) NSURLConnection		*appListFeedConnectionBusiness;
@property (nonatomic, retain) NSMutableData			*appListDataBusiness;
@property (nonatomic, retain) NSArray				*visblePathsBusiness;
@property (nonatomic, retain) UITableViewCell		*cellDisplayBusiness;
@property (nonatomic, retain) PeripheryBusinessDetailViewController *peripheryBusinessDetailViewController;

@end
