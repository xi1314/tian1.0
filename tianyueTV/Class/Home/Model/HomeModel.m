//
//  HomeModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/20.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeModel

/**
 数组映射

 @return 返回字典
 */
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"dataList" : @"HomeLiveModel"};
}

@end



@implementation HomeLiveModel

/**
 替换字段

 @return 返回字典
 */
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end


@implementation HomeSelectModel



@end
