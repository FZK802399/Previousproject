//
//  CanMakeCouponsViewController.m
//  ShopNum1V3.1
//
//  Created by 森泓投资 on 16/8/15.
//  Copyright © 2016年 WFS. All rights reserved.
//

#import "CanMakeCouponsViewController.h"
#import "CouponsModel.h"
#import "CanMakeCouponsTableViewCell.h"
#import "WXUtil.h"
@interface CanMakeCouponsViewController ()<UITableViewDelegate,UITableViewDataSource,CanMakeCouponsViewControllerDelegate>

{
    UITableView *_tableView;
    NSMutableArray *_dataLists;
    
}

@property (nonatomic,strong)NSString *time;
@property (nonatomic,strong)NSMutableString *outup;
@property (nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *member;
@property (nonatomic,assign)NSInteger num;
@property (nonatomic,assign)NSInteger numb;

//优惠券id
@property (nonatomic,strong)NSString *couponId;
@property (nonatomic,assign)NSInteger isUse;

@property (nonatomic ,strong)CanMakeCouponsTableViewCell *cell;
@end

@implementation CanMakeCouponsViewController

static NSString *const ID = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *str1 = @"coupon";
    NSString *str2 = @"efood7";
    
    NSString *string = [str1 stringByAppendingString:str2];
    NSLog(@"%@", string);
    
    
    
    long long tim = [self getDateTimeTOMilliSeconds:[NSDate date]];
    NSLog(@"===============================----------------=============%llu",tim);
    
    
    _time = [NSString stringWithFormat:@"%llu",tim];
    NSString *str =[NSString stringWithFormat:@"%llu%@",tim,string];
    
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    _outup = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {[_outup appendFormat:@"%02X", digest[i]];}
    
    NSLog(@"time =======%@  validation=======%@",_time,_outup);
    
    [self initViewData];
    [self initViewUI];
    
    
   

    
}

-(void)initViewData
{
    _dataLists  = [[NSMutableArray alloc]init];

}

-(void)initViewUI
{

    _num=0;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,120, SCREEN_WIDTH, SCREEN_HEIGHT-120) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0 blue:247/255.0 alpha:1.0];
    
    [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CanMakeCouponsTableViewCell class]) bundle:nil] forCellReuseIdentifier:ID];
    
    [self.view addSubview:_tableView];
    

    
   // [_dataLists addObject:cardItem];
    //获取用户信息
    
    NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
    NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
    
    NSLog(@"shop_web_appsign===================%@  memLoginId=====================%@",appsign,memLoginID);
    
    
    NSLog(@"shop_web_appsign==========————11111111———=========%@  memLoginId===========————111———==========%@",appsign,memLoginID);
    NSDictionary *caidy = [NSDictionary dictionaryWithObjectsAndKeys:
                           appsign,@"Appsign",
                           memLoginID,@"MemLoginID",
                           nil];
    [[AFAppAPIClient sharedClient]getPath:kWebAccountInfoPath parameters:caidy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject====——————————==%@",responseObject);
        _userId = responseObject[@"AccoutInfo"][@"ID"];
        
       
    NSLog(@"-----------userId=%@ time= %@ validation=%@===",_userId,_time,_outup);
    
    NSDictionary *cadiy= [NSDictionary dictionaryWithObjectsAndKeys:
                       _userId,@"userId",_time,@"time",_outup,@"validation",
                       nil];
   
    [[AFAppAPIClient sharedClient]getPath:kWebAppGetUserAllCoupon parameters:cadiy success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"----------用户所有优惠券----------------=%@",responseObject);
        id str= responseObject[@"data"];
        for (NSMutableDictionary *ob in str){
            
            _couponId = ob[@"couponId"];
            
           NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:_couponId,@"couponId",_time,@"time",_outup,@"validation",nil];
            
           [[AFAppAPIClient sharedClient]getPath:kWebAppGetCouponRuleByCouponId parameters:info success:^(AFHTTPRequestOperation *operation, id responseObject) {   
               NSLog(@"----优惠券使用规则--==%@",responseObject);

               CouponsModel *cardItem =[[CouponsModel alloc]init];
               cardItem.money =[NSString stringWithFormat:@"%ld",(long)[responseObject[@"result"][@"amount"]intValue]];
               cardItem.moneyMake= responseObject[@"result"][@"couponDescription"];
               cardItem.coupons = @"澳元优惠券";
               cardItem.time = [NSString stringWithFormat:@"使用期限：%@",                responseObject[@"result"][@"endTime"]];
                //需要转换的字符串
               
               cardItem.isUse = [ob[@"isUse"]integerValue];
               cardItem.date = responseObject[@"result"][@"endTime"];
               cardItem.RTtype=responseObject[@"result"][@"rangeType"];
                             //设置转换格式
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
               [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
               //NSString转NSDate
                NSDate *date=[formatter dateFromString:cardItem.date];
               
               long long shijian = [self getDateTimeTOMilliSeconds:[NSDate date]];
               long long shi = [self getDateTimeTOMilliSeconds:date];
               long long shijiancha = shi - shijian;
               if (shijiancha<0) {
                   [_dataLists removeObject:cardItem];
                   _numb = _numb+1;
               }
               else if (cardItem.isUse==1)
               {
               [_dataLists removeObject:cardItem];
                  
               }
               else{
              
                   
              [_dataLists addObject:cardItem];
                   _num = _num+1;
               }
               NSLog(@" -----num-----=%lu",_num);
    
               NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
               
               [defaults setInteger:_num forKey:@"num"];
                [defaults setInteger:_numb forKey:@"numb"];
                 [defaults synchronize];
               
               
               
               [_tableView reloadData];
           } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               NSLog(@"------------error= %@",error);
           }];
            
        }
      
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error= %@",error);
    }];

    
   
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error= %@",error);
    }];

    
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    _cell=[_tableView dequeueReusableCellWithIdentifier:ID];
    if (!_cell) {
        _cell = [[CanMakeCouponsTableViewCell alloc]initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:ID];
        

    }
    _cell.selectionStyle =UITableViewCellSelectionStyleNone;
    _cell.indexNum = indexPath.row+100;
    _cell.cmodel = _dataLists[indexPath.row];

    
    return _cell;
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 100;

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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
