//
//  AppDelegate.m
//  JustChatting
//
//  Created by Lemonade on 2017/8/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "AppDelegate.h"
#import "BasicTabBarController.h"


@interface AppDelegate () <EMClientDelegate, BMKLocationServiceDelegate>


@end

@implementation AppDelegate

#pragma mark - Life Circle Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window.rootViewController = [[BasicTabBarController alloc] init];
    NSLog(@"%@", kPathDocument);
    
    [self startEaseMob];
    [self startBaiduMap];
    
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

//app进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

//app即将从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)connectionStateDidChange:(EMConnectionState)aConnectionState {
    PDLog(@"网络变化");
}
#pragma mark - Private Methods
// 启动环信
- (void)startEaseMob {
    //使用已经注册好的AppKey,初始化单例
    EMOptions *options = [EMOptions optionsWithAppkey:EM_APP_KEY];
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
}
// 启动百度地图
- (void)startBaiduMap {
    BOOL ret = [self.mapManager start:BM_APP_KEY generalDelegate:nil];
    if (!ret) {
        NSLog(@"百度地图引擎启动失败");
    } else {
        NSLog(@"百度地图引擎启动成功");
    }
}

#pragma mark - Lazy Load
-(UIWindow *)window{
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [_window makeKeyAndVisible];
    }
    return _window;
}
- (BMKMapManager *)mapManager {
    if (_mapManager == nil) {
        _mapManager = [[BMKMapManager alloc] init];
    }
    return _mapManager;
}

@end
