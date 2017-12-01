//
//  NetworkManager.m
//  JustChatting
//
//  Created by Lemonade on 2017/8/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "NetworkManager.h"


@implementation NetworkManager

static NetworkManager *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

@end
