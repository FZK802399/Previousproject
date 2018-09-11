//
//  RefundGoodController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/12/1.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "RefundGoodController.h"
#import "ReturnMerchandiseModel.h"
#import "OrderController.h"
#import "OrderListController.h"
#import "RefundGoodView.h"
#import "RefundCell2.h"
#import "RefundCell.h"
#import "RefundOrderCell.h"
#import "OrderCell.h"
@interface RefundGoodController ()<RefundGoodDelegate>
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray * reasonArr;

@property (nonatomic,strong) NSIndexPath * indexPath;
///选择其他时的textView
@property (nonatomic,weak)UITextView * textView;
@end

@implementation RefundGoodController

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
    self.navigationItem.title = @"退货";
    self.refundBtn.layer.borderColor = LINE_DARKGRAY.CGColor;
    self.refundBtn.layer.borderWidth = 1;
    
//    RefundGoodView * view = [[[NSBundle mainBundle]loadNibNamed:@"RefundGoodView" owner:nil options:nil] lastObject];
//    view.reasonTable.rowHeight = 45;
////    view.frame = CGRectMake(0, 0, LZScreenWidth, 355);
//    view.reasonTable.tag = 2;
//    view.reasonTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    view.reasonTable.scrollEnabled = NO;
//    view.reasonTable.delegate = self;
//    view.reasonTable.dataSource = self;
//    self.tableView.tableFooterView = view;
    RefundGoodView * view = [[RefundGoodView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 355) delegate:self];
    self.tableView.tableFooterView = view;
    self.reasonArr = @[@"买多了／买错了",@"朋友／网上评价不好",@"后悔了，不想买了"];
    
    ///加了就不能选择了
    //    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignFirst)];
    //    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return self.model.ProductList.count;
    }
    else
    {
        return 4;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        RefundOrderCell * cell = [[NSBundle mainBundle]loadNibNamed:@"RefundOrderCell" owner:nil options:nil].firstObject;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        OrderMerchandiseIntroModel * model = self.model.ProductList[indexPath.row];
        cell.model = model;
        return cell;
    }
    else
    {
        if (indexPath.row == 3) {
            RefundCell2 * cell = [[[NSBundle mainBundle]loadNibNamed:@"RefundCell2" owner:nil options:nil]lastObject];
            self.textView = cell.textView;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.indexPath.row == 3 ) {
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
        if (indexPath.row == 3) {
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
        OrderMerchandiseIntroModel * model = self.model.ProductList[indexPath.row];
        model.isSelect = !model.isSelect;
        [self.tableView reloadData];
    }
    else
    {
        self.indexPath = indexPath;
        if (indexPath.row == 3) {
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

- (IBAction)ok:(id)sender {
    [self.view endEditing:YES];
    if (self.indexPath.row == 3) {
        if ([self.textView.text isEqualToString:@""]) {
            [self showMessageWithStr:@"请输入退货理由"];
            return;
        }
    }
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    
    NSMutableArray * submitReturnProductArray = [[NSMutableArray alloc] initWithCapacity:0];
    BOOL isHaveProduct = false;
    
    for (ReturnMerchandiseModel * submitModel in self.model.ReturnProductList) {
        NSInteger i = [self.model.ReturnProductList indexOfObject:submitModel];
        OrderMerchandiseIntroModel * model = self.model.ProductList[i];
        if (model.isSelect) {
            isHaveProduct = true;
            NSMutableDictionary *merchandiseParameters = [[NSMutableDictionary alloc] init];
            [merchandiseParameters setObject:submitModel.Attributes forKey:@"Attributes"];
            ///注意这里用的model和别的model不一样
            [merchandiseParameters setObject:[NSNumber numberWithInteger:model.refundNum] forKey:@"ReturnCount"];
            ///这里的退款金额 不包括 积分所抵
            [merchandiseParameters setObject:[NSNumber numberWithFloat:model.BuyPrice] forKey:@"BuyPrice"];
//            [merchandiseParameters setObject:[NSNumber numberWithFloat:self.model.AlreadPayPrice+self.model.SurplusPrice] forKey:@"BuyPrice"];
            NSLog(@"price %@",merchandiseParameters[@"BuyPrice"]);

            
            [merchandiseParameters setObject:submitModel.OrderGuid forKey:@"OrderGuid"];
            [merchandiseParameters setObject:submitModel.ProductImgStr forKey:@"ProductImage"];
            [merchandiseParameters setObject:submitModel.ProductGuid forKey:@"ProductGuid"];
            [merchandiseParameters setObject:[NSNumber numberWithInteger:1] forKey:@"OrderType"];
            
            [submitReturnProductArray addObject:merchandiseParameters];
        }
        
    }
    
    if (!isHaveProduct) {
        [self showMessageWithStr:@"请选择要退货的商品"];
        return;
    }
    
    
    NSMutableDictionary *returnParameters = [[NSMutableDictionary alloc] init];
    [returnParameters setObject:config.appSign forKey:@"AppSign"];
    [returnParameters setObject:self.model.Guid forKey:@"OrderGuid"];
    [returnParameters setObject:config.loginName forKey:@"ApplyUserID"];
    [returnParameters setObject:config.loginName forKey:@"OperateUserID"];
    [returnParameters setObject:[NSNumber numberWithInteger:0] forKey:@"OrderStatus"];
    if (self.indexPath.row == 3) {
        [returnParameters setObject:self.textView.text forKey:@"ReturnGoodsCause"];
    }
    else
    {
        [returnParameters setObject:self.reasonArr[_indexPath.row] forKey:@"ReturnGoodsCause"];
    }
    
    [returnParameters setObject:submitReturnProductArray forKey:@"GoodSList"];
    
    MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [OrderDetailModel AddReturnOrderWithParameters:returnParameters andblock:^(NSInteger result, NSError *error) {
        [progress hide:YES];
        if (result == 202) {
            for (id viewController in self.navigationController.viewControllers) {
                if ([viewController isKindOfClass:[OrderListController class]]) {
                    if ([viewController respondsToSelector:@selector(operationEndWithController:)]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                        [viewController operationEndWithController:self];
                    }
                    [self showMessageWithStr:@"申请退货成功"];
                }
            }

        }
        else
        {
            [self showMessageWithStr:@"申请退货失败"];
        }
        if (error) {
            [self showMessageWithStr:@"申请退货失败"];
        }
    }];
}

-(void)goodsReduceOrAddWithModel:(OrderMerchandiseIntroModel *)model addCell:(RefundOrderCell *)cell andBtn:(UIButton *)btn
{
    if (btn.tag == 1) {
        if (model.refundNum > 1) {
            model.refundNum --;
            [self.tableView reloadData];
        }
        else
        {
            [self showMessageWithStr:@"不能少于1"];
        }
    }
    else
    {
        if (model.refundNum < model.BuyNumber) {
            model.refundNum ++;
            [self.tableView reloadData];
        }
        else
        {
            [self showMessageWithStr:@"不能大于购买数量"];
        }
    }
}

- (IBAction)no:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showMessageWithStr:(NSString *)str
{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    
    [self showMessage:str];
}
@end
