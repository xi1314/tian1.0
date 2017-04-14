//
//  ShopModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/13.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"goodsAttributes"     : @"GoodStockModel",
             @"A_kind_of_attribute" : @"AttributeModel",
             @"messageList"         : @"MessageModel"};
}


@end



@implementation GoodStockModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end



@implementation MessageModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end
