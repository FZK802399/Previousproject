//
//  SubHomeDetailViewController.h
//  BeiJing360
//
//  Created by baobin on 11-5-30.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SubAppRecord.h"
#import "SubParseOperation.h"

@class MorePanoramaViewController;
@class PeripheryBusinessViewController;
@class CurrentMapGuideViewController;

@interface SubHomeDetailViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource,SubParseOperationDelegate, UIAlertViewDelegate, AVAudioPlayerDelegate> {
	
	IBOutlet UITableView	*placeOfInterestDetailTableView;
	IBOutlet UITableView	*parkPlaceDetailTableView;
	IBOutlet UITableView	*beijingLocationDetailTableView;
	IBOutlet UITableView	*cultureCustomsDetailTableView;
	IBOutlet UITableView	*museumDetailTableView;
	IBOutlet UITableView	*suburbSceneryDetailTableView;
	IBOutlet UITableView	*alleyStreetscapeDetailTableView;
	IBOutlet UITableView	*shoppingCenterDetailTableView;
	IBOutlet UITableView	*barDetailTableView;
	
	CurrentMapGuideViewController *currentMapGuideViewController;
	MorePanoramaViewController		*morePanoramaViewController;
	PeripheryBusinessViewController *peripheryBusinessViewController;
	
	NSArray					*entriesDetail;   
	NSMutableArray          *appRecordsDetail;
    NSOperationQueue		*queueDetail;
    NSURLConnection         *appListFeedConnectionDetail;
    NSMutableData           *appListDataDetail;
	
	NSMutableArray *zuobiao;
	
	IBOutlet UIImageView	*subHomeDetailImage;
	NSMutableData			*receiveImageData;
	NSInteger				activeDownloadImage;

	NSString				*accessSite, *accessTelphone;
	
	AVAudioPlayer *player;
    
    UIActivityIndicatorView *_paymentIndicator;
}

@property (nonatomic, retain) AVAudioPlayer *player;
@property (nonatomic, retain) NSArray				*entriesDetail;
@property (nonatomic, retain) NSMutableArray		*appRecordsDetail;
@property (nonatomic, retain) NSOperationQueue		*queueDetail;
@property (nonatomic, retain) NSURLConnection		*appListFeedConnectionDetail;
@property (nonatomic, retain) NSMutableData			*appListDataDetail;
@property (nonatomic, retain) NSMutableData			*receiveImageData;

@property (nonatomic, retain) NSMutableArray *zuobiao;

@property (nonatomic, retain) UITableView	*placeOfInterestDetailTableView;
@property (nonatomic, retain) UITableView	*parkPlaceDetailTableView;
@property (nonatomic, retain) UITableView	*beijingLocationDetailTableView;
@property (nonatomic, retain) UITableView	*cultureCustomsDetailTableView;
@property (nonatomic, retain) UITableView	*museumDetailTableView;
@property (nonatomic, retain) UITableView	*suburbSceneryDetailTableView;
@property (nonatomic, retain) UITableView	*alleyStreetscapeDetailTableView;
@property (nonatomic, retain) UITableView	*shoppingCenterDetailTableView;
@property (nonatomic, retain) UITableView	*barDetailTableView;

@property (nonatomic, retain) MorePanoramaViewController		*morePanoramaViewController;
@property (nonatomic, retain) PeripheryBusinessViewController	*peripheryBusinessViewController;
@property (nonatomic, retain) CurrentMapGuideViewController		*currentMapGuideViewController;
@property (nonatomic, retain) UIImageView						*subHomeDetailImage;

@property (nonatomic, retain) NSString *accessSite;
@property (nonatomic, retain) NSString *accessTelphone;

-(IBAction)buttonTapped:(id)sender;

//成功购买完成故宫后的回调方法
- (void)successPaymentTransaction;
//购买故宫交易失败的回调方法
- (void)failedPaymentTransaction;


@end
