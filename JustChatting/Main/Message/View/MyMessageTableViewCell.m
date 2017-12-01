//
//  MyMessageTableViewCell.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/12.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyMessageTableViewCell.h"

#import "UIView+Frame.h"

@implementation MyMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMessageModel:(PDMessageModel *)messageModel {
    switch (messageModel.type) {
            // 纯文本
        case EMMessageBodyTypeText:
        {
            self.messageLb.text = messageModel.text;
                
        }
            break;
            // 图片
        case EMMessageBodyTypeImage:
        {
            
        }
            break;
            
        default:
            break;
    }
}
@end
