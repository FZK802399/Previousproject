//
//  MerchandisePriceIntro.h
//  Shop
//
//  Created by Ocean Zhang on 4/2/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MerchandiseDetailModel.h"
#import "MerchandiseCollectModel.h"
#import "AppConfig.h"
#import "ScoreProductDetialModel.h"

@protocol MerchandisePriceIntroDelegate <NSObject>

@optional
- (void)favoTouch:(MerchandiseDetailModel *)detail;
- (void)biJiaViewDidSelectRowAtIndex:(NSInteger)index;

@end

@protocol MerchandisePriceIntroDataSource <NSObject>

@required
- (NSString *)biJiaViewTitleAtIndex:(NSInteger)index;
- (NSInteger)biJiaViewNumberOfRows;
- (CGPoint)scrollViewContentOffset;

@end


@interface MerchandisePriceIntro : UIView
@property (nonatomic, assign) id<MerchandisePriceIntroDelegate> delegate;
@property (nonatomic, weak) id<MerchandisePriceIntroDataSource> dataSource;
@property (nonatomic, strong) AppConfig * appconfig;

@property (nonatomic, strong) UILabel *endTimeLabel;

@property (strong, nonatomic) UITableView *tableView;

- (void)createMerchandisePriceIntro:(MerchandiseDetailModel *)detail withEndTime:(NSString*)endTime;

- (void)createScoreProductPriceIntro:(ScoreProductDetialModel *)detail;

-(NSTimeInterval)RemainingTimeWithDateStr:(NSString *)endtime;

- (void)setPrice:(CGFloat)price;

- (void)setNumber:(NSInteger)number;

- (void)favoSuccessed;


@end
