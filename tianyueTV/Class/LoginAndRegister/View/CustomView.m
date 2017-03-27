//
//  CustomView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/19.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "CustomView.h"
#import "UIImage+CustomImage.h"
@implementation CustomView

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
        
        [self addLayout];
    }
    return self;
}

-(UILabel *)phoneLabel
{
    if (!_phoneLabel)
    {
        _phoneLabel =[[UILabel alloc]init];
        _phoneLabel.text =@"手机号";
        _phoneLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _phoneLabel.textColor =[UIColor blackColor];
        _phoneLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.phoneLabel];
    }
    return _phoneLabel;
}
-(ZSCustomTextField *)phoneTextField
{
    if (!_phoneTextField)
    {
        _phoneTextField =[[ZSCustomTextField alloc]init];
        _phoneTextField.placeholder =@"+86";
        _phoneTextField.keyboardType =UIKeyboardTypePhonePad;
        [_phoneTextField setValue:[UIFont systemFontOfSize:kWidthChange(26)] forKeyPath:@"_placeholderLabel.font"];
        _phoneTextField.tag =10000;
        _phoneTextField.layer.borderColor =[[UIColor clearColor]CGColor];
        _phoneTextField.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.phoneTextField];
    }
    return _phoneTextField;
}
-(UILabel *)validationLabel
{
    if (!_validationLabel)
    {
        _validationLabel =[[UILabel alloc]init];
        _validationLabel.text =@"验证码";
        _validationLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _validationLabel.textColor =[UIColor blackColor];
        _validationLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.validationLabel];
    }
    return _validationLabel;
}
-(ZSCustomTextField *)validationTextField
{
    if (!_validationTextField)
    {
        _validationTextField =[[ZSCustomTextField alloc]init];
        _validationTextField.layer.borderColor =[[UIColor clearColor]CGColor];
        _validationTextField.placeholder =@"请输入验证码";
        _validationTextField.keyboardType =UIKeyboardTypeNumberPad;
        [_validationTextField setValue:[UIFont systemFontOfSize:kWidthChange(26)] forKeyPath:@"_placeholderLabel.font"];
        _validationTextField.tag =10001;
        _validationTextField.translatesAutoresizingMaskIntoConstraints =NO
        ;
        [self addSubview:self.validationTextField];
    }
    return _validationTextField;
}
-(UIButton *)validationButton
{
    if (!_validationButton)
    {
        _validationButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_validationButton setBackgroundColor:[UIColor blackColor]];
        [_validationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _validationButton.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(26)];
        _validationButton.userInteractionEnabled =NO;
        _validationButton.clipsToBounds =YES;
        _validationButton.layer.cornerRadius =5.0f;

        _validationButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.validationButton];
        
    }
    return _validationButton;
}
-(UIImageView *)line
{
    if (!_line)
    {
        _line =[[UIImageView alloc]init];
        _line.image =[UIImage createImageWithColor:WWColor(240, 240, 240)];
        _line.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.line];
    }
    return _line;
}
-(void)addLayout
{
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(34)];
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(34)];
    [self.line autoSetDimension:ALDimensionHeight toSize:kHeightChange(2)];
    [self.line autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [self.line autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];
    
    [self.phoneLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(34)];
    [self.phoneLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(34)];
    [self.phoneLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.line withOffset:-kHeightChange(32)];
    [self.phoneLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.phoneTextField withOffset:-kWidthChange(54)];
    
    [self.phoneTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(34)];
    [self.phoneTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.line withOffset:-kHeightChange(32)];
    [self.phoneTextField autoSetDimension:ALDimensionWidth toSize:kWidth];
    
    [self.validationLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line withOffset:kHeightChange(34)];
    [self.validationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(34)];
    [self.validationLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(34)];
    [self.validationLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.validationTextField withOffset:-kWidthChange(54)];
    
    [self.validationTextField autoSetDimension:ALDimensionWidth toSize:kWidthChange(190)];
    [self.validationTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(34)];
    [self.validationTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line withOffset:kHeightChange(34)];
    
    [self.validationButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(32)];
    [self.validationButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(30)];
    [self.validationButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line withOffset:kHeightChange(30)];
    [self.validationButton autoSetDimension:ALDimensionWidth toSize:kWidthChange(180)];
}
@end









