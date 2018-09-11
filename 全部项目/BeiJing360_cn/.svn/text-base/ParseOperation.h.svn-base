/*
 *  ParseOperation.h
 *  BeiJing360
 *
 *  Created by baobin on 11-5-23.
 *  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
 *
 */



@class AppRecord;

@protocol ParseOperationDelegate
- (void)didFinishParsing:(NSArray *)appList;
- (void)parseErrorOccurred:(NSError *)error;
@end

@interface ParseOperation : NSOperation <NSXMLParserDelegate>
{
@private
    id <ParseOperationDelegate> delegate;
    
    NSData          *dataToParse;
    
    NSMutableArray  *workingArray;
    AppRecord       *workingEntry;
    NSMutableString *workingPropertyString;
    NSArray         *elementsToParse;
    BOOL            storingCharacterData;

}

@property (nonatomic, assign) id <ParseOperationDelegate> delegate;
@property (nonatomic, retain) NSData *dataToParse;
@property (nonatomic, retain) NSMutableArray *workingArray;
@property (nonatomic, retain) AppRecord *workingEntry;
@property (nonatomic, retain) NSMutableString *workingPropertyString;
@property (nonatomic, retain) NSArray *elementsToParse;
@property (nonatomic, assign) BOOL storingCharacterData;


- (id)initWithDataWithSubHome:(NSData *)data delegate:(id <ParseOperationDelegate>)theDelegate;

@end

