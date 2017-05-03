//
//  NSObject+CacheData.h
//  Jiahaoyou2
//
//  Created by Jester Pendragon on 16/1/4.
//  Copyright © 2016年 XinJiYe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CacheData)

//删除数据
- (void)removeDataFromUsersDefaults:(NSString *)key;

//存储对象
- (void)saveObjectToUsersDefaults:(id)obj andKey:(NSString *)key;
//取出对象
- (id)gainObjectFromUsersDefaults:(NSString *)key;

//存储整数
- (void)saveIntegerToUsersDefaults:(NSInteger)integer andKey:(NSString *)key;
//取出整数
- (NSInteger)gainIntegerFromUsersDefaults:(NSString *)key;

//存储double类型数值
- (void)saveDoubleToUsersDefaults:(double)dou andKey:(NSString *)key;
//取出double类型数值
- (double)gainDoubleFromUsersDefaults:(NSString *)key;

@end
