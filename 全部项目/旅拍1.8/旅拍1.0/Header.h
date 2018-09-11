//
//  Header.h
//  旅拍1.0
//
//  Created by 司马帅帅 on 15/7/7.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

#define isIos7System [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

#define LIGHT_WHITE_COLOR [UIColor colorWithRed:231.0/255.0f green:231.0/255.0f blue:231.0/255.0f alpha:1.0f]
#define LIGHT_BLACK_COLOR [UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:0.7f]
#define LIGHT_OPAQUE_BLACK_COLOR [UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:0.4f]
#define LIGHT_GREEN_COLOR [UIColor colorWithRed:83.0/255.0f green:181.0/255.0f blue:70.0/255.0f alpha:1.0f]
#define LIGHT_RED_COLOR [UIColor colorWithRed:239.0/255.0f green:86.0/255.0f blue:70.0/255.0f alpha:1.0f]
#define LIGHT_PURPLE_COLOR [UIColor colorWithRed:132.0/255.0f green:59.0/255.0f blue:164.0/255.0f alpha:1.0f]

//公用域名地址
#define LocalWebSite @"http://www.lpxj.com/api.php?"
//注册用户
#define Reuqest_Login @"op=share_userInfo"
//上传照片
#define Request_Upload @"op=share_uploadPhotos"
//我的旅拍列表
#define Request_Mylist @"op=share_records"

typedef enum _UpdateType {
    UPDATETYPE_FOR_ADD_MORE_OBJECTS,
    UPDATETYPE_FOR_ADD_ONE_OBJECT,
    UPDATETYPE_FOR_EDIT_ONE_OBJECT,
    UPDATETYPE_FOR_DELETE_ONE_OBJECT,
    UPDATETYPE_FOR_DELETE_ALL_OBJECTS
} UpdateType;