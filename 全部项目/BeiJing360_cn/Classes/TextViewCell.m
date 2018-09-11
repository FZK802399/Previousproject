    //
//  TextViewCell.m
//  BeiJing360
//
//  Created by baobin on 11-10-16.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import "TextViewCell.h"


@implementation TextViewCell

@synthesize daoyou, gaikuang;
@synthesize address, telephone, site;

-(void)dealloc {
	[gaikuang, daoyou release];
	[address, telephone, site release];
	[super dealloc];
}

-(IBAction)toggleControls:(id)sender {
	if([sender selectedSegmentIndex] == kSwitchesSegmentIndex) {
		daoyou.hidden = NO;
		gaikuang.hidden = YES;
	} else {
		daoyou.hidden = YES;
		gaikuang.hidden = NO;
	}

}

#pragma mark - 
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 1;
		case 1:
			return 1;
		case 2:
			return 1;
		default:
			return 0;
	}
}

-(UITableViewCell *)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
	static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleTableIdentifier];
	if(cell == nil) {
		cell = [[[UITableViewCell alloc]
				 initWithStyle:UITableViewCellStyleDefault
				 reuseIdentifier:SimpleTableIdentifier]autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
	
	switch (indexPath.section) {
		case 0:
			cell.textLabel.text = address;
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			return cell;
		case 1:
			cell.textLabel.text = [NSString stringWithFormat:@"电话: %@", telephone];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			return cell;
		case 2:
			cell.textLabel.text = [NSString stringWithFormat:@"网站: %@", site];
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.selectionStyle = UITableViewCellSelectionStyleBlue;
			return cell;
		default:
			return cell;
	}
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	if(indexPath.section == 1) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
														message:@"您确定要拨打此电话吗？"
													   delegate:self
											  cancelButtonTitle:@"取消"
											  otherButtonTitles:@"拨号",nil];
		alert.tag = 1;
		[alert show];
		[alert release];
	}
	if(indexPath.section == 2) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Safari"
														message:@"您需要EDGE,3G或WIFI连线与Safari观看网页"
													   delegate:self
											  cancelButtonTitle:@"取消"
											  otherButtonTitles:@"确定", nil];
		
		alert.tag = 2;
		[alert show];
		[alert release];
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 2) return 30.0f;
	return 0.0f;
}

#pragma mark -
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if(alertView.tag == 1 && buttonIndex == 1) {
		if ([telephone intValue]) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", telephone]]];
		} else {
			UIAlertView *alertForTelephone = [[UIAlertView alloc] initWithTitle:@"提示"
																		message:@"无好吗"
																	   delegate:self
															  cancelButtonTitle:@"确定"
															  otherButtonTitles:nil];
			[alertForTelephone show];
			[alertForTelephone release];
		}
	}
	
	if(alertView.tag == 2 && buttonIndex == 1) {
		if(![site isEqualToString:@""]) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:site]];
			NSLog(@"%@",site);
		}else {
			UIAlertView *alertForSite = [[UIAlertView alloc] initWithTitle:@"提示"
																   message:@"次经典暂无网站"
																  delegate:self
														 cancelButtonTitle:@"确定"
														 otherButtonTitles:nil];
			[alertForSite show];
			[alertForSite release];
		}

	}
}


@end
