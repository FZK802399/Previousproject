//
//  UICityPicker.m
//  DDMates
//
//  Created by ShawnMa on 12/16/11.
//  Copyright (c) 2011 TelenavSoftware, Inc. All rights reserved.
//

#import "TSLocateView.h"

#define kDuration 0.3

@implementation TSLocateView

@synthesize titleLabel;
@synthesize locationPicker;
@synthesize procinelocate;
@synthesize citylocate;
@synthesize regionlocate;

- (id)initWithTitle:(NSString *)title delegate:(id /*<UIActionSheetDelegate>*/)delegate
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TSLocateView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.titleLabel.text = title;
        self.locationPicker.dataSource = self;
        self.locationPicker.delegate = self;
        self.appConfig = [AppConfig sharedAppConfig];
        
        //加载数据
        [self loadLocationProvincesData];
        
    }
    return self;
}

- (void)showInView:(UIView *) view
{
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromTop;
    [self setAlpha:1.0f];
    [self.layer addAnimation:animation forKey:@"DDLocateView"];
    
    self.frame = CGRectMake(0, view.frame.size.height - 260, view.frame.size.width, 260);
    NSLog(@"Frame : %@", NSStringFromCGRect(self.frame));
    [view addSubview:self];
}

-(void)loadLocationDataWithFatherId:(NSString *)fatherid andcompoent:(NSInteger) compoent{
    
    NSDictionary * locDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             fatherid,@"parentId",
                             kWebAppSign, @"AppSign", nil];
    [RegionModel getRegionListByParameters:locDic andblock:^(NSArray *regionList, NSError *error) {
        if (error) {
            
        }else {
            if (regionList) {
                switch (compoent) {
                    case 0:
                        self.provinces = [NSArray arrayWithArray:regionList];
                        break;
                    case 1:
                        self.citys = [NSArray arrayWithArray:regionList];
                        break;
                    case 2:
                        self.regions = [NSArray arrayWithArray:regionList];
                        self.regionlocate = [self.regions objectAtIndex:0];
                        break;
                    default:
                        break;
                }
                [self.locationPicker selectRow:0 inComponent:compoent animated:NO];
                [self.locationPicker reloadComponent:compoent];
            }
        }
    }];
}


-(void)loadLocationProvincesData {
    NSDictionary * locDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"0",@"parentId",
                             kWebAppSign, @"AppSign", nil];
    [RegionModel getRegionListByParameters:locDic andblock:^(NSArray *regionList, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请求失败请重试"
                                                               delegate:self
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            return ;
        }else {
            if (regionList) {
                self.provinces = [NSArray arrayWithArray:regionList];
                [self.locationPicker selectRow:0 inComponent:0 animated:NO];
                [self.locationPicker reloadComponent:0];
                self.procinelocate = [self.provinces objectAtIndex:0];                
                [self loadLocationCitysDataWithFatherid:[NSString stringWithFormat:@"%d",[[_provinces objectAtIndex:0] ownID]]];
            }
        }
    }];
}

-(void)loadLocationCitysDataWithFatherid:(NSString *)fatherid{
    NSDictionary * locDic = [NSDictionary dictionaryWithObjectsAndKeys:
                             fatherid,@"parentId",
                             kWebAppSign, @"AppSign", nil];
    [RegionModel getRegionListByParameters:locDic andblock:^(NSArray *regionList, NSError *error) {
        if (error) {
            
        }else {
            if (regionList) {
                self.citys = [NSArray arrayWithArray:regionList];
                [self.locationPicker selectRow:0 inComponent:1 animated:NO];
                [self.locationPicker reloadComponent:1];
                self.citylocate = [self.citys objectAtIndex:0];
                
                [self loadLocationDataWithFatherId:[NSString stringWithFormat:@"%d",[[_citys objectAtIndex:0] ownID]]  andcompoent:2];
            }
        }
    }];
}





#pragma mark - PickerView lifecycle

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return [_provinces count];
            break;
        case 1:
            return [_citys count];
            break;
        case 2:
            return [_regions count];
            break;
        default:
            return 0;
            break;
    }
}
//
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    switch (component) {
//        case 0:
//            return [[_provinces objectAtIndex:row] name];
//            break;
//        case 1:
//            return [[_citys objectAtIndex:row] name];;
//            break;
//        case 2:
//            return [[_regions objectAtIndex:row] name];
//            break;
//        default:
//            return nil;
//            break;
//    }
//}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString * namestr;
    switch (component) {
        case 0:
            namestr = [[_provinces objectAtIndex:row] name];
            
            break;
        case 1:
            namestr = [[_citys objectAtIndex:row] name];
            
            break;
        case 2:
            namestr = [[_regions objectAtIndex:row] name];
            
            break;
        default:
            return nil;
            break;
    }
    
    NSMutableAttributedString * titlestr = [[NSMutableAttributedString alloc] initWithString:namestr];
    NSRange strrange = {0 , namestr.length};
    [titlestr addAttribute:NSFontAttributeName value:[UIFont workDetailFont] range:strrange];
    return titlestr;
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            self.procinelocate = [self.provinces objectAtIndex:row];
            [self loadLocationCitysDataWithFatherid:[NSString stringWithFormat:@"%d",[[_provinces objectAtIndex:row] ownID]]];
            break;
        case 1:
            self.citylocate = [self.citys objectAtIndex:row];
            [self loadLocationDataWithFatherId:[NSString stringWithFormat:@"%d",[[_citys objectAtIndex:row] ownID]]  andcompoent:2];
            break;
        case 2:
            self.regionlocate = [self.regions objectAtIndex:row];
            break;
        default:
            break;
    }
    
}



#pragma mark - Button lifecycle

- (IBAction)cancel:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:0];
    }
}

- (IBAction)locate:(id)sender {
    CATransition *animation = [CATransition  animation];
    animation.delegate = self;
    animation.duration = kDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromBottom;
    [self setAlpha:0.0f];
    [self.layer addAnimation:animation forKey:@"TSLocateView"];
    [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:kDuration];
    if(self.delegate) {
        [self.delegate actionSheet:self clickedButtonAtIndex:1];
    }
    
}

@end
