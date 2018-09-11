//
//  AppConfig.m
//  Shop
//
//  Created by Ocean Zhang on 3/26/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig

static AppConfig *sharedAppConfigInstance = nil;

+ (AppConfig *)sharedAppConfig{
    @synchronized(self){
        if(sharedAppConfigInstance == nil){
            sharedAppConfigInstance = [[self alloc] init];
            [sharedAppConfigInstance loadConfig];
        }
    }
    
    return sharedAppConfigInstance;
}

-(NSMutableArray *)collectGuidList
{
    if (_collectGuidList == nil) {
        _collectGuidList = [NSMutableArray array];
    }
    return _collectGuidList;
}

- (id)init {
    self = [super init];
    
    if(self){
        _loginName = @"";
        _RealName = @"";
        _loginPwd = @"";
        _userGuid = @"";
        _userEmail = @"";
        _Mobile = @"";
        _userAdvancePayment = -1;
        _Rate = 0;
        _userScore = -1;
        _userMemberRank = -1;
        _userUrlStr = @"";
        _shopCartNum = 0;
        _firstRun = nil;
        _collectGuidList = nil;
    }
    
    return self;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    @synchronized(self){
        if(sharedAppConfigInstance == nil){
            sharedAppConfigInstance = [super allocWithZone:zone];
            return sharedAppConfigInstance;
        }
    }
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone{
    return self;
}

- (void)loadConfig{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:@"Shop_Login_Name"] != nil){
        _loginName = [userDefaults objectForKey:@"Shop_Login_Name"];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_RealName"] != nil){
        _RealName = [userDefaults objectForKey:@"Shop_Login_RealName"];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_Mobile"] != nil){
        _Mobile = [userDefaults objectForKey:@"Shop_Login_Mobile"];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_Password"] != nil){
        _loginPwd = [userDefaults objectForKey:@"Shop_Login_Password"];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_User_Guid"] != nil){
        _userGuid = [userDefaults objectForKey:@"Shop_Login_User_Guid"];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_User_Email"] != nil){
        _userEmail = [userDefaults objectForKey:@"Shop_Login_User_Email"];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_User_AdvancePayment"] != nil){
        _userAdvancePayment = [[userDefaults objectForKey:@"Shop_Login_User_AdvancePayment"] floatValue];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_User_Rate"] != nil){
        _Rate = [[userDefaults objectForKey:@"Shop_Login_User_Rate"] doubleValue];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_User_Score"] != nil){
        _userScore = [[userDefaults objectForKey:@"Shop_Login_User_Score"] intValue];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_User_MemberRank"] != nil){
        _userMemberRank = [[userDefaults objectForKey:@"Shop_Login_User_MemberRank"] intValue];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_User_Url_Str"] != nil){
        _userUrlStr = [userDefaults objectForKey:@"Shop_Login_User_Url_Str"];
    }
    
    if([userDefaults objectForKey:@"Shop_Login_User_First_Run"] != nil){
        _firstRun = [userDefaults objectForKey:@"Shop_Login_User_First_Run"];
    }
    
    if([userDefaults objectForKey:@"Shop_Web_AppSign"] != nil){
        _appSign = [userDefaults objectForKey:@"Shop_Web_AppSign"];
    }
    
    if([userDefaults objectForKey:@"Shop_Cart_Num"] != nil){
        _shopCartNum = [[userDefaults objectForKey:@"Shop_Cart_Num"] integerValue];
    }
    
    if([userDefaults objectForKey:@"Product_Collect_List"] != nil){
        _collectGuidList = [userDefaults objectForKey:@"Product_Collect_List"];
    }
}

- (void)saveConfig {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(_loginName != nil){
        [userDefaults setObject:self.loginName forKey:@"Shop_Login_Name"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_Name"];
    }
    
    if(_RealName != nil){
        [userDefaults setObject:self.RealName forKey:@"Shop_Login_RealName"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_RealName"];
    }
   
    if(_Mobile != nil){
        [userDefaults setObject:self.Mobile forKey:@"Shop_Login_Mobile"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_Mobile"];
    }
    
    if(_loginPwd != nil){
        [userDefaults setObject:self.loginPwd forKey:@"Shop_Login_Password"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_Password"];
    }
    
    if(_userGuid != nil){
        [userDefaults setObject:self.userGuid forKey:@"Shop_Login_User_Guid"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_User_Guid"];
    }
    
    if(_userEmail != nil){
        [userDefaults setObject:self.userEmail forKey:@"Shop_Login_User_Email"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_User_Email"];
    }
    
    if(_userAdvancePayment >= 0){
        [userDefaults setObject:[NSNumber numberWithFloat:self.userAdvancePayment] forKey:@"Shop_Login_User_AdvancePayment"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_User_AdvancePayment"];
    }
    
    if(_Rate >= 0){
        [userDefaults setObject:[NSNumber numberWithDouble:self.Rate] forKey:@"Shop_Login_User_Rate"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_User_Rate"];
    }
    
    if(_userScore >=0 ){
        [userDefaults setObject:[NSNumber numberWithInt:self.userScore] forKey:@"Shop_Login_User_Score"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_User_Score"];
    }
    
    if(_userMemberRank >= 0){
        [userDefaults setObject:[NSNumber numberWithInt:self.userMemberRank] forKey:@"Shop_Login_User_MemberRank"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_User_MemberRank"];
    }
    
    if(_userUrlStr != nil){
        [userDefaults setObject:self.userUrlStr forKey:@"Shop_Login_User_Url_Str"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_User_Url_Str"];
    }
    
    if(_firstRun != nil){
        [userDefaults setObject:self.firstRun forKey:@"Shop_Login_User_First_Run"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Login_User_First_Run"];
    }
    
    if(_appSign != nil){
        [userDefaults setObject:_appSign forKey:@"Shop_Web_AppSign"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Web_AppSign"];
    }
    
    if(_shopCartNum >= 0){
        [userDefaults setObject:[NSNumber numberWithInt:self.shopCartNum] forKey:@"Shop_Cart_Num"];
    }else{
        [userDefaults removeObjectForKey:@"Shop_Cart_Num"];
    }
    
    if(_collectGuidList != nil){
        [userDefaults setObject:self.collectGuidList forKey:@"Product_Collect_List"];
    }else{
        [userDefaults removeObjectForKey:@"Product_Collect_List"];
    }
    [userDefaults synchronize];
}

- (BOOL)isLogin {
    if([allTrim(_loginName) length] == 0){
        return NO;
    }
    return YES;
}

- (BOOL)userFirstRun {
    if([allTrim(_firstRun) length] == 0){
        return YES;
    }
    return NO;
}

- (void)clearUserInfo
{
    //    self.haveLogin = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        ///Member Login ID 登陆id
        _loginName = nil;
        
        _RealName = nil;
        
        _Mobile = nil;
        
        //登陆密码
        _loginPwd = nil;
        
        _userGuid = nil;
        
        _userEmail = nil;
        
        self.userAdvancePayment = 0;
        
        _Rate = 0;
        
        _userScore = 0;
        
        _userMemberRank = 0;
        
        _userUrlStr = nil;
        
        //        _firstRun = nil;
//        _appSign = nil;
        
        _shopCartNum = 0;
        
        _collectGuidList = nil;
        
        [self clearUserInfoFromDisk];
    });
}
- (void)clearUserInfoFromDisk
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults removeObjectForKey:@"Shop_Login_Name"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_RealName"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_Mobile"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_Password"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_User_Guid"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_User_Email"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_User_AdvancePayment"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_User_Rate"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_User_Score"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_User_MemberRank"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_User_Url_Str"];
    
    [userDefaults removeObjectForKey:@"Shop_Login_User_First_Run"];
    
//    [userDefaults removeObjectForKey:@"Shop_Web_AppSign"];
    
    [userDefaults removeObjectForKey:@"Shop_Cart_Num"];
    
    [userDefaults removeObjectForKey:@"Product_Collect_List"];
    
    [userDefaults synchronize];
}

+ (void)getRateWithBlock:(void(^)(CGFloat rate,NSError * error))block
{
    [[AFAppAPIClient sharedClient]getPath:@"api/GetRate/" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            CGFloat num = [[responseObject objectForKey:@"Rate"] doubleValue];
            AppConfig * config = [AppConfig sharedAppConfig];
            [config loadConfig];
            config.Rate = num;
            [config saveConfig];
            if (block) {
                block(num,nil);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (block) {
            block(-1,error);
        }
    }];
}

@end