//
//  ListViewController.h
//  whxfj
//
//  Created by 司马帅帅 on 14-8-23.
//  Copyright (c) 2014年 baobin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ListViewType {
    LISTVIEWTYPE_WHC,
    LISTVIEWTYPE_HKB,
    LISTVIEWTYPE_HDH,
    LISTVIEWTYPE_ZHK,
    LISTVIEWTYPE_QXX,
    LISTVIEWTYPE_HFX
} ListViewType;

@interface ListViewController : UIViewController

- (id)initWith:(ListViewType)listViewType_;

@end
