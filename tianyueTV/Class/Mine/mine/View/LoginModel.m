//
//  LoginModel.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/4.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "LoginModel.h"

@implementation LoginModel

/**
 参数字段修改
 
 @return 字典
 */
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end
