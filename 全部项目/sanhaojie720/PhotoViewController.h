//
//  PhotoViewController.h
//  BeiJing360
//
//  Created by lin yuxin on 12-2-9.
//  Copyright (c) 2012年 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *scrView1;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrView1;

@end
