//
//  PDProgressHUD.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/4.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "PDProgressHUD.h"

@implementation PDProgressHUD

+ (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    [MBProgressHUD showHUDAddedTo:view animated:animated];
}
+ (BOOL)hideHUDForView:(UIView *)view animated:(BOOL)animated {
    return [MBProgressHUD hideHUDForView:view animated:animated];
}
+ (void)showMessage:(NSString *)message addedTo:(UIView *)view andHideAfterDelay:(NSTimeInterval)delay {
    MBProgressHUD *oldHud = [MBProgressHUD HUDForView:view];
    if (oldHud) {
        oldHud = nil;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:hud];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = message;
    // 显示hud
    [hud showAnimated:YES];
    // 隐藏hud
    [hud hideAnimated:YES afterDelay:delay];
}
+ (void)showSuccessMessage:(NSString *)successMessage addedTo:(UIView *)view andHideAfterDelay:(NSTimeInterval)delay{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:hud];
    }
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
//    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"nav_back"];
    hud.customView = imageView;
    hud.label.text = successMessage;
    // 显示hud
    [hud showAnimated:YES];
    // 隐藏hud
    [hud hideAnimated:YES afterDelay:delay];
}
+ (void)showFailureMessage:(NSString *)failureMessage addedTo:(UIView *)view andHideAfterDelay:(NSTimeInterval)delay {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [[MBProgressHUD alloc] initWithView:view];
        [view addSubview:hud];
    }
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    //    imageView.backgroundColor = [UIColor redColor];
    imageView.image = [UIImage imageNamed:@"nav_back"];
    hud.customView = imageView;
    hud.label.text = failureMessage;
    // 显示hud
    [hud showAnimated:YES];
    // 隐藏hud
    [hud hideAnimated:YES afterDelay:delay];
}
@end
