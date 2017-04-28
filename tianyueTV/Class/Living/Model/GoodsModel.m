//
//  GoodsModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "GoodsModel.h"

@implementation GoodsModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsList" : @"GoodsDetailModel"};
}

@end



@implementation GoodsDetailModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end

