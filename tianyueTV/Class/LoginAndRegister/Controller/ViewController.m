//
//  ViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/10.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "ViewController.h"
#import "registViewController.h"
#import "ForgetPasswordViewController.h"
#import "MBProgressHUD+MJ.h"
#import "NetWorkTool.h"
#import "CustomRegistView.h"
#import "TabbarViewController.h"
#import "LoginHandler.h"
#import "AppDelegate.h"



@interface ViewController ()

@property (nonatomic, strong) UIImageView *logo;

@property (nonatomic, strong) UIImageView *phoneImage;
@property (nonatomic, strong) UIImageView *verticalLine;
@property (nonatomic, strong) ZSCustomTextField *phoneTextField;
@property (nonatomic, strong) UIImageView *horizontalLine;

@property (nonatomic, strong) UIImageView *passwordImage;
@property (nonatomic, strong) UIImageView *verticalLine1;
@property (nonatomic, strong) ZSCustomTextField *passwordTextField;
@property (nonatomic, strong) UIImageView *horizontalLine1;

@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    self.view.backgroundColor = WWColor(240, 240, 240);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"loginBack"];
    [self.view addSubview:imageView];

    [self addLayout];
}

// 登录按钮绑定方法
- (void)loginBtnClcik:(UIButton *)loginButton
{
    if (self.phoneTextField.text.length == 0 || self.passwordTextField.text.length == 0)
    {
        [MBProgressHUD showError:@"账号或密码不能为空"];
    }else
    {
        [self.view endEditing:YES];
        [self loginRequest];
    }
}


- (void)loginRequest
{
    [MBProgressHUD showMessage:nil];
    @weakify(self);
    [LoginHandler requestForLoginWithPhone:self.phoneTextField.text
                                       pwd:self.passwordTextField.text
                             completeBlock:^(id respondsObject, NSError *error) {
                                 [MBProgressHUD hideHUD];
                                 @strongify(self);
                                 if (respondsObject) {
                                     
                                     LoginModel *loginM = (LoginModel *)respondsObject;
                                     [self saveObjectToUsersDefaults:loginM andKey:@"loginSuccess"];
                                     [self saveObjectToUsersDefaults:self.phoneTextField.text andKey:@"userName"];
                                     [self saveObjectToUsersDefaults:self.passwordTextField.text andKey:@"password"];
                                     
                                     // 登录腾讯云通讯sdk
//                                     [self loginIMSDk:loginM];
                                     
                                     // 进入主页
                                     [self goToMain];
                                     
                                 }else {
                                     [MBProgressHUD showError:@"账号或密码错误"];
                                 }
                                 
                             }];
    
}


/*
// 登录腾讯云通讯sdk
- (void)loginIMSDk:(LoginModel *)loginModel {
    
    //     self.userSig = @"eJxtz11PgzAUgOH-0luNaUu7MZNdwAIGbcPGdHO7aZpRluPkY1CRZfG-iwTjjbfvc05OzhU9i-WdripIlbbKqVN0jwjDGFPGOUe3g5uugtoonVlT-3gvtB8ZtTV1A2XRA8WEE*pg-IeQmsJCBsOiNY0dewPHPshgtYh8AZ5OQvEalJ86cbQ*zVi7ifAuXuRhst*SNRydaVfE55kHnt-FUbGH90Dszn4oJbw88di9LHP5lsh2a7LlzQQ-iGbzuJrPf4*lJzX8*N9zFnIzdHcyJZS5bOz6cCg-CqvspRocM0bQ1zeeuVlk";
    //     self.userIdentifiler = @"test";
    NSString *userIdentify = [NSString stringWithFormat:@"ty%@", loginModel.ID];
    NSString *userSig = loginModel.userSig;
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ] init];
    // accountType 和 sdkAppId 通讯云管理平台分配
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    login_param.accountType = @"10441";
    login_param.identifier = userIdentify;
    login_param.userSig = userSig;
    login_param.appidAt3rd = @"1400024555";
    login_param.sdkAppId = 1400024555;
    
    TIMManager *manager = [TIMManager sharedInstance];
    [manager initSdk:[@"1400024555" intValue] accountType:@"10441"];
    
    //    NSLog(@"----------userSig   %@", login_param.userSig);

    [manager login:login_param succ:^(){

        NSLog(@"Login Succsss");

    } fail:^(int code, NSString * err) {
        
        NSLog(@"Login Failed: %d->%@", code, err);
        
    }];
    
}*/


// 自动登录
- (void)leftBtnClick:(UIButton *)btn
{
    registViewController *vc =[[registViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

// 忘记密码
- (void)rightBtnClick:(UIButton *)btn
{
    ForgetPasswordViewController *ForgetPasswordVC =[[ForgetPasswordViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:ForgetPasswordVC];
    [self presentViewController:nav animated:YES completion:nil];

}

// 进入主页
- (void)goToMain
{
    TabbarViewController *tabbarVC = [[TabbarViewController alloc] init];
    AppDelegate *appD = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appD.window.rootViewController = tabbarVC;
}

- (UIImageView *)logo
{
    if (!_logo)
    {
        _logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loginLogo"]];
        [self.view addSubview:self.logo];
    }
    return _logo;
}

- (UIImageView *)phoneImage
{
    if (!_phoneImage)
    {
        _phoneImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginTelephone"]];
        _phoneImage.translatesAutoresizingMaskIntoConstraints = NO;
         [self.view addSubview:self.phoneImage];
    }
    return _phoneImage;
}

- (UIImageView *)verticalLine
{
    if (!_verticalLine)
    {
        _verticalLine =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginVerLine"]];
        _verticalLine.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.verticalLine];
    }
    return _verticalLine;
}

- (ZSCustomTextField *)phoneTextField
{
    if (!_phoneTextField)
    {
        _phoneTextField =[[ZSCustomTextField alloc]init];
        _phoneTextField.placeholder =@"手机号";
        [_phoneTextField setValue:[UIFont systemFontOfSize:kWidthChange(30)] forKeyPath:@"_placeholderLabel.font"];
        [_phoneTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _phoneTextField.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.phoneTextField];
    }
    return _phoneTextField;
}

- (UIImageView *)horizontalLine
{
    if (!_horizontalLine)
    {
        _horizontalLine =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginHorLine"]];
        _horizontalLine.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.horizontalLine];
    }
    return _horizontalLine;
}

- (UIImageView *)passwordImage
{
    if (!_passwordImage)
    {
        _passwordImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginPwdImage"]];
        _passwordImage .translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.passwordImage];
    }
    return _passwordImage;
}

- (UIImageView *)verticalLine1
{
    if (!_verticalLine1)
    {
        _verticalLine1 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginVerLine"]];
        _verticalLine1.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.verticalLine1];
    }
    return _verticalLine1;
}

- (ZSCustomTextField *)passwordTextField
{
    if (!_passwordTextField)
    {
        _passwordTextField =[[ZSCustomTextField alloc]init];
        _passwordTextField.placeholder =@"密码";
        _passwordTextField.secureTextEntry =YES;
        [_passwordTextField setValue:[UIFont systemFontOfSize:kWidthChange(30)] forKeyPath:@"_placeholderLabel.font"];
        [_passwordTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTextField.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.passwordTextField];
    }
    return _passwordTextField;
}

- (UIImageView *)horizontalLine1
{
    if (!_horizontalLine1)
    {
        _horizontalLine1 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginHorLine"]];
        _horizontalLine1.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.horizontalLine1];
    }
    return _horizontalLine1;
}

// 立即注册
- (UIButton *)leftBtn
{
    if (!_leftBtn)
    {
        _leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"立即注册" forState:UIControlStateNormal];
        _leftBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(26)];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.leftBtn];
    }
    return _leftBtn;
}

// 忘记密码
- (UIButton *)rightBtn
{
    if (!_rightBtn)
    {
        _rightBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        _rightBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(26)];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.rightBtn];
    }
    return _rightBtn;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn)
    {
        _loginBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_loginBtn setTitleColor:WWColor(117, 117, 111) forState:UIControlStateNormal];
        _loginBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(35)];
        _loginBtn.layer.cornerRadius =5.0f;
        _loginBtn.clipsToBounds =YES;
        _loginBtn.backgroundColor=[UIColor whiteColor] ;
        [_loginBtn addTarget:self action:@selector(loginBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        _loginBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.loginBtn];
    }
    return _loginBtn;
}

#pragma mark --pureLayout--
- (void)addLayout
{
    // logo
    self.logo.frame = CGRectMake(0, kHeightChange(222), kHeightChange(120) * 498 / 170, kHeightChange(120));
    self.logo.center = CGPointMake(SCREEN_WIDTH / 2.0, self.logo.center.y);
    
    // 登录按钮
    [self.loginBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(405)];
    [self.loginBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.loginBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    [self.loginBtn autoSetDimension:ALDimensionHeight toSize:kHeightChange(80)];

    // 密码
    [@[self.horizontalLine1,self.horizontalLine,self.loginBtn]autoMatchViewsDimension:ALDimensionWidth ];
    [self.horizontalLine1 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.loginBtn withOffset:-kHeightChange(87)];
    [self.horizontalLine1 autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.horizontalLine1 autoSetDimension:ALDimensionHeight toSize:kHeightChange(2)];
    
    [self.passwordImage autoSetDimensionsToSize:CGSizeMake(kWidthChange(36), kHeightChange(55))];
    [self.passwordImage autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(90)];
    [self.passwordImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.horizontalLine1 withOffset:-kHeightChange(10)];
    
    [self.verticalLine1 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.horizontalLine1 withOffset:-kWidthChange(15)];
    [self.verticalLine1 autoSetDimensionsToSize:CGSizeMake(kWidthChange(2), kHeightChange(40))];
    [self.verticalLine1 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.passwordImage withOffset:kWidthChange(20)];

    [self.passwordTextField autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.verticalLine1 withOffset:kWidthChange(35)];
    [self.passwordTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.horizontalLine1 withOffset:-kHeightChange(13)];
    [self.passwordTextField autoSetDimension:ALDimensionHeight toSize:kHeightChange(55)];
    [self.passwordTextField autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    
    // 账号
    [self.horizontalLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.passwordTextField withOffset:-kHeightChange(54)];
    [self.horizontalLine autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.horizontalLine autoSetDimension:ALDimensionHeight toSize:kHeightChange(2)];
    
    [self.phoneImage autoSetDimensionsToSize:CGSizeMake(kWidthChange(36), kHeightChange(55))];
    [self.phoneImage autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(90)];
    [self.phoneImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.horizontalLine withOffset:-kHeightChange(10)];
    
    [self.verticalLine autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.horizontalLine withOffset:-kWidthChange(15)];
    [self.verticalLine autoSetDimensionsToSize:CGSizeMake(kWidthChange(2), kHeightChange(40))];
    [self.verticalLine autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.phoneImage withOffset:kWidthChange(20)];
    
    [self.phoneTextField autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.verticalLine withOffset:kWidthChange(35)];
    [self.phoneTextField autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.horizontalLine withOffset:-kHeightChange(13)];
    [self.phoneTextField autoSetDimension:ALDimensionHeight toSize:kHeightChange(55)];
    [self.phoneTextField autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];

    // 立即注册
    [self.leftBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.leftBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginBtn withOffset:kHeightChange(15)];
    [self.leftBtn autoSetDimensionsToSize:CGSizeMake(kWidthChange(150), kHeightChange(28))];
    
    // 忘记密码
    [self.rightBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    [@[self.leftBtn,self.rightBtn]autoMatchViewsDimension:ALDimensionWidth];
    [@[self.leftBtn,self.rightBtn]autoMatchViewsDimension:ALDimensionHeight];
    [@[self.leftBtn,self.rightBtn]autoAlignViewsToAxis:ALAxisHorizontal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


