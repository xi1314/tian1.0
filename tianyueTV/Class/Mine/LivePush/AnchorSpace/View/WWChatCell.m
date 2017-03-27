//
//  WWChatCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/12/6.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWChatCell.h"

@implementation WWChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        [self addPureLayOut];
    }
    return self;
}




- (void)awakeFromNib {
    [super awakeFromNib];
    }

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)addPureLayOut{
    [self addSubview:self.messageLabel];
    [self.messageLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.messageLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(10)];
}

- (UILabel *)messageLabel{
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
//        _messageLabel.text = @"大表哥：我喝酒时唯一不小心的是把酒给弄洒了";
        _messageLabel.font = [UIFont systemFontOfSize:13];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _messageLabel;
}

@end
