//
//  MyMessageImageTableViewCell.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/18.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyMessageImageTableViewCell.h"
#import "UIView+Frame.h"
#import "UIView+Utils.h"

@implementation MyMessageImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
    _messageModel = messageModel;
    CGFloat width = messageModel.width;
    CGFloat height = messageModel.height;
    // 如果已经存在对于messagebtn的约束(宽高),则移除
    if (self.messageIV.constraints.count > 0) {
        for (NSLayoutConstraint *con in self.messageIV.constraints) {
            if (con.firstAttribute == NSLayoutAttributeWidth || con.firstAttribute == NSLayoutAttributeHeight) {
                [self.messageIV removeConstraint:con];
            }
        }
    }
    
    if (width > (SCREEN_WIDTH-10-30-10-60)) {
        NSLayoutConstraint *widthCon = [NSLayoutConstraint constraintWithItem:self.messageIV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:(SCREEN_WIDTH-10-30-10-60)*0.6];
        NSLayoutConstraint *heightCon = [NSLayoutConstraint constraintWithItem:self.messageIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:(SCREEN_WIDTH-10-30-10-60)*height/width*0.6];
        [self.messageIV addConstraints:@[widthCon, heightCon]];
    } else {
        NSLayoutConstraint *widthCon = [NSLayoutConstraint constraintWithItem:self.messageIV attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:width*0.6];
        NSLayoutConstraint *heightCon = [NSLayoutConstraint constraintWithItem:self.messageIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:height*0.6];
        [self.messageIV addConstraints:@[widthCon, heightCon]];
    }
    
    self.messageIV.image = messageModel.image;
    
    if (self.messageIV.image == nil) {
        
        [self.messageIV setImage:[UIImage imageNamed:@"noImage"]];
        self.messageIV.width = 50;
        self.messageIV.height = 50;
    }
}

@end
