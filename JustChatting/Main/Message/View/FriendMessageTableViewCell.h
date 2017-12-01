//
//  FriendMessageTableViewCell.h
//  JustChatting
//
//  Created by Lemonade on 2017/9/12.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMessageModel.h"

@interface FriendMessageTableViewCell : UITableViewCell
/** 消息文本(对方) */
@property (weak, nonatomic) IBOutlet UILabel *messageLb;
/** 消息框的宽度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLbWidthCon;
/** 消息框的高度约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLbHeightCon;
@property (weak, nonatomic) IBOutlet UIImageView *messageBGIV;

@property (nonatomic, readwrite, strong) PDMessageModel *messageModel;

@end
