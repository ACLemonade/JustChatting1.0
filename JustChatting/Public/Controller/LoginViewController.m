//
//  LoginViewController.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/4.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"

#import "PDSecurity.h"

@interface LoginViewController () <UITextFieldDelegate>
/** 用户名图标 */
@property (nonatomic, readwrite, strong) UIImageView *userNameIV;
/** 用户名输入框 */
@property (nonatomic, readwrite, strong) UITextField *userNameTF;
/** 密码图标 */
@property (nonatomic, readwrite, strong) UIImageView *passwordIV;
/** 密码输入框 */
@property (nonatomic, readwrite, strong) UITextField *passwordTF;
/** 登录按钮 */
@property (nonatomic, readwrite, strong) UIButton *loginBtn;
/** 注册按钮 */
@property (nonatomic, readwrite, strong) UIButton *registerBtn;

@end

@implementation LoginViewController
#pragma mark - Life Circle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    [self registerBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - Target Methods
// 登录事件
- (void)loginAction:sender {
    // 弹出菊花等待框
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // 登录验证
    [[EMClient sharedClient] loginWithUsername:self.userNameTF.text password:self.passwordTF.text completion:^(NSString *aUsername, EMError *aError) {
        if (!aError) {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
            [UserDataManager sharedManager].userName = aUsername;
            [PDSecurity saveUserName:aUsername andPassword:self.passwordTF.text forServiceName:APPBundleID updateExisting:YES error:nil];
            // 弹出成功提示框,持续1.5秒
            [PDProgressHUD showSuccessMessage:@"登录成功" addedTo:self.view andHideAfterDelay:1.5f];
            // 非阻塞延时操作,1.5秒之后(弹出框持续时间)跳转至个人中心
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            });
        } else {
            // 弹出失败提示框,持续1.5秒
            [PDProgressHUD showFailureMessage:@"登录失败" addedTo:self.view andHideAfterDelay:1.5f];
        }
    }];
}
// 跳转注册界面事件
- (void)pushToRegisterVCAction:sender{
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
}
#pragma mark - Lazy Load
- (UIImageView *)userNameIV{
    if (_userNameIV == nil) {
        _userNameIV = [[UIImageView alloc] init];
        [self.view addSubview:_userNameIV];
        [_userNameIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(150);
            make.left.equalTo(30);
            make.width.height.equalTo(30);
        }];
        _userNameIV.image = [UIImage imageNamed:@"userName"];
    }
    return _userNameIV;
}
- (UITextField *)userNameTF{
    if (_userNameTF == nil) {
        _userNameTF = [[UITextField alloc] init];
        [self.view addSubview:_userNameTF];
        [_userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameIV.mas_right).equalTo(30);
            make.centerY.equalTo(self.userNameIV);
            make.right.equalTo(-30);
            make.height.equalTo(self.userNameIV);
        }];
        _userNameTF.borderStyle = UITextBorderStyleNone;
        _userNameTF.placeholder = @"请输入用户名";
        _userNameTF.textColor = TEXT_MID_COLOR;
        _userNameTF.delegate = self;
        
        //分割线
        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userNameTF.mas_bottom);
            make.left.equalTo(_userNameTF);
            make.right.equalTo(_userNameTF);
            make.height.equalTo(1);
        }];
        lineView.backgroundColor = SEPARATORLINE_COLOR;
    }
    return _userNameTF;
}
- (UIImageView *)passwordIV{
    if (_passwordIV == nil) {
        _passwordIV = [[UIImageView alloc] init];
        [self.view addSubview:_passwordIV];
        [_passwordIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userNameIV.mas_bottom).equalTo(50);
            make.left.equalTo(self.userNameIV);
            make.width.height.equalTo(30);
        }];
        _passwordIV.image = [UIImage imageNamed:@"password"];
    }
    return _passwordIV;
}
- (UITextField *)passwordTF{
    if (_passwordTF == nil) {
        _passwordTF = [[UITextField alloc] init];
        [self.view addSubview:_passwordTF];
        [_passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userNameTF);
            make.centerY.equalTo(self.passwordIV);
            make.right.equalTo(self.userNameTF);
            make.height.equalTo(self.passwordIV);
        }];
        _passwordTF.borderStyle = UITextBorderStyleNone;
        _passwordTF.placeholder = @"请输入密码";
        _passwordTF.textColor = TEXT_MID_COLOR;
        _passwordTF.delegate = self;
        
        //分割线
        UIView *lineView = [[UIView alloc] init];
        [self.view addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_passwordTF.mas_bottom);
            make.left.equalTo(_passwordTF);
            make.right.equalTo(_passwordTF);
            make.height.equalTo(1);
        }];
        lineView.backgroundColor = SEPARATORLINE_COLOR;
    }
    return _passwordTF;
}
- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_loginBtn];
        [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordIV.mas_bottom).equalTo(100);
            make.left.equalTo(self.passwordIV);
            make.right.equalTo(self.passwordTF);
            make.height.equalTo(50);
        }];
        _loginBtn.backgroundColor = DIAMOND_BLUE_COLOR;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 10;
        
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}
- (UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_registerBtn];
        [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginBtn.mas_bottom).equalTo(15);
            make.right.equalTo(self.loginBtn);
        }];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:DIAMOND_BLUE_COLOR forState:UIControlStateNormal];
        
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_registerBtn addTarget:self action:@selector(pushToRegisterVCAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

@end
