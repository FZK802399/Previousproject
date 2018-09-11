//
//  WebViewController.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/15.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WebInfo;

typedef enum _webViewType {
    WEBVIEW_TYPE_POST,
    WEBVIEW_TYPE_LIST
} WebViewType;

@interface WebViewController : UIViewController

- (id)initWithWebInfo:(WebInfo *)webInfo webViewType:(WebViewType)webViewType;

@end
