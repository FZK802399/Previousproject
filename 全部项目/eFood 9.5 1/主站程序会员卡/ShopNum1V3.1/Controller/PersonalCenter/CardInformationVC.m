//
//  CardInformationVC.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/7/8.
//  Copyright © 2016年 WFS. All rights reserved.

#import "CardInformationVC.h"
#import "CardNumberItem.h"
#import "CardNumberInformation.h"
#import "DonationVC.h"
#import "UIView+Frame.h"
#import "HomePageController.h"
#import "AFHTTPClient.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import "WXUtil.h"
#import "AFNetworking.h"
@interface CardInformationVC ()<UITableViewDelegate,UITableViewDataSource>
{
    
      UITableView *_tableView;
      UIRefreshControl   *_pullRefresh;      // 下拉刷新

}
@property (nonatomic ,strong) NSMutableArray *cardItems;
@property (nonatomic ,strong)CardNumberInformation *cell;


@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSMutableString *outup;
@property (nonatomic,strong)NSString *userId;
@end

@implementation CardInformationVC

static NSString *const ID = @"Cell";

- (void)viewDidAppear:(BOOL)animated{
    
    [self getList];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str1 = @"card";
    NSString *str2 = @"efood7";
    
    NSString *string = [str1 stringByAppendingString:str2];
    NSLog(@"%@", string);

    long long tim = [self getDateTimeTOMilliSeconds:[NSDate date]];
    NSLog(@"===============================----------------=============%llu",tim);
    _time = [NSString stringWithFormat:@"%llu",tim];
    NSString *str =[NSString stringWithFormat:@"%llu%@",tim,string];
    NSLog(@"md5====str==========%@",str);
    
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    _outup = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {[_outup appendFormat:@"%02X", digest[i]];}
    NSLog(@"output=======%@",_outup);

    [self initViewData];
    [self initViewUI];

}


//将时间戳转换为NSDate类型
-(NSDate *)getDateTimeFromMilliSeconds:(long long) miliSeconds
{
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;//这里的.0一定要加上，不然除下来的数据会被截断导致时间不一致
    NSLog(@"传入的时间戳=%f",seconds);
    return [NSDate dateWithTimeIntervalSince1970:seconds];
}

//将NSDate类型的时间转换为时间戳,从1970/1/1开始
-(long long)getDateTimeTOMilliSeconds:(NSDate *)datetime
{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    NSLog(@"转换的时间戳=%f",interval);
    long long totalMilliseconds = interval*1000 ;
    NSLog(@"totalMilliseconds=%llu",totalMilliseconds);
    return totalMilliseconds;
}

-(void)initViewData
{
    _cardItems =[[NSMutableArray alloc]init];
}
-(void)initViewUI
{

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,120, SCREEN_WIDTH, SCREEN_HEIGHT-120) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:247/255.0 alpha:1.0];
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CardNumberInformation class]) bundle:nil] forCellReuseIdentifier:ID];
    
    [self.view addSubview:_tableView];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _pullRefresh = [[UIRefreshControl alloc] init];
    [_pullRefresh addTarget:self action:@selector(requestNetworkData) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pullRefresh];

}

#pragma mark - 数据请求
- (void)requestNetworkData
{
    [self getList];
    [_tableView reloadData];
    [_pullRefresh endRefreshing];
    
}

-(void)getList
{
  
    
    _cardItems=[[NSMutableArray alloc]init];
    
    
    
    //获取用户信息
    
    NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
    NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
    
    NSLog(@"shop_web_appsign===================%@  memLoginId=====================%@",appsign,memLoginID);
    
        
        NSLog(@"shop_web_appsign==========--------11111111-------=========%@  memLoginId===========--------111-------==========%@",appsign,memLoginID);
        NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                               appsign,@"Appsign",
                               memLoginID,@"MemLoginID",
                               nil];
        [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"responseObject====---------------------==%@",responseObject);
            _userId = responseObject[@"AccoutInfo"][@"ID"];
            NSString *mobile = responseObject[@"AccoutInfo"][@"Mobile"];
         ApplicationDelegate.loginDic = [NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_userId,mobile,nil] forKeys:[NSArray arrayWithObjects:@"userId",@"Mobile",nil]];
            

            
            NSLog(@"userId==---------==---------------------==%@",_userId);
            NSLog(@"userId=======================================================%@",_userId);
            
            NSDictionary *ca= [NSDictionary dictionaryWithObjectsAndKeys:
                               _userId,@"userId",_time,@"time",_outup,@"validation",
                               nil];
            
            [[AFAppAPIClient sharedClient]getPath:kWebAppGetUserCards parameters:ca success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                NSLog(@"***************-----------**********************=%@",responseObject);
                id str= responseObject[@"result"];
                
                NSLog(@"======-----=-=-=-===--=-----=reddddsult=%@",str);
                for (NSMutableDictionary *ob in str){
                    NSLog(@"///////////////////////////-----------------///////////////=%@",ob);
                    CardNumberItem *cardItem =[[CardNumberItem alloc]init];
                    cardItem.cardNumber = [NSString stringWithFormat:@"%@",ob[@"cardCode"]];
                    cardItem.faceValue = [NSString stringWithFormat:@"%ld",(long)[ob[@"leftMoney"] intValue]];
                    cardItem.buyCardTime = ob[@"endTime"];
                    cardItem.cardPass = ob[@"password"];
                    if ([cardItem.faceValue isEqualToString:@"0"]) {
                        [_cardItems removeObject:cardItem];
                    }
                    else{
                        [_cardItems addObject:cardItem];
                    }
                    NSLog(@"---------**********-----------*************-----------------=%@",_cardItems);
                }
                [_tableView reloadData];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                //
                
            }];
            

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            NSLog(@"error=====------====----------------------------------------===%@",error);
            
            // NSString *userId = responseObject[@"Account"][@"name"];
        }];
        
        
    

    
    
   }

-(void)GiveCard:(NSNotification *)noti
{
    
    DonationVC *don = [[DonationVC alloc]init];
    [self.navigationController pushViewController:don animated:YES];
    
}

-(void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cardItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    


    _cell=[_tableView dequeueReusableCellWithIdentifier:ID];
    if (!_cell) {
        _cell = [[CardNumberInformation alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:ID];
    }
    _cell.selectionStyle =UITableViewCellSelectionStyleNone;
   
    _cell.cardItem = _cardItems[indexPath.row];
 
    return _cell;
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145*(SCREEN_HEIGHT/667);
}

@end
