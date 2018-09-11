    //
//  SubParseOperation.m
//  BeiJing360
//
//  Created by baobin on 11-5-31.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "SubParseOperation.h"
#import "SubAppRecord.h"
#import "Global.h"

//static NSString *kIDStr				= @"id";
static NSString *kVirtualTourStr	= @"im:virtualTour";
static NSString *kPanoramaStr		= @"im:morePanorama";
static NSString *kImageStr			= @"im:image";
static NSString *kArtistStr			= @"im:artist";
static NSString *kAddressStr		= @"im:address";
static NSString *kTelephoneStr		= @"im:telephone";
static NSString *kSiteStr			= @"im:site";
static NSString *kMapStr			= @"im:map";
static NSString *kBusinessStr		= @"im:business";
static NSString *kEntryStr			= @"entry";   


@interface SubParseOperation ()

@property (nonatomic, assign) id <SubParseOperationDelegate> delegate;
@property (nonatomic, retain) NSData						*dataToParseDetail;
@property (nonatomic, retain) NSMutableArray				*workingArrayDetail;
@property (nonatomic, retain) SubAppRecord					*workingEntryDetail;
@property (nonatomic, retain) NSMutableString				*workingPropertyStringDetail;
@property (nonatomic, retain) NSArray						*elementsToParseDetail;
@property (nonatomic, assign) BOOL							storingCharacterDataDetail;

@end

@implementation SubParseOperation

@synthesize delegate, dataToParseDetail, workingArrayDetail, workingEntryDetail, workingPropertyStringDetail, 
			elementsToParseDetail, storingCharacterDataDetail;



- (id)initWithDataWithSubHomeDetail:(NSData *)data delegate:(id <SubParseOperationDelegate>)theDelegate
{
    self = [super init];
	
    if (self != nil)
    {		
		
        self.dataToParseDetail = data;
		
        self.delegate = theDelegate;
		
		self.elementsToParseDetail = [NSArray arrayWithObjects:kVirtualTourStr, kImageStr, kArtistStr, 
									  kPanoramaStr, kAddressStr, kTelephoneStr, kSiteStr, kMapStr, kBusinessStr, nil];
		
    }
	
    return self;
}


- (void)dealloc
{
    [dataToParseDetail release];
    [workingEntryDetail release];
    [workingPropertyStringDetail release];
    [workingArrayDetail release];
	[elementsToParseDetail release];
    
    [super dealloc];
}

- (void)main
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.workingArrayDetail = [NSMutableArray array];
    self.workingPropertyStringDetail = [NSMutableString string];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParseDetail];
	[parser setDelegate:self];
    [parser parse];
	
	if (![self isCancelled])
    {
        // notify our AppDelegate that the parsing is complete
        [self.delegate didFinishParsingDetail:self.workingArrayDetail];
    }
    
    self.workingArrayDetail = nil;
    self.workingPropertyStringDetail = nil;
    self.dataToParseDetail = nil;
    
    [parser release];
	
	[pool release];
}


#pragma mark -
#pragma mark RSS processing

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
									namespaceURI:(NSString *)namespaceURI
									qualifiedName:(NSString *)qName
									attributes:(NSDictionary *)attributeDict
{
    // entry: { id (link), im:name (app name), im:image (variable height) }
	
    if ([elementName isEqualToString:kEntryStr])
	{
        self.workingEntryDetail = [[[SubAppRecord alloc] init] autorelease];
    }
	
    storingCharacterDataDetail = [elementsToParseDetail containsObject:elementName];
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
									namespaceURI:(NSString *)namespaceURI
									qualifiedName:(NSString *)qName
{
	if (self.workingEntryDetail)
	{
		if (storingCharacterDataDetail)
		{
			NSString *trimmedString = [workingPropertyStringDetail stringByTrimmingCharactersInSet:
									   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			[workingPropertyStringDetail setString:@""];  // clear the string for next time
			
	//		if ([elementName isEqualToString:kIDStr])
	//		{
	//			self.workingEntryDetail.idDetail = trimmedString;
	//
	//		} else 
				if ([elementName isEqualToString:kImageStr])
			{   
				self.workingEntryDetail.imageURLStringDetail = [NSString stringWithFormat:@"http://%@/sanhaojie_vtour/%@", WEBADDRESS, trimmedString];
				NSLog(@"aaa=%@", self.workingEntryDetail.imageURLStringDetail);
			
			}
			else if ([elementName isEqualToString:kVirtualTourStr])
			{
				self.workingEntryDetail.virtualTourURLStringDetail = [NSString stringWithFormat:@"http://%@/%@", WEBADDRESS, trimmedString];
			//	NSLog(@"self.workingEntryDetail.virtualTourURLStringDetail=%@", self.workingEntryDetail.virtualTourURLStringDetail);
			}
			else if ([elementName isEqualToString:kPanoramaStr])
			{
				self.workingEntryDetail.morePanoramaURLStringDetail = [NSString stringWithFormat:@"http://%@/%@", WEBADDRESS, trimmedString];
			//	NSLog(@"self.workingEntryDetail.morePanoramaURLStringDetail=%@", self.workingEntryDetail.morePanoramaURLStringDetail);
			} else if ([elementName isEqualToString:kArtistStr]) {
				
				self.workingEntryDetail.artistDetail = trimmedString;
				
			} else if ([elementName isEqualToString:kAddressStr]) {
				
				self.workingEntryDetail.addressDetail = trimmedString;
				
			} else if ([elementName isEqualToString:kTelephoneStr]) {
				
				self.workingEntryDetail.telephoneDetail = trimmedString;
				
			} else if ([elementName isEqualToString:kSiteStr]) {
								
				self.workingEntryDetail.siteDetail = trimmedString;
				
			} else if ([elementName isEqualToString:kMapStr]) {
				
				self.workingEntryDetail.mapDetail = trimmedString;
				
			} else if ([elementName isEqualToString:kBusinessStr]) {
				
				self.workingEntryDetail.businessDetail = [NSString stringWithFormat:@"http://%@/%@", WEBADDRESS, trimmedString];
			//	NSLog(@"self.workingEntryDetail.businessDetail= %@", self.workingEntryDetail.businessDetail);
			}
		} else if ([elementName isEqualToString:kEntryStr]) {
			
			[self.workingArrayDetail addObject:self.workingEntryDetail];  
			
			self.workingEntryDetail = nil;
		}
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterDataDetail)
    {
        [workingPropertyStringDetail appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [delegate parseErrorOccurredDetail:parseError];
}

@end