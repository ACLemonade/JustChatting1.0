//
//  MessageDetailViewController.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/12.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "MessageDetailViewController.h"

#import "FriendMessageTableViewCell.h"
#import "MyMessageTableViewCell.h"
#import "MyMessageImageTableViewCell.h"
#import "FriendMessageImageTableViewCell.h"

#import "MessageInputView.h"

#import "UIView+Frame.h"

#import "PDMessageModel.h"

#define kMessageInputViewHeight 84

typedef NS_ENUM(NSUInteger, EventType) {
    // 编辑文本
    EventTypeEditing,
    // 取消所有事件
    EventTypeCancel,
    // 点击相册按妞
    EventTypeChoosePhoto,
    // 点击相册按妞
    EventTypeTakePhoto,
    // 点击相册按妞
    EventTypePrepareMoney,
};

@interface MessageDetailViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MessageInputViewDelegate, EMChatManagerDelegate>

@property (nonatomic, readwrite, strong) UITableView *chatTableView;
/** 输入框&功能视图 */
@property (nonatomic, readwrite, strong) MessageInputView *messageInputView;
/** 消息列表 */
@property (nonatomic, readwrite, strong) NSMutableArray *messageList;
/** 点击操作标识 */
@property (nonatomic, readwrite, assign) EventType eventType;

@end

@implementation MessageDetailViewController

#pragma mark - Life Circle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.friendName;
    [self addBackButton];
    [self chatTableView];
    [self messageInputView];

    // 添加键盘即将frame改变的通知
    ADD_OBSERVER(UIKeyboardWillChangeFrameNotification, @selector(keyboardFrameWillChanged:));
    // 添加键盘已经显示的通知
    ADD_OBSERVER(UIKeyboardDidShowNotification, @selector(keyboardDidShow:));
    // 添加键盘已经隐藏的通知
    ADD_OBSERVER(UIKeyboardDidHideNotification, @selector(keyboardDidHide:));
    // 添加聊天管理器委托
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.friendName type:EMConversationTypeChat createIfNotExist:YES];
    [conversation loadMessagesStartFromId:nil count:10 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        if (!aError) {
            for (EMMessage *message in aMessages) {
                PDMessageModel *model = [[PDMessageModel alloc] initWithMessage:message];
                [self.messageList addObject:model];
            }
            [self.chatTableView reloadData];
            if (self.messageList.count > 0) {
                [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        } else {
            [PDProgressHUD showFailureMessage:@"加载失败" addedTo:self.view andHideAfterDelay:1.0f];
        }
    }];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)dealloc {
    // 移除通知
    REMOVE_OBSERVER(self);
    // 移除聊天管理器委托
    [[EMClient sharedClient] removeDelegate:self];
}
#pragma mark - Private Methods

#pragma mark - Target Methods
// 点击屏幕事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.eventType = EventTypeCancel;
    [self.view endEditing:YES];
}

// 键盘frame变化监听
- (void)keyboardFrameWillChanged:(NSNotification *)sender {
//    NSLog(@"%@", sender.userInfo);
    NSDictionary *userInfo = sender.userInfo;
    // 键盘弹出(消失)动画时间
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 键盘即将显示的frame
    CGRect keyboardNewFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    // 键盘的实时Y坐标
    CGFloat keyboardNewY = keyboardNewFrame.origin.y;
    // 增加messageInputView的高度(等于键盘的高度)
    if (self.messageInputView.height == kMessageInputViewHeight) {
        self.messageInputView.height += keyboardNewFrame.size.height;
    }
    
    if (keyboardNewY == SCREEN_HEIGHT) {    // 键盘即将消失
        if (self.eventType == EventTypeCancel) {
            [UIView animateWithDuration:duration animations:^{
                self.messageInputView.y = keyboardNewY - STATUS_AND_NAVIGATION_HEIGHT - kMessageInputViewHeight;
            } completion:^(BOOL finished) {
                self.eventType = EventTypeEditing;
            }];
        }
        
    } else {    //键盘即将弹出
        if (self.eventType == EventTypeEditing) {
            // 实现与键盘弹出一致的动画
            [UIView animateWithDuration:duration animations:^{
                self.messageInputView.y = keyboardNewY - STATUS_AND_NAVIGATION_HEIGHT - kMessageInputViewHeight;
            } completion:nil];
        }
    }
}
// 键盘已经显示,滑动tableView至最底部
- (void)keyboardDidShow:sender {
    if (self.messageList.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
// 键盘已经消失,滑动tableView至最底部
- (void)keyboardDidHide:sender {
    if (self.messageList.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}
#pragma mark - UITableViewDelegate/DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messageList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger row = indexPath.row;
    PDMessageModel *msgModel = [self.messageList objectAtIndex:row];
    if ([msgModel.from isEqualToString:[EMClient sharedClient].currentUsername]) {   // 发送方是当前账号
        switch (msgModel.type) {
            case EMMessageBodyTypeText:
            {
                MyMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyMessageTableViewCell class])];
                cell.messageModel = msgModel;
                return cell;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                MyMessageImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyMessageImageTableViewCell class])];
                cell.messageModel = msgModel;
                
                return cell;
            }
                break;
                
            default:
            {
                return [UITableViewCell new];
            }
                break;
        }
    } else {    // 发送方是对方
        switch (msgModel.type) {
            case EMMessageBodyTypeText:
            {
                FriendMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendMessageTableViewCell class])];
                cell.messageModel = msgModel;
                return cell;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                FriendMessageImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FriendMessageImageTableViewCell class])];
                cell.messageModel = msgModel;
                return cell;
                
            }
                break;
                
            default:
            {
                return [UITableViewCell new];
            }
                break;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.eventType = EventTypeCancel;
    [UIView animateWithDuration:0.25 animations:^{
        self.messageInputView.y = SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - kMessageInputViewHeight;
    } completion:^(BOOL finished) {
        self.eventType = EventTypeEditing;
    }];
    [self.view endEditing:YES];
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    // 获取编辑后的图片
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    // 关闭自动渲染
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    EMImageMessageBody *imageBody = [[EMImageMessageBody alloc] initWithData:imageData displayName:[NSString stringWithFormat:@"%@.png", GET_CURRENT_TIME]];
    NSString *userName = [EMClient sharedClient].currentUsername;
    EMMessage *imageMessage = [[EMMessage alloc] initWithConversationID:self.friendName from:userName to:self.friendName body:imageBody ext:nil];

    [[EMClient sharedClient].chatManager sendMessage:imageMessage progress:^(int progress) {
        
    } completion:^(EMMessage *message, EMError *error) {
        if (!error && message) {
            // 当前显示数组添加消息
            PDMessageModel *imageModel = [[PDMessageModel alloc] initWithMessage:message];
            [self.messageList addObject:imageModel];
            [self.chatTableView reloadData];
//            [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        } else {
            [PDProgressHUD showFailureMessage:@"发送失败" addedTo:self.view andHideAfterDelay:1.0f];
        }
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - MessageInputViewDelegate
- (BOOL)messageInputView:(MessageInputView *)messageInputView textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        self.eventType = EventTypeCancel;
        // 构造文本消息
        EMTextMessageBody *textMessageBody = [[EMTextMessageBody alloc] initWithText:textView.text];
        NSString *userName = [EMClient sharedClient].currentUsername;
        EMMessage *message = [[EMMessage alloc] initWithConversationID:self.friendName from:userName to:self.friendName body:textMessageBody ext:nil];
        // 当前显示数组添加消息
        [self.messageList addObject:[[PDMessageModel alloc] initWithMessage:message]];
        [self.chatTableView reloadData];
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        // 发送消息
        [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
            ;
        } completion:^(EMMessage *message, EMError *error) {
            if (!error) {
                textView.text = @"";
            } else {
                [PDProgressHUD showFailureMessage:@"发送失败" addedTo:self.view andHideAfterDelay:1.0f];
            }
        }];
        return NO;
    }
    return YES;
}
#pragma mark - EMChatManagerDelegate
// 接收消息回调
- (void)messagesDidReceive:(NSArray *)aMessages {
    for (EMMessage *message in aMessages) {
        PDMessageModel *model = [[PDMessageModel alloc] initWithMessage:message];
        [self.messageList addObject:model];
    }
    [self.chatTableView reloadData];
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageList.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    // 下载缩略图存在延迟,因此延时1.5秒执行刷新
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self.chatTableView reloadData];
    });
    
}

#pragma mark - Lazy Load
- (UITableView *)chatTableView {
    if (_chatTableView == nil) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [self.view addSubview:_chatTableView];
        [_chatTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(0);
            make.bottom.equalTo(self.messageInputView.mas_top);
        }];
        
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _chatTableView.dataSource = self;
        _chatTableView.delegate = self;
        
        [_chatTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FriendMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FriendMessageTableViewCell class])];
        [_chatTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FriendMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"FriendMessageImageCell"];
        [_chatTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyMessageTableViewCell class])];
        [_chatTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyMessageTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"MyMessageImageCell"];
        
        [_chatTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MyMessageImageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyMessageImageTableViewCell class])];
        [_chatTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FriendMessageImageTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([FriendMessageImageTableViewCell class])];
    }
    return _chatTableView;
}
- (MessageInputView *)messageInputView {
    if (_messageInputView == nil) {
        _messageInputView = [[MessageInputView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - STATUS_AND_NAVIGATION_HEIGHT - kMessageInputViewHeight, SCREEN_WIDTH, kMessageInputViewHeight)];
        [self.view addSubview:_messageInputView];
        _messageInputView.backgroundColor = DEFAULT_BACKGROUND_COLOR;
        _messageInputView.delegate = self;
        // 选择照片事件
        [_messageInputView choosePhotoBlock:^(UIButton *sender) {
            PDLog(@"选择照片");
            self.eventType = EventTypeChoosePhoto;
            [self.view endEditing:YES];
            // 判断相册是否可以打开
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                return;
            }
            UIImagePickerController *imagePC = [[UIImagePickerController alloc] init];
            imagePC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            // 允许编辑
            imagePC.allowsEditing = YES;
            imagePC.delegate = self;
            [self presentViewController:imagePC animated:YES completion:nil];
            
        } forControlEvents:UIControlEventTouchUpInside];
        // 拍照事件
        [_messageInputView takePhotoBlock:^(UIButton *sender) {
            PDLog(@"拍照");
            self.eventType = EventTypeTakePhoto;
            [self.view endEditing:YES];
        } forControlEvents:UIControlEventTouchUpInside];
        // 准备红包事件
        [_messageInputView prepareMoneyBlock:^(UIButton *sender) {
            PDLog(@"准备红包");
            self.eventType = EventTypePrepareMoney;
            [self.view endEditing:YES];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _messageInputView;
}
- (NSMutableArray *)messageList {
    if (_messageList == nil) {
        _messageList = [NSMutableArray array];
    }
    return _messageList;
}
@end
