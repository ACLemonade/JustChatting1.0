//
//  PDProgressHUD.h
//  JustChatting
//
//  Created by Lemonade on 2017/9/4.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDProgressHUD : UIView
/** 显示菊花 */
+ (void)showHUDAddedTo:(UIView *)view
              animated:(BOOL)animated;

/** 隐藏菊花 */
+ (BOOL)hideHUDForView:(UIView *)view
              animated:(BOOL)animated;

/** 显示普通文本,并在指定时间之后隐藏 */
+ (void)showMessage:(NSString *)message
            addedTo:(UIView *)view
  andHideAfterDelay:(NSTimeInterval)delay;

/** 显示成功文本,并在指定时间之后隐藏 */
+ (void)showSuccessMessage:(NSString *)successMessage
                   addedTo:(UIView *)view
         andHideAfterDelay:(NSTimeInterval)delay;

/** 显示失败文本,并在指定时间之后隐藏 */
+ (void)showFailureMessage:(NSString *)failureMessage
                   addedTo:(UIView *)view
         andHideAfterDelay:(NSTimeInterval)delay;

@end
