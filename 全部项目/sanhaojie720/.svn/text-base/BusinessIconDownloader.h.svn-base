//
//  BusinessIconDownloader.h
//  BeiJing360
//
//  Created by baobin on 11-6-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@class BusinessAppRecord;

@protocol BusinessIconDownloaderDelegate;

@interface BusinessIconDownloader : NSObject
{
    BusinessAppRecord	*appRecordBusiness;
    NSIndexPath			*indexPathInTableViewBusiness;
    id <BusinessIconDownloaderDelegate> delegate;
    
    NSMutableData		*activeDownloadBusiness;
    NSURLConnection		*imageConnectionBusiness;
}

@property (nonatomic, retain) BusinessAppRecord		*appRecordBusiness;
@property (nonatomic, retain) NSIndexPath			*indexPathInTableViewBusiness;
@property (nonatomic, assign) id <BusinessIconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData			*activeDownloadBusiness;
@property (nonatomic, retain) NSURLConnection		*imageConnectionBusiness;

- (void)startDownloadBusiness;
- (void)cancelDownloadBusiness;

@end

@protocol BusinessIconDownloaderDelegate 

- (void)appImageDidLoadBusiness:(NSIndexPath *)indexPath;

@end