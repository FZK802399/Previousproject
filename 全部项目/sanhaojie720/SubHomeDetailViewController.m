    //
//  SubHomeDetailViewController.m
//  BeiJing360
//
//  Created by baobin on 11-5-30.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "Global.h"
#import "MySingleton.h"
#import "SubHomeDetailViewController.h"
#import "SubAppRecord.h"
#import "SubParseOperation.h"
#import "MorePanoramaViewController.h"
#import "CurrentMapGuideViewController.h"
#import "PeripheryBusinessViewController.h"
#import "CurrentVirtualTourViewController.h"
#import <CFNetwork/CFNetwork.h>
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>

#import "TextViewCell.h"
#import "TextCell.h"

static NSString * SubTopPaidAppsFeed;

@implementation SubHomeDetailViewController

@synthesize player;

@synthesize entriesDetail, appRecordsDetail, queueDetail, appListFeedConnectionDetail, appListDataDetail;
@synthesize placeOfInterestDetailTableView, parkPlaceDetailTableView, beijingLocationDetailTableView, cultureCustomsDetailTableView,
			museumDetailTableView, suburbSceneryDetailTableView, alleyStreetscapeDetailTableView, shoppingCenterDetailTableView,
			barDetailTableView;

@synthesize subHomeDetailImage, morePanoramaViewController, peripheryBusinessViewController, currentMapGuideViewController;
@synthesize accessSite, accessTelphone, receiveImageData;

- (void)dealloc {
	
	[entriesDetail, appRecordsDetail, queueDetail, appListFeedConnectionDetail, appListDataDetail release];
	[placeOfInterestDetailTableView, parkPlaceDetailTableView, beijingLocationDetailTableView, cultureCustomsDetailTableView,
	 museumDetailTableView, suburbSceneryDetailTableView, alleyStreetscapeDetailTableView, shoppingCenterDetailTableView,
	 barDetailTableView release];
	[subHomeDetailImage, morePanoramaViewController, peripheryBusinessViewController release];
	self.accessSite = nil;
	self.accessTelphone = nil;
	self.receiveImageData = nil;
    [super dealloc];
}

//-(void)viewWillAppear:(BOOL)animated
//{
//	self.navigationController.navigationBar.hidden = NO;
//}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.

-(IBAction)buttonTapped:(id)sender {
	if(self.player.playing) {
		
		[self.player pause];
	} else {
		NSString *soundFilePath = [[NSBundle mainBundle]pathForResource:@"intro" ofType:@"mp3"];
		NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
		AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:fileURL error:nil];
		[fileURL release];
		self.player = newPlayer;
		[newPlayer release];
		[self.player prepareToPlay];
		
		[self.player setDelegate:self];
		self.player.numberOfLoops = 0;
		
		
		[self.player play];
	}
	
}

- (void)viewDidLoad {
    [super viewDidLoad];

    //[self.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Title.png"]] atIndex:1];
    
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackGround.png"]];
    
	accessSite = nil;
	accessTelphone = nil;
	
	activeDownloadImage = 0;
	
	// Initialize the array of app records and pass a reference to that list to our root view controller
    self.appRecordsDetail = [NSMutableArray array];
    self.entriesDetail = self.appRecordsDetail;
//	NSLog(@"whichSubDetailView= %d", [MySingleton sharedSingleton].whichSubDetailView);
	switch ([MySingleton sharedSingleton].whichSubDetailView) {
			
		case 100:
	
			SubTopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/sanhaojie_vtour/xml/cat1_%@.xml", WEBADDRESS, [MySingleton sharedSingleton].subHomeDetailGlobal];
			NSLog(@"SubTopPaidAppsFeed100 = %@", SubTopPaidAppsFeed);
			break;
			
		case 200:
	
			SubTopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/sanhaojie_vtour/xml/cat2_%@.xml", WEBADDRESS, [MySingleton sharedSingleton].subHomeDetailGlobal];
		//	NSLog(@"SubTopPaidAppsFeed200= %@", SubTopPaidAppsFeed);
			break;
			
		case 300:
	
			SubTopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/sanhaojie_vtour/xml/cat3_%@.xml", WEBADDRESS, [MySingleton sharedSingleton].subHomeDetailGlobal];
		//	NSLog(@"SubTopPaidAppsFeed300=%@", SubTopPaidAppsFeed);
			break;
			
		case 400:
		
			SubTopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/sanhaojie_vtour/xml/cat4_%@.xml", WEBADDRESS, [MySingleton sharedSingleton].subHomeDetailGlobal];
		//	NSLog(@"SubTopPaidAppsFeed400= %@", SubTopPaidAppsFeed);
			break;
			
		case 500:
		
			SubTopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/sanhaojie_vtour/show.php?catid=5&cid=%@", WEBADDRESS, [MySingleton sharedSingleton].subHomeDetailGlobal];
		//	NSLog(@"SubTopPaidAppsFeed500=%@", SubTopPaidAppsFeed);
			break;
			
		case 600:
	
			SubTopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/sanhaojie_vtour/show.php?catid=6&cid=%@", WEBADDRESS, [MySingleton sharedSingleton].subHomeDetailGlobal];

			break;
			
		case 700:
		
			SubTopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/show.php?catid=7&cid=%@", WEBADDRESS, [MySingleton sharedSingleton].subHomeDetailGlobal];

			break;
			
		case 800:
			
			SubTopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/show.php?catid=8&cid=%@", WEBADDRESS, [MySingleton sharedSingleton].subHomeDetailGlobal];

			break;
			
		case 900:
			
			SubTopPaidAppsFeed = [NSString stringWithFormat:@"http://%@/qjbj/show.php?catid=9&cid=%@", WEBADDRESS, [MySingleton sharedSingleton].subHomeDetailGlobal];

			break;
			
		default:
			break;
	}
	
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:SubTopPaidAppsFeed]];
	
	self.appListFeedConnectionDetail = [[[NSURLConnection alloc] initWithRequest:urlRequest delegate:self] autorelease];
	
    NSAssert(self.appListFeedConnectionDetail != nil, @"Failure to create URL connection.");
    
    // show in the status bar that network activity is starting
	
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)downloadImage:(NSString *)URLString {
    
	activeDownloadImage = 1;
	
//	NSLog(@"downloadImage %d count ", i++);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSURL *url = [NSURL URLWithString:URLString];
	
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
		
        receiveImageData = [[NSMutableData data] retain];
    }
    else
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
	
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView 
{ 
	return 7; 
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
		case 3:
			return 2;
		default:
			return 0;
	}
}

- (UITableViewCell *)tableView:(UITableView *)tView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *CellIdentifier = @"subHomeDetail";
	
	UITableViewCell *cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									   reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	
//	if ([entriesDetail count] > indexPath.row)
	if ([entriesDetail count] > 0) {
		//NSLog(@"count:%d", [entriesDetail count]);
		
//		NSInteger row = [[MySingleton sharedSingleton].subHomeDetailGlobal intValue];
//		SubAppRecord *subAppRecord = [self.entriesDetail objectAtIndex:row-1];
		SubAppRecord *subAppRecord = [self.entriesDetail objectAtIndex:0];
		
		switch (indexPath.section) {
			case 0:
					
				cell = [tView dequeueReusableCellWithIdentifier:@"PlaceOfInterest"];
				if (!cell)
					cell = [[[NSBundle mainBundle] loadNibNamed:@"Image" owner:self options:nil] lastObject];
					cell.selectionStyle	= UITableViewCellSelectionStyleNone;
				if (!subHomeDetailImage.image) {
				//	NSLog(@"downloadImage!!!");
					[self downloadImage:subAppRecord.imageURLStringDetail];
					NSLog(@"downloadImage:%@",subAppRecord.imageURLStringDetail);
					
				}
				cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
				cell.selectionStyle = UITableViewCellSelectionStyleBlue;
				return cell;
					
			case 1:
			
						cell.textLabel.text = @"720° 虚拟漫游";
						cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
						cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
						cell.selectionStyle = UITableViewCellSelectionStyleBlue;
						[MySingleton sharedSingleton].subHomeDetailVirtualTourURLString = subAppRecord.virtualTourURLStringDetail;
						return cell;
            case 2:
				
                cell = [tView dequeueReusableCellWithIdentifier:CellIdentifier];
				if(!cell) {
					cell =  [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                    
                    
				}
                CGRect nameLabelRect = CGRectMake(9, 2, 289, 137);
                UITextView *nameLabel = [[UITextView alloc] initWithFrame:nameLabelRect];
                //nameLabel.textAlignment = UITextAlignmentRight;
                nameLabel.text = subAppRecord.artistDetail;
                nameLabel.font = [UIFont systemFontOfSize:14.0f];
                [nameLabel setEditable:NO];
                [cell.contentView addSubview:nameLabel];
                [nameLabel release];
              //  cell.detailText.text = subAppRecord.artistDetail;
				return cell;
					
			case 3:
				cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
				switch (indexPath.row) {
					case 0:
						cell.textLabel.text = [NSString stringWithFormat:@"地址: %@",subAppRecord.addressDetail];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
					case 1:
						cell.textLabel.text = [NSString stringWithFormat:@"电话: %@", subAppRecord.telephoneDetail];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                        accessTelphone = subAppRecord.telephoneDetail;
						return cell;
				
					default:
						return cell;
				}
					
			default:
				return cell;
			}
	
	}
	
	return cell;	

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[tableView deselectRowAtIndexPath:indexPath animated:YES];	//选中后的反显颜色即刻消失  
	
	if (indexPath.section == 2 || (indexPath.section ==3 && indexPath.row == 0)) {
		
	} else {
	
	
	
	if(indexPath.section == 0 || indexPath.section == 1) {
        
        
		UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
		backItem.title = @"返回";
		[self.navigationItem setBackBarButtonItem:backItem];
		[backItem release];
		
		[MySingleton sharedSingleton].currentFlagWithVirtualTour = 1;
		
		CurrentVirtualTourViewController *currentVirtualTourViewController = [[[CurrentVirtualTourViewController alloc] init] autorelease];
		
		[self.navigationController pushViewController:currentVirtualTourViewController
											 animated:YES];
      
	}
     
     	 
        
    if (indexPath.section == 3 && indexPath.row == 1) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"您确定要拨打此电话吗？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"拨号", nil];
        alert.tag = 1;
        [alert show];
        [alert release];
    }    

	}
	
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

	if (indexPath.section == 0) return 90.0f;
	if (indexPath.section == 2) return 150.0f;
	if (indexPath.section == 1 || indexPath.section == 3) return 30.0f;
	
	return 0.0f;
}

- (void)handleLoadedAppsDetail:(NSArray *)loadedApps
{
	
    [self.appRecordsDetail addObjectsFromArray:loadedApps];
	
	// tell our table view to reload its data, now that parsing has completed
	switch ([MySingleton sharedSingleton].whichSubDetailView) {
		case 100:
			[self.placeOfInterestDetailTableView reloadData];
			break;
		case 200:
			[self.parkPlaceDetailTableView reloadData];
			break;
		case 300:
			[self.beijingLocationDetailTableView reloadData];
			break;
		case 400:
			[self.cultureCustomsDetailTableView reloadData];
			break;
		case 500:
			[self.museumDetailTableView reloadData];
			break;
		case 600:
			[self.suburbSceneryDetailTableView reloadData];
			break;
		case 700:
			[self.alleyStreetscapeDetailTableView reloadData];
			break;
		case 800:
			[self.shoppingCenterDetailTableView reloadData];
			break;
		case 900:
			[self.barDetailTableView reloadData];
			break;

		default:
			break;
	}
	
}
- (void)didFinishParsingDetail:(NSArray *)appList
{
    [self performSelectorOnMainThread:@selector(handleLoadedAppsDetail:) withObject:appList waitUntilDone:NO];
    
    self.queueDetail = nil;   // we are finished with the queue and our ParseOperation
}

- (void)parseErrorOccurredDetail:(NSError *)error
{
    [self performSelectorOnMainThread:@selector(handleErrorDetail:) withObject:error waitUntilDone:NO];
}


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

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.appListDataDetail = [NSMutableData data];    // start off with new data
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	switch (activeDownloadImage) {
		case 0:
			[appListDataDetail appendData:data];  // append incoming data			
			break;
		case 1:
			 [receiveImageData appendData:data];
			break;

		default:
			break;
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	//downloadImage error!
	
	switch (activeDownloadImage) {
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
			
			self.appListFeedConnectionDetail = nil;   // release our connection
			
			break;
		case 1:
			
			[connection release];
			[receiveImageData release];
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
	
	switch (activeDownloadImage) {
			
		case 0:
			self.appListFeedConnectionDetail = nil;   // release our connection
			
			[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;   
			
			// create the queue to run our ParseOperation
			
			self.queueDetail = [[[NSOperationQueue alloc] init] autorelease];
			
			SubParseOperation *parser = [[SubParseOperation alloc] initWithDataWithSubHomeDetail:appListDataDetail delegate:self];
			
			[queueDetail addOperation:parser]; // this will start the "ParseOperation"
			
			[parser release];
			
			// ownership of appListData has been transferred to the parse operation
			// and should no longer be referenced in this thread
			
			self.appListDataDetail = nil;
			
			break;
			
		case 1:
				
			[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
			
			UIImage *image = [[UIImage alloc] initWithData:receiveImageData];
			
			[subHomeDetailImage setImage:image];
			
			//将一个view得外部整成圆角
			subHomeDetailImage.layer.cornerRadius = 10;
			subHomeDetailImage.layer.masksToBounds = YES; 
			
			[image release];
			[connection release];
			
			self.receiveImageData = nil;
			break;
			
		default:
			break;
	}
   
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (alertView.tag == 1 && buttonIndex == 1) {
		if ([accessTelphone intValue]) {
			
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", accessTelphone]]];
		} else {
			UIAlertView *alertForTelephone = [[UIAlertView alloc] initWithTitle:@"提示" message:@"无号码!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
			[alertForTelephone show];
			[alertForTelephone release];
		}
	}
}

@end
