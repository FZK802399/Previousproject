//
//  TiXianUpdataTypeController.m
//  ShopNum1V3.1
//
//  Created by yons on 16/3/9.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "TiXianUpdataTypeController.h"

@interface TiXianUpdataTypeController ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *bankName;
@property (weak, nonatomic) IBOutlet UITextField *num;

@end

@implementation TiXianUpdataTypeController

+ (instancetype)create
{
    return [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"TiXianUpdataTypeController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帐户管理";
    self.tableView.backgroundColor = BACKGROUND_GRAY;
    self.name.text = self.model.BankAccountName;
    self.bankName.text = self.model.BankName;
    self.num.text = self.model.BankAccountNumber;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 2) {
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
    if (section == 2) {
        return 0;
    }
    else
    {
        return 12;
    }
}

- (IBAction)deleClick:(id)sender {
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除该银行账户？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary * dict = @{
                                @"Guid":self.model.Guid
                                };
        [[AFAppAPIClient sharedClient]postPath:@"/api/DeleteMemberBankAccount/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([responseObject objectForKey:@"HttpStatusCode"] != [NSNull null]) {
                NSInteger abc = [[responseObject objectForKey:@"HttpStatusCode"] integerValue];
                if (abc == 200) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [MBProgressHUD showSuccess:@"删除成功"];
                }
                else
                {
                    [MBProgressHUD showError:@"删除失败"];
                }
            }
            else
            {
                [MBProgressHUD showError:@"删除失败"];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD showError:@"网络错误"];
        }];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
