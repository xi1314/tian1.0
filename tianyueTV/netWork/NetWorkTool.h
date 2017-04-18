//
//  NetWorkTool.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/11.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>


typedef enum :NSUInteger{
    GET,  // get请求
    POST  // post请求

} requestMthod; // 请求方式

// 网络状态
typedef NS_ENUM(NSUInteger ,NetworkStates){
    NetworkStatusNone,  // 未连接
    NetworkStatus2G,    // 2G
    NetworkStatus3G,    // 3G
    NetworkStatus4G,    // 4G
    NetworkStatusWIFI   // WIFI
};

typedef void(^callBackBlock)(id responseObject ,NSError* error);

@interface NetWorkTool : AFHTTPSessionManager


/**
 单例

 @return 单例对象
 */
+ (instancetype)sharedTool;


/**
 网络状态判断

 @return 网络状态
 */
+ (NetworkStates)getNetworkStatus;


/**
 请求网络

 @param method 请求方式
 @param url 请求url（未添加域名的地址）
 @param paraments 请求参数
 @param finished 请求完成回调
 */
- (void)requestMethod:(requestMthod)method URL:(NSString *)url paraments:(id)paraments finish:(callBackBlock)finished;


/**
 请求网络

 @param method 请求方式
 @param server 域名地址
 @param url 请求url（未添加域名的地址）
 @param paraments 请求参数
 @param finished 请求完成回调
 */
- (void)requestMethod:(requestMthod)method serverAddress:(NSString *)server URL:(NSString *)url paraments:(id)paraments finish:(callBackBlock)finished;



@end
