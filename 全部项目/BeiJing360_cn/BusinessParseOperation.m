    //
//  BusinessParseOperation.m
//  BeiJing360
//
//  Created by baobin on 11-6-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "BusinessParseOperation.h"
#import "BusinessAppRecord.h"
#import "Global.h"

// string contants found in the RSS feed
//static NSString *kIDStr     = @"id";
static NSString *kNameStr			  = @"im:name";
//static NSString *kImageStr			  = @"im:image";
static NSString *kArtistStr			  = @"im:artist";
static NSString *kPeripheryBusinessDetailStr = @"im:businessDetail";
static NSString *kEntryStr			  = @"entry";

@interface BusinessParseOperation ()
@property (nonatomic, assign) id <BusinessParseOperationDelegate> delegate;
@property (nonatomic, retain) NSData *dataToParseBusiness;
@property (nonatomic, retain) NSMutableArray *workingArrayBusiness;
@property (nonatomic, retain) BusinessAppRecord *workingEntryBusiness;
@property (nonatomic, retain) NSMutableString *workingPropertyStringBusiness;
@property (nonatomic, retain) NSArray *elementsToParseBusiness;
@property (nonatomic, assign) BOOL storingCharacterDataBusiness;

@end

@implementation BusinessParseOperation

@synthesize delegate, dataToParseBusiness, workingArrayBusiness, workingEntryBusiness, workingPropertyStringBusiness, 
			elementsToParseBusiness, storingCharacterDataBusiness;

- (id)initWithDataWithBusinessParse:(NSData *)data delegate:(id <BusinessParseOperationDelegate>)theDelegate
{
    self = [super init];
	
    if (self != nil)
    {		
        self.dataToParseBusiness = data;
        self.delegate = theDelegate;
		//	self.elementsToParsePano = [NSArray arrayWithObjects:kIDStr, kNameStr, kImageStr, kArtistStr, nil];
		self.elementsToParseBusiness = [NSArray arrayWithObjects:kNameStr,kArtistStr, kPeripheryBusinessDetailStr, nil];
		
    }
    return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc
{
    [dataToParseBusiness release];
    [workingEntryBusiness release];
    [workingPropertyStringBusiness release];
    [workingArrayBusiness release];
	[elementsToParseBusiness release];
    
    [super dealloc];
}

- (void)main
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.workingArrayBusiness = [NSMutableArray array];
    self.workingPropertyStringBusiness = [NSMutableString string];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParseBusiness];
	[parser setDelegate:self];
    [parser parse];
	
	if (![self isCancelled])
    {
        // notify our AppDelegate that the parsing is complete
        [self.delegate didFinishParsingBusiness:self.workingArrayBusiness];
    }
    
    self.workingArrayBusiness = nil;
    self.workingPropertyStringBusiness = nil;
    self.dataToParseBusiness = nil;
    
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
        self.workingEntryBusiness = [[BusinessAppRecord alloc] init] ;
    }
    storingCharacterDataBusiness = [elementsToParseBusiness containsObject:elementName];
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
									namespaceURI:(NSString *)namespaceURI
									qualifiedName:(NSString *)qName
{
	if (self.workingEntryBusiness)
	{
		if (storingCharacterDataBusiness)
		{
			NSString *trimmedString = [workingPropertyStringBusiness stringByTrimmingCharactersInSet:
									   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			[workingPropertyStringBusiness setString:@""];  // clear the string for next time
			if ([elementName isEqualToString:kPeripheryBusinessDetailStr])
			{
				self.workingEntryBusiness.peripheryBusinessDetailURLString = [NSString stringWithFormat:@"http://%@/%@", WEBADDRESS, trimmedString];
			//	NSLog(@"PeripheryBusinessDetail= %@", self.workingEntryBusiness.peripheryBusinessDetailURLString);
			}
			else if ([elementName isEqualToString:kNameStr])
			{   
				self.workingEntryBusiness.appNameBusiness = trimmedString;
			}
		//	else if ([elementName isEqualToString:kImageStr])
		//	{
		//		self.workingEntryBusiness.imageURLString = trimmedString;
		//	}
			else if ([elementName isEqualToString:kArtistStr])
			{
				self.workingEntryBusiness.artistBusiness = trimmedString;
			}
		}
		else if ([elementName isEqualToString:kEntryStr])
		{
			[self.workingArrayBusiness addObject:self.workingEntryBusiness];  
			self.workingEntryBusiness = nil;
		}
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterDataBusiness)
    {
        [workingPropertyStringBusiness appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurredBusiness:(NSError *)parseError
{
    [delegate parseErrorOccurredBusiness:parseError];
}

@end

