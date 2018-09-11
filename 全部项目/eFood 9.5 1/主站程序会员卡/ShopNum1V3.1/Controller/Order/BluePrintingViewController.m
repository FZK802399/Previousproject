//
//  BluePrintingViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-9-15.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "BluePrintingViewController.h"
#import "BluePrintingModel.h"

@interface BluePrintingViewController ()

@end

@implementation BluePrintingViewController{

    __weak IBOutlet NSLayoutConstraint *constraint;
    NSInteger btnTag;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (NSMutableArray *)pickedPics {
    if (!_pickedPics) {
        _pickedPics = [NSMutableArray array];
    }
    
    return _pickedPics;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLeftBackBtn];

    self.titleTextfield.layer.borderWidth = 1;
    self.titleTextfield.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.contextText.layer.borderWidth = 1;
    self.contextText.layer.borderColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1].CGColor;
    
    self.submitBtn.clipsToBounds = YES;
    self.submitBtn.layer.cornerRadius = 3.0f;
    constraint.constant = SCREEN_HEIGHT - 64;
    
//    self.allScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - 64);
//    self.allScrollView.scrollEnabled = YES;
    
//    [self registerForKeyboardNotifications];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    
    [[NSNotificationCenter defaultCenter] addObserverForName:WFSUploadDidEndNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        id object = note.object;
        [self.pickedPics addObject:object];
        if ([self.pickedPics count] == [self.upadatePicDatas count]) {
            
            NSString *imagePath;
            for (int i = 0; i< self.pickedPics.count; i++) {
                if (i==0) {
                    imagePath = [self.pickedPics objectAtIndex:i];
                }else {
                    imagePath=[imagePath stringByAppendingString:[NSString stringWithFormat:@"|%@", [self.pickedPics objectAtIndex:i]]];
                }
            }
            
            NSDictionary *submitDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       kWebAppSign,@"AppSign",
                                       self.appConfig.loginName,@"MemLoginID",
                                       _productGuid,@"ProductGuid",
                                       _orderNumber,@"OrderNumber",
                                       self.appConfig.loginName,@"Name",
                                       allTrim(self.titleTextfield.text),@"Title",
                                       allTrim(self.contextText.text),@"Content",
                                       imagePath,@"Image",nil];
            [BluePrintingModel addBluePrintingByParameters:submitDic andblock:^(NSInteger result, NSError *error) {
                if (error) {
                    
                }else {
                    if (result == 202) {
                        [self showAlertWithMessage:@"晒单成功"];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                }
            }];
        }
    }];
    // Do any additional setup after loading the view.
}

- (void)resignKeyboard {
    [self.titleTextfield resignFirstResponder];
    [self.contextText resignFirstResponder];
}


//注册键盘监听
- (void)registerForKeyboardNotifications{
    // keyboard notification
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        float animationTime = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        NSValue *rectValue = [note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [rectValue CGRectValue];
        
        float instance= self.allScrollView.frame.origin.y + self.allScrollView.frame.size.height + keyboardFrame.size.height - SCREEN_HEIGHT -  200;
        
        if (kCurrentSystemVersion < 7.0) {
            instance += 64;
        }
        if (instance > 0) {
            [UIView animateWithDuration:animationTime animations:^{
                CGFloat OriginY  = 0;
                OriginY = [self MatchIOS7:OriginY];
                self.allScrollView.frame = CGRectMake(0, OriginY-instance, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height);
            }];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillChangeFrameNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        float animationTime = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        NSValue *rectValue = [note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [rectValue CGRectValue];
        
        float instance= self.allScrollView.frame.origin.y + self.allScrollView.frame.size.height + keyboardFrame.size.height - SCREEN_HEIGHT -  200;
        
        if (kCurrentSystemVersion < 7.0) {
            instance += 64;
        }
        if (instance > 0) {
            [UIView animateWithDuration:animationTime animations:^{
                CGFloat OriginY  = 0;
                OriginY = [self MatchIOS7:OriginY];
                self.allScrollView.frame = CGRectMake(0, OriginY-instance, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height);
            }];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        
        float animationTime = [[note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
        
        [UIView animateWithDuration:animationTime animations:^{
            CGFloat OriginY  = 0;
            OriginY = [self MatchIOS7:OriginY];
            self.allScrollView.frame = CGRectMake(0, OriginY, self.allScrollView.frame.size.width, self.allScrollView.frame.size.height);
        }];
    }];
    
}



- (IBAction)submitActionClick:(id)sender {
    if (allTrim(self.titleTextfield.text).length == 0) {
        [self showAlertWithMessage:@"请输入标题内容"];
        return;
    }
    
    if (allTrim(self.contextText.text).length == 0) {
        [self showAlertWithMessage:@"请输入标题内容"];
        return;
    }
    
    
    _upadatePicDatas = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 1001; i<=1003; i++) {
        UIButton * btn = (UIButton*)[self.view viewWithTag:i];
        if (![UIImagePNGRepresentation([btn backgroundImageForState:UIControlStateNormal])isEqual:UIImagePNGRepresentation([UIImage imageNamed:@"btn_addpic_bg.png"])]) {
            UIImage *image= [btn backgroundImageForState:UIControlStateNormal];
            NSData *imageData = UIImageJPEGRepresentation(image,1);
            NSData *uploadData = imageData;
            NSUInteger dateLength = imageData.length;
            NSUInteger maxDataLength = 500000;
            if (dateLength > maxDataLength) {
                float compressRate = maxDataLength * 1.0 / dateLength;
                NSData *newImageData = UIImageJPEGRepresentation(image, compressRate);
                uploadData = newImageData;
            }
            [_upadatePicDatas addObject:uploadData];
        }
    }
    
    
    [BluePrintingModel uploadData:_upadatePicDatas withNameID:self.appConfig.loginName];
    
}

- (IBAction)deletePicAction:(UIButton *)sender {
    
    UIButton * Btn = (UIButton *)[self.view viewWithTag:sender.tag - 1000];
    [Btn setBackgroundImage:[UIImage imageNamed:@"btn_addpic_bg.png"] forState:UIControlStateNormal];
    [sender setHidden:YES];
    
}

- (UIImagePickerController *)imagePickerController {
    if (nil == _imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
    }
    
    return _imagePickerController;
}


- (IBAction)uploadDidTapped:(UIButton *)sender {
    btnTag = sender.tag;
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取", @"拍照", nil];
    [as showInView:self.view];
}

- (void)showImagePicker {
    UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取", @"拍照", nil];
    [as showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (0 == buttonIndex) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self  presentViewController:self.imagePickerController animated:YES completion:nil];
        
    } else if (1 == buttonIndex) {
        
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        [self  presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    // 拍照后存储照片
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self,
                                       @selector(image:didFinishSavingWithError:contextInfo:),
                                       nil);
    }
    
    
    UIButton *btn = (UIButton *)[self.view viewWithTag:btnTag];
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    
    UIButton * delBtn = (UIButton *)[self.view viewWithTag:btnTag + 1000];
    [delBtn setHidden:NO];
    
    // 压缩图片控制在500k以内
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //
    //        NSData *imageData = UIImageJPEGRepresentation(image, 1);
    //        NSData *uploadData = imageData;
    //        NSUInteger dateLength = imageData.length;
    //        NSUInteger maxDataLength = 500000;
    //        if (dateLength > maxDataLength) {
    //            float compressRate = maxDataLength * 1.0 / dateLength;
    //            NSData *newImageData = UIImageJPEGRepresentation(image, compressRate);
    //            uploadData = newImageData;
    //        }
    //
    //
    //
    //
    //        [BluePrintingModel uploadData:uploadData withNameID:self.workDetail.guid];
    //
    //        // 重绘图
    //        CGSize newSize = CGSizeMake(60, 60);
    //        UIGraphicsBeginImageContext(newSize);
    //        // Tell the old image to draw in this new context, with the desired
    //        // new size
    //        [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    //        // Get the new image from the context
    //        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    //        // End the context
    //        UIGraphicsEndImageContext();
    //
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            // 调整按钮尺寸让图片不变形
    //            UIButton *btn = (UIButton *)[self.controls lastObject];
    //            CGRect frame = btn.frame;
    //            frame.size.width = frame.size.height * newSize.width / newSize.height;
    //            btn.frame = frame;
    //
    //            [btn setBackgroundImage:newImage forState:UIControlStateNormal];
    //        });
    //    });
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // Handle the end of the image write process
    if (error)
        NSLog(@"Error writing to photo album: %@", [error localizedDescription]);
}

@end
