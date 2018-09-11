//
//  AddressViewController.m
//  ShopNum1V3.1
//
//  Created by Mac on 14-8-28.
//  Copyright (c) 2014年 WFS. All rights reserved.
//

#import "AddressViewController.h"
#import "EditAddressViewController.h"

#import "ModifyAddressTableViewController.h"

@protocol AddressTableViewCellDelegate <NSObject>

- (void)editAddress:(AddressModel *)merchandise;

@end

@interface AddressTableViewCell : UITableViewCell

@property (assign, nonatomic) id<AddressTableViewCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *telLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabe;
@property (strong, nonatomic) AddressModel *addressModel;


- (IBAction)editBtnClick:(id)sender;



-(void)creatAddresslTableViewCellWithAddressModel:(AddressModel*)intro;

@end

@implementation AddressTableViewCell

- (IBAction)editBtnClick:(id)sender {
    
    if ([_delegate respondsToSelector:@selector(editAddress:)]) {
        [self.delegate editAddress:_addressModel];
    }
}

-(void)creatAddresslTableViewCellWithAddressModel:(AddressModel*)intro{
    _addressModel = intro;
    self.nameLabel.text = intro.name;
    self.telLabel.text = intro.tel;
    self.addressLabe.text = intro.address;
}

@end

//-------------------------------------------------------------------------------



@interface AddressViewController ()<AddressTableViewCellDelegate>

@end

@implementation AddressViewController
{

    AddressModel *currentAddress;
    
    AddressModel *selectedModel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.showType == AddressListForSelect) {
        if (selectedModel == nil) {
            if (self.addressList.count == 1) {
                AddressModel * model = self.addressList.lastObject;
                if([self.delegate respondsToSelector:@selector(selectedAddress:)]){
                    [self.delegate selectedAddress:model];
                }
            }
            else
            {
                if([self.delegate respondsToSelector:@selector(selectedAddress:)]){
                    [self.delegate selectedAddress:nil];
                }
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    currentAddress = nil;
    selectedModel = nil;
    //  加载地址数据
    [self loadAddressList];
}

-(void)loadAddressList{
    NSDictionary * addressDic= [NSDictionary dictionaryWithObjectsAndKeys:
                                self.appConfig.loginName,@"MemLoginID",
                                kWebAppSign, @"AppSign", nil];
    ZDXWeakSelf(weakSelf);
    [self showLoadView];
    [AddressModel getLoginUserAddressListByParameters:addressDic andblock:^(NSArray *list, NSError *error) {
        [weakSelf hideLoadView];
        if (error) {
            [weakSelf showErrorMessage:@"网络错误"];
        }else {
            if (list) {
                weakSelf.addressList = [NSMutableArray arrayWithArray:list];
                [weakSelf.addressTableView reloadData];
            } else {
                [weakSelf showMessage:@"暂无收货地址"];
            }
        }
    }];
    
}

#pragma mark - tableView数据源代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressTableViewCellMainView];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatAddresslTableViewCellWithAddressModel:[self.addressList objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressModel *address = [self.addressList objectAtIndex:indexPath.row];
    if (self.showType == AddressListForView) {

    } else if (self.showType == AddressListForSelect){
        selectedModel = address;
        if([self.delegate respondsToSelector:@selector(selectedAddress:)]){
            [self.delegate selectedAddress:address];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

-(void)editAddress:(AddressModel *)merchandise{
    currentAddress = merchandise;
    [self performSegueWithIdentifier:kSegueAddressToEdit sender:self];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:kSegueAddressToEdit]) {
        ModifyAddressTableViewController *modifyVC  = [segue destinationViewController];
        modifyVC.currenAddressModel = currentAddress;
        modifyVC.isEditAddress = YES;
    }
}


@end
