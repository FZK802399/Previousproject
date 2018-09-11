//
//  NameViewController.m
//  Shop
//
//  Created by yons on 15/11/2.
//  Copyright (c) 2015年 ocean. All rights reserved.
//

#import "NameViewController.h"
#import "AFAppAPIClient.h"
#import "AppConfig.h"
@interface NameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@end

@implementation NameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改昵称";
    [self.btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    self.btn.layer.cornerRadius = 3.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)save
{
    if ([self.nameText.text isEqualToString:@""]) {
        [self showMessageWithStr:@"昵称不能为空"];
        return;
    }
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"Email":@"",
                            @"MemLoginID":config.loginName,
                            @"RealName":self.nameText.text,
                            @"QQ":@"",
                            @"AppSign":config.appSign
                            };
//    NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",str);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient]postPath:@"api/UpdateAccount" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject - %@",responseObject);
        NSInteger result = [[responseObject objectForKey:@"HttpStatusCode"] integerValue];
        if (result == 200) {
            [self showMessageWithStr:@"修改成功"];
            config.RealName = self.nameText.text;
            [config saveConfig];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showMessageWithStr:@"修改失败"];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showMessageWithStr:@"修改失败"];
    }];
}

-(void)showMessageWithStr:(NSString *)str
{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    [MBProgressHUD showMessage:str hideAfterTime:1.0f];
}
@end
