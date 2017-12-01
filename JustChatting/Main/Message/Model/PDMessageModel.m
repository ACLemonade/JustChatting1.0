//
//  PDMessageModel.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/19.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "PDMessageModel.h"

@implementation PDMessageModel

- (instancetype)initWithMessage:(EMMessage *)message {
    if (self = [super init]) {
        self.from = message.from;
        self.to = message.to;
        self.type = message.body.type;
        switch (self.type) {
                // 纯文本
            case EMMessageBodyTypeText:
            {
                self.body = (EMTextMessageBody *)message.body;
                EMTextMessageBody *textBody = (EMTextMessageBody *)self.body;
                self.text = textBody.text;
            }
                break;
                // 图片
            case EMMessageBodyTypeImage:
            {
                self.body = (EMImageMessageBody *)message.body;
                EMImageMessageBody *imageBody = (EMImageMessageBody *)self.body;
                self.width = ceilf(imageBody.size.width);
                self.height = ceilf(imageBody.size.height);
                self.image = [UIImage imageWithContentsOfFile:imageBody.localPath];
                self.remotePath = imageBody.remotePath;
                NSLog(@"大图remote路径 -- %@"   ,imageBody.remotePath);
                NSLog(@"大图local路径 -- %@"    ,imageBody.localPath); // // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"大图的secret -- %@"    ,imageBody.secretKey);
                NSLog(@"大图的W -- %f ,大图的H -- %f",imageBody.size.width,imageBody.size.height);
                NSLog(@"大图的下载状态 -- %u",imageBody.downloadStatus);
                
                
                // 缩略图sdk会自动下载
                NSLog(@"小图remote路径 -- %@"   ,imageBody.thumbnailRemotePath);
                NSLog(@"小图local路径 -- %@"    ,imageBody.thumbnailLocalPath);
                NSLog(@"小图的secret -- %@"    ,imageBody.thumbnailSecretKey);
                NSLog(@"小图的W -- %f ,大图的H -- %f",imageBody.thumbnailSize.width,imageBody.thumbnailSize.height);
                NSLog(@"小图的下载状态 -- %u",imageBody.thumbnailDownloadStatus);
            }
                break;
                
            default:
                break;
        }
    }
    return self;
}
- (instancetype)initWithImage:(UIImage *)image {
    if (self = [super init]) {
        self.from = [EMClient sharedClient].currentUsername;
        self.image = image;
        self.width = image.size.width;
        self.height = image.size.height;
    }
    return self;
}
@end
