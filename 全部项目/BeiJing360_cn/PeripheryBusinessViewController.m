    //
//  PeripheryBusinessViewController.m
//  BeiJing360
//
//  Created by baobin on 11-6-8.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "PeripheryBusinessViewController.h"
#import "BusinessAppRecord.h"
#import <CFNetwork/CFNetwork.h>
#import "BusinessParseOperation.h"
#import "MySingleton.h"
#import "PeripheryBusinessDetailViewController.h"

#define kCustomRowHeight    60.0
#define kCustomRowCount     7


@implementation PeripheryBusinessViewController
@synthesize peripheryBusinessTableView, peripheryBusinessDetailViewController;
@synthesize visblePathsBusiness, entriesBusiness, cellDisplayBusiness, appRecordsBusiness, 
			queueBusiness, appListFeedConnectionBusiness, appListDataBusiness;


- (void)dealloc {
	
	[visblePathsBusiness, entriesBusiness, cellDisplayBusiness, appRecordsBusiness, 
	 queueBusiness, appListFeedConnectionBusiness, appListDataBusiness release];
	[peripheryBusinessTableView, peripheryBusinessDetailViewController release];
	
    [super dealloc]; 
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	
	// Initialize the array of app records and pass a reference to that list to our root view controller
    self.appRecordsBusiness = [NSMutableArray array];
    self.entriesBusiness	= self.appRecordsBusiness;
	NSLog(@"周边商业=　%@", [MySingleton sharedSingleton].peripheryBusinessURLString);
	
	NSURLRequest *urlRequest;
	
	if ([[MySingleton sharedSingleton].peripheryBusinessURLString isEqualToString:@"http://pano.720a.com/"]) {
		UIAlertView *alertBusiness = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无周边商业!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[alertBusiness show];
		[alertBusiness release];
		return;
	} else {
		urlRequest = [NSURLRequest requestWithURL:
									[NSURL URLWithString:[MySingleton sharedSingleton].peripheryBusinessURLString]];	//singleton instance
	}

	
	
	self.appListFeedConnectionBusiness = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
	
    NSAssert(self.appListFeedConnectionBusiness != nil, @"Failure to create URL connection.");
    
    // show in the status bar that network activity is starting
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
    // Release any cached data, images, etc. that aren't in use.
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
	
	int count = [entriesBusiness count];
	
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
	
	static NSString *CellIdentifier = @"PeripheryBusiness";
    static NSString *PlaceholderCellIdentifier = @"PlaceholderCell";
    
    // add a placeholder cell while waiting on table data
    int nodeCount = [self.entriesBusiness count];

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
		
	//	cell.detailTextLabel.text = @"Loading…";
		
		return cell;
    }
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier] autorelease];
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
    // Leave cells empty if there's no data yet
    if (nodeCount > 0)
	{
		
        // Set up the cell...
        BusinessAppRecord *appRecordBusiness = [self.entriesBusiness objectAtIndex:indexPath.row];
		
		cell.textLabel.text = appRecordBusiness.appNameBusiness;
        cell.detailTextLabel.text = appRecordBusiness.artistBusiness;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:1.25];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:YES];

	[tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失  
	
	BusinessAppRecord *appRecordBusinessGlobal = [self.entriesBusiness objectAtIndex:indexPath.row];
	
	[MySingleton sharedSingleton].peripheryBusinessDetailGlobal = appRecordBusinessGlobal.peripheryBusinessDetailURLString;
	
	[MySingleton sharedSingleton].peripheryBusinessDidSelectRow = [NSString stringWithFormat:@"%d", indexPath.row+1];
	
	self.peripheryBusinessDetailViewController = [[PeripheryBusinessDetailViewController alloc] initWithNibName:@"PeripheryBusinessDetailTable" bundle:nil];
	
	peripheryBusinessDetailViewController.title = appRecordBusinessGlobal.appNameBusiness;
	
	[self.navigationController pushViewController:peripheryBusinessDetailViewController animated:NO];
	
	[UIView commitAnimations];
	
}
/*
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	if (indexPath.row == 0 || indexPath.row%2 == 0) {
        UIColor *altCellColor = [UIColor colorWithWhite:0.9 alpha:0.1];
		cell.backgroundColor = altCellColor;
    }
}
*/
- (void)handleLoadedAppsBusiness:(NSArray *)loadedApps
{
	
    [self.appRecordsBusiness addObjectsFromArray:loadedApps];
	
	// tell our table view to reload its data, now that parsing has completed
	[self.peripheryBusinessTableView reloadData];
	
}


- (void)didFinishParsingBusiness:(NSArray *)appList
{
	[self performSelectorOnMainThread:@selector(handleLoadedAppsBusiness:) withObject:appList waitUntilDone:NO];
	
    self.queueBusiness = nil;   // we are finished with the queue and our ParseOperation
}

- (void)parseErrorOccurredBusiness:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(handleErrorBusiness:) withObject:error waitUntilDone:NO];
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)handleErrorBusiness:(NSError *)error
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
    self.appListDataBusiness = [NSMutableData data];    // start off with new data
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[appListDataBusiness appendData:data];  // append incoming data
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
        [self handleErrorBusiness:noConnectionError];
    }
	else
	{
        // otherwise handle the error generically
        [self handleErrorBusiness:error];
    }
    
    self.appListFeedConnectionBusiness = nil;   // release our connection
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
    self.appListFeedConnectionBusiness = nil;   // release our connection
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
    
    // create the queue to run our ParseOperation
    self.queueBusiness = [[[NSOperationQueue alloc] init] autorelease];
	
    BusinessParseOperation *parser = [[BusinessParseOperation alloc] initWithDataWithBusinessParse:appListDataBusiness delegate:self];
    
    [queueBusiness addOperation:parser]; // this will start the "ParseOperation"
    
    [parser release];
    
    // ownership of appListData has been transferred to the parse operation
    // and should no longer be referenced in this thread
    self.appListDataBusiness = nil;
}

@end
