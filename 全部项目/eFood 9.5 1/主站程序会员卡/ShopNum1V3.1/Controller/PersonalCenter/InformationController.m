//
//  InformationController.m
//  OnlineShop
//
//  Created by yons on 15/8/25.
//  Copyright (c) 2015年 m. All rights reserved.
//

#import "InformationController.h"
#import "NameViewController.h"

@interface InformationController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@end

@implementation InformationController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    self.name.text = [config.RealName isEqualToString:@""] ? self.mobile : config.RealName;
    self.phone.text = self.mobile;
    NSURL * url = [NSURL URLWithString:config.userUrlStr];
    [self.imgView setImageWithURL:url];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人信息";

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LZScreenWidth, 50)];
    view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
    self.tableView.tableFooterView = view;
    self.tableView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1];
}



#pragma mark - Table view data source

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    switch (section) {
//        case 0:
//            return 0;
//            break;
//        default:
//            return 18;
//            break;
//    }
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:@"请选择相片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"相册", nil];
                [sheet showInView:self.view];
            }
            if (indexPath.row == 1) {
                NameViewController * vc = [[UIStoryboard storyboardWithName:@"Center" bundle:nil]instantiateViewControllerWithIdentifier:@"NameViewController"];
                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:vc action:@selector(popViewControllerAnimated:)];
                [self.navigationController pushViewController:vc animated:YES];

            }
            NSLog(@"section - 1");
            break;
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    AppConfig * config = [AppConfig sharedAppConfig];
    [config loadConfig];
    UIImage * img = info[UIImagePickerControllerOriginalImage];
    self.imgView.image = img;
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
                            @"memloginID":config.loginName
                            };
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.labelText = @"上传中...";
    [[AFAppAPIClient sharedClient2]postPath:@"api/uploadpic.ashx" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"上传图片 -- responseObject -- %@",responseObject);
        if ([[responseObject objectForKey:@"tip"] isEqualToString:@"1"]) {
            NSString * picStr = [responseObject objectForKey:@"success"];
            
            NSDictionary * dd = @{
                                  @"AppSign":config.appSign,
                                  @"MemLoginID":config.loginName,
                                  @"Photo":picStr
                                  };
            [[AFAppAPIClient sharedClient]getPath:@"api/updatephoto" parameters:dd success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"更新图片 -- responseObject -- %@",responseObject);
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
                NSInteger result = [[responseObject objectForKey:@"return"] integerValue];
                if (result == 200) {
                    NSString * photoStr = [NSString stringWithFormat:@"%@%@",kWebMainBaseUrl,picStr];
                    config.userUrlStr = photoStr;
                    [config saveConfig];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [self showMessageWithStr:@"更改头像成功"];
                }
                else
                {
                    [self showMessageWithStr:@"上传图片失败"];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
            }];
        }
        else
        {
            [self showMessageWithStr:@"上传图片失败"];
            [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    switch (buttonIndex) {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
            } else {
                [self showMessageWithStr:@"相机不可用"];
            }
            break;
        }
        case 1:
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            break;
        }
        default:
        {
            return;
        }
    }
}

-(void)showMessageWithStr:(NSString *)str
{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"提示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alert show];
    [MBProgressHUD showMessage:str hideAfterTime:1.0f];
}
@end
