    //
//  ParseOperationBusinessDetail.m
//  BeiJing360
//
//  Created by baobin on 11-6-9.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "ParseOperationBusinessDetail.h"
#import "AppRecordBusinessDetail.h"
#import "Global.h"

// string contants found in the RSS feed
//static NSString *kIDBusinessDetailStr				= @"id";
static NSString *kVirtualTourBusinessDetailStr		= @"im:virtualTour";
static NSString *kImageBusinessDetailStr			= @"im:image";
static NSString *kArtistBusinessDetailStr			= @"im:artist";
static NSString *kAddressBusinessDetailStr			= @"im:address";
static NSString *kTelephoneBusinessDetailStr		= @"im:telephone";
static NSString *kSiteBusinessDetailStr				= @"im:site";
static NSString *kMapBusinessDetailStr				= @"im:map";
static NSString *kEntryBusinessDetailStr			= @"entry";   


@interface ParseOperationBusinessDetail ()
@property (nonatomic, assign) id <ParseOperationDelegateBusinessDetail> delegate;
@property (nonatomic, retain) NSData									*dataToParseBusinessDetail;
@property (nonatomic, retain) NSMutableArray							*workingArrayBusinessDetail;
@property (nonatomic, retain) AppRecordBusinessDetail					*workingEntryBusinessDetail;
@property (nonatomic, retain) NSMutableString							*workingPropertyStringBusinessDetail;
@property (nonatomic, retain) NSArray									*elementsToParseBusinessDetail;
@property (nonatomic, assign) BOOL										storingCharacterDataBusinessDetail;

@end

@implementation ParseOperationBusinessDetail

@synthesize delegate, dataToParseBusinessDetail, workingArrayBusinessDetail, workingEntryBusinessDetail, workingPropertyStringBusinessDetail, 
elementsToParseBusinessDetail, storingCharacterDataBusinessDetail;



- (id)initWithDataWithBusinessDetail:(NSData *)data delegate:(id <ParseOperationDelegateBusinessDetail>)theDelegate
{
    self = [super init];
    if (self != nil)
    {		
		
        self.dataToParseBusinessDetail = data;
        self.delegate = theDelegate;
		self.elementsToParseBusinessDetail = [NSArray arrayWithObjects:kVirtualTourBusinessDetailStr, kImageBusinessDetailStr, kArtistBusinessDetailStr, 
									   kAddressBusinessDetailStr, kTelephoneBusinessDetailStr, kSiteBusinessDetailStr, kMapBusinessDetailStr, nil];
		
    }
    return self;
}


- (void)dealloc
{
    [dataToParseBusinessDetail release];
    [workingEntryBusinessDetail release];
    [workingPropertyStringBusinessDetail release];
    [workingArrayBusinessDetail release];
    [elementsToParseBusinessDetail release];
    [super dealloc];
}

- (void)main
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.workingArrayBusinessDetail = [NSMutableArray array];
    self.workingPropertyStringBusinessDetail = [NSMutableString string];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParseBusinessDetail];
	[parser setDelegate:self];
    [parser parse];
	
	if (![self isCancelled])
    {
        // notify our AppDelegate that the parsing is complete
        [self.delegate didFinishParsingBusinessDetail:self.workingArrayBusinessDetail];
    }
    
    self.workingArrayBusinessDetail = nil;
    self.workingPropertyStringBusinessDetail = nil;
    self.dataToParseBusinessDetail = nil;
    
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
    	
    if ([elementName isEqualToString:kEntryBusinessDetailStr])
	{
        self.workingEntryBusinessDetail = [[[AppRecordBusinessDetail alloc] init] autorelease];
    }
    storingCharacterDataBusinessDetail = [elementsToParseBusinessDetail containsObject:elementName];
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
									namespaceURI:(NSString *)namespaceURI
									qualifiedName:(NSString *)qName
{
	if (self.workingEntryBusinessDetail)
	{
		if (storingCharacterDataBusinessDetail)
		{
			NSString *trimmedString = [workingPropertyStringBusinessDetail stringByTrimmingCharactersInSet:
									   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			[workingPropertyStringBusinessDetail setString:@""];  // clear the string for next time
			
	//		if ([elementName isEqualToString:kIDBusinessDetailStr])
	//		{
	//			self.workingEntryBusinessDetail.idBusinessDetail = trimmedString;
				
	//		} else 
			if ([elementName isEqualToString:kImageBusinessDetailStr]) {   
				
				self.workingEntryBusinessDetail.imageURLStringBusinessDetail = [NSString stringWithFormat:@"http://%@/qjbj/%@", WEBADDRESS, trimmedString];
			//	NSLog(@"image:%@", self.workingEntryBusinessDetail.imageURLStringBusinessDetail);
				
			} else if ([elementName isEqualToString:kVirtualTourBusinessDetailStr]) {
			
				self.workingEntryBusinessDetail.virtualTourURLStringBusinessDetail = trimmedString;
			
			} else if ([elementName isEqualToString:kArtistBusinessDetailStr]) {
				
				self.workingEntryBusinessDetail.artistBusinessDetail = trimmedString;
				
			} else if ([elementName isEqualToString:kAddressBusinessDetailStr]) {
				
				self.workingEntryBusinessDetail.addressBusinessDetail = trimmedString;
				
			} else if ([elementName isEqualToString:kTelephoneBusinessDetailStr]) {
				
				self.workingEntryBusinessDetail.telephoneBusinessDetail = trimmedString;
				
			} else if ([elementName isEqualToString:kSiteBusinessDetailStr]) {
				
				self.workingEntryBusinessDetail.siteBusinessDetail = trimmedString;
				
			} else if ([elementName isEqualToString:kMapBusinessDetailStr]) {
				
				self.workingEntryBusinessDetail.mapBusinessDetail = trimmedString;
			}
		} else if ([elementName isEqualToString:kEntryBusinessDetailStr]) {
			
			[self.workingArrayBusinessDetail addObject:self.workingEntryBusinessDetail];  
			
			self.workingEntryBusinessDetail = nil;
		}
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterDataBusinessDetail) {
		
        [workingPropertyStringBusinessDetail appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    [delegate parseErrorOccurredBusinessDetail:parseError];
}

@end