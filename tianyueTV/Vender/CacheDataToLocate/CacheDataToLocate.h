//
//  CacheDataToLocate.h
//  Jiahaoyou2
//
//  Created by Jester Pendragon on 16/1/4.
//  Copyright © 2016年 XinJiYe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheDataToLocate : NSObject

+ (instancetype)shareCacheData;

//删除数据
- (void)removeDataFromLocate:(NSString *)key;

//保存对象
- (void)saveObjectToLocate:(id)obj andKey:(NSString *)key;
//取出对象
- (id)gainObjectFromLocate:(NSString *)key;

//保存整数
- (void)saveIntegerToLocate:(NSInteger)integer andKey:(NSString *)key;
//取出整数
- (NSInteger)gainIntegerFromLocate:(NSString *)key;

//保存double类型数值
- (void)saveDoubleToLocate:(double)dou andKey:(NSString *)key;
//取出double类型数值
- (double)gainDoubleFromLocate:(NSString *)key;

@end
