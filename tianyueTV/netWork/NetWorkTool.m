//
//  NetWorkTool.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/11.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "NetWorkTool.h"


@implementation NetWorkTool


/**
 单例
 
 @return 单例对象
 */
+ (instancetype)sharedTool
{
    static NetWorkTool *tool;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tool =[[NetWorkTool alloc]initWithBaseURL:nil];
        tool.requestSerializer.timeoutInterval =20.f;
        tool.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json", @"text/html",@"text/javascript",@"text/plain", nil];
    });
    return tool;
}


/**
 网络状态判断
 
 @return 网络状态
 */
+ (NetworkStates)getNetworkStatus
{
    NSArray *subviews =[[[[UIApplication sharedApplication]valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    //保持网络状态
    NetworkStates status =NetworkStatusNone;
    
    for (id child in subviews)
    {
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            //获取到状态栏码
            int networkType =[[child valueForKeyPath:@"dataNetworkType"]intValue];
            
            switch (networkType) {
                case 0:
                    status =NetworkStatusNone;
                    
                    break;
                case 1:
                    status = NetworkStatus2G;
                    
                    break;
                case 2:
                    status = NetworkStatus3G;
                    
                    break;
                case 3:
                    status = NetworkStatus4G;
                    
                    break;
                case 5:
                {
                    status = NetworkStatusWIFI;
                    
                }
                    break;
                default:
                    break;
            }
        }
    }
    return status;
}


/**
 请求网络
 
 @param method 请求方式
 @param url 请求url（未添加域名的地址）
 @param paraments 请求参数
 @param finished 请求完成回调
 */
- (void)requestMethod:(requestMthod)method URL:(NSString *)url paraments:(id)paraments finish:(callBackBlock)finished
{
    
    NSString *resultURL = [TIANYUESERVERADDRESS stringByAppendingString:url];
    
    if (method == GET)
    {
        [self GET:resultURL parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
          
            finished(nil,error);
        }];
    }else if (method ==POST)
    {
        [self POST :resultURL parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            finished(nil,error);
        }];
    }
}


/**
 请求网络
 
 @param method 请求方式
 @param server 域名地址
 @param url 请求url（未添加域名的地址）
 @param paraments 请求参数
 @param finished 请求完成回调
 */
- (void)requestMethod:(requestMthod)method serverAddress:(NSString *)server URL:(NSString *)url paraments:(id)paraments finish:(callBackBlock)finished
{
    
    NSString *resultURL = [server stringByAppendingString:url];
    
    if (method == GET)
    {
        [self GET:resultURL parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            finished(nil,error);
        }];
    }else if (method ==POST)
    {
        [self POST :resultURL parameters:paraments progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            finished(responseObject,nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            finished(nil,error);
        }];
    }
}



@end









