//
//  MyCenterViewController.m
//  JustChatting
//
//  Created by Lemonade on 2017/8/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MyCenterViewController.h"
#import "LoginViewController.h"

#import "MyInfoTableViewCell.h"
#import "SubmitTableViewCell.h"

#import "PDSecurity.h"
#import "BasicNavigationController.h"
#import "UIControl+Event.h"

@interface MyCenterViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite, strong) UITableView *myTableView;

@end

@implementation MyCenterViewController
#pragma mark - Life Circle Methods
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"我";
    [self myTableView];
    

}
#pragma mark - UITableViewDataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if (section == 0) {
        MyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyInfoTableViewCell class])];
        
        return cell;
    } else {
        SubmitTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SubmitTableViewCell class])];
        [cell.submitBtn addControlClickBlock:^(UIControl *sender) {
            [[EMClient sharedClient].options setIsAutoLogin:NO];
            [PDSecurity deleteItemWithUserName:[UserDataManager sharedManager].userName andServiceName:APPBundleID error:nil];
            [UserDataManager sharedManager].userName = nil;
            BasicNavigationController *basicNavi = [[BasicNavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
            [self presentViewController:basicNavi animated:YES completion:nil];
        } forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 100;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Lazy Load
- (UITableView *)myTableView {
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_myTableView];
        [_myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _myTableView.dataSource = self;
        _myTableView.delegate = self;
        
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyInfoTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyInfoTableViewCell class])];
        [_myTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SubmitTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SubmitTableViewCell class])];
        
    }
    return _myTableView;
}

@end
