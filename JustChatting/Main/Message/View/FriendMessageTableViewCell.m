//
//  FriendMessageTableViewCell.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/12.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "FriendMessageTableViewCell.h"

@implementation FriendMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMessageModel:(PDMessageModel *)messageModel {
    self.messageLb.text = messageModel.text;
}
@end
