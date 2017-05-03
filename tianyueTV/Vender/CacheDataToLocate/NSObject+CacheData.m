//
//  NSObject+CacheData.m
//  Jiahaoyou2
//
//  Created by Jester Pendragon on 16/1/4.
//  Copyright © 2016年 XinJiYe. All rights reserved.
//

#import "NSObject+CacheData.h"
#import "CacheDataToLocate.h"

@implementation NSObject (CacheData)

//删除数据
- (void)removeDataFromUsersDefaults:(NSString *)key {
    [[CacheDataToLocate shareCacheData] removeDataFromLocate:key];
}

//存储数据
- (void)saveObjectToUsersDefaults:(id)obj andKey:(NSString *)key {
    [[CacheDataToLocate shareCacheData] saveObjectToLocate:obj andKey:key];
}
//保存数据
- (id)gainObjectFromUsersDefaults:(NSString *)key {
    
    return [[CacheDataToLocate shareCacheData] gainObjectFromLocate:key];
}

//存储整数
- (void)saveIntegerToUsersDefaults:(NSInteger)integer andKey:(NSString *)key {
    [[CacheDataToLocate shareCacheData] saveIntegerToLocate:integer andKey:key];
}
//取出整数
- (NSInteger)gainIntegerFromUsersDefaults:(NSString *)key {
    return [[CacheDataToLocate shareCacheData] gainIntegerFromLocate:key];
}

//存储double类型数值
- (void)saveDoubleToUsersDefaults:(double)dou andKey:(NSString *)key {
    [[CacheDataToLocate shareCacheData] saveDoubleToLocate:dou andKey:key];
}
//取出double类型数值
- (double)gainDoubleFromUsersDefaults:(NSString *)key {
    return [[CacheDataToLocate shareCacheData] gainDoubleFromLocate:key];
}

@end
