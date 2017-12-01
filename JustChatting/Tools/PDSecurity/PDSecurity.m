//
//  PDSecurity.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/6.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "PDSecurity.h"
#import <Security/Security.h>

static NSString *PDKeychainUtilsErrorDomain = @"PDKeychainUtilsErrorDomain";

@implementation PDSecurity
+ (NSString *)passwordWithUserName:(NSString *)userName andServiceName:(NSString *)serviceName error:(NSError *__autoreleasing *)pError {
    // 对于password赋予初值nil,只有当确实查询到password的值的时候才进行赋值
    NSString *password = nil;
    
    if (!userName || !serviceName) {
        if (pError) {
            *pError = [NSError errorWithDomain:PDKeychainUtilsErrorDomain code:-2000 userInfo:nil];
        }
        return password;
    }
    // 如果pError存在,pError的值置空
    if (pError) {
        *pError = nil;
    }
    
    NSArray *keys = @[
                      (__bridge id)kSecClass,
                      (__bridge id)kSecAttrAccount,
                      (__bridge id)kSecAttrService
                      ];
    NSArray *objects = @[
                         (__bridge id)kSecClassGenericPassword,
                         userName,
                         serviceName
                         ];
    // 基础查询字典,包含userName和serviceName
    NSDictionary *query = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    // 首先对Keychain进行一次查询,返回内容为attributes.按照规范而言,password应当作为data参数存储在Keychain,但是以防万一老版本中出现误操作,将password以attribute的形式存储,因而需要对于attributes进行一次查询
    NSMutableDictionary *attributesQuery = [query mutableCopy];
    [attributesQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    OSStatus attributesStatus = SecItemCopyMatching((CFDictionaryRef)attributesQuery, nil);
    
    if (attributesStatus != noErr) {
        if (pError && attributesStatus != errSecItemNotFound) {
            *pError = [NSError errorWithDomain:PDKeychainUtilsErrorDomain code:attributesStatus userInfo:nil];
        }
        return password;
    }
    
    
    // 之后对于data参数进行查询
    NSMutableDictionary *passwordQuery = [query mutableCopy];
    [passwordQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    CFTypeRef passwordResult = nil;
    
    OSStatus passwordStatus = SecItemCopyMatching((CFDictionaryRef)passwordQuery, &passwordResult);
    
    if (passwordStatus != noErr) {
        if (passwordStatus == errSecItemNotFound) {
            if (pError) {
                *pError = [NSError errorWithDomain:PDKeychainUtilsErrorDomain code:-1999 userInfo:nil];
            }
        } else {
            if (pError) {
                *pError = [NSError errorWithDomain:PDKeychainUtilsErrorDomain code:passwordStatus userInfo:nil];
            }
        }
        return password;
    }
    
    
    NSData *passwordData = (__bridge NSData *)passwordResult;
    // data中存在password数据
    if (passwordData) {
        password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
    } else {
        if (pError) {
            *pError = [NSError errorWithDomain:PDKeychainUtilsErrorDomain code:passwordStatus userInfo:nil];
        }
    }
    return password;
}

+ (BOOL)saveUserName:(NSString *)userName andPassword:(NSString *)password forServiceName:(NSString *)serviceName updateExisting:(BOOL)updateExisting error:(NSError *__autoreleasing *)pError {
    
    if (!userName || !password || !serviceName) {
        if (pError) {
            *pError = [NSError errorWithDomain:PDKeychainUtilsErrorDomain code:-2000 userInfo:nil];
        }
        return NO;
    }
    // 如果pError存在,pError的值置空
    if (pError) {
        *pError = nil;
    }
    
    // 首先判断给定userName和serviceName是否能查询到password
    NSError *pwdError = nil;
    NSString *existingPassword = [self passwordWithUserName:userName andServiceName:serviceName error:&pwdError];
    
    // 存在这条记录但是没有password,可能由于新老本版的更替导致
    if ([pwdError code] == -1999) {
        pwdError = nil;
        // 删除这条错误格式的记录
        [self deleteItemWithUserName:userName andServiceName:serviceName error:&pwdError];
        
        if ([pwdError code] != noErr) {
            if (pError) {
                *pError = pwdError;
            }
            return NO;
        }
    } else if ([pwdError code] != noErr) {  // 存在错误
        if (pError) {
            *pError = pwdError;
        }
        return NO;
    }
    OSStatus status = noErr;
    
    // 存在拥有密码并且位于正确的存储位置的记录
    if (existingPassword)
    {
        
        // 更新现有密码
        if (![existingPassword isEqualToString:password] && updateExisting)
        {
            // 根据传入参数updateExisting判断是否更新现有密码
            
            NSArray *keys = @[
                              (__bridge id)kSecClass,
                              (__bridge id)kSecAttrService,
                              (__bridge id)kSecAttrLabel,
                              (__bridge id)kSecAttrAccount
                              ];
            
            NSArray *objects = @[
                                 (__bridge id)kSecClassGenericPassword,
                                 serviceName,
                                 serviceName,
                                 userName
                                 ];
            
            NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
            
            status = SecItemUpdate((CFDictionaryRef) query, (CFDictionaryRef) [NSDictionary dictionaryWithObject: [password dataUsingEncoding: NSUTF8StringEncoding] forKey: (__bridge id)kSecValueData]);
        }
    } else {
        // 不存在现有密码,存储新密码
        
        NSArray *keys = @[
                          (__bridge id)kSecClass,
                          (__bridge id)kSecAttrService,
                          (__bridge id)kSecAttrLabel,
                          (__bridge id)kSecAttrAccount,
                          (__bridge id)kSecValueData
                          ];
        
        NSArray *objects = @[
                             (__bridge id)kSecClassGenericPassword,
                             serviceName,
                             serviceName,
                             userName,
                             [password dataUsingEncoding: NSUTF8StringEncoding]
                             ];
        
        NSDictionary *query = [[NSDictionary alloc] initWithObjects: objects forKeys: keys];
        
        status = SecItemAdd((CFDictionaryRef) query, NULL);
    }
    
    if (pError && status != noErr)
    {
        // 添加记录发生未知错误,返回错误
        *pError = [NSError errorWithDomain: PDKeychainUtilsErrorDomain code: status userInfo: nil];
        
        return NO;
    }
    return YES;
}
+ (BOOL)deleteItemWithUserName:(NSString *)userName andServiceName:(NSString *)serviceName error:(NSError *__autoreleasing *)pError {
    
    if (!userName || !serviceName) {
        if (pError) {
            *pError = [NSError errorWithDomain:PDKeychainUtilsErrorDomain code:-2000 userInfo:nil];
        }
        return NO;
    }
    // 如果pError存在,pError的值置空
    if (pError) {
        *pError = nil;
    }
    
    NSArray *keys = @[
                      (__bridge id)kSecClass,
                      (__bridge id)kSecAttrAccount,
                      (__bridge id)kSecAttrService,
                      (__bridge id)kSecReturnAttributes
                      ];
    NSArray *objects = @[
                         (__bridge id)kSecClassGenericPassword,
                         userName,
                         serviceName,
                         (__bridge id)kCFBooleanTrue
                         ];
    // 删除查询字典,包含userName和serviceName
    NSDictionary *deleteQuery = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    OSStatus deleteStatus = SecItemDelete((CFDictionaryRef)deleteQuery);
    
    if (pError && deleteQuery != noErr) {
        *pError = [NSError errorWithDomain:PDKeychainUtilsErrorDomain code:deleteStatus userInfo:nil];
        return NO;
    }
    
    return YES;
}

@end
