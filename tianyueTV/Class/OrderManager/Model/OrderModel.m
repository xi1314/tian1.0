//
//  OrderModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

/**
 数组映射

 @return 字典
 */
+ (NSDictionary *)objectClassInArray{
    return @{@"orderSnList" : @"OrderSnModel"};
}

@end



@implementation OrderSnModel

/**
 数组映射

 @return 字典
 */
+ (NSDictionary *)objectClassInArray{
    return @{@"goodsList" : @"GoodsInfoModel"};
}

@end



@implementation GoodsInfoModel

/**
 参数字段修改

 @return 字典
 */
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}

@end

