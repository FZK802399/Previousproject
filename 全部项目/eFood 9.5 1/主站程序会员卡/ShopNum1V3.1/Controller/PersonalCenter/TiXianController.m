//
//  TiXianController.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/7.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianController.h"
#import "TiXianTypeController.h"
#import "TiXianDetailController.h"

#import "TiXianOneCell.h"
#import "TiXianTwoCell.h"
#import "TiXianThreeCell.h"
@interface TiXianController ()<UITableViewDataSource,UITableViewDelegate,TiXianTypeDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) UILabel * label;
///已选择银行Guid
@property (nonatomic,strong)BankModel * model;
///金额
@property (nonatomic,weak)UITextField * money;
///备注
@property (nonatomic,weak)UITextField * Memo;
@end

@implementation TiXianController

+ (instancetype)create
{
    return [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"TiXianController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicStep];
}

- (void)basicStep
{
    self.btn.layer.cornerRadius = 3;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGB(246, 246, 246);
    self.navigationItem.title = @"提现";
    UIBarButtonItem * item = [[UIBarButtonItem alloc]initWithTitle:@"提现明细" style:UIBarButtonItemStylePlain target:self action:@selector(tixianDetail)];
    item.tintColor = RGB(71, 71, 71);
    self.navigationItem.rightBarButtonItem = item;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"first"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"first"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"请选择提现方式";
            cell.textLabel.textColor = FONT_LIGHTGRAY;
            self.label = cell.textLabel;
            return cell;
            break;
        }
        case 1:
        {
            TiXianOneCell * cell = [tableView dequeueReusableCellWithIdentifier:@"second"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TiXianOneCell" owner:nil options:nil].lastObject;
            }
            [cell refreshWithMoney:self.allMonry];
            return cell;
            break;
        }
        case 2:
        {
            ///金额
            TiXianTwoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"third"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TiXianTwoCell" owner:nil options:nil].lastObject;
            }
            self.money = cell.field;
            return cell;
            break;
        }
        default:
        {
            ///备注
            TiXianThreeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
            if (cell == nil) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TiXianThreeCell" owner:nil options:nil].lastObject;
            }
            self.Memo = cell.textField;
            return cell;
            break;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 1:
        {
            return 35;
            break;
        }
        case 3:
        {
            return 60;
            break;
        }
        default:
        {
            return 50;
            break;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TiXianTypeController * vc = [TiXianTypeController create];
        vc.delegate = self;
        if (self.model) {
            vc.Guid = self.model.Guid;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)TiXianTypeController:(TiXianTypeController *)vc withModel:(BankModel *)Model
{
    if (Model) {
        self.label.text = Model.BankName;
        self.label.textColor = FONT_BLACK;
        self.model = Model;
    }
    else
    {
        self.label.text = @"请选择提现方式";
        self.label.textColor = FONT_LIGHTGRAY;
        self.model = nil;
    }
}

#pragma mark - 提现明细
- (void)tixianDetail
{
    TiXianDetailController * vc = [[TiXianDetailController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)tixian:(id)sender {
    if ([self.label.text isEqualToString:@"请选择提现方式"]) {
        [MBProgressHUD showError:@"请选择提现方式"];
        return;
    }
    if ([self.money.text isEqualToString:@""]) {
        [MBProgressHUD showError:@"请输入金额"];
        return;
    }
//    if ([self.Memo.text isEqualToString:@""]) {
//        [MBProgressHUD showError:@"请输入备注"];
//        return;
//    }
    NSString * Memo = [self.Memo.text isEqualToString:@""] ? @"无" : self.Memo.text;
    NSDictionary * dict = @{
                            @"OperateMoney":self.money.text,
                            @"Bank":self.model.BankName,
                            @"TrueName":self.model.BankAccountName,
                            @"Account":self.model.BankAccountNumber,
                            @"MemLoginID":self.model.MemLoginID,
                            @"Memo":Memo
                            };
//    NSData * data =[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    [[AFAppAPIClient sharedClient]postPath:@"/api/AddAdvancePaymentApplyLog" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject - %@",responseObject);
        if ([responseObject objectForKey:@"HttpStatusCode"] != [NSNull null]) {
            NSInteger abc = [[responseObject objectForKey:@"HttpStatusCode"] integerValue];
            if (abc == 200) {
                [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"提现成功，请等待审核"];
            }
            else
            {
                [MBProgressHUD showError:@"提现失败"];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
    }];
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
