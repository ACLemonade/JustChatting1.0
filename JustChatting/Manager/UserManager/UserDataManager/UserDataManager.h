//
//  UserDataManager.h
//  JustChatting
//
//  Created by Lemonade on 2017/9/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDataManager : NSObject

/** UserDataManager单例 */
+ (instancetype)sharedManager;

@property (nonatomic, readwrite, strong) NSString *userName;

@end
