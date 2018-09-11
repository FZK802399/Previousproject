//
//  MorePanoramaViewController.h
//  BeiJing360
//
//  Created by baobin on 11-6-2.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PanoIconDownloader.h"
#import "PanoAppRecord.h"
#import "PanoParseOperation.h"

@class CustomMorePanoViewController;
@class CustomMorePanoViewCell;

@interface MorePanoramaViewController : UIViewController 
<UIScrollViewDelegate, PanoIconDownloaderDelegate, UITableViewDelegate, UITableViewDataSource, PanoParseOperationDelegate> {

	IBOutlet UITableView	*morePanoramaTableView;
	
	NSArray					*entriesPano;   
    NSMutableDictionary		*imageDownloadsInProgressPano; 
	NSMutableArray          *appRecordsPano;
    NSOperationQueue		*queuePano;
    NSURLConnection         *appListFeedConnectionPano;
    NSMutableData           *appListDataPano;
	NSArray					*visblePathsPano;
	CustomMorePanoViewCell	*cellDisplayPano;
	CustomMorePanoViewController *customMorePano;
	
}

@property (nonatomic, retain) UITableView			*morePanoramaTableView;
@property (nonatomic, retain) NSArray				*entriesPano;
@property (nonatomic, retain) NSMutableDictionary	*imageDownloadsInProgressPano;
@property (nonatomic, retain) NSMutableArray		*appRecordsPano;
@property (nonatomic, retain) NSOperationQueue		*queuePano;
@property (nonatomic, retain) NSURLConnection		*appListFeedConnectionPano;
@property (nonatomic, retain) NSMutableData			*appListDataPano;
@property (nonatomic, retain) NSArray				*visblePathsPano;
@property (nonatomic, retain) CustomMorePanoViewCell *cellDisplayPano;
@property (nonatomic, retain) CustomMorePanoViewController *customMorePano;

- (void)appImageDidLoadPano:(NSIndexPath *)indexPath;
- (void)startIconDownloadPano:(PanoAppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath;
@end
