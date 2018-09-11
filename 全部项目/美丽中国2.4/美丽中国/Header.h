//
//  Header.h
//  美丽中国
//
//  Created by 司马帅帅 on 15/7/20.
//  Copyright (c) 2015年 司马帅帅. All rights reserved.
//

//宏定义NSUserDefault
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]

//宏定义导游存储路径
#define GUIDE_PATH [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"GuideData"];

//主域名
#define LOCAL_HOST @"http://app.quanjingke.com/api.php?"
//第二个域名
#define LOCAL_HOST_SECONDE @"http://app.quanjingke.com"

//软件的APPKEY
#define APPKEY @"cb4812e66579dfed965e70063d026d8d"

//用户注册与登陆
#define USER_LOGIN_REQUEST @"op=api_reglog"

//请求城市列表
#define CiTY_LIST_REQUEST @"op=api_areasort&appKey=ad36b8ed4ee6ee55faf7f00adf5d0dab"

//请求分类列表
#define CATEGORY_LIST_REQUEST @"op=api_classify"

//请求分类列表的子列表
#define CATEGORY_SUB_LIST_REQUEST @"op=api_classifylist"

//请求导游列表
#define GUIDE_LIST_REQUEST @"op=dyt_chanpin_list"

//请求城市的全景列表
#define CITY_PANO_LIST_REQUEST @"op=api_shootlist"

//请求全景
#define PANO_REQUEST @"http://www.quanjingke.com/index.php?m=space&c=space_album1&a=pano_play&id="

//全景详细页评论列表
#define PANO_COMMENT_LIST_REQUEST @"op=api_commentlist"


