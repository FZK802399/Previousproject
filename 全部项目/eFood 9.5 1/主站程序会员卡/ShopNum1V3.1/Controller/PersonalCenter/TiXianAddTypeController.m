//
//  TiXianAddTypeController.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/8.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianAddTypeController.h"
#import "UserInfoModel.h"
@interface TiXianAddTypeController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UITextField *num;
@property (weak, nonatomic) IBOutlet UITextField *passWord;


@end

@implementation TiXianAddTypeController

+ (instancetype)create
{
    return [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"TiXianAddTypeController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新增账户";
    self.tableView.backgroundColor = BACKGROUND_GRAY;
    self.btn.layer.cornerRadius = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return nil;
    }
    else
    {
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 12)];
        view.backgroundColor = BACKGROUND_GRAY;
        
        UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 11.5, LZScreenWidth, 0.5)];
        line.backgroundColor = LINE_LIGHTGRAY;
        [view addSubview:line];
        return view;
    }
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 0;
    }
    else
    {
        return 12;
    }
}

- (IBAction)click:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)add:(id)sender {
    [self.view endEditing:YES];
    if ([self.passWord.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入预存款支付密码"];
        return;
    }
    if ([self.name.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入开户人"];
        return;
    }
    if ([self.bankName.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入开户银行"];
        return;
    }
    if ([self.num.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入银行卡号"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * checkDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               config.loginName,@"MemLoginID",
                               allTrim(self.passWord.text),@"PayPwd",
                               config.appSign,@"AppSign", nil];
    [UserInfoModel checkPayPwdByParamer:checkDic andblocks:^(NSInteger result, NSError *error){
        
        if (error) {
            [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            [MBProgressHUD showError:@"网络错误"];
        }else {
            if (result == 200) {
                [self nextStepWithConfig:config];
            }
            else
            {
                [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
                [MBProgressHUD showError:@"支付密码错误"];
            }
        }
    }];
}

- (void)nextStepWithConfig:(AppConfig *)config
{
    NSDictionary * dict = @{
                            @"MemLoginID":config.loginName,
                            @"BankName":self.bankName.text,
                            @"BankAccountName":self.name.text,
                            @"BankAccountNumber":self.num.text,
                            @"Mobile":config.Mobile
                            };
    [[AFAppAPIClient sharedClient]postPath:@"/api/InsertMemberBankAccount/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        NSLog(@"responseObject - %@",responseObject);
        if ([responseObject objectForKey:@"HttpStatusCode"] != [NSNull null]) {
            NSInteger abc = [[responseObject objectForKey:@"HttpStatusCode"] integerValue];
            if (abc == 200) {
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"添加成功"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showError:@"网络错误"];
    }];
}

@end
