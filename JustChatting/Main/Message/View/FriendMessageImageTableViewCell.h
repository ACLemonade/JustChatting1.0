//
//  FriendMessageImageTableViewCell.h
//  JustChatting
//
//  Created by Lemonade on 2017/9/18.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDMessageModel.h"

@interface FriendMessageImageTableViewCell : UITableViewCell <PYPhotoBrowseViewDelegate>
/** 信息视图 */
@property (weak, nonatomic) IBOutlet UIImageView *messageIV;

@property (nonatomic, readwrite, strong) PDMessageModel *messageModel;

@end
