//   
//  IndividualSubviewsBasedApplicationCell.h
//  BeiJing360
//
//  Created by baobin on 11-6-13.
//  Copyright 2011 __ChuangYiFengTong__. All rights reserved.


#import <Foundation/Foundation.h>
#import "ApplicationCell.h"


@interface IndividualSubviewsBasedApplicationCell : ApplicationCell
{
    IBOutlet UIImageView *iconView;		//imageView
    IBOutlet UILabel *publisherLabel;	//artist
    IBOutlet UILabel *nameLabel;		//title
    
}
@property (nonatomic, retain) UIImageView *iconView;

@end
