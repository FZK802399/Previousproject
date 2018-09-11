//
//  ModifyAddressTableViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 16/1/3.
//  Copyright (c) 2016年 WFS. All rights reserved.
//

#import "ModifyAddressTableViewController.h"
#import "FDTakeController.h"
#import "AddressModel.h"
#import "TSLocateView.h"
#import "NSString+GF.h"

@interface ModifyAddressTableViewController ()<FDTakeDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *postcodeTextField;
@property (weak, nonatomic) IBOutlet UITextField *IDCardTextField;
@property (weak, nonatomic) IBOutlet UITextField *eMail;


@property (weak, nonatomic) IBOutlet UIButton *frontButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (weak, nonatomic) IBOutlet UIButton *isDefaultButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@property (nonatomic,strong)NSString *provinceName;
@property (nonatomic,strong)NSString *cityName;
@property (nonatomic,strong)NSString *areaName;

@property (strong, nonatomic) FDTakeController *takeController;
@property (strong, nonatomic) AppConfig *config;

@end

@implementation ModifyAddressTableViewController
{
    BOOL isDefault;
    BOOL isFront;
    NSString *frontURL;
    NSString *backURL;
    NSString *regionCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.config = [AppConfig sharedAppConfig];
    [self.config loadConfig];
    
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // 编辑地址，则更新视图
    if (self.isEditAddress) {
        self.title = @"编辑地址";
        [self loadCodeDetail];
    } else {
        self.title = @"新增地址";
        isDefault = YES;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)loadCodeDetail
{
    ///通过code获取省市区
    NSString * str = [NSString stringWithFormat:@"api/GetAreaByCode/?code=%@",_currenAddressModel.addressCode];
    [[AFAppAPIClient sharedClient]getPath:str parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"Data"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = [responseObject objectForKey:@"Data"];
            NSString * AreaName = [dict objectForKey:@"AreaName"];
            NSString * CityName = [dict objectForKey:@"CityName"];
            NSString * ProvinceName = [dict objectForKey:@"ProvinceName"];
            NSString * Str = [NSString stringWithFormat:@"%@%@%@",ProvinceName,CityName,AreaName];
            
            NSLog(@"--------------------=====++++++======------------------%@%@%@",ProvinceName,CityName,AreaName);
            
            
            
            [self updateTableViewWithAreaName:Str];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)updateTableViewWithAreaName:(NSString *)Str
{
    self.addressLabel.text = Str;
    self.detailAddressTextField.text = [_currenAddressModel.address stringByReplacingOccurrencesOfString:Str withString:@""];
    self.nameTextField.text = _currenAddressModel.name;
    self.phoneTextField.text = _currenAddressModel.mobile;
    self.IDCardTextField.text = _currenAddressModel.IDCard;
    self.postcodeTextField.text = _currenAddressModel.postalcode;
    self.deleteButton.hidden = NO;
    self.eMail.text = _currenAddressModel.email;
    
    isDefault = _currenAddressModel.isDefault;
    frontURL = _currenAddressModel.IdCardFront;
    backURL = _currenAddressModel.IdCardVerso;
    regionCode = _currenAddressModel.addressCode;
    
    if (frontURL.length > 0) {
        NSURL *imageUrl;
        if (![frontURL hasPrefix:kWebMainBaseUrl]) {
            imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, _currenAddressModel.IdCardFront]];
        }
        else
        {
            imageUrl = [NSURL URLWithString:frontURL];
        }
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                UIImage *image = [UIImage imageWithData:data];
                [self.frontButton setImage:image forState:UIControlStateNormal];
        }];
    }
    if (backURL.length > 0) {
        NSURL *imageUrl;
        if (![backURL hasPrefix:kWebMainBaseUrl]) {
            imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, _currenAddressModel.IdCardVerso]];
        }
        else
        {
            imageUrl = [NSURL URLWithString:backURL];
        }
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imageUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            UIImage *image = [UIImage imageWithData:data];
            [self.backButton setImage:image forState:UIControlStateNormal];
        }];
    }
    
    if (isDefault) {
        [self.isDefaultButton setImage:[UIImage imageNamed:@"checkbox_on_new"] forState:UIControlStateNormal];
    } else {
        [self.isDefaultButton setImage:[UIImage imageNamed:@"checkbox_new"] forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 115;
    } else {
        return 40;
    }
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.row == 1) {
//        self.idCardCell = [tableView dequeueReusableCellWithIdentifier:kIdCardTableViewCellIdentifier];
//        return self.idCardCell;
//    } else {
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
//        return cell;
//    }
//}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    switch (row) {
        case 0:
            
            break;
        case 1:
            
            break;
        case 2:
            
            break;
        case 3: {
            [self.view endEditing:YES];
            TSLocateView *locateView = [[TSLocateView alloc] initWithTitle:@"选择城市" delegate:self];
            [locateView showInView:[UIApplication sharedApplication].keyWindow];
        }
            break;
        case 4:
            // 选择街道
            
            break;
        case 5:
            
            break;
        case 6:
            
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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

- (IBAction)chooseIsDefault:(UIButton *)sender {
    isDefault = !isDefault;
    if (isDefault) {
        [sender setImage:[UIImage imageNamed:@"checkbox_on_new"] forState:UIControlStateNormal];
    } else {
        [sender setImage:[UIImage imageNamed:@"checkbox_new"] forState:UIControlStateNormal];
    }
}

// 正面
- (IBAction)frontButtonPressed:(id)sender {
    isFront = YES;
    [self.takeController setAllowsEditingPhoto:YES];
    [self.takeController takePhotoOrChooseFromLibrary];
}

// 反面
- (IBAction)backButtonPressed:(id)sender {
    isFront = NO;
    [self.takeController setAllowsEditingPhoto:YES];
    [self.takeController takePhotoOrChooseFromLibrary];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    TSLocateView * loca = (TSLocateView *)actionSheet;
    if(buttonIndex == 0) {
        
    }else {
        self.addressLabel.textColor = [UIColor blackColor];
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@", loca.procinelocate.name, loca.citylocate.name ,loca.regionlocate.name];
        if (loca.regionlocate) {
            regionCode = [NSString stringWithFormat:@"%@",loca.regionlocate.code];
        }else {
            regionCode = [NSString stringWithFormat:@"%@",loca.citylocate.code];
        }
        //        NSLog(@"regionCode = %@",regionCode);
    }
}

#pragma mark - FDTakeDelegate


- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt {
    if (frontURL.length > 0) {
        if (![frontURL hasPrefix:kWebMainBaseUrl]) {
            [self.frontButton.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, frontURL]]];
        }
        else
        {
            [self.frontButton.imageView setImageWithURL:[NSURL URLWithString:frontURL]];
        }
        
    }
    if (backURL.length > 0) {
        if (![backURL hasPrefix:kWebMainBaseUrl]) {
            [self.backButton.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebMainBaseUrl, backURL]]];
        }
        else
        {
            [self.frontButton.imageView setImageWithURL:[NSURL URLWithString:backURL]];
        }
    }
}


- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    
    UIImage * img = info[UIImagePickerControllerOriginalImage];
    NSData * data;
    if (img.size.height < 800 && img.size.width < 800) {
        data = UIImageJPEGRepresentation(img, 1);
    }
    else
    {
        data = UIImageJPEGRepresentation(img, 0.5);
    }
    NSString * dataStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSDictionary * dict = @{
                            @"fileData":dataStr,
                            @"memloginID":self.config.loginName
                            };
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = @"上传中...";
    
    ZDXWeakSelf(weakSelf);
    [[AFAppAPIClient sharedClient2]postPath:@"api/uploadpic.ashx" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"上传图片 -- responseObject -- %@",responseObject);
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        if ([[responseObject objectForKey:@"tip"] isEqualToString:@"1"]) {
            NSString * picStr = [responseObject objectForKey:@"success"];
            if (isFront) {
                frontURL = picStr;
                [weakSelf.frontButton setImage:img forState:UIControlStateNormal];
            } else {
                backURL = picStr;
                [weakSelf.backButton setImage:img forState:UIControlStateNormal];
            }
        } else {
            [MBProgressHUD showError:@"上传图片失败"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络错误"];
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }];
}

- (IBAction)deleteAddress:(id)sender {
    
    if (self.isEditAddress) {
        NSDictionary *deleteDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   _currenAddressModel.guid,@"Guid",
                                   self.config.appSign, @"AppSign", nil];
        ZDXWeakSelf(weakSelf);
        [AddressModel deleteAddressWithParameters:deleteDic andblock:^(NSInteger result, NSError *error) {
            if (error) {
                [weakSelf showErrorWithMessage:@"网络错误"];
            }else{
                if (result == 202) {
                    [MBProgressHUD showSuccess:@"删除成功" toView:[UIApplication sharedApplication].keyWindow];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [weakSelf showErrorWithMessage:@"删除失败"];
                }
            }
        }];
    }
}


// 提交数据
- (IBAction)submit:(id)sender {
    
    if (allTrim(self.nameTextField.text).length == 0) {
        [self showErrorWithMessage:@"姓名不可为空"];
        return;
    }
    
    if (allTrim(self.nameTextField.text).length < 2) {
        [self showErrorWithMessage:@"姓名格式有误"];
        return;
    }
    
    if (allTrim(self.IDCardTextField.text).length == 0) {
        [self showErrorWithMessage:@"身份证号不可为空"];
        return;
    }
    if (![NSString isIDCard:allTrim(self.IDCardTextField.text)]) {
        [self showErrorWithMessage:@"身份证号码有误"];
        return;
    }    
    if (allTrim(self.phoneTextField.text).length == 0) {
        [self showErrorWithMessage:@"手机号不可为空"];
        return;
    }
    
    if (![NSString isMobileNumber:allTrim(self.phoneTextField.text)]) {
        [self showErrorWithMessage:@"手机号格式有误"];
        return;
    }
    
    if (allTrim(self.detailAddressTextField.text).length == 0) {
        [self showErrorWithMessage:@"详细地址不可为空"];
        return;
    }
    if (allTrim(self.postcodeTextField.text).length == 0) {
        [self showErrorWithMessage:@"邮编不可为空"];
        return;
    }
    
    if (allTrim(self.postcodeTextField.text).length != 6) {
        [self showErrorWithMessage:@"邮编格式有误"];
        return;
    }
    
//    if ([self.eMail.text rangeOfString:@"@"].location == NSNotFound) {
//        [self showErrorWithMessage:@"邮箱格式有误"];
//        return;
//    }
//    
    if (!(frontURL && frontURL.length > 0)) {
        [self showErrorWithMessage:@"请上传身份证正面照片"];
        return;
    }
    if (!(backURL && backURL.length > 0)) {
        [self showErrorWithMessage:@"请上传身份证反面照片"];
        return;
    }
    if (!(regionCode && regionCode.length > 0)) {
        [self showErrorWithMessage:@"请选择所在地区"];
        return;
    }
    
    // IsDefault   IdCardFront   IdCardVerso   9个参数 + appsign
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"AppSign"] = self.config.appSign;
    dict[@"MemLoginID"] = self.config.loginName;
    dict[@"NAME"] = allTrim(self.nameTextField.text);
    dict[@"Mobile"] = allTrim(self.phoneTextField.text);
    dict[@"Tel"] = @"";
    dict[@"Email"] = allTrim(self.eMail.text);
    dict[@"IDCard"] = allTrim(self.IDCardTextField.text);
    dict[@"Postalcode"] = allTrim(self.postcodeTextField.text);
    dict[@"IsDefault"] = @(isDefault);
    dict[@"IdCardFront"] = frontURL;
    dict[@"IdCardVerso"] = backURL;
    dict[@"Code"] = regionCode;
    dict[@"Address"] = [allTrim(self.addressLabel.text) stringByAppendingString:allTrim(self.detailAddressTextField.text)];
    
    
    dict[@"Province"] = self.provinceName;
    dict[@"City"] = self.cityName;
    dict[@"Area"] = self.areaName;

    
//    NSDictionary * addDic = [NSDictionary dictionaryWithObjectsAndKeys:
//                             self.config.appSign,@"AppSign",
//                             regionCode, @"Code",
//                             allTrim(self.nameTextField.text), @"NAME",
//                             @"",@"Email",
//                             allTrim(self.phoneTextField.text),@"Mobile",
//                             @"",@"Tel",
//                             self.config.loginName, @"MemLoginID",
//                             @"430079",@"Postalcode",
//                             [allTrim(self.addressLabel.text) stringByAppendingString:allTrim(self.addressLabel.text)],@"Address",nil];
    
    ZDXWeakSelf(weakSelf);    
    if (self.isEditAddress) {
        dict[@"Guid"] = _currenAddressModel.guid;
//        NSLog(@"GUID : %@", _currenAddressModel.guid);
        [AddressModel editAddressWithParameters:dict andblock:^(NSInteger result, NSError *error){
            if (error) {
                [weakSelf showErrorWithMessage:@"网络错误"];
            } else {
                if (result == 202) {
                    [MBProgressHUD showSuccess:@"修改成功" toView:[UIApplication sharedApplication].keyWindow];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [weakSelf showErrorWithMessage:@"修改失败"];
                }
            }
        }];
        
    } else {
        
        [AddressModel addAddressWithParameters:dict andlbock:^(NSInteger result, NSError *error) {
            if (error) {
                [weakSelf showErrorWithMessage:@"网络错误"];
            }else {
                if (result == 202) {
                    [MBProgressHUD showSuccess:@"添加成功" toView:[UIApplication sharedApplication].keyWindow];
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    [weakSelf showErrorWithMessage:@"添加失败"];
                }
            }
        }];
    }
    
    
    

}

- (void)showErrorWithMessage:(NSString *)message {
    [MBProgressHUD showError:message];
}

-(void)dealloc
{
//    NSLog(@"dealloc");
}
@end
