//
//  CommentList.h
//  Shop
//
//  Created by Ocean Zhang on 4/12/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "EGORefreshView.h"

//0 商品 1 商铺
typedef enum{
    CommentForMerchandise = 0,
    CommentForPicture = 1
    
} CommentListViewType;

@interface CommentList : EGORefreshView

//0 商品 1 商铺
@property (nonatomic, assign) CommentListViewType viewType;

@property (nonatomic, assign) NSInteger shopID;

@property (nonatomic, assign) NSString *merchandiseGuid;


//0全部 1好评 2中评  3差评
@property (nonatomic, assign) NSInteger commentType;

- (void)refreshList;

@end
