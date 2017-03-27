//
//  BottomView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "BottomView.h"
#import <Masonry.h>

@implementation BottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.66];
        [self addLayout];
    }
    return self;
}
-(UIButton *)startButton
{
    if (!_startButton)
    {
        _startButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_startButton setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        
        [_startButton setImage:[UIImage imageNamed:@"播放(1)"] forState:UIControlStateSelected];
        _startButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.startButton];
    }
    return _startButton;
}
-(UIButton *)barrageButton
{
    if (!_barrageButton)
    {
        _barrageButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_barrageButton setImage:[UIImage imageNamed:@"弹幕开-(1)"] forState:UIControlStateNormal];
        [_barrageButton setImage:[UIImage imageNamed:@"弹幕关-(1)111"] forState:UIControlStateSelected];
        _barrageButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.barrageButton];
    }
    return _barrageButton;
}
-(UITextField *)textField
{
    if (!_textField)
    {
        _textField =[[ZSCustomTextField alloc]init];
        _textField.placeholder =@"输入发送的弹幕内容";
        _textField.textColor =[UIColor whiteColor];
        _textField.clipsToBounds =YES;
        _textField.layer.cornerRadius =5.0f;
        _textField.font =[UIFont systemFontOfSize:kWidthChange(28)];
        _textField.backgroundColor =[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3];
        [_textField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [_textField setValue:[UIFont systemFontOfSize:kWidthChange(26)] forKeyPath:@"_placeholderLabel.font"];
        _textField.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.textField];
    }
    return _textField;
}
-(UIButton *)sendBtn
{
    if (!_sendBtn)
    {
        _sendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.layer.cornerRadius =5.0f;
        _sendBtn.clipsToBounds =YES;
        [_sendBtn setBackgroundColor:WWColor(11, 14, 12)];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _sendBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.sendBtn];
    }
    return _sendBtn;
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
//    __weak typeof(self)weakSelf = self;
//    [self.startButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(kWidthChange(44), kWidthChange(44)));
//        make.left.equalTo(weakSelf).with.offset(kWidthChange(10));
//        make.bottom.equalTo(weakSelf).with.offset(kHeightChange(-10));
//    }];
    [self.startButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(20)];
    [self.startButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(10)];
    [self.startButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(55), kHeightChange(55))];
    
    [self.barrageButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.startButton withOffset:kWidthChange(20)];
    
    [self.giftBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(20)];
    [@[self.startButton,self.barrageButton,self.giftBtn]autoAlignViewsToAxis:ALAxisHorizontal];
    [@[self.startButton,self.barrageButton,self.giftBtn]autoMatchViewsDimension:ALDimensionWidth];
    [@[self.startButton,self.barrageButton,self.giftBtn]autoMatchViewsDimension:ALDimensionHeight];
    
    [self.sendBtn autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.giftBtn withOffset:-kWidthChange(20)];
    [self.sendBtn autoSetDimension:ALDimensionWidth toSize:kWidthChange(120)];
    [@[self.sendBtn,self.textField]autoMatchViewsDimension:ALDimensionHeight];
    [@[self.sendBtn,self.textField]autoAlignViewsToAxis:ALAxisHorizontal];
    
    [self.textField autoSetDimension:ALDimensionHeight toSize:kHeightChange(60)];
    [self.textField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(20)];
    [self.textField autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.barrageButton withOffset:kWidthChange(20)];
    [self.textField autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.sendBtn withOffset:-kWidthChange(20)];
    
//    [self.startButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(10)];
//    [self.startButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(10)];
//    [self.startButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(44), kWidthChange(44))];
//    
//    [self.barrageButton autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.startButton withOffset:kWidthChange(10)];
//    
//    [self.giftBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(10)];
//    [@[self.startButton,self.barrageButton,self.giftBtn]autoAlignViewsToAxis:ALAxisHorizontal];
//    [@[self.startButton,self.barrageButton,self.giftBtn]autoMatchViewsDimension:ALDimensionWidth];
//    [@[self.startButton,self.barrageButton,self.giftBtn]autoMatchViewsDimension:ALDimensionHeight];
//    
//    [self.sendBtn autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.giftBtn withOffset:-kWidthChange(10)];
//    [self.sendBtn autoSetDimension:ALDimensionWidth toSize:kWidthChange(60)];
//    [@[self.sendBtn,self.textField]autoMatchViewsDimension:ALDimensionHeight];
//    [@[self.sendBtn,self.textField]autoAlignViewsToAxis:ALAxisHorizontal];
//    
//    [self.textField autoSetDimension:ALDimensionHeight toSize:kHeightChange(100)];
//    [self.textField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(25)];
//    [self.textField autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.barrageButton withOffset:kWidthChange(10)];
//    [self.textField autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.sendBtn withOffset:-kWidthChange(10)];
}
@end


















