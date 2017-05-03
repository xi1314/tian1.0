//
//  CacheDataToLocate.m
//  Jiahaoyou2
//
//  Created by Jester Pendragon on 16/1/4.
//  Copyright © 2016年 XinJiYe. All rights reserved.
//

#import "CacheDataToLocate.h"
#import "FastCoder.h"

@implementation CacheDataToLocate

+ (instancetype)shareCacheData {
    static dispatch_once_t onceToken;
    static CacheDataToLocate *shareObj = nil;
    dispatch_once(&onceToken, ^{
        shareObj = [[[self class] alloc] init];
    });
    
    return shareObj;
}

- (void)removeDataFromLocate:(NSString *)key {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    [users removeObjectForKey:key];
    [users synchronize];
}

- (void)saveObjectToLocate:(id)obj andKey:(NSString *)key
{
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSData *data = [FastCoder dataWithRootObject:obj];
    [users setObject:data forKey:key];
    [users synchronize];
}

- (id)gainObjectFromLocate:(NSString *)key {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSData *data = [users objectForKey:key];
    
    if (!data) {
        return nil;
    }
    id obj = [FastCoder objectWithData:data];
    return obj;
}

- (void)saveIntegerToLocate:(NSInteger)integer andKey:(NSString *)key {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    [users setInteger:integer forKey:key];
    [users synchronize];
}

- (NSInteger)gainIntegerFromLocate:(NSString *)key {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSNumber *intes = [users objectForKey:key];
    if (intes) {
        return [intes integerValue];
    }else
        return -1;
}

- (void)saveDoubleToLocate:(double)dou andKey:(NSString *)key {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    [users setDouble:dou forKey:key];
    [users synchronize];
}

- (double)gainDoubleFromLocate:(NSString *)key {
    NSUserDefaults *users = [NSUserDefaults standardUserDefaults];
    NSNumber *dou = [users objectForKey:key];
    if (dou) {
        return [dou doubleValue];
    }else
        return -1;
}


@end
