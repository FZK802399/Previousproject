//
//  MessageItemTableViewCell.h
//  Shop
//
//  Created by Ocean Zhang on 4/20/14.
//  Copyright (c) 2014 ocean. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModelMy.h"

typedef enum {
    kCellStateCenter,
    kCellStateLeft,
    kCellStateRight
} MITCCellState;

@class MessageItemTableViewCell;
@protocol MessageItemTableViewCellDelegate <NSObject>

@optional
- (void)swippableTableViewCell:(MessageItemTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(MessageItemTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index;
- (void)swippableTableViewCell:(MessageItemTableViewCell *)cell scrollingToState:(MITCCellState)state;


@end

@interface MessageItemTableViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *leftUtilityButtons;
@property (nonatomic, strong) NSArray *rightUtilityButtons;
@property (nonatomic) id <MessageItemTableViewCellDelegate> delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier containingTableView:(UITableView *)containingTableView leftUtilityButtons:(NSArray *)leftUtilityButtons rightUtilityButtons:(NSArray *)rightUtilityButtons;

- (void)setBackgroundColor:(UIColor *)backgroundColor;
- (void)hideUtilityButtonsAnimated:(BOOL)animated;

- (void)createWithMessageModelMy:(MessageModelMy *)model;

@end
