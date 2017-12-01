//
//  AppDelegate.h
//  JustChatting
//
//  Created by Lemonade on 2017/8/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, readwrite, strong) BMKMapManager *mapManager;

@end

