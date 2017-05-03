//
//  CustomRegistView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/19.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "CustomRegistView.h"
#import "UIImage+CustomImage.h"
@implementation CustomRegistView

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

-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel =[[UILabel alloc]init];
        _nameLabel.text =@"昵称";
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _nameLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.nameLabel];
    }
    return _nameLabel;
}
-(ZSCustomTextField *)nameTextField
{
    if (!_nameTextField)
    {
        _nameTextField =[[ZSCustomTextField alloc]init];
        _nameTextField.placeholder =@"请输入您的昵称";
        [_nameTextField setValue:[UIFont systemFontOfSize:kWidthChange(26)] forKeyPath:@"_placeholderLabel.font"];        _nameTextField.layer.borderColor =[[UIColor clearColor]CGColor];
        _nameTextField.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.nameTextField];
    }
    return _nameTextField;
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
-(UILabel *)passwordLabel
{
    if (!_passwordLabel)
    {
        _passwordLabel =[[UILabel alloc]init];
        _passwordLabel.text =@"密码";
        _passwordLabel.textAlignment = NSTextAlignmentCenter;
        _passwordLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _passwordLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.passwordLabel];
    }
    return _passwordLabel;
}
-(ZSCustomTextField *)passwordTextField
{
    if (!_passwordTextField)
    {
        _passwordTextField =[[ZSCustomTextField alloc]init];
        _passwordTextField.placeholder =@"密码至少由6位数字组成";
        [_passwordTextField setValue:[UIFont systemFontOfSize:kWidthChange(26)] forKeyPath:@"_placeholderLabel.font"];
        _passwordTextField.secureTextEntry =YES;
        _passwordTextField.layer.borderColor =[[UIColor clearColor]CGColor];
        _passwordTextField.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.passwordTextField];
    }
    return _passwordTextField;
}
-(UIButton *)eyeImageView
{
    if (!_eyeImageView)
    {
        _eyeImageView =[UIButton buttonWithType:UIButtonTypeCustom];
        [_eyeImageView setImage:[UIImage imageNamed:@"eye_normal"] forState:UIControlStateNormal];
        [_eyeImageView setImage:[UIImage imageNamed:@"eye_selected"] forState:UIControlStateSelected];
        _eyeImageView.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.eyeImageView];
    }
    return _eyeImageView;
}
-(void)addLayout
{
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(34)];
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(34)];
    [self.line autoSetDimension:ALDimensionHeight toSize:kHeightChange(2)];
    [self.line autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [self.line autoAlignAxisToSuperviewMarginAxis:ALAxisHorizontal];

    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(34)];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(34)];
    [self.nameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.line withOffset:-kHeightChange(32)];
    [self.nameLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.nameTextField withOffset:-kWidthChange(22)];
    [self.nameLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(130)];
    
    [self.nameTextField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(34)];
    [self.nameTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.line withOffset:-kHeightChange(32)];
    [self.nameTextField autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];
    
    
    [self.passwordLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(34)];
    [self.passwordLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line withOffset:kHeightChange(34)];
    [self.passwordLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(34)];
    [self.passwordLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.passwordTextField withOffset:-kWidthChange(22)];
    [self.passwordLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(130)];
    
    [self.passwordTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line withOffset:kHeightChange(34)];
    [self.passwordTextField autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(34)];
    [self.passwordTextField autoSetDimension:ALDimensionWidth toSize:kWidthChange(350)];
    
    [self.eyeImageView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(35)];
    [self.eyeImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(50)];
    [self.eyeImageView autoSetDimensionsToSize:CGSizeMake(kWidthChange(38), kHeightChange(30))];
}
@end












