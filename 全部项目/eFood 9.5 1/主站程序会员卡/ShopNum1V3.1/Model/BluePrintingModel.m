//
//  BluePrintingModel.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-10.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "BluePrintingModel.h"
#import "MBProgressHUD.h"

@implementation BluePrintingModel

- (id)initWithAttribute:(NSDictionary *)attribute{
    self = [super init];
    if(self){
        _guid = [attribute objectForKey:@"Guid"];
        _comment = [attribute objectForKey:@"Content"];
        _commentTimeStr = [attribute objectForKey:@"CreateTime"];
        _memberLoginID = [attribute objectForKey:@"CreateUser"];
        _commenttitle = [attribute objectForKey:@"Title"];
        _ProductGuid = [attribute objectForKey:@"ProductGuid"];
        _commentImageStr = [attribute objectForKey:@"Image"] == [NSNull null] ? @"" : [attribute objectForKey:@"Image"];
    }
    
    return self;
}

-(NSArray*)commentImages{
    if (_commentImageStr.length > 0) {
        NSMutableArray * tempArray = [NSMutableArray arrayWithCapacity:0];
        NSArray * imagestrArray = [_commentImageStr componentsSeparatedByString:@"|"];
        for (NSString * temp in imagestrArray) {
            NSString * imagestr = [temp hasPrefix:@"http"] ? temp :[kWebMainBaseUrl stringByAppendingString:temp];
            [tempArray addObject:[NSURL URLWithString:imagestr]];
        }
        return _commentImages = [NSArray arrayWithArray:tempArray];
    }
    
    return [NSArray array];
}

+(void)getMerchandisePictureListByParameters:(NSDictionary *)parameters andblock:(void (^)(NSArray *, NSInteger, NSError *))block{
    [[AFAppAPIClient sharedClient] getPath:kWebgetbaskorderloglistPath parameters:parameters success:^(AFHTTPRequestOperation *operation,id JSON){
        NSInteger count = [JSON objectForKey:@"count"] == [NSNull null] ? 0 :[[JSON objectForKey:@"count"] integerValue];
        NSArray *response = [JSON objectForKey:@"data"];
        NSMutableArray *commentList = [[NSMutableArray alloc] initWithCapacity:[response count]];
        for (NSDictionary *dict in response) {
            BluePrintingModel *detail = [[BluePrintingModel alloc] initWithAttribute:dict];
            [commentList addObject:detail];
        }
        if(block){
            block(commentList,count,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(nil,0,error);
        }
    }];
}


+(void)addBluePrintingByParameters:(NSDictionary *)parameters andblock:(void (^)(NSInteger, NSError *))block{
    
//    NSError *testError;
//    NSData *testData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&testError];
//    NSString *testStr = [[NSString alloc] initWithBytes:[testData bytes] length:[testData length] encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",testStr);

    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient] postPath:kWebAddBaskOrderLogPath parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON){
        [AFAppAPIClient sharedClient].parameterEncoding = AFFormURLParameterEncoding;
        NSInteger result = [[JSON objectForKey:@"return"] integerValue];
//        NSLog(@"result ===%d", result);
        if(block){
            block(result, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
        if(block){
            block(-1, error);
        }
    }];

}

+ (void)uploadData:(NSArray *)datas withNameID:(NSString *)nameID {
    MBProgressHUD *activeIndicator = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    activeIndicator.labelText = @"上传中...";
    
//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"yyyyMMddHHmmss";
//    NSString *fileName = [df stringFromDate:[NSDate date]];
    
    //上传个图片文件；
    for (NSData *data in datas) {
        NSString *_encodedImageStr = [data base64Encoding];
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:
                              nameID,@"memloginid",
                              _encodedImageStr, @"filedata", nil];
        NSURLRequest *request = [[AFAppAPIClient sharedClient2] requestWithMethod:@"POST" path:kWebServiceUploadPath parameters:dic];
        
        //    NSMutableURLRequest *request = [[AFAppAPIClient sharedClient2] multipartFormRequestWithMethod:@"POST" path:kWebServiceUploadPath parameters:dic constructingBodyWithBlock: ^(id<AFMultipartFormData> formData) {
        ////        [formData appendPartWithFileURL:[NSURL fileURLWithPath:theImagePath] name:@"filedata" error:nil];
        //
        //        [formData appendPartWithFileData:data name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg",fileName] mimeType:@"image/jpeg"];
        //    }];
        
        AFHTTPRequestOperation *uploadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [uploadOperation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            if (totalBytesWritten == totalBytesExpectedToWrite) {
//                NSLog(@"upload--------=====success");
            }
        }];
        
        [uploadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (200 == operation.response.statusCode) {
                
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:nil];
//                NSLog(@"upload------------ success %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
                
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                NSInteger result = [[json objectForKey:@"tip"] integerValue];
                if (result == 1) {
                    NSString * imagepath = [json objectForKey:@"success"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:WFSUploadDidEndNotification object:imagepath];

                }else{
//                    [MBHUDView dismissCurrentHUD];
//                    [MBHUDView hudWithBody:@"上传失败" type:MBAlertViewHUDTypeExclamationMark hidesAfter:1.5 show:YES];
                }
                //            [MBHUDView hudWithBody:@"上传完成" type:MBAlertViewHUDTypeCheckmark hidesAfter:1.5 show:YES];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            NSLog(@"upload faile----------- error %@", error.description);
            //        [MBHUDView dismissCurrentHUD];
            //        [MBHUDView hudWithBody:@"上传失败" type:MBAlertViewHUDTypeExclamationMark hidesAfter:1.5 show:YES];
        }];
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [uploadOperation start];
        });
    }

}


@end
