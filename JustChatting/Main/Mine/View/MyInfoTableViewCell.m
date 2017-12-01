//
//  MyInfoTableViewCell.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyInfoTableViewCell.h"

@implementation MyInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.userNameLb.text = [UserDataManager sharedManager].userName;
}

@end
