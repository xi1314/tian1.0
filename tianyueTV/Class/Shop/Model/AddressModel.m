//
//  AddressModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/1.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

/**
 数组映射

 @return 字典
 */
+ (NSDictionary *)objectClassInArray {
    return @{@"sAddresses_list" : @"AddressInfoModel"};
}

@end

@implementation AddressInfoModel

/**
 参数字段修改

 @return 字典
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"id" : @"ID"};
}

@end
