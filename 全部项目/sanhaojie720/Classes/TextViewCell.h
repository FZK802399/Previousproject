//
//  TextViewCell.h
//  BeiJing360
//
//  Created by baobin on 11-10-16.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSwitchesSegmentIndex 0

@interface TextViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
	UITextView *daoyou;
	UITableView *gaikuang;
	
	NSString *address;
	NSString *telephone;
	NSString *site;
}

@property (nonatomic, retain) IBOutlet UITextView *daoyou;
@property (nonatomic, retain) IBOutlet UITableView *gaikuang;
@property (nonatomic, retain) NSString *address, *telephone, *site;

-(IBAction)toggleControls:(id)sender;

@end
