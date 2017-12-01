//
//  BasicTabBarController.m
//  JustReader
//
//  Created by Lemonade on 2017/7/20.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "BasicTabBarController.h"
#import "BasicNavigationController.h"

#import "MessageListViewController.h"
#import "ContactsListViewController.h"
#import "MyCenterViewController.h"

@interface BasicTabBarController ()

@end

@implementation BasicTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置tabBarItem的数据源
    BasicNavigationController *messageNavi = [[BasicNavigationController alloc] initWithRootViewController:[[MessageListViewController alloc] init]];
    messageNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"message_normal"] selectedImage:[UIImage imageNamed:@"message_selected"]];
    
    BasicNavigationController *contactsNavi = [[BasicNavigationController alloc] initWithRootViewController:[[ContactsListViewController alloc] init]];
    contactsNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"联系人" image:[UIImage imageNamed:@"contacts_normal"] selectedImage:[UIImage imageNamed:@"contacts_selected"]];
    
    BasicNavigationController *mineNavi = [[BasicNavigationController alloc] initWithRootViewController:[[MyCenterViewController alloc] init]];
    mineNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我" image:[UIImage imageNamed:@"mine_normal"] selectedImage:[UIImage imageNamed:@"mine_selected"]];
    
    [self setViewControllers:@[messageNavi, contactsNavi, mineNavi] animated:YES];
    // 设置tabBar背景色
    self.tabBar.barTintColor = TEXT_WHITE_COLOR;
    // 设置tabBarItem的文字颜色
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: UIColorFromRGB(0xbfbfbf)} forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: DIAMOND_BLUE_COLOR} forState:UIControlStateSelected];
}


@end
