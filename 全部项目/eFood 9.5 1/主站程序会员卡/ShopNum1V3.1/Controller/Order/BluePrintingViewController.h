//
//  BluePrintingViewController.h
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-15.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "WFSViewController.h"

@interface BluePrintingViewController : WFSViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) UIImagePickerController * imagePickerController;
@property (strong, nonatomic) IBOutlet UIScrollView *allScrollView;
@property (strong, nonatomic) IBOutlet UIView *uploadImageView;

@property (strong, nonatomic) IBOutlet UITextField *titleTextfield;
@property (strong, nonatomic) IBOutlet UITextView *contextText;

@property (strong, nonatomic) IBOutlet UIButton *submitBtn;

@property (strong, nonatomic) IBOutlet UIButton *upload1;
@property (strong, nonatomic) IBOutlet UIButton *upload2;
@property (strong, nonatomic) IBOutlet UIButton *uplaod3;
@property (strong, nonatomic) IBOutlet UIButton *delete1;
@property (strong, nonatomic) IBOutlet UIButton *delete2;
@property (strong, nonatomic) IBOutlet UIButton *delete3;

@property (strong, nonatomic) NSString *orderNumber;
@property (strong, nonatomic) NSString *productGuid;

@property (nonatomic, strong) NSMutableArray * pickedPics;
@property (nonatomic, strong) NSMutableArray * upadatePicDatas;

- (IBAction)submitActionClick:(id)sender;
- (IBAction)deletePicAction:(id)sender;

@end
