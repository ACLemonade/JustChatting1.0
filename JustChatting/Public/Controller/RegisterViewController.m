//
//  RegisterViewController.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/4.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "RegisterViewController.h"


@interface RegisterViewController () <UITextFieldDelegate>
/** 用户名图标 */
@property (nonatomic, readwrite, strong) UIImageView *userNameIV;
/** 用户名输入框 */
@property (nonatomic, readwrite, strong) UITextField *userNameTF;
/** 密码图标 */
@property (nonatomic, readwrite, strong) UIImageView *passwordIV;
/** 密码输入框 */
@property (nonatomic, readwrite, strong) UITextField *passwordTF;
/** 注册按钮 */
@property (nonatomic, readwrite, strong) UIButton *registerBtn;

@end

@implementation RegisterViewController
#pragma mark - Life Circle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"注册";
    [self addBackButton];
    [self registerBtn];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
#pragma mark - Private Methods
// 点击屏幕事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];

}
#pragma mark - Target Methods
// 注册用户事件
- (void)registerUserAction:sender{

    
    [PDProgressHUD showHUDAddedTo:self.view animated:YES];
    [[EMClient sharedClient] registerWithUsername:self.userNameTF.text password:self.passwordTF.text completion:^(NSString *aUsername, EMError *aError) {
        [PDProgressHUD hideHUDForView:self.view animated:YES];
        if (!aError) {
            [PDProgressHUD showMessage:@"注册成功" addedTo:self.view andHideAfterDelay:1.5f];
        } else {
            [PDProgressHUD showMessage:@"注册失败" addedTo:self.view andHideAfterDelay:1.5f];
        }
    }];
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
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
- (UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:_registerBtn];
        [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.passwordIV.mas_bottom).equalTo(100);
            make.left.equalTo(self.passwordIV);
            make.right.equalTo(self.passwordTF);
            make.height.equalTo(50);
        }];
        _registerBtn.backgroundColor = DIAMOND_BLUE_COLOR;
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 10;
        
        [_registerBtn addTarget:self action:@selector(registerUserAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}
@end
