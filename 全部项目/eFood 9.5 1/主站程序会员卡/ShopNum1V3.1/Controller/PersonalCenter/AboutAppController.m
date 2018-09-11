//
//  AboutAppController.m
//  ShopNum1V3.1
//
//  Created by yons on 15/12/30.
//  Copyright (c) 2015年 WFS. All rights reserved.
//

#import "AboutAppController.h"

@interface AboutAppController ()
@property (weak, nonatomic) IBOutlet UILabel *build;

@end

@implementation AboutAppController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    self.navigationController.navigationBar.translucent = NO;
    self.build.text = [NSString stringWithFormat:@"V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
