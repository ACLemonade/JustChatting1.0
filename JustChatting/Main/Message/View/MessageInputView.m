
//
//  MessageInputView.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/13.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MessageInputView.h"

#import "UIControl+Event.h"

#define kDefaultButtonTag 10000

@interface MessageInputView () <YYTextViewDelegate>

/** 输入框 */
@property (nonatomic, readwrite, strong) YYTextView *inputTV;
/** 功能视图 */
@property (nonatomic, readwrite, strong) UIView *functionView;


@end

@implementation MessageInputView

- (instancetype)init {
    if (self = [super init]) {
        [self functionView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self functionView];
    }
    return self;
}
#pragma mark - Target Methods
- (void)choosePhotoBlock:(ChoosePhotoBlock)choosePhotoBlock forControlEvents:(UIControlEvents)controlEvents {
    UIButton *albumBtn = [self.functionView viewWithTag:kDefaultButtonTag + 0];
    [albumBtn addControlClickBlock:^(UIControl *sender) {
        choosePhotoBlock((UIButton *)sender);
    } forControlEvents:controlEvents];
}
- (void)takePhotoBlock:(TakePhotoBlock)takePhotoBlock forControlEvents:(UIControlEvents)controlEvents {
    UIButton *cameraBtn = [self.functionView viewWithTag:kDefaultButtonTag + 1];
    [cameraBtn addControlClickBlock:^(UIControl *sender) {
        takePhotoBlock((UIButton *)sender);
    } forControlEvents:controlEvents];
}
- (void)prepareMoneyBlock:(PrepareMoneyBlock)prepareMoneyBlock forControlEvents:(UIControlEvents)controlEvents {
    UIButton *giftBtn = [self.functionView viewWithTag:kDefaultButtonTag + 2];
    [giftBtn addControlClickBlock:^(UIControl *sender) {
        prepareMoneyBlock((UIButton *)sender);
    } forControlEvents:controlEvents];
}

#pragma mark - YYTextViewDelegate
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([_delegate respondsToSelector:@selector(messageInputView:textView:shouldChangeTextInRange:replacementText:)]) {
        [_delegate messageInputView:self textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}
- (void)textViewDidBeginEditing:(YYTextView *)textView {
    if ([_delegate respondsToSelector:@selector(messageInputView:textViewDidBeginEditing:)]) {
        [_delegate messageInputView:self textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(YYTextView *)textView {
    if ([_delegate respondsToSelector:@selector(messageInputView:textViewDidEndEditing:)]) {
        [_delegate messageInputView:self textViewDidEndEditing:textView];
    }
}
#pragma mark - Lazy Load
- (YYTextView *)inputTV {
    if (_inputTV == nil) {
        _inputTV = [[YYTextView alloc] init];
        [self addSubview:_inputTV];
        [_inputTV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(8);
            make.right.equalTo(-8);
            make.height.equalTo(30);
        }];
        _inputTV.backgroundColor = [UIColor whiteColor];
        
        _inputTV.returnKeyType = UIReturnKeySend;
        
        _inputTV.layer.cornerRadius = 3;
        _inputTV.layer.borderWidth = 0.5;
        _inputTV.layer.borderColor = TEXT_LIGHT_COLOR.CGColor;
        
        _inputTV.delegate = self;
    }
    return _inputTV;
}
- (UIView *)functionView {
    if (_functionView == nil) {
        _functionView = [[UIView alloc] init];
        [self addSubview:_functionView];
        [_functionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputTV.mas_bottom).equalTo(4);
            make.left.bottom.right.equalTo(0);
        }];
//        _functionView.backgroundColor = [UIColor lightGrayColor];
        
        // 相册
        UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_functionView addSubview:albumBtn];
        [albumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(4);
            make.left.equalTo(8);
            make.size.equalTo(CGSizeMake(30, 30));
        }];
        [albumBtn setImage:[UIImage imageNamed:@"albumIcon"] forState:UIControlStateNormal];
        albumBtn.tag = kDefaultButtonTag + 0;
        // 拍照
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_functionView addSubview:cameraBtn];
        [cameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(albumBtn);
            make.left.equalTo(albumBtn.mas_right).equalTo(15);
            make.size.equalTo(albumBtn);
        }];
        [cameraBtn setImage:[UIImage imageNamed:@"cameraIcon"] forState:UIControlStateNormal];
        cameraBtn.tag = kDefaultButtonTag + 1;
        
        // 红包
        UIButton *giftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_functionView addSubview:giftBtn];
        [giftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(albumBtn);
            make.left.equalTo(cameraBtn.mas_right).equalTo(15);
            make.size.equalTo(albumBtn);
        }];
        [giftBtn setImage:[UIImage imageNamed:@"giftIcon"] forState:UIControlStateNormal];
        giftBtn.tag = kDefaultButtonTag + 2;
    }
    return _functionView;
}


@end
