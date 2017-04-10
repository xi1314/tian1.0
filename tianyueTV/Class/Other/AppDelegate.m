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

// 极光推送
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>


@interface AppDelegate () <JPUSHRegisterDelegate>
{
    Reachability *_reacha;
    NetworkStates _preStatus;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    [self jPushInit:launchOptions]; //极光推送
    [self talkingData]; // 分析数据
    [self firstLoad]; // 是否是第一次使用APP
    [self shareSDK]; // 分享
   // [PLPlayerEnv initEnv]; // 初始化播放器
   // [PLStreamingEnv initEnv]; // 初始化推流端
    [self checkNetworkStates]; // 网络状态的监听
    //对键盘的处理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
    manager.shouldResignOnTouchOutside = YES;
    
    return YES;
}


/**
 极光推送

 @param launchOptions 字典
 */
- (void)jPushInit:(NSDictionary *)launchOptions
{
    //极光push  appkey   f3c1cb42c33239e276ba95fe
    
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    //0 (默认值)表示采用的是开发证书，1 表示采用生产证书发布应用。
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"f3c1cb42c33239e276ba95fe"
                          channel:@"App Store"
                 apsForProduction:0
            advertisingIdentifier:nil];
}

// 分析数据
- (void)talkingData
{
    [TalkingData setExceptionReportEnabled:YES];
    
    [TalkingData sessionStarted:@"542E9E10184343A0961789A4BBEB0160" withChannelId:@""];
    [TalkingDataSMS init:@"542E9E10184343A0961789A4BBEB0160" withSecretId:@""];
}

// 是否是第一次使用APP
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

// 网络状态的监听
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

// 分享
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

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
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
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {

    /*
     NSDictionary *aps = userInfo[@"aps"];
     NSString *alert = aps[@"alert"];
     */
    
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
    completionHandler(UNNotificationPresentationOptionAlert);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    
    // 系统要求执行这个方法
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {

    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}


@end


