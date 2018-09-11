    //
//  BusinessIconDownloader.m
//  BeiJing360
//
//  Created by baobin on 11-6-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "BusinessIconDownloader.h"
#import "BusinessAppRecord.h"

#define kAppIconHeight 48


@implementation BusinessIconDownloader

@synthesize appRecordBusiness;
@synthesize indexPathInTableViewBusiness;
@synthesize delegate;
@synthesize activeDownloadBusiness;
@synthesize imageConnectionBusiness;

#pragma mark

- (void)dealloc
{
    [appRecordBusiness release];
    [indexPathInTableViewBusiness release];
    
    [activeDownloadBusiness release];
    
    [imageConnectionBusiness cancel];
    [imageConnectionBusiness release];
    
    [super dealloc];
}

- (void)startDownloadBusiness
{
	
    self.activeDownloadBusiness = [NSMutableData data];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:appRecordBusiness.imageURLString]] delegate:self];
    self.imageConnectionBusiness = conn;
    [conn release];
}

- (void)cancelDownloadBusiness
{
	
    [self.imageConnectionBusiness cancel];
    self.imageConnectionBusiness = nil;
    self.activeDownloadBusiness = nil;
}


#pragma mark -
#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	
    [self.activeDownloadBusiness appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    self.activeDownloadBusiness = nil;
    
    // Release the connection now that it's finished
    self.imageConnectionBusiness = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
    // Set appIcon and clear temporary data/image
    UIImage *image = [[UIImage alloc] initWithData:self.activeDownloadBusiness];
    
    if (image.size.width != kAppIconHeight && image.size.height != kAppIconHeight)
	{
        CGSize itemSize = CGSizeMake(kAppIconHeight, kAppIconHeight);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		self.appRecordBusiness.appIconBusiness = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    else
    {
        self.appRecordBusiness.appIconBusiness = image;
    }
    
    self.activeDownloadBusiness = nil;
    [image release];
    
    // Release the connection now that it's finished
    self.imageConnectionBusiness = nil;
	
    // call our delegate and tell it that our icon is ready for display
    [delegate appImageDidLoadBusiness:self.indexPathInTableViewBusiness];
}

@end