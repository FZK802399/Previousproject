//
//  RegisterNextViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "RegisterNextViewController.h"
#import "UserInfoModel.h"
#import "EMIMHelper.h"
@interface RegisterNextViewController ()<IChatManagerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation RegisterNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadLeftBackBtn];
    // Do any additional setup after loading the view.
    self.submitButton.layer.cornerRadius = 3.0f;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

// 提交信息
- (IBAction)register:(id)sender {
    /// <summary>
    /// 门户注册
    /// </summary>
    /// <param name="MemLoginID">登录ID</param>
    /// <param name="Pwd">密码</param>
    /// <param name="Email">邮件</param>
    /// <param name="CommendPeople">推荐人</param>
    /// <param name="Mobile">手机号</param>
    /// <param name="AppSign"></param>
    /// <returns></returns>
//   /api/accountregist?MemLoginID=Tide&Pwd=123456&Email=zhangsan@126.com&CommendPeople=yoyo4&Mobile=13569856952&AppSign=9991fa8f663fe072a54ba7cce6341e4b

    if (allTrim(self.passwordTextfield.text).length == 0) {
        [self showAlertWithMessage:@"请先输入密码"];
        return;
    }
    if (allTrim(self.passwordTextfield.text).length < 6) {
        [self showAlertWithMessage:@"密码需要输入6个字符长度以上"];
        return;
    }
    if (![allTrim(self.passwordTextfield.text) isEqualToString:allTrim(self.surepassword.text)]) {
        [self showAlertWithMessage:@"两次输入密码不一致"];
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"MemLoginID"] = self.userName;
    dict[@"Pwd"] = self.passwordTextfield.text;
    dict[@"Email"] = @"0";
    dict[@"Mobile"] = self.userName;
//    dict[@"CommendPeople"] = @"";
    dict[@"MobileCode"] = self.countryCode;
    dict[@"AppSign"] = kWebAppSign;
    
    if (allTrim(self.recommnedPersonTextfield.text).length >0) {
        // 验证推荐人是否存在
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        dictionary[@"MemLoginID"] = allTrim(self.recommnedPersonTextfield.text);
        dictionary[@"AppSign"] = kWebAppSign;
        [UserInfoModel userNameIsExistByParamer:dictionary andblocks:^(bool isExist, NSError *error) {
            if (error) {
                [self showAlertWithMessage:@"网络错误"];
            }else {
                if (!isExist) {
                    [self showAlertWithMessage:@"推荐人不存在"];
                    return;
                } else {
                    dict[@"CommendPeople"] = self.recommnedPersonTextfield.text;
                    [self submitInfoByDict:dict];
                }
            }
        }];
    } else {
        dict[@"CommendPeople"] = @"";
        [self submitInfoByDict:dict];
    }
}

- (void)submitInfoByDict:(NSDictionary *)dict {
    
    [UserInfoModel registerUserByParamer:dict andblocks:^(bool isSuccess, NSError *error) {
        if (error) {
            [self showAlertWithMessage:@"网络错误"];
        }else{
            if (isSuccess) {
                self.appConfig.loginName = allTrim(self.userName);
                self.appConfig.loginPwd = allTrim(self.passwordTextfield.text);
                [self.appConfig saveConfig];
                [self.navigationController popToRootViewControllerAnimated:YES];
                [UIHelper gotoTabbar:3];
                ///退出环信的登录
                [[EMIMHelper defaultHelper] logoffEasemobSDK];
            }else{
                [self showAlertWithMessage:@"注册失败"];
            }
        }
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didRegisterNewAccount:(NSString *)username
                     password:(NSString *)password
                        error:(EMError *)error;
{
    if (!error) {
        NSLog(@"注册成功");
        
        
        
        
        NSString *appsign = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Web_AppSign"];
        NSString *memLoginID = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Name"];
        
        
        
        NSString *passWord = [[NSUserDefaults standardUserDefaults]objectForKey:@"Shop_Login_Password"];
            NSMutableString *pwd = [NSMutableString stringWithCapacity:0];
            
            for (int i=0; i<passWord.length; i++) {
                
                char a = [passWord characterAtIndex:i];
                NSArray *arr1=@[@",",@".",@"/",@"-",@" ",@":",@"=",@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
                NSArray *arr2=@[ @",",@"%",@"/",@"-",@" ",@":",@"0",@"d",@"4",@"I",@"E",@"=",@"7",@"5",@"6",@"s",@"y",@"D",@"x",@"F",@"w",@"G",@"h",@"J",@"K",@"2",@"3",@"L",@"M",@"c",@"e",@"Q",@"f",@"g",@"O",@"j",@"l",@"N",@"i",@"p",@"P",@"k",@"T",@"a",@"H",@"W",@"n",@"X",@"Y",@"1",@"U",@"Z",@"b",@"m",@"o",@"q",@"r",@"8",@"B",@"9",@"R",@"S",@"C",@"t",@"u",@"A",@"v",@"V",@"z"];
                for (int j=0; j<[arr1 count]; j++) {
                    char  b= [arr1[j] characterAtIndex:0];
                    if (a==b) {
                        a=[arr2[j] characterAtIndex:0];
                        break;
                    }
                    else
                    {
                        a=a;
                    }
                    
                }
                
                [pwd appendFormat:@"%c",a];
            }

        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                               appsign,@"Appsign",
                               memLoginID,@"MemLoginID",pwd,@"pwd",
                               nil];
       [[AFAppAPIClient sharedClient]postPath:kWebAppRegDingCard parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
          
           NSLog(@"------------------responseObject=%@",responseObject);
           
           
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
           NSLog(@"------------------error=%@",error);
           
       }];
        
        
    }
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
