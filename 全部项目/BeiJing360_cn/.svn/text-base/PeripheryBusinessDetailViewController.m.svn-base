    //
//  PeripheryBusinessDetailViewController.m
//  BeiJing360
//
//  Created by baobin on 11-6-9.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "PeripheryBusinessDetailViewController.h"
#import "Global.h"
#import "ParseOperationBusinessDetail.h"
#import "AppRecordBusinessDetail.h"
#import <CFNetwork/CFNetwork.h>
#import "MySingleton.h"
#import <QuartzCore/QuartzCore.h>
#import "CurrentMapGuideViewController.h"

@implementation PeripheryBusinessDetailViewController

@synthesize entriesBusinessDetail, appRecordsBusinessDetail, queueBusinessDetail, appListFeedConnectionBusinessDetail, appListDataBusinessDetail;

@synthesize peripheryBusinessDetailImage, peripheryBusinessDetailTableView, currentMapGuideViewController;
@synthesize accessSiteForBusiness, accessTelphoneForBusiness;

- (void)dealloc {
	
	[entriesBusinessDetail, appRecordsBusinessDetail, queueBusinessDetail, appListFeedConnectionBusinessDetail, 
	 appListDataBusinessDetail release];
	[peripheryBusinessDetailImage, peripheryBusinessDetailTableView, currentMapGuideViewController release];
	self.accessSiteForBusiness = nil;
	self.accessTelphoneForBusiness = nil;
	
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	accessSiteForBusiness = nil;
	accessTelphoneForBusiness = nil;
	
	activeDownloadBusinessImage = 0;
	
    self.appRecordsBusinessDetail = [NSMutableArray array];
	
    self.entriesBusinessDetail = self.appRecordsBusinessDetail;
		
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:
								[NSURL URLWithString:[MySingleton sharedSingleton].peripheryBusinessDetailGlobal]];
	
	self.appListFeedConnectionBusinessDetail = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
	
    NSAssert(self.appListFeedConnectionBusinessDetail != nil, @"Failure to create URL connection.");
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)downloadImageBusinessDetail:(NSString *)URLString {
//	NSLog(@"downloadimageBusinessDetail!!!");
    
	activeDownloadBusinessImage = 1;
	
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	
    NSURL *url = [NSURL URLWithString:URLString];
	
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
	
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
		
        receiveImageDataBusinessDetail = [[NSMutableData data] retain];
    }
    else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
	
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	return 4; 
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section 
{
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 1;
		case 2:
			return 1;
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"peripheryBusinessDetail";
	
	UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
//	if ([entriesBusinessDetail count] > indexPath.row) 
	if ([entriesBusinessDetail count] > 0) {
		
	//	NSInteger row = [[MySingleton sharedSingleton].peripheryBusinessDidSelectRow intValue];
	//	AppRecordBusinessDetail *appRecordBusinessDetail = [self.entriesBusinessDetail objectAtIndex:row-1];
		AppRecordBusinessDetail *appRecordBusinessDetail = [self.entriesBusinessDetail objectAtIndex:0];
		
	//	if ([[MySingleton sharedSingleton].peripheryBusinessDidSelectRow isEqualToString: appRecordBusinessDetail.idBusinessDetail]) {
			
			switch (indexPath.section) {
				case 0:
					
					cell = [tView dequeueReusableCellWithIdentifier:@"ImagePeripheryBusiness"];
					
					if (!cell)
						cell = [[[NSBundle mainBundle] loadNibNamed:@"ImagePeripheryBusiness" owner:self options:nil] lastObject];
					
						cell.selectionStyle	= UITableViewCellSelectionStyleNone;
					if (!peripheryBusinessDetailImage.image) {
						[self downloadImageBusinessDetail:appRecordBusinessDetail.imageURLStringBusinessDetail];
					}
	
					return cell;
				case 1:
					cell.textLabel.text = @"Map 地图";
					cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
					cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
					cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			
					
					[MySingleton sharedSingleton].currentLogitude = [[[appRecordBusinessDetail.mapBusinessDetail componentsSeparatedByString:@"|"] objectAtIndex:0] doubleValue];
					[MySingleton sharedSingleton].currentLatitude = [[[appRecordBusinessDetail.mapBusinessDetail componentsSeparatedByString:@"|"] objectAtIndex:1] doubleValue];
					
					
					return cell;			
					
				case 2:
					
					cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
					
					if (!cell) {
						cell = [[[NSBundle mainBundle] loadNibNamed:@"TextViewCell" owner:self options:nil] lastObject];
						
						cell.selectionStyle	= UITableViewCellSelectionStyleNone;
						
						[(UITextView *)[cell viewWithTag:101] setText:appRecordBusinessDetail.artistBusinessDetail];
						
						[cell setAddress:[NSString stringWithFormat:@"地址:%@",appRecordBusinessDetail.addressBusinessDetail]];
						[cell setTelephone:appRecordBusinessDetail.telephoneBusinessDetail];
						[cell setSite:appRecordBusinessDetail.siteBusinessDetail];
					}
					
					return cell;
                default:
					return cell;
			}
		
		
	}
	return cell;	
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	//选中后的反显颜色即刻消失  
	
	if (indexPath.section == 1) {
		
		[UIView beginAnimations:@"View Flip" context:nil];
		[UIView setAnimationDuration:1.25];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:YES];
		
		self.currentMapGuideViewController = [[CurrentMapGuideViewController alloc] initWithNibName:@"CurrentMap" bundle:nil];
		[self.navigationController pushViewController:currentMapGuideViewController animated:NO];
		
		[UIView commitAnimations];
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0) return 160.0f;
	if (indexPath.section == 1 || indexPath.section == 3) return 35.0f;
	if (indexPath.section == 2) return 185.0f; 
	
	return 0.0f;
}

- (void)handleLoadedAppsBusinessDetail:(NSArray *)loadedApps
{
	
    [self.appRecordsBusinessDetail addObjectsFromArray:loadedApps];
	
	// tell our table view to reload its data, now that parsing has completed
	[self.peripheryBusinessDetailTableView reloadData];
		
	
}
- (void)didFinishParsingBusinessDetail:(NSArray *)appList
{
    [self performSelectorOnMainThread:@selector(handleLoadedAppsBusinessDetail:) withObject:appList waitUntilDone:NO];
    
    self.queueBusinessDetail = nil;   // we are finished with the queue and our ParseOperation
}

- (void)parseErrorOccurredBusinessDetail:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(handleErrorDetail:) withObject:error waitUntilDone:NO];
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)handleErrorDetail:(NSError *)error
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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.appListDataBusinessDetail = [NSMutableData data];    // start off with new data
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	switch (activeDownloadBusinessImage) {
		case 0:
			[appListDataBusinessDetail appendData:data];  
			break;
		case 1:
			[receiveImageDataBusinessDetail appendData:data];
			break;
			
		default:
			break;
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//downloadImage error!
	
	switch (activeDownloadBusinessImage) {
		case 0:
			
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
			
			if ([error code] == kCFURLErrorNotConnectedToInternet)
			{
				// if we can identify the error, we can present a more precise message to the user.
				
				NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
																	 forKey:NSLocalizedDescriptionKey];
				
				NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
																 code:kCFURLErrorNotConnectedToInternet
																	userInfo:userInfo];
				[self handleErrorDetail:noConnectionError];
			}
			else
			{
				// otherwise handle the error generically
				
				[self handleErrorDetail:error];
			}
			
			self.appListFeedConnectionBusinessDetail = nil;   // release our connection
			
			break;
		case 1:
			
			[connection release];
			
			[receiveImageDataBusinessDetail release];
			
			NSLog(@"Connection failed! Error - %@ %@",
				  [error localizedDescription],
				  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
			
			break;
			
		default:
			break;
	}
	
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	switch (activeDownloadBusinessImage) {
			
		case 0:
			self.appListFeedConnectionBusinessDetail = nil;   // release our connection
			
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
			
			// create the queue to run our ParseOperation
			
			self.queueBusinessDetail = [[[NSOperationQueue alloc] init] autorelease];
			
			ParseOperationBusinessDetail *parser = [[ParseOperationBusinessDetail alloc] 
														initWithDataWithBusinessDetail:appListDataBusinessDetail delegate:self];
			
			[queueBusinessDetail addOperation:parser]; 
			
			[parser release];
			
			// ownership of appListData has been transferred to the parse operation
			// and should no longer be referenced in this thread
			
			self.appListDataBusinessDetail = nil;
			break;
			
		case 1:
			
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
			UIImage *image = [[UIImage alloc] initWithData:receiveImageDataBusinessDetail];
			
			[peripheryBusinessDetailImage setImage:image];
			
			//将一个view得外部整成圆角
			peripheryBusinessDetailImage.layer.cornerRadius = 10;
			
			peripheryBusinessDetailImage.layer.masksToBounds = YES; 
			
			[image release];
			[connection release];
			[receiveImageDataBusinessDetail release];
			break;
			
		default:
			break;
	}
	
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1 && buttonIndex == 1) {
		if ([accessTelphoneForBusiness intValue]) {
			
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", accessTelphoneForBusiness]]];
		} else {
			UIAlertView *alertForTelephone1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无号码!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alertForTelephone1 show];
			[alertForTelephone1 release];
		}
		
	}
	
	if (alertView.tag == 2 && buttonIndex == 1) {
		if (![accessSiteForBusiness isEqualToString:@""]) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:accessSiteForBusiness]];
		} else {
			UIAlertView *alertForSite1 = [[UIAlertView alloc] initWithTitle:@"提示" message:@"此景点暂时无网站!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alertForSite1 show];
			[alertForSite1 release];
		}
		
	}
}

@end
