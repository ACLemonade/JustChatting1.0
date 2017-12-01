//
//  FriendMessageImageTableViewCell.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/18.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "FriendMessageImageTableViewCell.h"
#import "UIView+Frame.h"
#import "UIView+Utils.h"

@implementation FriendMessageImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.messageIV.layer.borderWidth = 0;
    self.messageIV.layer.borderColor = RGB(204, 204, 204).CGColor;
    self.messageIV.layer.cornerRadius = 3;
    self.messageIV.layer.masksToBounds = YES;
    self.messageIV.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage:)];
    [self.messageIV addGestureRecognizer:tap];
}
- (void)showImage:sender {
    // 1. 创建photoBroseView对象
    PYPhotoBrowseView *photoBroseView = [[PYPhotoBrowseView alloc] init];
    // 2.1 设置图片源(UIImageView)数组
    photoBroseView.imagesURL = @[self.messageModel.remotePath];
    photoBroseView.placeholderImage = self.messageModel.image;
    //    photoBroseView.sourceImgageViews = @[self.messageIV];
    // 2.2 设置初始化图片下标（即当前点击第几张图片）
    photoBroseView.currentIndex = 0;
    photoBroseView.frameFormWindow = [UIView absoluteFrameFromView:self.messageIV toView:nil];
    photoBroseView.frameToWindow = [UIView absoluteFrameFromView:self.messageIV toView:nil];
    // 3.显示(浏览)
    [photoBroseView show];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setMessageModel:(PDMessageModel *)messageModel {
    self.messageIV.width = messageModel.width;
    self.messageIV.height = messageModel.height;
    self.messageIV.image = [UIImage imageWithContentsOfFile:((EMImageMessageBody *)messageModel.body).thumbnailLocalPath];
    if (self.messageIV.image == nil) {
        
        self.messageIV.image = [UIImage imageNamed:@"noImage"];
        self.messageIV.width = 50;
        self.messageIV.height = 50;
    }
}
@end
