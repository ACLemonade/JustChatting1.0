//
//  SubmitTableViewCell.m
//  JustChatting
//
//  Created by Lemonade on 2017/9/12.
//  Copyright © 2017年 Lemonade. All rights reserved.
//

#import "SubmitTableViewCell.h"

@implementation SubmitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.submitBtn.layer.masksToBounds = YES;
    self.submitBtn.layer.cornerRadius = 10;
}

@end
