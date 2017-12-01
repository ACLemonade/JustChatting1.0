//
//  SingletonPatternMacros.h
//  Base
//
//  Created by Lemonade on 2017/5/17.
//  Copyright © 2017年 Lemonade. All rights reserved.
//  单例宏定义

#ifndef SingletonPatternMacros_h
#define SingletonPatternMacros_h

// @interface
#define singleton_interface(className) \
+ (instancetype)shared##className;

// @implementation
#define singleton_implementation(className) \
static className *_instance; \
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)shared##className \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}


#endif /* SingletonPatternMacros_h */
