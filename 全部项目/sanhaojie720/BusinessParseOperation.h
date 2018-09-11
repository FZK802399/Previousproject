//
//  BusinessParseOperation.h
//  BeiJing360
//
//  Created by baobin on 11-6-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


@class BusinessAppRecord;

@protocol BusinessParseOperationDelegate;

@interface BusinessParseOperation : NSOperation <NSXMLParserDelegate>
{
@private
    id <BusinessParseOperationDelegate> delegate;
    
    NSData				*dataToParseBusiness;
    
    NSMutableArray		*workingArrayBusiness;
    BusinessAppRecord   *workingEntryBusiness;
    NSMutableString		*workingPropertyStringBusiness;
    NSArray				*elementsToParseBusiness;
    BOOL				storingCharacterDataBusiness;
	
}

- (id)initWithDataWithBusinessParse:(NSData *)data delegate:(id <BusinessParseOperationDelegate>)theDelegate;

@end

@protocol BusinessParseOperationDelegate
- (void)didFinishParsingBusiness:(NSArray *)appList;
- (void)parseErrorOccurredBusiness:(NSError *)error;
@end
