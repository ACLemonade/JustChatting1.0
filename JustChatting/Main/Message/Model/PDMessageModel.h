//
//  PDMessageModel.h
//  JustChatting
//
//  Created by Lemonade on 2017/9/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDMessageModel : NSObject

@property (nonatomic, readwrite, strong) NSString *from;

@property (nonatomic, readwrite, strong) NSString *to;

@property (nonatomic, readwrite, assign) EMMessageBodyType type;

@property (nonatomic, readwrite, strong) EMMessageBody *body;

@property (nonatomic, readwrite, strong) NSString *text;

@property (nonatomic, readwrite, strong) UIImage *image;

@property (nonatomic, readwrite, assign) CGFloat width;

@property (nonatomic, readwrite, assign) CGFloat height;

@property (nonatomic, readwrite, strong) NSString *remotePath;

/** 初始化消息类,适用于接收消息或从会话中取得消息(网络请求) */
- (instancetype)initWithMessage:(EMMessage *)message;

- (instancetype)initWithImage:(UIImage *)image;

@end
