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
#import "SearchViewController.h"
#import "JPUSHService.h"
#import "FindingViewController.h"

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:mineVC];
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
    
    FindingViewController * findingVC = [[FindingViewController alloc] init];
    UINavigationController *findingNav = [[UINavigationController alloc] initWithRootViewController:findingVC];
    findingNav.tabBarItem.image = [[UIImage imageNamed:@"tab_found"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findingNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_found_chosen"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    findingNav.title = @"发现";
    
    self.viewControllers = @[liveNav,findingNav,mineNav];
    
    
    // 设置推送标签
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:@"user_id"];
    NSString *userString = [NSString stringWithFormat:@"%@", userID];
    [JPUSHService setAlias:userString callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
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
