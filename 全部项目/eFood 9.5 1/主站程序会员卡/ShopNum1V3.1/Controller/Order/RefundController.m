//
//  RefundController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "RefundController.h"
#import "OrderController.h"
#import "OrderListController.h"
#import "OrderCell.h"
#import "RefundCell.h"
#import "RefundCell2.h"
#import "RefundVIew.h"
@interface RefundController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *refundBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray * reasonArr;

@property (nonatomic,strong) NSIndexPath * indexPath;
///选择其他时的textView
@property (nonatomic,weak)UITextView * textView;

@end

@implementation RefundController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(show:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self basicStep];
}

-(void)basicStep
{
    self.navigationItem.title = @"退款";
    self.refundBtn.layer.borderColor = LINE_DARKGRAY.CGColor;
    self.refundBtn.layer.borderWidth = 1;
    
    RefundVIew * view = [[[NSBundle mainBundle]loadNibNamed:@"RefundView" owner:nil options:nil] lastObject];
    view.frame = CGRectMake(0, 0, LZScreenWidth, 535);
    view.price.text = [NSString stringWithFormat:@"%.2f 元",self.model.AlreadPayPrice+self.model.SurplusPrice];
    view.reasonTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    view.reasonTable.scrollEnabled = NO;
    view.reasonTable.delegate = self;
    view.reasonTable.dataSource = self;
    self.tableView.tableFooterView = view;
    
    self.reasonArr = @[@"买多了／买错了",@"计划有变，没时间消费",@"预约不上",@"去过了，不太满意",@"朋友／网上评价不好",@"后悔了，不想买了"];
    
    ///加了就不能选择了
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirst)];
//    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return self.model.ProductList.count;
    }
    else
    {
        return 7;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        OrderCell * cell = [[NSBundle mainBundle]loadNibNamed:@"OrderCell" owner:nil options:nil].firstObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        OrderMerchandiseIntroModel * model = self.model.ProductList[indexPath.row];
        cell.model = model;
        return cell;
    }
    else
    {
        if (indexPath.row == 6) {
            RefundCell2 * cell = [[[NSBundle mainBundle]loadNibNamed:@"RefundCell2" owner:nil options:nil]lastObject];
            self.textView = cell.textView;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.indexPath.row == 6 ) {
                cell.btn.selected = YES;
            }
            else
            {
                cell.btn.selected = NO;
            }
            cell.textView.delegate = self;
            return cell;
        }
        else
        {
            RefundCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"RefundCell" owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.indexPath.row == indexPath.row) {
                cell.btn.selected = YES;
            }
            else
            {
                cell.btn.selected = NO;
            }
            cell.reason.text = self.reasonArr[indexPath.row];
            return cell;
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return 96;
    }
    else
    {
        if (indexPath.row == 6) {
            return 100;
        }
        else
        {
            return 45;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        return;
    }
    else
    {
        self.indexPath = indexPath;
        if (indexPath.row == 6) {
            RefundCell2 * cell = (RefundCell2 *)[tableView cellForRowAtIndexPath:indexPath];
            cell.btn.selected = !cell.btn.selected;
            [tableView reloadData];
        }
        else
        {
            RefundCell * cell = (RefundCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell.btn.selected = !cell.btn.selected;
            [tableView reloadData];
        }
    }
}

#pragma mark - textViewDelegate

- (void)resignFirst
{
    [self.textView resignFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 键盘处理
- (void)show:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    CGPoint center = self.view.center;
    center.y -= keyboardSize.height;
    [UIView transitionWithView:self.view duration:1.0f options:UIViewAnimationOptionTransitionNone/*特效*/ animations:^{
        self.view.center = center;
    } completion:nil];
}

- (void)hide:(NSNotification *)aNotification {
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [aValue CGRectValue].size;
    
    [UIView transitionWithView:self.view duration:1.0f options:UIViewAnimationOptionTransitionNone animations:^{
        CGPoint center = self.view.center;
        center.y += keyboardSize.height;
        self.view.center = center;
        
    } completion:nil];
}

#pragma mark - 提交
- (IBAction)submit:(id)sender {
    NSString *ApplyReason;
    if (self.indexPath.row == 6) {
        if ([self.textView.text isEqualToString:@""]) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入理由" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
            [MBProgressHUD showError:@"请输入理由"];
            return;
        } else {
            
            ApplyReason = self.textView.text;
        }
    } else {
        ApplyReason = self.reasonArr[self.indexPath.row];
    }
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    NSDictionary * dict = @{
                            @"OrderID":self.model.OrderNumber,
                            @"MemLoginID":config.loginName,
                            @"ApplyReason":ApplyReason,
                            @"ReturnMoney":@(self.model.AlreadPayPrice+self.model.SurplusPrice),
                            @"AppSign":config.appSign
                            };
        NSLog(@"url - %@/api/memberepairs/",kWebAppBaseUrl);
//    NSData * data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
//    NSString * str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"str - %@",str);
    [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/html", nil]];
    [AFAppAPIClient sharedClient].parameterEncoding = AFJSONParameterEncoding;
    [[AFAppAPIClient sharedClient]postPath:@"/api/memberepairs/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"return"] integerValue] == 202) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"申请退款成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
            [self showSuccessMesaageInWindow:@"申请退款成功"];
            
            for (id viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[OrderListController class]]) {
                    if ([viewController respondsToSelector:@selector(operationEndWithController:)]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                        [viewController operationEndWithController:self];
                    }
                }
            }
        } else {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"申请退款失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
            [self showErrorMessage:@"申请退款失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (error) {
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"申请退款失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//            [alert show];
            [self showErrorMessage:@"网络错误"];
        }
    }];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
