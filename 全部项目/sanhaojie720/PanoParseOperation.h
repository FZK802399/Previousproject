//
//  PanoParseOperation.h
//  BeiJing360
//
//  Created by baobin on 11-6-3.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//


@class PanoAppRecord;

@protocol PanoParseOperationDelegate;

@interface PanoParseOperation : NSOperation <NSXMLParserDelegate>
{
@private
    id <PanoParseOperationDelegate> delegate;
    
    NSData          *dataToParsePano;
    
    NSMutableArray  *workingArrayPano;
    PanoAppRecord   *workingEntryPano;
    NSMutableString *workingPropertyStringPano;
    NSArray         *elementsToParsePano;
    BOOL            storingCharacterDataPano;
	
}

- (id)initWithDataWithMorePano:(NSData *)data delegate:(id <PanoParseOperationDelegate>)theDelegate;

@end

@protocol PanoParseOperationDelegate

- (void)didFinishParsingPano:(NSArray *)appList;
- (void)parseErrorOccurredPano:(NSError *)error;

@end
