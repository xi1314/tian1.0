//
//  BottomView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/21.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "TextFieldView.h"
#import "UIImage+CustomImage.h"

@implementation TextFieldView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.backgroundColor =[UIColor whiteColor];
        [self addLayout];
    }
    return self;
}
-(UIImageView *)bgView

{
    if (!_bgView)
    {
        _bgView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-14"]];
        _bgView.userInteractionEnabled =YES;
        _bgView.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.bgView];
    }
    return _bgView;
}
-(ZSCustomTextField *)textField
{
    if (!_textField)
    {
        _textField =[[ZSCustomTextField alloc]init];
        _textField.placeholder=@"输入要发送的内容";
        [_textField setValue:[UIFont systemFontOfSize:kWidthChange(26)] forKeyPath:@"_placeholderLabel.font"];
        
        _textField.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _textField.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.textField];
    }
    return _textField;
}
-(UIImageView *)line
{
    if (!_line)
    {
        _line =[[UIImageView alloc]init];
        _line.image =[UIImage createImageWithColor:WWColor(234, 234, 234)];
        _line.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.line];
    }
    return _line;
}
-(UIButton *)sendButton
{
    if (!_sendButton)
    {
        _sendButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(36)];
        [_sendButton setTitleColor:WWColor(165, 165, 165) forState:UIControlStateNormal];
        _sendButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.sendButton];
    }
    return _sendButton;
}
-(UIButton *)giftBtn
{
    if (!_giftBtn)
    {
        _giftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_giftBtn setImage:[UIImage imageNamed:@"礼物-(1)"] forState:UIControlStateNormal];
        _giftBtn.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.giftBtn];
    }
    return _giftBtn;
}
-(void)addLayout
{
    [self.bgView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
    [self.bgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(10)];
    [self.bgView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:
     self.giftBtn withOffset:-kWidthChange(30)];

    [@[self.bgView,self.giftBtn,self.sendButton,self.textField]autoMatchViewsDimension:ALDimensionHeight];

    [self.sendButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.giftBtn withOffset:-kWidthChange(30)];
    [self.sendButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(10)];
    [self.sendButton autoSetDimension:ALDimensionWidth toSize:kWidthChange(120)];
    
    [self.textField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(10)];
    [self.textField autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
    [self.textField autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.sendButton withOffset:-kWidthChange(8)];
    
    [self.giftBtn autoSetDimension:ALDimensionWidth toSize:kWidthChange(95)];
    [self.giftBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(20)];
    [self.giftBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(10)];
    [self.giftBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(15)];
}
@end













