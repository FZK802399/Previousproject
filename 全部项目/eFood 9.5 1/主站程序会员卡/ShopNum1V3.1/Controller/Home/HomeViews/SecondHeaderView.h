//
//  SecondHeaderView.h
//  HomePage
//
//  Created by 梁泽 on 15/11/20.
//  Copyright © 2015年 right. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const kSecondHeaderView;
@interface SecondHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void) refershWithNotice:(NSString*)notice;
@end
