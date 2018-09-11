//
//  MerchandisePriceCell.m
//  ShopNum1V3.1
//
//  Created by yons on 16/1/13.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "MerchandisePriceCell.h"
#import "LZPopView.h"
#import "BiJiaModel.h"

@interface MerchandisePriceCell ()<UITableViewDataSource,UITableViewDelegate,LZPopViewDataSoure,LZPopViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *smallTitle;
@property (weak, nonatomic) IBOutlet UILabel *marketPeice;
@property (weak, nonatomic) IBOutlet UILabel *shopPrice;
///最近售出
@property (weak, nonatomic) IBOutlet UILabel *buyCount;
///评价
@property (weak, nonatomic) IBOutlet UILabel *isBest;
///赠送积分
@property (weak, nonatomic) IBOutlet UILabel *score;
///比较按钮
@property (weak, nonatomic) IBOutlet UIButton *BiJiaBtn;
///收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *favoBtn;
///税费
@property (weak, nonatomic) IBOutlet UILabel *shuiPrice;
///商品介绍
@property (weak, nonatomic) IBOutlet UILabel *Brief;

@property (nonatomic,strong)UIView * biJiaView;
@property (nonatomic,weak)UITableView * tableView;
@property (nonatomic,strong)LZPopView * popView;

@property (nonatomic,strong)NSMutableArray * arr;

@end

@implementation MerchandisePriceCell

- (LZPopView *)popView {
    if (!_popView) {
        _popView = [[LZPopView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) dataSource:self backGroundColor:RGBA(0, 0, 0, 0)];
        _popView.animationType = LZAnimationTypeFadeInOut;
        _popView.isBiJia = YES;
    }
    return _popView;
}

-(NSMutableArray *)arr
{
    if (_arr == nil) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

-(void)setModel:(MerchandiseDetailModel *)model
{
    _model = model;
    self.name.text = model.name;
    self.smallTitle.text = model.SmallTitle;
    self.marketPeice.text = [NSString stringWithFormat:@"约¥%.2f",model.marketPrice];
    self.shopPrice.text = [NSString stringWithFormat:@"AU$%.2f",model.shopPrice];
    self.buyCount.text = [NSString stringWithFormat:@"最近售出%ld",model.BuyCount];
    self.isBest.text = [NSString stringWithFormat:@"评分%ld",model.IsBest];
    self.score.text = [NSString stringWithFormat:@"赠送积分%ld",model.PresentScore/100];
    self.shuiPrice.text = [NSString stringWithFormat:@"进口税%.0f元／件",model.IncomeTax];
    self.Brief.text = model.Brief;
    /*
    [self loadBiJia];
     */
    [self favoYesOrNO];
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.shopPrice.textColor = MAIN_ORANGE;
    //临时
    self.BiJiaBtn.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

///比价信息
-(void)loadBiJia
{
    NSURLSession * session = [NSURLSession sharedSession];
    NSString * str = [NSString stringWithFormat:@"http://www.efood7.com/JobPages/job/GoodsPrcoess.ashx?productname=%@&operatetype=GETGOODSINFO&date=%@",_model.name,[NSDate date]];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"比价 - %@",str);
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

- (UIView *)biJiaView {
    if (!_biJiaView) {
        CGFloat height = self.arr.count * 25 + 40;
        _biJiaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, height)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:_biJiaView.bounds];
        imageView.image = [UIImage imageNamed:@"bijia_bg"];
        [_biJiaView addSubview:imageView];
        
        
        UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(1, 5, 127, height - 5) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.rowHeight = 25.0f;
        tableView.sectionHeaderHeight = 30.0f;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.bounces = NO;
        
        [_biJiaView addSubview:tableView];
        self.tableView = tableView;
    }
    return _biJiaView;
}

#pragma PopView Delegate DataSource
- (UIView *)popViewContentViewForLZPopView:(LZPopView *)popView {
    CGFloat contentOffset = [self.delegate getContentOffsetY];
    CGFloat y = self.BiJiaBtn.center.y;
    CGPoint center = self.BiJiaBtn.center;
    CGFloat h = self.arr.count * 25 + 40;  //比价视图的高
    center.y = y + 250 + h/2.0 - 5 - contentOffset;
    self.biJiaView.center = center;
    
    return self.biJiaView;
}

- (void)popViewDidClickBackgroud:(LZPopView *)popView {
    [self.popView dismiss];
}

- (IBAction)BiJiaClick:(id)sender {
    [self.popView show];
}

#pragma mark - UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *biJiaCellIdentifier = @"BiJiaViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:biJiaCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:biJiaCellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
        cell.textLabel.textColor = FONT_DARKGRAY;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
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


- (void)btnfavoTouch:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(merchandisePriceCell:favoBtnDidClick:)]) {
        [self.delegate merchandisePriceCell:self favoBtnDidClick:sender];
    }
}

#pragma mark - 判断收藏

-(void)favoYesOrNO
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    if ([config isLogin]) {
        if ([config.collectGuidList containsObject:_model.guid]) {
            [_favoBtn setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateDisabled];
            [_favoBtn setEnabled:NO];
        }else{
            [_favoBtn addTarget:self action:@selector(btnfavoTouch:) forControlEvents:UIControlEventTouchUpInside];
        }
    }else{
        [_favoBtn addTarget:self action:@selector(btnfavoTouch:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)favoSuccess
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSMutableArray * tempArray = [NSMutableArray arrayWithArray:config.collectGuidList];
    if (!tempArray) {
        tempArray = [NSMutableArray arrayWithCapacity:0];
    }
    [tempArray addObject:_model.guid];
    config.collectGuidList = [NSMutableArray arrayWithArray:tempArray];
    [config saveConfig];
    [self.favoBtn setImage:[UIImage imageNamed:@"yishoucang"] forState:UIControlStateDisabled];
    self.favoBtn.enabled = NO;
}
@end
