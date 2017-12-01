//
//  ContactsListViewController.m
//  JustChatting
//
//  Created by Lemonade on 2017/8/31.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "ContactsListViewController.h"
#import "MessageDetailViewController.h"

@interface ContactsListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readwrite, strong) NSArray *contactsList;

@property (nonatomic, readwrite, strong) UITableView *contactsTableView;

@end

@implementation ContactsListViewController
#pragma mark - Life Circle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"联系人";
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[EMClient sharedClient].contactManager getContactsFromServerWithCompletion:^(NSArray *aList, EMError *aError) {
        if (!aError) {
            self.contactsList = aList;
            [self.contactsTableView reloadData];
        } else {
            [PDProgressHUD showFailureMessage:@"获取失败" addedTo:self.view andHideAfterDelay:1.5f];
        }
    }];
}
#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.contactsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.contactsList objectAtIndex:row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //左侧分割线留白
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    MessageDetailViewController *messageDetailVC = [[MessageDetailViewController alloc] init];
    messageDetailVC.friendName = [self.contactsList objectAtIndex:row];
    messageDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageDetailVC animated:YES];
}
#pragma mark - Lazy Load
- (UITableView *)contactsTableView {
    if (_contactsTableView == nil) {
        _contactsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_contactsTableView];
        [_contactsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        _contactsTableView.dataSource = self;
        _contactsTableView.delegate = self;
    }
    return _contactsTableView;
}

@end
