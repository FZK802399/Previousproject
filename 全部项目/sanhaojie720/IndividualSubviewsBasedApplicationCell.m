
 //   
 //  IndividualSubviewsBasedApplicationCell.m
 //  BeiJing360
 //
 //  Created by baobin on 11-6-13.
 //  Copyright 2011 __ChuangYiFengTong__. All rights reserved.
 

#import "IndividualSubviewsBasedApplicationCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation IndividualSubviewsBasedApplicationCell
@synthesize iconView;


	- (void)setIcon:(UIImage *)newIcon

{
    [super setIcon:newIcon];
    iconView.image = newIcon;
}

- (void)setPublisher:(NSString *)newPublisher
{
    [super setPublisher:newPublisher];
    publisherLabel.text = newPublisher;
}


- (void)setName:(NSString *)newName
{
    [super setName:newName];
    nameLabel.text = newName;
}


- (void)dealloc
{
    [iconView release];
    [publisherLabel release];
    [nameLabel release];

    [super dealloc];
}

@end
