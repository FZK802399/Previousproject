//
//  PanoIconDownloader.h
//  BeiJing360
//
//  Created by baobin on 11-6-3.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

@class PanoAppRecord;

@protocol PanoIconDownloaderDelegate;

@interface PanoIconDownloader : NSObject
{
    PanoAppRecord					*appRecordPano;
    NSIndexPath						*indexPathInTableViewPano;
    id <PanoIconDownloaderDelegate> delegate;
    NSMutableData					*activeDownloadPano;
    NSURLConnection					*imageConnectionPano;
}

@property (nonatomic, retain) PanoAppRecord *appRecordPano;
@property (nonatomic, retain) NSIndexPath	*indexPathInTableViewPano;
@property (nonatomic, assign) id <PanoIconDownloaderDelegate> delegate;

@property (nonatomic, retain) NSMutableData		*activeDownloadPano;
@property (nonatomic, retain) NSURLConnection	*imageConnectionPano;

- (void)startDownloadPano;
- (void)cancelDownloadPano;

@end

@protocol PanoIconDownloaderDelegate 

- (void)appImageDidLoadPano:(NSIndexPath *)indexPath;

@end