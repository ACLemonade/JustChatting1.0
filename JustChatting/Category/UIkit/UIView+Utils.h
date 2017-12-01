//
//  UIView+Utils.h
//  JustChatting
//
//  Created by Lemonade on 2017/12/1.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Utils)

/** 获得视图A相对于视图B(默认屏幕)的绝对位置 */
+ (CGRect)absoluteFrameFromView:(UIView * __nonnull)originView toView:( UIView * _Nullable)targetView;

@end
