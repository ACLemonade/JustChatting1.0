//
//  UIView+Utils.m
//  JustChatting
//
//  Created by Lemonade on 2017/12/1.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "UIView+Utils.h"

@implementation UIView (Utils)

+ (CGRect)absoluteFrameFromView:(UIView *)originView toView:(UIView *)targetView {
    if (!targetView) {
        targetView = [UIApplication sharedApplication].keyWindow;
    }
    UIView *tmpView = originView;
    CGFloat tmp_X = .0;
    CGFloat tmp_Y = .0;
    // 如果临时视图的并不是目标视图,则进入循环,通过计算临时视图位于其父视图位置(frame),累加坐标,最终得到原始视图位于目标视图的绝对坐标
    while (tmpView.bounds.size.width != targetView.bounds.size.width || tmpView.bounds.size.height != targetView.bounds.size.height) {
        // 对于scrollView及其子类,由于滚动的问题,故而存在偏移量,当前屏幕的坐标需要原始坐标减去偏移量
        if ([tmpView.superview isKindOfClass:[UIScrollView class]]) {
            UIScrollView *scView = (UIScrollView *)tmpView.superview;
            CGPoint point = scView.contentOffset;
            tmp_X -= point.x;
            tmp_Y -= point.y;
        }
        CGRect rect = [tmpView convertRect:tmpView.bounds toView:tmpView.superview];
        tmp_X += rect.origin.x;
        tmp_Y += rect.origin.y;
        // 一层层向上提取
        tmpView = tmpView.superview;
    }
    return CGRectMake(tmp_X, tmp_Y, originView.bounds.size.width, originView.bounds.size.height);
}

@end
