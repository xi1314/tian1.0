//
//  AnchorSpaceModel.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/18.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AnchorSpaceModel.h"

@implementation AnchorSpaceModel


/**
 数组映射
 
 @return 字典
 */
+ (NSDictionary *)objectClassInArray{
    return @{@"broadcast" : @"BroadCastModel"};
}


@end


@implementation BroadCastModel


/**
 参数字段修改
 
 @return 字典
 */
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"ID" : @"id"};
}


@end


