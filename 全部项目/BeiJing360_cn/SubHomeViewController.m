    //
//  SubHomeViewController.m
//  BeiJing360
//
//  Created by baobin on 11-5-23.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//


// This framework was imported so we could use the kCFURLErrorNotConnectedToInternet error code.
#import <CFNetwork/CFNetwork.h>
#import "SubHomeViewController.h"
#import "AppRecord.h"
#import "SubHomeDetailViewController.h"
#import "ParseOperation.h"
#import "Global.h"
#import "MySingleton.h"


static NSString * TopPaidAppsFeed;

#define kCustomRowHeight    60.0
#define kCustomRowCount     7

#pragma mark -

@interface SubHomeViewController ()
- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath;
@end




@implementation SubHomeViewController
@synthesize entries, whichView, visblePaths, cellDisplay, cellNib;
@synthesize appRecords, queue, appListFeedConnection, appListData, imageDownloadsInProgress;
@synthesize placesOfInterestViewController, parkPlaceViewController, beijingLocationViewController, 
			cultureCustomsViewController, museumViewController, suburbSceneryViewController,
			alleyStreetscapeViewController, shoppingCenterViewController, barViewController;
@synthesize placesOfInterestDetailViewController, parkPlaceDetailViewController, beijingLocationDetailViewController,
		    cultureCustomsDetailViewController, museumDetailViewController, suburbSceneryDetailViewController,
    		alleyStreetscapeDetailViewController, shoppingCenterDetailViewController, barDetailViewController;


- (void)dealloc {
	[cellNib, queue, cellDisplay, visblePaths, entries release];
    [appListData, appListFeedConnection, appRecords, imageDownloadsInProgress release];
	[placesOfInterestViewController, parkPlaceViewController, beijingLocationViewController release];
	[cultureCustomsViewController, museumViewController, suburbSceneryViewController release];
	[alleyStreetscapeViewController, shoppingCenterViewController, barViewController release];
 	[placesOfInterestDetailViewController, parkPlaceDetailViewController, beijingLocationDetailViewController,
 	 cultureCustomsDetailViewController, museumDetailViewController, suburbSceneryDetailViewController,
 	 alleyStreetscapeDetailViewController, shoppingCenterDetailViewController, barDetailViewController release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	
    if (self) 
	{
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
	// Initialize the array of app records and pass a reference to that list to our root view controller
    self.appRecords = [NSMutableArray array];
    self.entries = self.appRecords;

	switch (whichView) {
		case 1:
			self.title = @"名胜古迹";
			TopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/index.php?catid=%d", WEBADDRESS, whichView];
			break;
		case 2:
			self.title = @"公园广场";
			TopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/index.php?catid=%d", WEBADDRESS, whichView];
			break;
		case 3:
			self.title = @"北京地标";
			TopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/index.php?catid=%d", WEBADDRESS, whichView];
			//NSLog(@"TopPaidAppsFeed北京地标=%@", TopPaidAppsFeed);
			break;
		case 4:
			self.title = @"文化民俗";
			TopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/index.php?catid=%d", WEBADDRESS, whichView];
		//	NSLog(@"TopPaidAppsFeed文化民俗=%@", TopPaidAppsFeed);
			break;
		case 5:
			self.title = @"博物展馆";
			TopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/index.php?catid=%d", WEBADDRESS, whichView];
			break;
		case 6:
			self.title = @"京郊风光";
			TopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/index.php?catid=%d", WEBADDRESS, whichView];
			break;
		case 7:
			self.title = @"胡同街景";
			TopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/index.php?catid=%d", WEBADDRESS, whichView];
			//NSLog(@"TopPaidAppsFeed胡同街景=%@", TopPaidAppsFeed);
			break;
		case 8:
			self.title = @"购物中心";
			TopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/index.php?catid=%d", WEBADDRESS, whichView];
			break;
		case 9:
			self.title = @"酒吧娱乐";
			TopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/index.php?catid=%d", WEBADDRESS, whichView];
			break;
		default:
			break;
	}
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:TopPaidAppsFeed]];
	self.appListFeedConnection = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
    NSAssert(self.appListFeedConnection != nil, @"Failure to create URL connection.");
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	self.cellNib = [UINib nibWithNibName:@"CustomViewCell" bundle:nil];
}

-(void)viewDidUnload
{
	[super viewDidLoad];
	
 	self.cellDisplay = nil;
 	self.cellNib = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
     [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
	
    // Release any cached data, images, etc. that aren't in use.
}

#pragma mark -
#pragma mark Table view creation (UITableViewDataSource)

// customize the number of rows in the table view
 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

	int count = [entries count];
	
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
	
	static NSString *CellIdentifier = @"SubHomeCell";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.entries count];
	
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
		
    ApplicationCell *cell = (ApplicationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
	{
		[self.cellNib instantiateWithOwner:self options:nil];
		cell = cellDisplay;
		self.cellDisplay = nil;
	
    }

	
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
        // Set up the cell...
		AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
		
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		cell.name = appRecord.appName;		
		cell.publisher = appRecord.artist;
		
		
        // Only load cached images; defer new downloads until scrolling ends
        if (!appRecord.appIcon)
        {

			switch (self.whichView) {
				case 1:
					if (self.placesOfInterestViewController.dragging == NO && self.placesOfInterestViewController.decelerating == NO)
						[self startIconDownload:appRecord forIndexPath:indexPath];
					break;
				case 2:
					if (self.parkPlaceViewController.dragging == NO && self.parkPlaceViewController.decelerating == NO)
						[self startIconDownload:appRecord forIndexPath:indexPath];
					break;
				case 3:
					if (self.beijingLocationViewController.dragging == NO && self.beijingLocationViewController.decelerating == NO)
						[self startIconDownload:appRecord forIndexPath:indexPath];
					break;
				case 4:
					if (self.cultureCustomsViewController.dragging == NO && self.cultureCustomsViewController.decelerating == NO)
						[self startIconDownload:appRecord forIndexPath:indexPath];
					break;
				case 5:
					if (self.museumViewController.dragging == NO && self.museumViewController.decelerating == NO)
						[self startIconDownload:appRecord forIndexPath:indexPath];
					break;
				case 6:
					if (self.suburbSceneryViewController.dragging == NO && self.suburbSceneryViewController.decelerating == NO)
						[self startIconDownload:appRecord forIndexPath:indexPath];
					break;
				case 7:
					if (self.alleyStreetscapeViewController.dragging == NO && self.alleyStreetscapeViewController.decelerating == NO)
						[self startIconDownload:appRecord forIndexPath:indexPath];
					break;
				case 8:
					if (self.shoppingCenterViewController.dragging == NO && self.shoppingCenterViewController.decelerating == NO)
						[self startIconDownload:appRecord forIndexPath:indexPath];
					break;
				case 9:
					if (self.barViewController.dragging == NO && self.barViewController.decelerating == NO)
						[self startIconDownload:appRecord forIndexPath:indexPath];
					break;

				default:
					break;
			}
            // if a download is deferred or in progress, return a placeholder image
			cell.icon = [UIImage imageNamed:@"Placeholder.png"];

        } else {
		
			cell.icon = appRecord.appIcon;
        }
		
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.row == 0 || indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.7 alpha:0.1];
		cell.backgroundColor = altCellColor;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失  
	
    if ([entries count] == 0)
    {
        return;
    }
	NSInteger cnt = indexPath.row;
	[MySingleton sharedSingleton].soundID = cnt;
	AppRecord *tempRecord = nil; 
	tempRecord= [self.entries objectAtIndex:cnt];
	//Enter SubHomeDetailViewController!
	if ([PLACESOFINTEREST isEqualToString:tempRecord.appID]) 
	{
		self.placesOfInterestDetailViewController = [[SubHomeDetailViewController alloc] initWithNibName:@"PlacesOfInterestDetailViewController" bundle:nil];
		
		placesOfInterestDetailViewController.title = tempRecord.appName;
		
		[MySingleton sharedSingleton].whichSubDetailView = 100;	//xml Parse for subHomeDetailViewController

		[MySingleton sharedSingleton].subHomeDetailGlobal = [NSString stringWithFormat:@"%d", indexPath.row+1];

		[self.navigationController pushViewController:placesOfInterestDetailViewController animated:YES];
		
	} else if ([PARKPLACE isEqualToString:tempRecord.appID]) {
		
		self.parkPlaceDetailViewController = [[SubHomeDetailViewController alloc] initWithNibName:@"ParkPlaceDetailViewController" bundle:nil];
		
		parkPlaceDetailViewController.title = tempRecord.appName;
		
		[MySingleton sharedSingleton].whichSubDetailView = 200; //xml Parse for subHomeDetailViewController
		
		[MySingleton sharedSingleton].subHomeDetailGlobal = [NSString stringWithFormat:@"%d", indexPath.row+1];
		
		[self.navigationController pushViewController:parkPlaceDetailViewController animated:YES];
		
	} else if ([BEIJINGLOCATION isEqualToString:tempRecord.appID]) {
		
		self.beijingLocationDetailViewController = [[SubHomeDetailViewController alloc] initWithNibName:@"BeijingLocationDetailViewController" bundle:nil];
		
		beijingLocationDetailViewController.title = tempRecord.appName;
		
		[MySingleton sharedSingleton].whichSubDetailView = 300;
		
		[MySingleton sharedSingleton].subHomeDetailGlobal = [NSString stringWithFormat:@"%d", indexPath.row+1];
		
		[self.navigationController pushViewController:beijingLocationDetailViewController animated:YES];
		
	} else if ([CULTURECUSTOMS isEqualToString:tempRecord.appID]) {
		
		self.cultureCustomsDetailViewController = [[SubHomeDetailViewController alloc] initWithNibName:@"CultureCustomsDetailViewController" bundle:nil];
		
		cultureCustomsDetailViewController.title = tempRecord.appName;
		
		[MySingleton sharedSingleton].whichSubDetailView = 400;
		
		[MySingleton sharedSingleton].subHomeDetailGlobal = [NSString stringWithFormat:@"%d", indexPath.row+1];
		
		[self.navigationController pushViewController:cultureCustomsDetailViewController animated:YES];
		
	} else if ([MUSEUM isEqualToString:tempRecord.appID]) {
		
		self.museumDetailViewController = [[SubHomeDetailViewController alloc] initWithNibName:@"MuseumDetailViewController" bundle:nil];
		
		museumDetailViewController.title = tempRecord.appName;
		
		[MySingleton sharedSingleton].whichSubDetailView = 500;
		
		[MySingleton sharedSingleton].subHomeDetailGlobal = [NSString stringWithFormat:@"%d", indexPath.row+1];
		
		[self.navigationController pushViewController:museumDetailViewController animated:YES];
		
	} else if ([SUBURBSCENERY isEqualToString:tempRecord.appID]) {
		self.suburbSceneryDetailViewController = [[SubHomeDetailViewController alloc] initWithNibName:@"SuburbSceneryDetailViewController" bundle:nil];
		
		suburbSceneryDetailViewController.title  = tempRecord.appName;
		
		[MySingleton sharedSingleton].whichSubDetailView = 600;
		
		[MySingleton sharedSingleton].subHomeDetailGlobal = [NSString stringWithFormat:@"%d", indexPath.row+1];
		
		[self.navigationController pushViewController:suburbSceneryDetailViewController animated:YES];
		
	} else if ([ALLEYSTREETSCAPE isEqualToString:tempRecord.appID]) {
		self.alleyStreetscapeDetailViewController = [[SubHomeDetailViewController alloc] initWithNibName:@"AlleyStreetscapeDetailViewController" bundle:nil];
		
		alleyStreetscapeDetailViewController.title  = tempRecord.appName;
		
		[MySingleton sharedSingleton].whichSubDetailView = 700;
		
		[MySingleton sharedSingleton].subHomeDetailGlobal = [NSString stringWithFormat:@"%d", indexPath.row+1];
		
		[self.navigationController pushViewController:alleyStreetscapeDetailViewController animated:YES];
		
	} else if ([SHOPPINGCENTER isEqualToString:tempRecord.appID]) {
		self.shoppingCenterDetailViewController = [[SubHomeDetailViewController alloc] initWithNibName:@"ShoppingCenterDetailViewController" bundle:nil];
		
		shoppingCenterDetailViewController.title  = tempRecord.appName;
		
		[MySingleton sharedSingleton].whichSubDetailView = 800;
		
		[MySingleton sharedSingleton].subHomeDetailGlobal = [NSString stringWithFormat:@"%d", indexPath.row+1];
		
		[self.navigationController pushViewController:shoppingCenterDetailViewController animated:YES];
		
	} else if ([BAR isEqualToString:tempRecord.appID]) {
		self.barDetailViewController = [[SubHomeDetailViewController alloc] initWithNibName:@"BarDetailViewController" bundle:nil];
		
		barDetailViewController.title  = tempRecord.appName;
		
		[MySingleton sharedSingleton].whichSubDetailView = 900;
		
		[MySingleton sharedSingleton].subHomeDetailGlobal = [NSString stringWithFormat:@"%d", indexPath.row+1];
		
		[self.navigationController pushViewController:barDetailViewController animated:YES];
		
	}
}
#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(AppRecord *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
	
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.entries count] > 0)
    {
			
		if (self.whichView == 1) {
			self.visblePaths  = [self.placesOfInterestViewController indexPathsForVisibleRows];
		} else if (self.whichView == 2) {
			self.visblePaths  = [self.parkPlaceViewController indexPathsForVisibleRows];
		} else if (self.whichView == 3) {
			self.visblePaths  = [self.beijingLocationViewController indexPathsForVisibleRows];
		} else if (self.whichView == 4) {
			self.visblePaths  = [self.cultureCustomsViewController indexPathsForVisibleRows];
		} else if (self.whichView == 5) {
			self.visblePaths  = [self.museumViewController indexPathsForVisibleRows];
		} else if (self.whichView == 6) {
			self.visblePaths  = [self.suburbSceneryViewController indexPathsForVisibleRows];
		} else if (self.whichView == 7) {
			self.visblePaths  = [self.alleyStreetscapeViewController indexPathsForVisibleRows];
		} else if (self.whichView == 8) {
			self.visblePaths  = [self.shoppingCenterViewController indexPathsForVisibleRows];
		} else if (self.whichView == 9) {
			self.visblePaths  = [self.barViewController indexPathsForVisibleRows];
		}
		        
        for (NSIndexPath *indexPath in visblePaths)
        {
            AppRecord *appRecord = [self.entries objectAtIndex:indexPath.row];
            
            if (!appRecord.appIcon) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
	
    if (iconDownloader != nil)
    {
		switch (self.whichView) {
			case 1:
				self.cellDisplay = (ApplicationCell *)[self.placesOfInterestViewController cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		//		cellDisplay.imageView.image = iconDownloader.appRecord.appIcon;
		//		custom.customCellImage.image = iconDownloader.appRecord.appIcon;
				cellDisplay.icon = iconDownloader.appRecord.appIcon;
				break;
			case 2:
				self.cellDisplay = (ApplicationCell *)[self.parkPlaceViewController cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		//		 cellDisplay.imageView.image = iconDownloader.appRecord.appIcon;
				cellDisplay.icon = iconDownloader.appRecord.appIcon;
				break;
			case 3:
				self.cellDisplay = (ApplicationCell *)[self.beijingLocationViewController cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		//		cellDisplay.imageView.image = iconDownloader.appRecord.appIcon;
				cellDisplay.icon = iconDownloader.appRecord.appIcon;
				break;
			case 4:
				self.cellDisplay = (ApplicationCell *)[self.cultureCustomsViewController cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		//		cellDisplay.imageView.image = iconDownloader.appRecord.appIcon;
				cellDisplay.icon = iconDownloader.appRecord.appIcon;
				break;
			case 5:
				self.cellDisplay = (ApplicationCell *)[self.museumViewController cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		//		cellDisplay.imageView.image = iconDownloader.appRecord.appIcon;
				cellDisplay.icon = iconDownloader.appRecord.appIcon;
				break;
			case 6:
				self.cellDisplay = (ApplicationCell *)[self.suburbSceneryViewController cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		//		cellDisplay.imageView.image = iconDownloader.appRecord.appIcon;
				cellDisplay.icon = iconDownloader.appRecord.appIcon;
				break;
			case 7:
				self.cellDisplay = (ApplicationCell *)[self.alleyStreetscapeViewController cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		//		cellDisplay.imageView.image = iconDownloader.appRecord.appIcon;
				cellDisplay.icon = iconDownloader.appRecord.appIcon;
				break;
			case 8:
				self.cellDisplay = (ApplicationCell *)[self.shoppingCenterViewController cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		//		cellDisplay.imageView.image = iconDownloader.appRecord.appIcon;
				cellDisplay.icon = iconDownloader.appRecord.appIcon;
				break;
			case 9:
				self.cellDisplay = (ApplicationCell *)[self.barViewController cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
		//		cellDisplay.imageView.image = iconDownloader.appRecord.appIcon;
				cellDisplay.icon = iconDownloader.appRecord.appIcon;
				break;
			default:
				break;
		}
               
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


- (void)handleLoadedApps:(NSArray *)loadedApps
{
	
    [self.appRecords addObjectsFromArray:loadedApps];

	// tell our table view to reload its data, now that parsing has completed
	switch (self.whichView) {
		case 1:
			 [self.placesOfInterestViewController reloadData];
			break;
		case 2:
			 [self.parkPlaceViewController reloadData];
			break;
		case 3:
			[self.beijingLocationViewController reloadData];
			break;
		case 4:
			[self.cultureCustomsViewController reloadData];
			break;
		case 5:
			[self.museumViewController reloadData];
			break;
		case 6:
			[self.suburbSceneryViewController reloadData];
			break;
		case 7:
			[self.alleyStreetscapeViewController reloadData];
			break;
		case 8:
			[self.shoppingCenterViewController reloadData];
			break;
		case 9:
			[self.barViewController reloadData];
			break;
		default:
			break;
	}
   
}


- (void)didFinishParsing:(NSArray *)appList
{
	[self performSelectorOnMainThread:@selector(handleLoadedApps:) withObject:appList waitUntilDone:NO];
    	
    self.queue = nil;   // we are finished with the queue and our ParseOperation
}

- (void)parseErrorOccurred:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(handleError:) withObject:error waitUntilDone:NO];
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)handleError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示："
														message:@"您的网络连接失败，请检查您的网络是否连接正常！"
													   delegate:nil
											  cancelButtonTitle:@"确定"
											  otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.appListData = [NSMutableData data];    // start off with new data
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[appListData appendData:data];  // append incoming data
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
        [self handleError:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleError:error];
    }
    
    self.appListFeedConnection = nil;   // release our connection
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

    self.appListFeedConnection = nil;   // release our connection
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    
    // create the queue to run our ParseOperation
	
    self.queue = [[[NSOperationQueue alloc] init] autorelease];

    ParseOperation *parser = [[ParseOperation alloc] initWithDataWithSubHome:appListData delegate:self];
    
    [queue addOperation:parser]; // this will start the "ParseOperation"
    
    [parser release];
    
    // ownership of appListData has been transferred to the parse operation
    // and should no longer be referenced in this thread
    self.appListData = nil;
}


@end
