    //
//  MorePanoramaViewController.m
//  BeiJing360
//
//  Created by baobin on 11-6-2.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "MorePanoramaViewController.h"
#import "PanoAppRecord.h"
#import <CFNetwork/CFNetwork.h>
#import "PanoParseOperation.h"
#import "MySingleton.h"
#import "CurrentVirtualTourViewController.h"
#import "CustomMorePanoViewCell.h"
#import "CustomMorePanoViewController.h"

#define kCustomRowHeight    60.0
#define kCustomRowCount     7


@implementation MorePanoramaViewController
@synthesize morePanoramaTableView, customMorePano;
@synthesize visblePathsPano, entriesPano, cellDisplayPano, imageDownloadsInProgressPano, appRecordsPano, 
			queuePano, appListFeedConnectionPano, appListDataPano;


- (void)dealloc {
	
	[visblePathsPano, entriesPano, cellDisplayPano, imageDownloadsInProgressPano, appRecordsPano, 
	 queuePano, appListFeedConnectionPano, appListDataPano release];
	[morePanoramaTableView, customMorePano release];
	
    [super dealloc];
	
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.imageDownloadsInProgressPano = [NSMutableDictionary dictionary];
	
	// Initialize the array of app records and pass a reference to that list to our root view controller
    self.appRecordsPano = [NSMutableArray array];
    self.entriesPano = self.appRecordsPano;
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[MySingleton sharedSingleton].morePanoramoURLString]];	//singleton instance
	
	self.appListFeedConnectionPano = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
	
    NSAssert(self.appListFeedConnectionPano != nil, @"Failure to create URL connection.");
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
	// terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgressPano allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownloadPano)];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Table view creation (UITableViewDataSource)

// customize the number of rows in the table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	int count = [entriesPano count];
	
	// ff there's no data yet, return enough rows to fill the screen
    if (count == 0)
	{
        return kCustomRowCount;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	// customize the appearance of table view cells

	static NSString *CellIdentifier = @"MorePanoramaTableCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
	
    int nodeCount = [self.entriesPano count];
	
	if (nodeCount == 0 && indexPath.row == 0)
	{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:PlaceholderCellIdentifier];
        if (cell == nil)
		{
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
										   reuseIdentifier:PlaceholderCellIdentifier] autorelease];   
            cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
		
		cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }
	
    CustomMorePanoViewCell *cell = (CustomMorePanoViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	self.customMorePano = nil;
	
    if (cell == nil)
	{
		customMorePano = [[CustomMorePanoViewController alloc] init];
		
		[[NSBundle mainBundle] loadNibNamed:@"CustomMorePanoViewCell" owner:customMorePano options:nil];
		
		cell = customMorePano.customMorePanoViewCell;
		
   //     cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
	//								   reuseIdentifier:CellIdentifier] autorelease];
		
    } else {
		
		customMorePano = cell.customMorePanoViewController;
	}
	
    // Leave cells empty if there's no data yet
	
    if (nodeCount > 0)
	{	NSLog(@"count:%d", nodeCount);
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
        // Set up the cell...
        PanoAppRecord *appRecordPano = [self.entriesPano objectAtIndex:indexPath.row];
        
		customMorePano.customMorePanoCellTitle.text = appRecordPano.appNamePano;
        customMorePano.customMorePanoCellArtist.text = appRecordPano.artistPano;
		
        // Only load cached images; defer new downloads until scrolling ends
        if (!appRecordPano.appIconPano)
        {
            if (self.morePanoramaTableView.dragging == NO && self.morePanoramaTableView.decelerating == NO)
            {
                [self startIconDownloadPano:appRecordPano forIndexPath:indexPath];
            }
            // if a download is deferred or in progress, return a placeholder image
        //    cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];                
        } else {
			customMorePano.customMorePanoCellImage.image = appRecordPano.appIconPano;
        }
		
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	[tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失  
	
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:YES];
	
	PanoAppRecord *appRecordPano = [self.entriesPano objectAtIndex:indexPath.row];
	
	//[MySingleton sharedSingleton].subHomeDetailVirtualTourURLString = appRecordPano.imageURLStringPano;
	[MySingleton sharedSingleton].morePanoramoVirtualTourURLString = appRecordPano.imageURLStringPano;
	[MySingleton sharedSingleton].currentFlagWithVirtualTour = 3;

	CurrentVirtualTourViewController *currentMorePanorama = [[[CurrentVirtualTourViewController alloc] init] autorelease];
		
	[self.navigationController pushViewController:currentMorePanorama animated:NO];
		
	[UIView commitAnimations];
	
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownloadPano:(PanoAppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    PanoIconDownloader *iconDownloaderPano = [imageDownloadsInProgressPano objectForKey:indexPath];
	
    if (iconDownloaderPano == nil) {
        iconDownloaderPano = [[PanoIconDownloader alloc] init];
        iconDownloaderPano.appRecordPano= appRecord;
        iconDownloaderPano.indexPathInTableViewPano = indexPath;
        iconDownloaderPano.delegate = self;
        [imageDownloadsInProgressPano setObject:iconDownloaderPano forKey:indexPath];
        [iconDownloaderPano startDownloadPano];
        [iconDownloaderPano release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRowsPano
{
	
    if ([self.entriesPano count] > 0)
    {
        self.visblePathsPano  = [self.morePanoramaTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visblePathsPano)
        {
            PanoAppRecord *appRecordPano = [self.entriesPano objectAtIndex:indexPath.row];
            
            if (!appRecordPano.appIconPano) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownloadPano:appRecordPano forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoadPano:(NSIndexPath *)indexPath
{

    PanoIconDownloader *iconDownloaderPano = [imageDownloadsInProgressPano objectForKey:indexPath];
	
    if (iconDownloaderPano != nil)
    {
        self.cellDisplayPano = (CustomMorePanoViewCell *)[self.morePanoramaTableView cellForRowAtIndexPath:iconDownloaderPano.indexPathInTableViewPano];
        
        // Display the newly loaded image
        cellDisplayPano.customMorePanoViewController.customMorePanoCellImage.image = iconDownloaderPano.appRecordPano.appIconPano;
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{

    if (!decelerate)
	{
        [self loadImagesForOnscreenRowsPano];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRowsPano];
}



#pragma mark -
#pragma mark ParseOperation delegate methods
- (void)handleLoadedAppsPano:(NSArray *)loadedApps
{
	
    [self.appRecordsPano addObjectsFromArray:loadedApps];
	
	// tell our table view to reload its data, now that parsing has completed
	[self.morePanoramaTableView reloadData];
	
}


- (void)didFinishParsingPano:(NSArray *)appList
{
	[self performSelectorOnMainThread:@selector(handleLoadedAppsPano:)
						   withObject:appList waitUntilDone:NO];
    self.queuePano = nil;   // we are finished with the queue and our ParseOperation
}

- (void)parseErrorOccurredPano:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(handleErrorPano:)
						   withObject:error waitUntilDone:NO];
}

- (void)handleErrorPano:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot Show 720a"
														message:errorMessage
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}


#pragma mark -
#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.appListDataPano = [NSMutableData data];    // start off with new data
	/*NSHTTPURLResponse *r =	(NSHTTPURLResponse *)response;
    int code = [r statusCode];
	switch (code) {
		case 200:
			//ok
			break;
		case 404:
			//ok
			break;
		case 500:
			//ok
			break;
		default:
			break;
	}*/
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[appListDataPano appendData:data];  // append incoming data
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([error code] == kCFURLErrorNotConnectedToInternet)
	{
        // if we can identify the error, we can present a more precise message to the user.
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
															 forKey:NSLocalizedDescriptionKey];
        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
														 code:kCFURLErrorNotConnectedToInternet
													 userInfo:userInfo];
        [self handleErrorPano:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleErrorPano:error];
    }
    
    self.appListFeedConnectionPano = nil;   // release our connection
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
    self.appListFeedConnectionPano = nil;   // release our connection
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    
    // create the queue to run our ParseOperation
    self.queuePano = [[[NSOperationQueue alloc] init] autorelease];
	
    PanoParseOperation *parser = [[PanoParseOperation alloc]
								  initWithDataWithMorePano:appListDataPano
								  delegate:self];
    
    [queuePano addOperation:parser]; // this will start the "ParseOperation"
    
    [parser release];
    
    // ownership of appListData has been transferred to the parse operation
    // and should no longer be referenced in this thread
    self.appListDataPano = nil;
}




@end
