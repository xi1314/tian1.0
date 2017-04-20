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

@interface TabbarViewController ()

@end

@implementation TabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [[UITabBar appearance]setTintColor:[UIColor redColor]];
    
    /*
    HomepageViewController *liveVC = [[HomepageViewController alloc]init];
    liveVC.tabBarItem.image = [UIImage imageNamed:@""];
    UINavigationController *liveNav = [[UINavigationController alloc]initWithRootViewController:liveVC];
    liveNav.tabBarItem.image = [UIImage imageNamed:@"直播-拷贝-2"];
    liveNav.title = @"直播";
    */
    
    
     HomeViewController *liveVC = [[HomeViewController alloc] init];
     liveVC.tabBarItem.image = [UIImage imageNamed:@""];
     UINavigationController *liveNav = [[UINavigationController alloc] initWithRootViewController:liveVC];
     liveNav.tabBarItem.image = [UIImage imageNamed:@"直播-拷贝-2"];
     liveNav.title = @"直播";
    
    
    MineViewController *mineVC = [[MineViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:mineVC];
    mineNav.tabBarItem.image = [UIImage imageNamed:@"我的"];
    mineNav.title = @"我的";
    
    
    SearchViewController *findVC = [[SearchViewController alloc]init];
    UINavigationController *findNav = [[UINavigationController alloc]initWithRootViewController:findVC];
    findNav.tabBarItem.image = [UIImage imageNamed:@"发现-(5)"];
    findNav.title = @"发现";
    
    self.viewControllers = @[liveNav,findNav,mineNav];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
