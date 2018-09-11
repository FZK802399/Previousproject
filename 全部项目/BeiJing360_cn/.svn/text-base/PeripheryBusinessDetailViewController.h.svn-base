//
//  PeripheryBusinessDetailViewController.h
//  BeiJing360
//
//  Created by baobin on 11-6-9.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseOperationBusinessDetail.h"
#import "AppRecordBusinessDetail.h"

@class CurrentMapGuideViewController;

@interface PeripheryBusinessDetailViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource,ParseOperationDelegateBusinessDetail, UIAlertViewDelegate> {
	
	IBOutlet UITableView	*peripheryBusinessDetailTableView;
	
	NSArray					*entriesBusinessDetail;   
	NSMutableArray          *appRecordsBusinessDetail;
    NSOperationQueue		*queueBusinessDetail;
    NSURLConnection         *appListFeedConnectionBusinessDetail;
    NSMutableData           *appListDataBusinessDetail;
	
	IBOutlet UIImageView	*peripheryBusinessDetailImage;
	NSMutableData			*receiveImageDataBusinessDetail;
	NSInteger				activeDownloadBusinessImage;
	
	CurrentMapGuideViewController *currentMapGuideViewController;
	
	NSString				*accessSiteForBusiness, *accessTelphoneForBusiness;
}

@property (nonatomic, retain) UITableView			*peripheryBusinessDetailTableView;

@property (nonatomic, retain) NSArray				*entriesBusinessDetail;
@property (nonatomic, retain) NSMutableArray		*appRecordsBusinessDetail;
@property (nonatomic, retain) NSOperationQueue		*queueBusinessDetail;
@property (nonatomic, retain) NSURLConnection		*appListFeedConnectionBusinessDetail;
@property (nonatomic, retain) NSMutableData			*appListDataBusinessDetail;
@property (nonatomic, retain) UIImageView			*peripheryBusinessDetailImage;
@property (nonatomic, retain) CurrentMapGuideViewController *currentMapGuideViewController;
@property (nonatomic, retain) NSString				*accessSiteForBusiness;
@property (nonatomic, retain) NSString				*accessTelphoneForBusiness;

@end
