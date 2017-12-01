//
//  PDSecurity.h
//  JustChatting
//
//  Created by Lemonade on 2017/9/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDSecurity : NSObject

/** 根据userName和serviceName获取password */
+ (NSString *)passwordWithUserName:(NSString *)userName
                    andServiceName:(NSString *)serviceName
                             error:(NSError **)pError;

/** 保存userName,password等重要信息 */
+ (BOOL)saveUserName:(NSString *)userName
         andPassword:(NSString *)password
      forServiceName:(NSString *)serviceName
      updateExisting:(BOOL)updateExisting
               error:(NSError **)pError;

/** 根据userName和serviceName删除指定数据 */
+ (BOOL)deleteItemWithUserName:(NSString *)userName
                andServiceName:(NSString *)serviceName
                         error:(NSError **)pError;


@end
