//
//  WWSaveView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/3.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWSaveView.h"

@interface WWSaveView ()
//当前账号登录
@property (nonatomic,strong) UIView *accountBgView;
@property (nonatomic,strong) UIImageView *warnImgaeView;
@property (nonatomic,strong) UILabel *signLabel;
@property (nonatomic,strong) UILabel *accountLabel;
//验证码
@property (nonatomic,strong) UIView *midBgView;
@property (nonatomic,strong) UILabel *verificationLabel;


@property (nonatomic,strong) UIView *line1;
@property (nonatomic,strong) UIView *line2;
//新密码
@property (nonatomic,strong) UILabel *newpaswdLabel;

//再确认密码
@property (nonatomic,strong) UILabel *aginpasswdLabel;

//确认修改按钮


@end
@implementation WWSaveView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = WWColor(245, 245, 245);
        [self addPureLayout];
    }
    return self;
}

#pragma mark ----Actions---
- (void)respondsToCodeClicked:(UIButton *)sender{
    NSLog(@"获取验证码");
    if (self.getButtonHandler) {
        self.getButtonHandler();
    }
}

- (void)respondsTodetermineButton:(UIButton *)sender{
    NSLog(@"确认修改");
    if (self.confirmButtonHandler) {
        self.confirmButtonHandler();
    }
}

#pragma mark ----布局-----

- (void)addPureLayout{
    [self addSubview:self.accountBgView];
    [self.accountBgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(25) +64];
    [self.accountBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.accountBgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.accountBgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(150)];
    [self.accountBgView addSubview:self.warnImgaeView];
    [self.warnImgaeView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20)];
    
    [self.warnImgaeView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(40)];
    [self.warnImgaeView autoSetDimensionsToSize:CGSizeMake(kWidthChange(30), kWidthChange(30))];
    
    [self.accountBgView addSubview:self.signLabel];
    [self.signLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20)];
    [self.signLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.warnImgaeView withOffset:kWidthChange(10)];
    [self.signLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(200)];
    
    [self.accountBgView addSubview:self.accountLabel];
    [self.accountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.warnImgaeView withOffset:kHeightChange(30)];
    [self.accountLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(80)];
    [self.accountLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(260)];
    
    //中间白色的背景
    [self addSubview:self.midBgView];
    [self.midBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.midBgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.midBgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.accountBgView withOffset:kHeightChange(25)];
    [self.midBgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(395)];
    
    [self.midBgView addSubview:self.line1];
    [self.line1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.line1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.line1 autoSetDimension:ALDimensionHeight toSize:kHeightChange(4)];
    [self.line1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(130)];
    
    [self.midBgView addSubview:self.line2];
    [self.line2 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.line2 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.line2 autoSetDimension:ALDimensionHeight toSize:kHeightChange(4)];
    [self.line2 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(130)];
    
    [self.midBgView addSubview:self.verificationLabel];
    [self.verificationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [self.verificationLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(45)];
    [self.verificationLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(125)];
    
    //验证码输入框
    [self.midBgView addSubview:self.verificationCode];
    [self.verificationCode autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(45)];
    [self.verificationCode autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.verificationLabel];
    [self.verificationCode autoSetDimension:ALDimensionWidth toSize:kWidthChange(240)];
    
    [self.midBgView addSubview:self.getVerificationCodeButton];
    [self.getVerificationCodeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.verificationCode];
    [self.getVerificationCodeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(55)];
    [self.getVerificationCodeButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(135), kHeightChange(45))];
    
    [self.midBgView addSubview:self.newpaswdLabel];
    [self.newpaswdLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [self.newpaswdLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line1 withOffset:kHeightChange(45)];
    [self.newpaswdLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(125)];
    
    //验证码输入框
    [self.midBgView addSubview:self.newpasswdTextField1];
    [self.newpasswdTextField1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line1 withOffset:kHeightChange(45)];
    [self.newpasswdTextField1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.newpaswdLabel];
    [self.newpasswdTextField1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(55)];
    
    [self.midBgView addSubview:self.aginpasswdLabel];
    [self.aginpasswdLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [self.aginpasswdLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line2 withOffset:kHeightChange(45)];
    [self.aginpasswdLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(125)];
    
    //验证码输入框
    [self.midBgView addSubview:self.aginpasswdTextField];
    [self.aginpasswdTextField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line2 withOffset:kHeightChange(45)];
    [self.aginpasswdTextField autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.aginpasswdLabel];
    [self.aginpasswdTextField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(55)];
    
    [self addSubview:self.determineButton];
    [self.determineButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(75)];
    [self.determineButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(75)];
    [self.determineButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(435)];
    [self.determineButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(75)];
}

#pragma mark ----Getters----
//确认按钮
- (UIButton *)determineButton{
    if (!_determineButton) {
        _determineButton = [[UIButton alloc] init];
        [_determineButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_determineButton setTitle:@"确认修改" forState:UIControlStateNormal];
        _determineButton.titleLabel.font = [UIFont boldSystemFontOfSize:kWidthChange(30)];
        _determineButton.backgroundColor = WWColor(211, 5, 26);
        _determineButton.layer.cornerRadius = kWidthChange(10);
        [_determineButton addTarget:self action:@selector(respondsTodetermineButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineButton;
}

// 再次输入新密码输入框
- (UITextField *)aginpasswdTextField{
    if (!_aginpasswdTextField) {
        _aginpasswdTextField = [[UITextField alloc] init];
        _aginpasswdTextField.layer.borderWidth = 0;
//        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"请再次输入你的新密码"];
        _aginpasswdTextField.placeholder = @"请再次输入你的新密码";
        [_aginpasswdTextField setValue:[UIFont systemFontOfSize:kWidthChange(28)] forKeyPath:@"_placeholderLabel.font"];
//        _aginpasswdTextField.attributedPlaceholder = attribute;
        
        _aginpasswdTextField.textAlignment = NSTextAlignmentLeft;
        //        _newpasswdTextField1.placeholderRectForBounds
    }
    return _aginpasswdTextField;
}
//确认密码
- (UILabel *)aginpasswdLabel{
    if (!_aginpasswdLabel) {
        _aginpasswdLabel = [[UILabel alloc] init];
        _aginpasswdLabel.text = @"确认密码";
        _aginpasswdLabel.textColor = WWColor(77, 77, 77);
        _aginpasswdLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
    }
    return _aginpasswdLabel;
}


// 新密码输入框
- (UITextField *)newpasswdTextField1{
    if (!_newpasswdTextField1) {
        _newpasswdTextField1 = [[UITextField alloc] init];
        _newpasswdTextField1.layer.borderWidth = 0;
//        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"输入你的新密码"];
        _newpasswdTextField1.placeholder = @"输入你的新密码";
        [_newpasswdTextField1 setValue:[UIFont systemFontOfSize:kWidthChange(28)] forKeyPath:@"_placeholderLabel.font"];
        
//        _newpasswdTextField1.attributedPlaceholder = attribute;
        _newpasswdTextField1.textAlignment = NSTextAlignmentLeft;
//        _newpasswdTextField1.placeholderRectForBounds
    }
    return _newpasswdTextField1;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds

{
    
    //return CGRectInset(bounds, 50, 0);
    
    CGRect inset = CGRectMake(bounds.origin.x+190, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
    
    
    
    return inset;
    
    
}

//新密码
- (UILabel *)newpaswdLabel{
    if (!_newpaswdLabel) {
        _newpaswdLabel = [[UILabel alloc] init];
        _newpaswdLabel.text = @"新密码";
        _newpaswdLabel.textColor = WWColor(77, 77, 77);
        _newpaswdLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
    }
    return _newpaswdLabel;
}

//获取验证码按钮
- (UIButton *)getVerificationCodeButton{
    if (!_getVerificationCodeButton) {
        _getVerificationCodeButton = [[UIButton alloc] init];
        _getVerificationCodeButton.backgroundColor = WWColor(48, 48, 48);
        [_getVerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getVerificationCodeButton.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(20)];
        _getVerificationCodeButton.layer.cornerRadius = kWidthChange(5);
        _getVerificationCodeButton.layer.masksToBounds = YES;
        [_getVerificationCodeButton addTarget:self action:@selector(respondsToCodeClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _getVerificationCodeButton;
}

- (UITextField *)verificationCode{
    if (!_verificationCode) {
        _verificationCode = [[UITextField alloc] init];
        _verificationCode.layer.borderWidth = 0;
        _verificationCode.placeholder = @"请输入验证码";
        [_verificationCode setValue:[UIFont systemFontOfSize:kWidthChange(28)] forKeyPath:@"_placeholderLabel.font"];
    }
    return _verificationCode;
}

- (UILabel *)verificationLabel{
    if (!_verificationLabel) {
        _verificationLabel = [[UILabel alloc] init];
        _verificationLabel.text = @"验证码";
        _verificationLabel.textColor = WWColor(77, 77, 77);
        _verificationLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
        
    }
    return _verificationLabel;
}

- (UIView *)line2{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = WWColor(245, 245, 245);
        
    }
    return _line2;
}

- (UIView *)line1{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = WWColor(245, 245, 245);

    }
    return _line1;
}

- (UIView *)midBgView{
    if (!_midBgView) {
        _midBgView = [[UIView alloc] init];
        _midBgView.backgroundColor = [UIColor whiteColor];
        _midBgView.layer.cornerRadius = kWidthChange(5);
        _midBgView.layer.masksToBounds = YES;
    }
    return _midBgView;
}

//当前登录账号
- (UILabel *)accountLabel{
    if (!_accountLabel) {
         _accountLabel = [[UILabel alloc] init];
        NSString *telephone = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        NSString *str1 = [telephone substringToIndex:3];//截取掉下标5之前的字符串
        NSLog(@"截取的值为：%@",str1);
        NSString *str2 = [telephone substringFromIndex:7];//截取掉下标3之后的字符串
//         _accountLabel.text = @"188****0032";
        _accountLabel.text = [NSString stringWithFormat:@"%@****%@",str1,str2];
         _accountLabel.textColor = [UIColor blackColor];
         _accountLabel.font = [UIFont boldSystemFontOfSize:kWidthChange(38)];
         _accountLabel.textAlignment = NSTextAlignmentNatural;
    }
    return _accountLabel;
}

- (UILabel *)signLabel{
    if (!_signLabel) {
        _signLabel = [[UILabel alloc] init];
        _signLabel.text = @"当前登录账号";
        _signLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _signLabel.textColor = WWColor(152, 152, 152);
    }
    return _signLabel;
}

- (UIImageView *)warnImgaeView{
    if (!_warnImgaeView) {
        _warnImgaeView = [[UIImageView alloc] init];
        _warnImgaeView.image = [UIImage imageNamed:@"register_alert"];
        _warnImgaeView.layer.cornerRadius = kWidthChange(15);
        _warnImgaeView.layer.masksToBounds = YES;
    }
    return _warnImgaeView;
}

- (UIView *)accountBgView{
    if (!_accountBgView) {
        _accountBgView = [[UIView alloc] init];
        _accountBgView.backgroundColor = [UIColor whiteColor];
    }
    return _accountBgView;
}

@end
