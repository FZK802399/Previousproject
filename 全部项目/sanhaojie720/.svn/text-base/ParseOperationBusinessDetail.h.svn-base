//
//  ParseOperationBusinessDetail.h
//  BeiJing360
//
//  Created by baobin on 11-6-9.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

@class AppRecordBusinessDetail;

@protocol ParseOperationDelegateBusinessDetail;

@interface ParseOperationBusinessDetail : NSOperation <NSXMLParserDelegate>
{
@private
    id <ParseOperationDelegateBusinessDetail> delegate;
    
    NSData						*dataToParseBusinessDetail;
    
    NSMutableArray				*workingArrayBusinessDetail;
    AppRecordBusinessDetail     *workingEntryBusinessDetail;
    NSMutableString				*workingPropertyStringBusinessDetail;
    NSArray						*elementsToParseBusinessDetail;
    BOOL						storingCharacterDataBusinessDetail;
	
}

- (id)initWithDataWithBusinessDetail:(NSData *)data delegate:(id <ParseOperationDelegateBusinessDetail>)theDelegate;

@end

@protocol ParseOperationDelegateBusinessDetail

- (void)didFinishParsingBusinessDetail:(NSArray *)appList;
- (void)parseErrorOccurredBusinessDetail:(NSError *)error;

@end