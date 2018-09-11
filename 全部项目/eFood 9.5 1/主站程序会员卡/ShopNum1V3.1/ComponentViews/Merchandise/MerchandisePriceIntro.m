//
//  MerchandisePriceIntro.m
//  Shop
//
//  Created by Ocean Zhang on 4/2/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "MerchandisePriceIntro.h"
#import "StrikeThroughLabel.h"
#import "BorderLabel.h"
#import <QuartzCore/QuartzCore.h>

#import "LZPopView.h"
#import "DzyPopView.h"
#import "BiJiaModel.h"

@interface MerchandisePriceIntro() <UITableViewDataSource, UITableViewDelegate, LZPopViewDataSoure, LZPopViewDelegate>


@property (nonatomic, strong) MerchandiseDetailModel *currentMerchandise;

@property (nonatomic, strong) UILabel *nameLabel;
///新加的0119 简单显示详情
@property (nonatomic, weak) UILabel *nameDetail;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UILabel *getScoreLabelTitle;
@property (nonatomic, strong) UILabel *getScoreLabel;
@property (nonatomic, strong) StrikeThroughLabel *lbMarketPrice;
@property (nonatomic, strong) UILabel *lbShopPrice;
@property (nonatomic, strong) UILabel *PromotionsLabel;
@property (nonatomic, strong) UILabel *lbProductNumTitle;
@property (nonatomic, strong) UILabel *lbProductNum;
@property (nonatomic, strong) UILabel *lbBrandNameTitle;
@property (nonatomic, strong) UILabel *lbRepertoryCountTitle;
@property (nonatomic, strong) UILabel *lbRepertoryCount;
@property (nonatomic, strong) UIButton *btnFavo;
@property (nonatomic, strong) UIButton *biJiaBtn; // 比价按钮

@property (strong, nonatomic) LZPopView *popView;
@property (strong, nonatomic) UIView *biJiaView;

@property (nonatomic, strong) NSMutableArray * arr;

@end

@implementation MerchandisePriceIntro{
    BOOL isFavo;
    NSInteger alltime;
}

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

///比价信息
-(void)loadBiJia
{
    NSURLSession * session = [NSURLSession sharedSession];
    NSString * str = [NSString stringWithFormat:@"http://www.efood7.com/JobPages/job/GoodsPrcoess.ashx?productname=%@&operatetype=GETGOODSINFO&date=%@",_currentMerchandise.name,[NSDate date]];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL * url = [NSURL URLWithString:str];
    NSURLSessionTask * task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSArray * arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        for (NSDictionary * dict in arr) {
            BiJiaModel * model = [BiJiaModel modelWithDict:dict];
            [self.arr addObject:model];
        }
        [self.tableView reloadData];
    }];
    [task resume];
}

#pragma mark -Event
- (IBAction)btnfavoTouch:(id)sender{
    if(isFavo){
        return;
    }

    if([self.delegate respondsToSelector:@selector(favoTouch:)]){
        [self.delegate favoTouch:_currentMerchandise];
    }
}

- (void)createMerchandisePriceIntro:(MerchandiseDetailModel *)detail withEndTime:(NSString*)endTime{
    
    CGFloat originX = 10;
    CGFloat originY = 5;
    CGFloat nameWidth = SCREEN_WIDTH - 65;
    CGFloat nameHeight = 35;
    CGFloat titleHeight = 32;
    //名称
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, nameWidth, nameHeight)];
        _nameLabel.textColor = [UIColor darkGrayColor];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.numberOfLines = 2;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_nameLabel];
    }
    
    
//    收藏
    if(_btnFavo == nil){
        _btnFavo = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnFavo.frame = CGRectMake(SCREEN_WIDTH - 45, originY, 40, 35);
        [_btnFavo setImage:[UIImage imageNamed:@"weishoucang"] forState:UIControlStateNormal];
        [_btnFavo.layer setCornerRadius:10];
        
        [self addSubview:_btnFavo];
    }
    // 竖线
    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_btnFavo.frame) -5, 8, 0.5, 28)];
    sepView.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:sepView];
    
    
    _appconfig = [AppConfig sharedAppConfig];
    
    if ([_appconfig isLogin]) {
        if ([self.appconfig.collectGuidList containsObject:detail.guid]) {
            [_btnFavo setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateDisabled];
            [_btnFavo setEnabled:NO];
        }else{
            [_btnFavo addTarget:self action:@selector(btnfavoTouch:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        [_btnFavo addTarget:self action:@selector(btnfavoTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    originY += nameHeight;
    
    if (_nameDetail == nil) {
        UILabel * nameDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), originY, nameWidth, 28)];
        nameDetail.numberOfLines = 0;
        nameDetail.text = detail.SmallTitle;
        nameDetail.font = [UIFont systemFontOfSize:11];
        nameDetail.textColor = [UIColor redColor];
        [self addSubview:nameDetail];
        _nameDetail = nameDetail;
    }
    
    originY += 28;
    
    //市场价格
    if(_lbMarketPrice == nil){
        _lbMarketPrice = [[StrikeThroughLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_nameLabel.frame), originY, 100, 25)];
        _lbMarketPrice.textColor = [UIColor colorWithWhite:0.530 alpha:1.000];
        _lbMarketPrice.font = [UIFont systemFontOfSize:12.0];
        _lbMarketPrice.strikeThroughEnabled = YES;
        _lbMarketPrice.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbMarketPrice];
    }
    
    originY += CGRectGetHeight(_lbMarketPrice.frame);
    
    //店铺价格
    if(_lbShopPrice == nil){
        _lbShopPrice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_lbMarketPrice.frame), originY, 0, 28)];
        _lbShopPrice.textColor = MAIN_ORANGE;
        _lbShopPrice.font = [UIFont systemFontOfSize:16.0f];
        [self addSubview:_lbShopPrice];
    }
    // 比价按钮
    if (_biJiaBtn == nil) {
        _biJiaBtn = [[UIButton alloc] init];
        [_biJiaBtn setImage:[UIImage imageNamed:@"bijia"] forState:UIControlStateNormal];
        [_biJiaBtn addTarget:self action:@selector(biJia:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_biJiaBtn];
    }
    
    originY += CGRectGetHeight(_lbShopPrice.frame);
    
    //抢购时间
    if (_endTimeLabel == nil && endTime.length > 0) {
        _endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, 200, titleHeight)];
        _endTimeLabel.textAlignment = NSTextAlignmentLeft;
        _endTimeLabel.textColor = [UIColor barTitleColor];
        alltime = round([self RemainingTimeWithDateStr:endTime]);
        _endTimeLabel.text = [self getTimeDifferenceWithTimeInterval:alltime];
        _endTimeLabel.font = [UIFont workListDetailFont];
        
        [self addSubview:_endTimeLabel];
    }
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.borderWidth = 1;
    bottomLayer.borderColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1].CGColor;
    bottomLayer.frame = CGRectMake(0, originY, SCREEN_WIDTH, 1);
    [self.layer addSublayer:bottomLayer];
    
    
    CGFloat labelWidth = (SCREEN_WIDTH - 20) / 3.0;

    //售出数量title
    if(_lbProductNumTitle == nil){
        _lbProductNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, originY, labelWidth, titleHeight)];
        _lbProductNumTitle.textColor = [UIColor grayColor];
//        _lbProductNumTitle.text = @"最近售出 ";
        _lbProductNumTitle.font = [UIFont systemFontOfSize:12];
        _lbProductNumTitle.backgroundColor = [UIColor clearColor];
        _lbProductNumTitle.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_lbProductNumTitle];
    }
    
    //售出数量
//    if(_lbProductNum == nil){
//        _lbProductNum = [[UILabel alloc] initWithFrame:CGRectMake(originX+60, originY, 70, titleHeight)];
//        _lbProductNum.textColor = [UIColor blackColor];
//        _lbProductNum.font = [UIFont systemFontOfSize:11];
//        _lbProductNum.textAlignment = NSTextAlignmentLeft;
//        _lbProductNum.backgroundColor = [UIColor clearColor];
//        [self addSubview:_lbProductNum];
//    }
    
//    //Score title
    if(_lbBrandNameTitle == nil){
        _lbBrandNameTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lbProductNumTitle.frame), originY, labelWidth, titleHeight)];
        _lbBrandNameTitle.textColor = [UIColor grayColor];
//        _lbBrandNameTitle.text = @"评分 ";
        _lbBrandNameTitle.font = [UIFont systemFontOfSize:12];
        _lbBrandNameTitle.backgroundColor = [UIColor clearColor];
        _lbBrandNameTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lbBrandNameTitle];
    }
//
//    //Score
//    if(_scoreLabel == nil){
//        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX+150, originY, 70, titleHeight)];
//        _scoreLabel.textColor = [UIColor blackColor];
//        _scoreLabel.textAlignment = NSTextAlignmentLeft;
//        _scoreLabel.font = [UIFont systemFontOfSize:11];
//        _scoreLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:_scoreLabel];
//    }
    
    //getScore title
    if(_getScoreLabelTitle == nil){
        _getScoreLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lbBrandNameTitle.frame), originY, labelWidth, titleHeight)];
        _getScoreLabelTitle.textColor = [UIColor grayColor];
//        _getScoreLabelTitle.text = @"赠送积分 ";
        _getScoreLabelTitle.font = [UIFont systemFontOfSize:12];
        _getScoreLabelTitle.backgroundColor = [UIColor clearColor];
        _getScoreLabelTitle.textAlignment = NSTextAlignmentRight;
        [self addSubview:_getScoreLabelTitle];
    }
//    NSLog(@"%f", CGRectGetMaxY(_getScoreLabelTitle.frame));
    
    //getScore
//    if(_getScoreLabel == nil){
//        _getScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX+270, originY, 60, titleHeight)];
//        _getScoreLabel.textColor = [UIColor blackColor];
//        _getScoreLabel.textAlignment = NSTextAlignmentLeft;
//        _getScoreLabel.font = [UIFont systemFontOfSize:11];
//        _getScoreLabel.backgroundColor = [UIColor clearColor];
//        [self addSubview:_getScoreLabel];
//    }
    
    //        //库存量
    //        if(_lbRepertoryCountTitle == nil){
    //            _lbRepertoryCountTitle = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, titleWidth, spectHeight)];
    //            _lbRepertoryCountTitle.textColor = generalColor;
    //            _lbRepertoryCountTitle.font = generalFont;
    //            _lbRepertoryCountTitle.text = @"库存量:";
    //            _lbRepertoryCountTitle.backgroundColor = [UIColor clearColor];
    //            [self addSubview:_lbRepertoryCountTitle];
    //        }
    //
    //        if(_lbRepertoryCount == nil){
    //            _lbRepertoryCount = [[UILabel alloc] initWithFrame:CGRectMake(contentOriginX, originY, contentWidth, spectHeight)];
    //            _lbRepertoryCount.textColor = [UIColor blueColor];
    //            _lbRepertoryCount.font = generalFont;
    //            _lbRepertoryCount.backgroundColor = [UIColor clearColor];
    //            [self addSubview:_lbRepertoryCount];
    //        }
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:240 /255.0f green:238 /255.0f blue:236 /255.0f alpha:1].CGColor;
    self.backgroundColor = [UIColor whiteColor];
//    [self.layer setCornerRadius:10];
    
    
    _currentMerchandise = detail;
    if (endTime.length <= 0) {
        _lbProductNumTitle.text = [NSString stringWithFormat:@"最近售出 %d", detail.BuyCount];
        _lbBrandNameTitle.text = [NSString stringWithFormat:@"评分 %d", detail.IsBest];
        //修改数据
        //    _scoreLabel.text = [NSString stringWithFormat:@"%d", detail.IsBest];
        //    NSLog(@"(NSInteger)(detail.shopPrice * 100) = %f",(detail.shopPrice * 100));
        if (detail.PresentRankScore == -1) {
            detail.PresentScore = detail.PresentScore/100;
        }
        _getScoreLabelTitle.text = [NSString stringWithFormat:@"赠送积分 %d",detail.PresentScore];
        //    _getScoreLabel.text = [NSString stringWithFormat:@"%d",detail.PresentScore];
    }
    _lbMarketPrice.text = [NSString stringWithFormat:@"AU$%.2f",detail.marketPrice];    
    _nameLabel.text = detail.name;
    _lbShopPrice.text = [NSString stringWithFormat:@"AU$%.2f",detail.shopPrice];
    
    NSString *shopPriceStr = [NSString stringWithFormat:@"AU$%.2f",detail.shopPrice];
    _lbShopPrice.text = shopPriceStr;
    CGRect labelRect = [shopPriceStr boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil];
    CGRect priceRect = _lbShopPrice.frame;
    priceRect.size.width = labelRect.size.width;
    _lbShopPrice.frame = priceRect;
    _biJiaBtn.frame = CGRectMake(CGRectGetMaxX(_lbShopPrice.frame) + 10, CGRectGetMinY(_lbShopPrice.frame), 28, 28);
    LZLOG(@"BijiA : %@", NSStringFromCGRect(_biJiaBtn.frame));
    
    [self loadBiJia];
}



-(void)createScoreProductPriceIntro:(ScoreProductDetialModel *)detail{

    UIFont *generalFont = [UIFont systemFontOfSize:14.0f];
    CGFloat originX = 6;
    CGFloat originY = 10;
    CGFloat nameWidth = 250;
    CGFloat nameHeight = 35;
    CGFloat titleWidth = 70;
    CGFloat titleHeight = 20;
    //名称
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY, nameWidth, nameHeight)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = generalFont;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.numberOfLines = 2;
        _nameLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:_nameLabel];
    }
    
    //收藏
    if(_btnFavo == nil){
        _btnFavo = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnFavo.frame = CGRectMake(originX + nameWidth +25, originY, 35, 35);
        _btnFavo.backgroundColor = [UIColor redColor];
        [_btnFavo.layer setCornerRadius:10];
        
        [self addSubview:_btnFavo];
    }
//    _appconfig = [AppConfig sharedAppConfig];
//    
//    if ([_appconfig isLogin]) {
//        if ([self.appconfig.collectGuidList containsObject:detail.guid]) {
//            [_btnFavo setImage:[UIImage imageNamed:@"btn_Collect_selected.png"] forState:UIControlStateDisabled];
//            [_btnFavo setEnabled:NO];
//        }else{
//            [_btnFavo addTarget:self action:@selector(btnfavoTouch:) forControlEvents:UIControlEventTouchUpInside];
//        }
//    }else{
//        [_btnFavo addTarget:self action:@selector(btnfavoTouch:) forControlEvents:UIControlEventTouchUpInside];
//    }
    
    
    originY += nameHeight;
    //店铺价格
    if(_lbShopPrice == nil){
        _lbShopPrice = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY + 5, 70, titleHeight)];
        _lbShopPrice.textColor = [UIColor redColor];
        _lbShopPrice.font = generalFont;
        _lbShopPrice.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbShopPrice];
    }
    
    //市场价格
    if(_lbMarketPrice == nil){
        _lbMarketPrice = [[StrikeThroughLabel alloc] initWithFrame:CGRectMake(originX + 75, originY + 5, 70, titleHeight)];
        _lbMarketPrice.textColor = [UIColor colorWithRed:164 /255.0f green:164 /255.0f blue:164 /255.0f alpha:1];
        _lbMarketPrice.font = generalFont;
        _lbMarketPrice.strikeThroughEnabled = NO;
        _lbMarketPrice.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbMarketPrice];
    }
    
    originY += titleHeight;
    
    CALayer *bottomLayer = [CALayer layer];
    bottomLayer.borderWidth = 1;
    bottomLayer.borderColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1].CGColor;
    bottomLayer.frame = CGRectMake(0, originY + 40, SCREEN_WIDTH, 1);
    [self.layer addSublayer:bottomLayer];
    
    //售出数量title
    if(_lbProductNumTitle == nil){
        _lbProductNumTitle = [[UILabel alloc] initWithFrame:CGRectMake(originX, originY+52, titleWidth, titleHeight)];
        _lbProductNumTitle.textColor = [UIColor blackColor];
        _lbProductNumTitle.text = @"最近售出：";
        _lbProductNumTitle.font = [UIFont systemFontOfSize:13];
        _lbProductNumTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbProductNumTitle];
    }
    
    //售出数量
    if(_lbProductNum == nil){
        _lbProductNum = [[UILabel alloc] initWithFrame:CGRectMake(originX+60, originY+52, 70, titleHeight)];
        _lbProductNum.textColor = [UIColor blackColor];
        _lbProductNum.font = [UIFont systemFontOfSize:13];
        _lbProductNum.textAlignment = NSTextAlignmentLeft;
        _lbProductNum.backgroundColor = [UIColor clearColor];
        [self addSubview:_lbProductNum];
    }
    
    
    //getScore title
    if(_getScoreLabelTitle == nil){
        _getScoreLabelTitle = [[UILabel alloc] initWithFrame:CGRectMake(originX+210, originY+52, titleWidth, titleHeight)];
        _getScoreLabelTitle.textColor = [UIColor blackColor];
        _getScoreLabelTitle.text = @"点击次数：";
        _getScoreLabelTitle.font = [UIFont systemFontOfSize:13];
        _getScoreLabelTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:_getScoreLabelTitle];
    }
    
    //getScore
    if(_getScoreLabel == nil){
        _getScoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(originX+270, originY+52, 60, titleHeight)];
        _getScoreLabel.textColor = [UIColor blackColor];
        _getScoreLabel.textAlignment = NSTextAlignmentLeft;
        _getScoreLabel.font = [UIFont systemFontOfSize:13];
        _getScoreLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_getScoreLabel];
    }
    
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor colorWithRed:240 /255.0f green:238 /255.0f blue:236 /255.0f alpha:1].CGColor;
    self.backgroundColor = [UIColor whiteColor];
    //    [self.layer setCornerRadius:10];
    
    
//    _currentMerchandise = detail;
    _lbShopPrice.text = [NSString stringWithFormat:@"AU$%.2f",detail.prmo];
    _lbMarketPrice.text = [NSString stringWithFormat:@"%d积分",detail.ExchangeScore];
    _lbProductNum.text = [NSString stringWithFormat:@"%d", detail.SaleNumber];
    _nameLabel.text = detail.name;
//    //修改数据
//    //    _scoreLabel.text = [NSString stringWithFormat:@"%d", detail.IsBest];
//    //    NSLog(@"(NSInteger)(detail.shopPrice * 100) = %f",(detail.shopPrice * 100));
//    if (detail.PresentRankScore == -1) {
//        detail.PresentScore = detail.PresentScore/100;
//    }
    _getScoreLabel.text = [NSString stringWithFormat:@"%d",detail.ClickCount];

}


-(NSString *)getTimeDifferenceWithTimeInterval:(NSInteger) remainingTime{
    NSString * timeStr;
    if (remainingTime <= 0) {
        timeStr = @"活动已结束";
    }else {
        NSInteger dayNum = remainingTime / 86400;
        NSInteger hourNum = remainingTime % 86400 / 3600;
        NSInteger minuteNum = remainingTime % 3600 / 60;
        NSInteger secondNum = remainingTime % 60;
        timeStr = [NSString stringWithFormat:@"剩余时间：%d天%d小时%d分%d秒",dayNum, hourNum, minuteNum, secondNum];
        
    }
    return timeStr;
}

-(NSTimeInterval)RemainingTimeWithDateStr:(NSString *)endtime{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    NSDate * endTimeDate = [dateFormatter dateFromString:endtime];
    NSTimeInterval timeSinceNow = [endTimeDate timeIntervalSinceNow];
    return timeSinceNow;
}

- (void)setPrice:(CGFloat)price{
    _lbShopPrice.text = [NSString stringWithFormat:@"AU$%.2f",price];
}

- (void)setNumber:(NSInteger)number{
    _lbRepertoryCount.text = [NSString stringWithFormat:@"%d",number];
}

- (void)favoSuccessed{
    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:self.appconfig.collectGuidList];
    if (!tempArray) {
        tempArray = [NSMutableArray arrayWithCapacity:0];
    }
    [tempArray addObject:_currentMerchandise.guid];
    
    self.appconfig.collectGuidList = [NSMutableArray arrayWithArray:tempArray];
    [self.appconfig saveConfig];
    [_btnFavo setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateDisabled];
    [_btnFavo setEnabled:NO];
}

- (LZPopView *)popView {
    if (!_popView) {
        _popView = [[LZPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) dataSource:self backGroundColor:RGBA(0, 0, 0, 0)];
        _popView.animationType = LZAnimationTypeFadeInOut;
        _popView.isBiJia = YES;
    }
    return _popView;
}

- (UIView *)biJiaView {
    if (!_biJiaView) {
        CGFloat height = self.arr.count * 25 + 40;
//        if ([_dataSource respondsToSelector:@selector(biJiaViewNumberOfRows)]) {
//            height = [_dataSource biJiaViewNumberOfRows] * 25 + 40;
//        }
        _biJiaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, height)];
//        _biJiaView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bijia_bg"]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_biJiaView.bounds];
        imageView.image = [UIImage imageNamed:@"bijia_bg"];
        [_biJiaView addSubview:imageView];
        
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 5, 127, height - 5) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.rowHeight = 25.0f;
        _tableView.sectionHeaderHeight = 30.0f;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        
        [_biJiaView addSubview:_tableView];
    }
    return _biJiaView;
}

#pragma PopView Delegate DataSource
- (UIView *)popViewContentViewForLZPopView:(LZPopView *)popView {
    CGFloat offset = 0;
    if ([self.dataSource respondsToSelector:@selector(scrollViewContentOffset)]) {
        offset = [_dataSource scrollViewContentOffset].y;
        //        NSLog(@"Offset : %.2f", offset);
    }
    
    CGFloat y = self.biJiaBtn.center.y;
    CGPoint center = self.biJiaBtn.center;
    
    center.y = y + (CGRectGetHeight(self.biJiaBtn.frame) + CGRectGetHeight(self.biJiaView.frame)) / 2.0f + 225 - offset + 64;
    self.biJiaView.center = center;
    
    return self.biJiaView;
}

- (void)popViewDidClickBackgroud:(LZPopView *)popView {
    [self.popView dismiss];
}

// MARK: 比价视图
- (void)biJia:(UIButton *)sender {

//    NSLog(@"Center : %@", NSStringFromCGPoint(center));
    
    [self.popView show];
}

#pragma mark - UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if ([self.dataSource respondsToSelector:@selector(biJiaViewNumberOfRows)]) {
//        return [self.dataSource biJiaViewNumberOfRows];
//    } else {
//        return 0;
//    }
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *biJiaCellIdentifier = @"BiJiaViewCell";
//    NSString *title = nil;
//    if ([self.dataSource respondsToSelector:@selector(biJiaViewTitleAtIndex:)]) {
//        title = [self.dataSource biJiaViewTitleAtIndex:indexPath.row];
//    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:biJiaCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:biJiaCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.textColor = FONT_DARKGRAY;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
//    if (title && title.length > 0) {
//        cell.textLabel.text = title;
//    }
    BiJiaModel * model = self.arr[indexPath.row];
    cell.textLabel.text = model.source;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"AU$%@",model.price];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40.0f)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = FONT_LIGHTGRAY;
    label.text = @" 其他商城价格";
    [headerView addSubview:label];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 向代理发点击事件
    if ([self.delegate respondsToSelector:@selector(biJiaViewTitleAtIndex:)]) {
        [self.delegate biJiaViewDidSelectRowAtIndex:indexPath.row];
    }
}

@end
