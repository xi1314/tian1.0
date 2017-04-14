//
//  CommonUtil.h
//  WechatPayDemo
//
//  Created by Ze on 14-6-5.
//  Copyright (c) 2014年 liuyufeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

+ (NSString *)md5:(NSString *)input;

+ (NSString *)sha1:(NSString *)input;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;

@end
