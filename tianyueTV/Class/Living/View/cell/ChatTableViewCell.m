//
//  ChatTableViewCell.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/19.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "ChatTableViewCell.h"

@implementation ChatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier] )
    {
        [self addLayout];
//        self.textLabel.font =[UIFont systemFontOfSize:kWidthChange(28)];
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = WWColor(235, 235, 235);
    }
    return self;
}

-(UILabel *)chatLabel
{
    if (!_chatLabel)
    {
        _chatLabel =[[UILabel alloc]init];
        //_chatLabel.backgroundColor =[UIColor whiteColor];
        _chatLabel.textColor =[UIColor blackColor];
        _chatLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.chatLabel];
    }
    return _chatLabel;
}

-(void)addLayout
{
    [self.chatLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(2)];
    [self.chatLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(2)];
    [self.chatLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(2)];
    [self.chatLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(2)];
}

@end
