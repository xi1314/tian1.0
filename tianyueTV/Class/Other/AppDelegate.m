//
//  AppDelegate.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/10.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "IQKeyboardManager.h"

//#import <PLPlayerKit/PLPlayerEnv.h>

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import "ViewController.h"

#import "MineViewController.h"
#import "SearchViewController.h"
//#import "PLMediaStreamingKit.h"
#import "GuideViewController.h"


#import "TalkingData.h"
#import "TalkingDataSMS.h"

#import "HomepageViewController.h"
#import "TabbarViewController.h"


@interface AppDelegate ()
{
    Reachability *_reacha;
    NetworkStates _preStatus;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self talkingData];//分析数据
    [self firstLoad];//是否是第一次使用APP
    [self shareSDK];//分享
  //  [PLPlayerEnv initEnv];//初始化播放器
   // [PLStreamingEnv initEnv];//初始化推流端
    [self checkNetworkStates];//网络状态的监听
    //对键盘的处理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
    manager.shouldResignOnTouchOutside = YES;
    
    return YES;
}
- (void)talkingData
{
    [TalkingData setExceptionReportEnabled:YES];
    
    [TalkingData sessionStarted:@"542E9E10184343A0961789A4BBEB0160" withChannelId:@""];
    [TalkingDataSMS init:@"542E9E10184343A0961789A4BBEB0160" withSecretId:@""];
}
- (void)firstLoad
{
    NSString *key = @"CFBundleShortVersionString";
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    
    NSString *currentVersion = [[NSUserDefaults standardUserDefaults]objectForKey:key];
    NSLog(@"前面%@----当前%@", lastVersion, currentVersion);

    if ([currentVersion isEqualToString:lastVersion])
    {
        //自动登录
        [self autoLogin];
    }else
    {
        self.window.rootViewController = [[GuideViewController alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)checkNetworkStates
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkChange) name:kReachabilityChangedNotification object:nil];
    _reacha = [Reachability reachabilityWithHostName:@"http://www.baidu.com"];
    [_reacha startNotifier];
}
- (void)networkChange
{
    NetworkStates currentStates = [NetWorkTool getNetworkStatus];
    if (currentStates == _preStatus) return;
    _preStatus = currentStates;
}

//自动登录
- (void)autoLogin
{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"cookies"])
    {
        NSLog(@"no cookies");
        self.window.rootViewController = [[ViewController alloc]init];
    }else
    {

        HomepageViewController *liveVC = [[HomepageViewController alloc]init];
        liveVC.tabBarItem.image = [UIImage imageNamed:@""];
        UINavigationController *liveNav = [[UINavigationController alloc]initWithRootViewController:liveVC];
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
        
        TabbarViewController *tabbar = [[TabbarViewController alloc] init];        
        tabbar.viewControllers = @[liveNav,findNav,mineNav];
        self.window.rootViewController = tabbar;
    }

}

- (void)shareSDK
{
    [ShareSDK registerApp:@"17b8b02db64b8"
          activePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
                 
                 //微信已注册
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx23f288ae6e7e2339"
                                       appSecret:@"e0dbe44258b82f5dfbc0d79662c8ac61"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1105742552"
                                      appKey:@"aUng5Dsublz1ital"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
