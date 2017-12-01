//
//  MessageInputView.h
//  JustChatting
//
//  Created by Lemonade on 2017/9/13.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChoosePhotoBlock)(UIButton *sender);

typedef void(^TakePhotoBlock)(UIButton *sender);

typedef void(^PrepareMoneyBlock)(UIButton *sender);

@class MessageInputView;
@protocol MessageInputViewDelegate <NSObject>

@required
/** 主要用于判断returnKey的点击事件 */
- (BOOL)messageInputView:(MessageInputView *)messageInputView
                textView:(YYTextView *)textView
 shouldChangeTextInRange:(NSRange)range
         replacementText:(NSString *)text;
@optional
/** 编辑开始触发事件 */
- (void)messageInputView:(MessageInputView *)messageInputView
 textViewDidBeginEditing:(YYTextView *)textView;

/** 编辑结束触发事件 */
- (void)messageInputView:(MessageInputView *)messageInputView
   textViewDidEndEditing:(YYTextView *)textView;
@end

@interface MessageInputView : UIView

@property (nonatomic, weak) id<MessageInputViewDelegate> delegate;

- (void)choosePhotoBlock:(ChoosePhotoBlock)choosePhotoBlock
        forControlEvents:(UIControlEvents)controlEvents;

- (void)takePhotoBlock:(TakePhotoBlock)takePhotoBlock
      forControlEvents:(UIControlEvents)controlEvents;

- (void)prepareMoneyBlock:(PrepareMoneyBlock)prepareMoneyBlock
         forControlEvents:(UIControlEvents)controlEvents;


@end
