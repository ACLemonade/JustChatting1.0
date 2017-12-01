//
//  UserDataManager.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "UserDataManager.h"

@implementation UserDataManager

@synthesize userName = _userName;

static UserDataManager *_instance;

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
- (void)setUserName:(NSString *)userName{
    _userName = userName;
    NSUserDefaults *dict = USER_DEFAULT;
    [dict setObject:userName forKey:@"userName"];
    [dict synchronize];
}
- (NSString *)userName{
    if (_userName) {
        return _userName;
    } else {
        return [USER_DEFAULT objectForKey:@"userName"];
    }
}
@end
