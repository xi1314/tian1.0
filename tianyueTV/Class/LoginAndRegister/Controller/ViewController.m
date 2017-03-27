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
#import "MineViewController.h"
//#import "MainViewController.h"

#import "HomepageViewController.h"


#import "CustomRegistView.h"
#import "SearchViewController.h"
@interface ViewController ()

//@property(nonatomic,strong)CustomRegistView *registView;

@property(nonatomic,strong)UIImageView *logo;

@property(nonatomic,strong)UIImageView *phoneImage;
@property(nonatomic,strong)UIImageView *verticalLine;
@property(nonatomic,strong)ZSCustomTextField *phoneTextField;
@property(nonatomic,strong)UIImageView *horizontalLine;

@property(nonatomic,strong)UIImageView *passwordImage;
@property(nonatomic,strong)UIImageView *verticalLine1;
@property(nonatomic,strong)ZSCustomTextField *passwordTextField;
@property(nonatomic,strong)UIImageView *horizontalLine1;

@property(nonatomic,strong)UIButton *leftBtn;
@property(nonatomic,strong)UIButton *rightBtn;

@property(nonatomic,strong)UIButton *loginBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"登录";
    self.view.backgroundColor=WWColor(240, 240, 240);
    
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image =[UIImage imageNamed:@"背景-拷贝123456"];
    [self.view addSubview:imageView];
    
    //[self customBackBtn];
    [self addLayout];
}

-(void)loginRequest
{
    NSMutableDictionary *paraments =[[NSMutableDictionary alloc]init];
    paraments[@"userName"] =self.phoneTextField.text;
    paraments[@"password"] =self.passwordTextField.text;
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"mobileLogin" paraments:paraments finish:^(id responseObject, NSError *error) {
        NSLog(@" 登录----%@----%@",responseObject,error);
        if ([responseObject[@"status"] isEqualToString:@"success"])
        {
            //userSig用于初始化腾讯sdk
            [USER_Defaults setObject:responseObject[@"user"][@"userSig"] forKey:@"userSig"];
            
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"nickName"] forKey:@"nickName"];
            if (responseObject[@"user"][@"bCard"] != [NSNull null]) {
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"bCard"] forKey:@"bCard"];
            }
            
            //判断是否有直播间
            if (responseObject[@"user"][@"baudit"] != [NSNull null]) {
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"baudit"] forKey:@"baudit"];
            }
            if ([responseObject[@"user"][@"userName"] isKindOfClass:[NSString class]]) {
                [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"userName"] forKey:@"account" ];
            }
        
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            [self  saveUserAccountInfo];
            [self getAndSaveCookie];
            
            
            [self goToMain];
        }else
        {
            [MBProgressHUD showError:@"账号或密码错误"];
        }
    }];
}
-(void)saveUserAccountInfo
{
    [[NSUserDefaults standardUserDefaults]setObject:self.phoneTextField.text forKey:@"userName"];
    [[NSUserDefaults standardUserDefaults]setObject:self.passwordTextField.text forKey:@"password"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
//注册按钮绑定方法
-(void)registBtnClick
{
    registViewController *registVC =[[registViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:registVC];
    [self presentViewController:nav animated:YES completion:nil];

}
//忘记密码
-(void)rightBtnClick:(UIButton *)btn
{
    ForgetPasswordViewController *ForgetPasswordVC =[[ForgetPasswordViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:ForgetPasswordVC];
    [self presentViewController:nav animated:YES completion:nil];

}
//登录按钮绑定方法
-(void)loginBtnClcik:(UIButton *)loginButton
{
    if (self.phoneTextField.text.length ==0||self.passwordTextField.text.length ==0)
    {
        [MBProgressHUD showError:@"账号或密码不能为空"];
    }else
    {
        [self loginRequest];
    }
}
//自动登录
-(void)leftBtnClick:(UIButton *)btn
{
    registViewController *vc =[[registViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil
     ];
}
-(void)getAndSaveCookie
{
    NSData *cookiesData =[NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage]cookies]];
    [[NSUserDefaults standardUserDefaults]setObject:cookiesData forKey:@"cookies"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
//进入主页
-(void)goToMain
{
    //MainViewController *liveVC =[[MainViewController alloc]init];
    HomepageViewController *liveVC =[[HomepageViewController alloc]init];

    liveVC.tabBarItem.image =[UIImage imageNamed:@""];
    UINavigationController *liveNav =[[UINavigationController alloc]initWithRootViewController:liveVC];
    liveNav.tabBarItem.image =[UIImage imageNamed:@"直播-拷贝-2"];
    liveNav.title =@"直播";
    
    MineViewController *mineVC =[[MineViewController alloc]init];
    UINavigationController *mineNav =[[UINavigationController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem.image =[UIImage imageNamed:@"我的"];
    mineNav.title =@"我的";
    
    
    SearchViewController *findVC =[[SearchViewController alloc]init];
    UINavigationController *findNav =[[UINavigationController alloc]initWithRootViewController:findVC];
    findNav.tabBarItem.image =[UIImage imageNamed:@"发现-(5)"];
    findNav.title =@"发现";
    
    UITabBarController *tabBar =[[UITabBarController   alloc]init];
    [[UITabBar appearance]setTintColor:[UIColor redColor]];
    tabBar.viewControllers =@[liveNav,findNav,mineNav];
    [self presentViewController:tabBar animated:YES completion:nil];

}

-(void)backBtnClick:(UIButton *)btn
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UIImageView *)logo
{
    if (!_logo)
    {
        _logo =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"1"]];
        _logo.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.logo];
    }
    return _logo;
}
-(UIImageView *)phoneImage
{
    if (!_phoneImage)
    {
        _phoneImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"手机"]];
        _phoneImage .translatesAutoresizingMaskIntoConstraints =NO;
         [self.view addSubview:self.phoneImage];
    }
    return _phoneImage;
}
-(UIImageView *)verticalLine
{
    if (!_verticalLine)
    {
        _verticalLine =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-969"]];
        _verticalLine.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.verticalLine];
    }
    return _verticalLine;
}
-(ZSCustomTextField *)phoneTextField
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
-(UIImageView *)horizontalLine
{
    if (!_horizontalLine)
    {
        _horizontalLine =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-970"]];
        _horizontalLine.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.horizontalLine];
    }
    return _horizontalLine;
}
-(UIImageView *)passwordImage
{
    if (!_passwordImage)
    {
        _passwordImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"密码-(1)"]];
        _passwordImage .translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.passwordImage];
    }
    return _passwordImage;
}
-(UIImageView *)verticalLine1
{
    if (!_verticalLine1)
    {
        _verticalLine1 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-969"]];
        _verticalLine1.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.verticalLine1];
    }
    return _verticalLine1;
}
-(ZSCustomTextField *)passwordTextField
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
-(UIImageView *)horizontalLine1
{
    if (!_horizontalLine1)
    {
        _horizontalLine1 =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"矩形-970"]];
        _horizontalLine1.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.horizontalLine1];
    }
    return _horizontalLine1;
}

//-(CustomRegistView *)registView
//{
//    if (!_registView)
//    {
//        _registView =[[CustomRegistView alloc]init];
//        _registView.backgroundColor =[UIColor whiteColor];
//        [_registView.eyeImageView removeFromSuperview];
//        _registView.nameLabel.text =@"手机号";
//        _registView.nameTextField.placeholder =@"+86";
//        _registView.passwordLabel.text =@"密码";
//        _registView.passwordTextField.placeholder =@"请输入密码";
//        _registView.layer.cornerRadius =5.0f;
//        _registView.clipsToBounds =YES;
//
//        _registView.translatesAutoresizingMaskIntoConstraints=NO;
//        [self.view addSubview:self.registView];
//    }
//    return _registView;
//}
//自动登陆
//-(UIButton  *)leftBtn
//{
//    if (!_leftBtn)
//    {
//        _leftBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_leftBtn setTitle:@"自动登录" forState:UIControlStateNormal];
//        [_leftBtn setImage:[UIImage imageNamed:@"矩形-6"] forState:UIControlStateNormal];
//        [_leftBtn setImageEdgeInsets:UIEdgeInsetsMake(kHeightChange(3), kWidthChange(3), kHeightChange(3), kWidthChange(3))];
//        
//        [_leftBtn setImage:[UIImage imageNamed:@"勾-(1)"] forState:UIControlStateSelected];
//        _leftBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(26)];
//        [_leftBtn setTitleColor:WWColor(192, 67, 73) forState:UIControlStateNormal];
//        [_leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _leftBtn.translatesAutoresizingMaskIntoConstraints =NO;
//        [self.view addSubview:self.leftBtn];
//    }
//    return _leftBtn;
//}

//立即注册
-(UIButton *)leftBtn
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
//忘记密码
-(UIButton *)rightBtn
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
-(UIButton *)loginBtn
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
//-(void)customBackBtn
//{
//    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame =CGRectMake(0, 0, 44, 44);
//    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
//    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationItem.leftBarButtonItem =backItem;
//    
//    UIButton *registBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//    registBtn.frame =CGRectMake(0, 0, 44, 44);
//    [registBtn setTitleColor:WWColor(16, 16, 16) forState:UIControlStateNormal];
//    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
//    [registBtn addTarget:self action:@selector(registBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *registItem =[[UIBarButtonItem alloc]initWithCustomView:registBtn];
//    self.navigationItem.rightBarButtonItem =registItem;
//    
//}
#pragma mark --pureLayout--
-(void)addLayout
{
//    [self.registView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(60)+64];
//    [self.registView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
//    [self.registView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
//    [self.registView autoSetDimension:ALDimensionHeight toSize:kHeightChange(260)];
    
    //logo
    [self.logo autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(222)];
    [self.logo autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(173)];
    [self.logo autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [self.logo autoSetDimension:ALDimensionHeight toSize:kHeightChange(120)];
    
    //登录按钮
    [self.loginBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(405)];
    [self.loginBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.loginBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    [self.loginBtn autoSetDimension:ALDimensionHeight toSize:kHeightChange(80)];

    //密码
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
    
    //账号
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

    //立即注册
    [self.leftBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.leftBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.loginBtn withOffset:kHeightChange(15)];
    [self.leftBtn autoSetDimensionsToSize:CGSizeMake(kWidthChange(150), kHeightChange(28))];
    
    //忘记密码
    [self.rightBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    [@[self.leftBtn,self.rightBtn]autoMatchViewsDimension:ALDimensionWidth];
    [@[self.leftBtn,self.rightBtn]autoMatchViewsDimension:ALDimensionHeight];
    [@[self.leftBtn,self.rightBtn]autoAlignViewsToAxis:ALAxisHorizontal];
    
}

#pragma mark - 获取时间差
- (NSString *)getTimeWithTime:(NSString *)timeString{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSDate *nowDate=[dateFormatter dateFromString:dateString];
    NSTimeInterval lateNow=[nowDate timeIntervalSince1970]*1;
    
    NSDate * sinceDate = [dateFormatter dateFromString:timeString];
    NSTimeInterval lateSince = [sinceDate timeIntervalSince1970]*1;
    
    NSTimeInterval cha =  lateSince-lateNow ;
    
    if ((int)cha<60) {
        return [NSString stringWithFormat:@"刚刚"];
    }
    else if ((int)cha/60<60) {
        //分
        return [NSString stringWithFormat:@"%d分前",(int)cha/60];
    }
    else{
        if ((int)cha/3600 < 24) {
            //时
            return [NSString stringWithFormat:@"%d时前", (int)cha/3600];
        } else {
            //天
            return [NSString stringWithFormat:@"%d天前", (int)cha/(3600*24)];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
