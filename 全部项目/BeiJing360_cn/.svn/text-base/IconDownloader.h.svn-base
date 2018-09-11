/*
 *  IconDownloader.h
 *  BeiJing360
 *
 *  Created by baobin on 11-5-23.
 *  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
 *
 */

@class AppRecord;
//@class PlacesOfInterestViewController;

@protocol IconDownloaderDelegate 

- (void)appImageDidLoad:(NSIndexPath *)indexPath;

@end

@interface IconDownloader : NSObject
{
    AppRecord			*appRecord;
    NSIndexPath			*indexPathInTableView;
    id <IconDownloaderDelegate> delegate;
    
    NSMutableData		*activeDownload;
    NSURLConnection		*imageConnection;
}

@property (nonatomic, retain) AppRecord			*appRecord;
@property (nonatomic, retain) NSIndexPath		*indexPathInTableView;
@property (nonatomic, assign) id <IconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData		*activeDownload;
@property (nonatomic, retain) NSURLConnection	*imageConnection;

- (void)startDownload;
- (void)cancelDownload;

@end

