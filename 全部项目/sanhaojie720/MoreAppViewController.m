//
//  MoreAppViewController.m
//  BeiJing360
//
//  Created by baobin on 11-10-11.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "MoreAppViewController.h"


@implementation MoreAppViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"MoreAppViewController" bundle:nil];
    if (self) {
		//	self.title = @"关于我们";
		self.tabBarItem.title = @"更多应用";
		[self.tabBarItem initWithTabBarSystemItem:UITabBarSystemItemMore tag:6];
        // Custom initialization.
    }
    return self;
}

-(void)gotoApp1 {
	UIAlertView *alertForApp1 = [[UIAlertView alloc] initWithTitle:@"欢迎下载全景游北京(免费版)"
														   message:@"您需要EDGE,3G或WIFI连线于Safari进入下载页"
														  delegate:self
												 cancelButtonTitle:@"取消"
												 otherButtonTitles:@"确定", nil];
	alertForApp1.tag = 1;
	[alertForApp1 show];
	[alertForApp1 release];
}

-(void)gotoApp2 {
	UIAlertView *alertForApp2 = [[UIAlertView alloc] initWithTitle:@"欢迎下载全景游深圳(免费版)"
														   message:@"您需要EDGE,3G或WIFI连线于Safari进入下载页"
														  delegate:self
												 cancelButtonTitle:@"取消"
												 otherButtonTitles:@"确定", nil];
	alertForApp2.tag = 2;
	[alertForApp2 show];
	[alertForApp2 release];
}

-(void)gotoApp3 {
	UIAlertView *alertForApp3 = [[UIAlertView alloc] initWithTitle:@"欢迎下载全景游香港(免费版)"
														   message:@"您需要EDGE,3G或WIFI连线于Safari进入下载页"
														  delegate:self
												 cancelButtonTitle:@"取消"
												 otherButtonTitles:@"确定", nil];
	alertForApp3.tag = 3;
	[alertForApp3 show];
	[alertForApp3 release];
}

-(void)gotoApp4 {
	UIAlertView *alertForApp4 = [[UIAlertView alloc] initWithTitle:@"欢迎下载全景游海南(免费版)"
														   message:@"您需要EDGE,3G或WIFI连线于Safari进入下载页"
														  delegate:self
												 cancelButtonTitle:@"取消"
												 otherButtonTitles:@"确定", nil];
	alertForApp4.tag = 4;
	[alertForApp4 show];
	[alertForApp4 release];
}

-(void)gotoApp5 {
	UIAlertView *alertForApp5 = [[UIAlertView alloc] initWithTitle:@"欢迎下载全景游井冈山(免费版)"
														   message:@"您需要EDGE,3G或WIFI连线于Safari进入下载页"
														  delegate:self
												 cancelButtonTitle:@"取消"
												 otherButtonTitles:@"确定", nil];
	alertForApp5.tag = 5;
	[alertForApp5 show];
	[alertForApp5 release];
}



-(void)viewDidLoad {
	[super viewDidLoad];
	UIImage *image = [UIImage imageNamed:@"MoreApp1.jpg"];
	
	//UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 411)];
	imageView.image = image;
	imageView.userInteractionEnabled = YES;
	[self.view addSubview:imageView];
	
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(51, 18, 240, 15)];
	[label setText:@"点击下面的图标进行免费下载"];
	[label setTextColor:[UIColor blackColor]];
	label.backgroundColor = [UIColor clearColor];
	
	UIButton *myButtonApp1 = [[UIButton alloc] init];
	[myButtonApp1 setBackgroundImage:[UIImage imageNamed:@"beijing_logo.png"] forState:UIControlStateNormal];
	[myButtonApp1 setFrame:CGRectMake(17, 70, 57, 57)];
	[myButtonApp1 addTarget:self action:@selector(gotoApp1) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *myButtonApp2 = [[UIButton alloc] init];
	[myButtonApp2 setBackgroundImage:[UIImage imageNamed:@"shenzhen_logo.png"] forState:UIControlStateNormal];
	[myButtonApp2 setFrame:CGRectMake(93, 70, 57, 57)];
	[myButtonApp2 addTarget:self action:@selector(gotoApp2) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *myButtonApp3 = [[UIButton alloc] init];
	[myButtonApp3 setBackgroundImage:[UIImage imageNamed:@"xianggang_logo.png"] forState:UIControlStateNormal];
	[myButtonApp3 setFrame:CGRectMake(169, 70, 57, 57)];
	[myButtonApp3 addTarget:self action:@selector(gotoApp3) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *myButtonApp4 = [[UIButton alloc] init];
	[myButtonApp4 setBackgroundImage:[UIImage imageNamed:@"hainan_logo.png"] forState:UIControlStateNormal];
	[myButtonApp4 setFrame:CGRectMake(245, 70, 57, 57)];
	[myButtonApp4 addTarget:self action:@selector(gotoApp4) forControlEvents:UIControlEventTouchUpInside];
	
	UIButton *myButtonApp5 = [[UIButton alloc] init];
	[myButtonApp5 setBackgroundImage:[UIImage imageNamed:@"jinggangshan_logo.png"] forState:UIControlStateNormal];
	[myButtonApp5 setFrame:CGRectMake(17, 157, 57, 57)];
	[myButtonApp5 addTarget:self action:@selector(gotoApp5) forControlEvents:UIControlEventTouchUpInside];	
	
	
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(12, 133, 114, 15)];
	[label1 setText:@"全景游北京"];
	label1.font = [UIFont systemFontOfSize:13.0f];
	[label1 setTextColor:[UIColor blackColor]];
	label1.backgroundColor = [UIColor clearColor];
	
	UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(88, 133, 114, 15)];
	[label2 setText:@"全景游深圳"];
	label2.font = [UIFont systemFontOfSize:13.0f];
	[label2 setTextColor:[UIColor blackColor]];
	label2.backgroundColor = [UIColor clearColor];
	
	UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(164, 133, 114, 15)];
	[label3 setText:@"全景游香港"];
	label3.font = [UIFont systemFontOfSize:13.0f];
	[label3 setTextColor:[UIColor blackColor]];
	label3.backgroundColor = [UIColor clearColor];
	
	UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(240, 133, 114, 15)];
	[label4 setText:@"全景游海南"];
	label4.font = [UIFont systemFontOfSize:13.0f];
	[label4 setTextColor:[UIColor blackColor]];
	label4.backgroundColor = [UIColor clearColor];
	
	UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(5, 221, 114, 15)];
	[label5 setText:@"全景游井冈山"];
	label5.font = [UIFont systemFontOfSize:13.0f];
	[label5 setTextColor:[UIColor blackColor]];
	label5.backgroundColor = [UIColor clearColor];
	
	[imageView addSubview:myButtonApp1];
	[imageView addSubview:myButtonApp2];
	[imageView addSubview:myButtonApp3];
	[imageView addSubview:myButtonApp4];
	[imageView addSubview:myButtonApp5];
	[imageView addSubview:label];
	[imageView addSubview:label1];
	[imageView addSubview:label2];
	[imageView addSubview:label3];
	[imageView addSubview:label4];
	[imageView addSubview:label5];
	
	[myButtonApp1 release];
	[myButtonApp2 release];
	[myButtonApp3 release];
	[myButtonApp4 release];
	[myButtonApp5 release];

	[label release];
	[label1 release];
	[label2 release];
	[label3 release];
	[label4 release];
	[label5 release];
	
	[image release];
	[imageView release];
}
- (void)didReceiveMemoryWarning {
    // Releases the view if it doe sn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1) {
		if(buttonIndex == 1) { 
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id446584627?mt=8"]];
		}
	} else if (alertView.tag == 2) {
		if(buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id469341689?mt=8"]];
		}
	} else if (alertView.tag == 3) {
		if(buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id472618307?mt=8"]];
		}
	} else if (alertView.tag == 4) {
		if(buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id474708790?mt=8"]];
		}
	} else if (alertView.tag == 5) {
		if(buttonIndex == 1) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/cn/app/id474719069?mt=8"]];
		}
	}
}

@end
