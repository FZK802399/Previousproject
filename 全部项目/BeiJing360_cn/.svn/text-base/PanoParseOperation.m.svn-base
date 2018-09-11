    //
//  PanoParseOperation.m
//  BeiJing360
//
//  Created by baobin on 11-6-3.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "PanoParseOperation.h"
#import "PanoAppRecord.h"
#import "Global.h"

// string contants found in the RSS feed
//static NSString *kIDStr			  = @"id";
static NSString *kNameStr			  = @"im:name";
static NSString *kImageStr			  = @"im:image";
static NSString *kArtistStr			  = @"im:artist";
static NSString *kVirtualTourImageStr = @"im:virtualTourImage";
static NSString *kEntryStr			  = @"entry";

@interface PanoParseOperation ()
@property (nonatomic, assign) id <PanoParseOperationDelegate> delegate;
@property (nonatomic, retain) NSData *dataToParsePano;
@property (nonatomic, retain) NSMutableArray *workingArrayPano;
@property (nonatomic, retain) PanoAppRecord *workingEntryPano;
@property (nonatomic, retain) NSMutableString *workingPropertyStringPano;
@property (nonatomic, retain) NSArray *elementsToParsePano;
@property (nonatomic, assign) BOOL storingCharacterDataPano;

@end

@implementation PanoParseOperation

@synthesize delegate, dataToParsePano, workingArrayPano, workingEntryPano, workingPropertyStringPano, elementsToParsePano, storingCharacterDataPano;

- (id)initWithDataWithMorePano:(NSData *)data delegate:(id <PanoParseOperationDelegate>)theDelegate
{
    self = [super init];
	
    if (self != nil)
    {		
        self.dataToParsePano = data;
        self.delegate = theDelegate;
	//	self.elementsToParsePano = [NSArray arrayWithObjects:kIDStr, kNameStr, kImageStr, kArtistStr, nil];
		self.elementsToParsePano = [NSArray arrayWithObjects:kNameStr, kImageStr, kArtistStr, kVirtualTourImageStr, nil];
		
    }
    return self;
}

// -------------------------------------------------------------------------------
//	dealloc:
// -------------------------------------------------------------------------------
- (void)dealloc
{
    [dataToParsePano release];
    [workingEntryPano release];
    [workingPropertyStringPano release];
    [workingArrayPano release];
    [elementsToParsePano release];
	
    [super dealloc];
}

- (void)main
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.workingArrayPano = [NSMutableArray array];
    self.workingPropertyStringPano = [NSMutableString string];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:dataToParsePano];
	[parser setDelegate:self];
    [parser parse];
	
	if (![self isCancelled])
    {
        // notify our AppDelegate that the parsing is complete
        [self.delegate didFinishParsingPano:self.workingArrayPano];
    }
    
    self.workingArrayPano = nil;
    self.workingPropertyStringPano = nil;
    self.dataToParsePano = nil;
    
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
        self.workingEntryPano = [[[PanoAppRecord alloc] init] autorelease];
    }
   
	storingCharacterDataPano = [elementsToParsePano containsObject:elementName];
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
									namespaceURI:(NSString *)namespaceURI
									qualifiedName:(NSString *)qName
{
	if (self.workingEntryPano)
	{
		if (storingCharacterDataPano)
		{
			NSString *trimmedString = [workingPropertyStringPano stringByTrimmingCharactersInSet:
									   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
			
			[workingPropertyStringPano setString:@""];  // clear the string for next time
			
			if ([elementName isEqualToString:kVirtualTourImageStr]) {
				
				self.workingEntryPano.imageURLStringPano = [NSString stringWithFormat:@"http://%@/qjbj/%@", WEBADDRESS, trimmedString];
				NSLog(@"%@: %@", self.workingEntryPano.appNamePano, self.workingEntryPano.imageURLStringPano);
				//self.workingEntryPano.imageURLStringPano = trimmedString;
				
			} else if ([elementName isEqualToString:kNameStr]){   
				
				self.workingEntryPano.appNamePano = trimmedString;
				
			} else if ([elementName isEqualToString:kImageStr]) {
				
				self.workingEntryPano.imageURLString = [NSString stringWithFormat:@"http://%@/qjbj/%@", WEBADDRESS, trimmedString];
			//	NSLog(@"MorePanorama image= %@", self.workingEntryPano.imageURLString);
				
			} else if ([elementName isEqualToString:kArtistStr]) {
				
				self.workingEntryPano.artistPano = trimmedString;
			}
		} else if ([elementName isEqualToString:kEntryStr]) {
			
			[self.workingArrayPano addObject:self.workingEntryPano]; 
			
			self.workingEntryPano = nil;
		}
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingCharacterDataPano)
    {
        [workingPropertyStringPano appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurredPano:(NSError *)parseError
{
    [delegate parseErrorOccurredPano:parseError];
}

@end
