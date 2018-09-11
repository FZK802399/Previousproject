//
//  CommentController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/11/26.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "CommentController.h"
#import "OrderCell.h"
#import "OrderController.h"
#import "OrderListController.h"
#import "AFAppAPIClient.h"
#import "CommentView.h"
@interface CommentController ()<UITextViewDelegate,CommentDelegate>
@property (nonatomic,strong)NSMutableArray * textArr;
@property (nonatomic,strong)NSMutableArray * starArr;
@end

@implementation CommentController

-(NSMutableArray *)starArr
{
    if (_starArr == nil) {
        _starArr = [NSMutableArray array];
    }
    return _starArr;
}

-(NSMutableArray *)textArr
{
    if (_textArr == nil) {
        _textArr = [NSMutableArray array];
    }
    return _textArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"评价";
    self.tableView.rowHeight = 96;
    self.tableView.backgroundColor = BACKGROUND_GRAY;
    NSUInteger n = self.model.ProductList.count;
    for (int i = 0; i < n; i++) {
        [self.textArr addObject:@"内容在 5 - 200个字之间"];
        [self.starArr addObject:@0];
    }
    [self setTableFootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setTableFootView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 150)];
    view.backgroundColor = BACKGROUND_GRAY;
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(LZScreenWidth - 90, 10, 80, 35);
    [btn setBackgroundColor:MYRED];
    [btn setTitle:@"提交" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    btn.layer.cornerRadius = 3;
    [view addSubview:btn];
    [btn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = view;
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.model.ProductList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderCell * cell = [[NSBundle mainBundle]loadNibNamed:@"OrderCell" owner:nil options:nil].firstObject;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OrderMerchandiseIntroModel * model = self.model.ProductList[indexPath.section];
    cell.model = model;
    return cell;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 11;
}

- (CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 135;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    CommentView * view = [[NSBundle mainBundle]loadNibNamed:@"CommentView" owner:nil options:nil].lastObject;
    [view setArr];
    view.tag = section;
    view.delegate = self;
    view.textView.delegate = self;
    view.textView.tag = section;
    view.textView.text = self.textArr[section];
    for (int i = 0; i < [self.starArr[section] integerValue]; i++) {
        UIButton * btn = view.startArr[i];
        btn.selected = YES;
    }
    return view;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = FONT_BLACK;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.textArr[textView.tag] = textView.text;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return YES;
    }
    return YES;
}

#pragma mark - 提交
-(void)submit
{
    [self.view endEditing:YES];
    for (NSString * text in self.textArr) {
        if ([text isEqualToString:@"内容在 5 - 200个字之间"]||[text isEqualToString:@""]) {
            [self showMessageWithStr:@"请填写内容"];
            return;
        }
    }
    for (NSNumber * num in self.starArr) {
        if (num.integerValue == 0) {
            [self showMessageWithStr:@"请选择星级"];
            return;
        }
    }
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    for (NSString * text in self.textArr) {
        NSInteger i = [self.textArr indexOfObject:text];
        OrderMerchandiseIntroModel * model = self.model.ProductList[i];
        NSDictionary * dict = @{
                                @"MemLoginID":config.loginName,
                                @"ProductGuid":model.ProductGuid,
                                @"Rank":self.starArr[i],
                                @"Content":text,
                                @"AppSign":config.appSign,
                                @"OrderNumber":model.orderNum
                                };
        [[AFAppAPIClient sharedClient]postPath:@"api/addProductComment/" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (i == self.textArr.count -1) {
                NSLog(@"responseObject - %@",responseObject);
                if ([[responseObject objectForKey:@"return"]integerValue] == 202) {
                    for (id viewController in self.navigationController.viewControllers) {
                        if ([viewController isKindOfClass:[OrderListController class]]) {
                            [self.navigationController popToViewController:viewController animated:YES];
                            if ([viewController respondsToSelector:@selector(operationEndWithController:)]) {
                                [viewController operationEndWithController:self];
                            }
                            [self showMessageWithStr:@"评价成功"];
                        }
                    }
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
    }
}

-(void)startClickWithStart:(UIButton *)start CommentView:(CommentView *)view
{
    BOOL isSelect = NO;
    for (UIButton * btn in view.startArr) {
        if (isSelect == NO) {
            btn.selected = YES;
            if ([btn isEqual:start]) {
                isSelect = YES;
            }
        }
        else
        {
            btn.selected = NO;
        }
        
    }
    self.starArr[view.tag] = @([view.startArr indexOfObject:start]+1);
    NSLog(@"%@",self.starArr[view.tag]);
}

-(void)showMessageWithStr:(NSString *)str
{
    [MBProgressHUD showMessage:str hideAfterTime:1.0f];
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
}
@end
