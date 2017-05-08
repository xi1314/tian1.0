//
//  TabbarViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/22.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "TabbarViewController.h"
#import "HomepageViewController.h"
#import "HomeViewController.h"
#import "MineViewController.h"
#import "JPUSHService.h"
#import "FindingViewController.h"
#import "MyViewController.h"
#import "LoginHandler.h"
#import <ImSDK/ImSDK.h>

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = WWColor(243, 243, 243);
    
    [[UITabBar appearance] setTintColor:WWColor(255, 65, 77)];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];

    /*
    HomepageViewController *liveVC = [[HomepageViewController alloc]init];
    liveVC.tabBarItem.image = [UIImage imageNamed:@""];
    UINavigationController *liveNav = [[UINavigationController alloc]initWithRootViewController:liveVC];
    liveNav.tabBarItem.image = [UIImage imageNamed:@"tabbar_living"];
    liveNav.title = @"直播";
    */
    
    
    HomeViewController *liveVC = [[HomeViewController alloc] init];
    UINavigationController *liveNav = [[UINavigationController alloc] initWithRootViewController:liveVC];
    liveNav.tabBarItem.image = [[UIImage imageNamed:@"tab_index"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    liveNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_index_chosen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    liveNav.title = @"直播";
    
    
    FindingViewController * findingVC = [[FindingViewController alloc] init];
    UINavigationController *findingNav = [[UINavigationController alloc] initWithRootViewController:findingVC];
    findingNav.tabBarItem.image = [[UIImage imageNamed:@"tab_found"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findingNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_found_chosen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findingNav.title = @"发现";
    
    /*
    MineViewController *mineVC = [[MineViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem.image = [[UIImage imageNamed:@"tab_personal information"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_personal information_chosen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.title = @"我的";
     */
    
    MyViewController *mineVC = [[MyViewController alloc] init];
    UINavigationController *mineNav = [[UINavigationController alloc] initWithRootViewController:mineVC];
    mineNav.tabBarItem.image = [[UIImage imageNamed:@"tab_personal information"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_personal information_chosen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    mineNav.title = @"我的";
    
    /*
    SearchViewController *findVC = [[SearchViewController alloc]init];
    UINavigationController *findNav = [[UINavigationController alloc]initWithRootViewController:findVC];
    findNav.tabBarItem.image = [[UIImage imageNamed:@"tab_found"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_found_chosen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findNav.title = @"发现";
    */

    self.viewControllers = @[liveNav,findingNav,mineNav];
    
    
    // 设置推送标签
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:@"user_id"];
    NSString *userString = [NSString stringWithFormat:@"%@", userID];
    [JPUSHService setAlias:userString callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}


/**
 登录数据请求网络
 */
- (void)requestNetwork_login
{
    NSString *phone = [self gainObjectFromUsersDefaults:@"userName"];
    NSString *pwd = [self gainObjectFromUsersDefaults:@"password"];
    @weakify(self);
    [LoginHandler requestForLoginWithPhone:phone
                                       pwd:pwd
                             completeBlock:^(id respondsObject, NSError *error) {
                                 @strongify(self);
                                 if (respondsObject) {
                                     
                                     LoginModel *loginM = (LoginModel *)respondsObject;
                                     [self saveObjectToUsersDefaults:loginM andKey:@"loginSuccess"];
                                     
                                     // 登录腾讯云通讯sdk
                                     [self loginIMSDk:loginM];
 
                                 }
                                 
                             }];
}


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
    
}


// 推送标签设置结果回调
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet*)tags
                    alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation != UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
