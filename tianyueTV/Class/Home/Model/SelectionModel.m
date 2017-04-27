
//
//  SelectionModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/27.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "SelectionModel.h"

@implementation SelectionModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"sgoods1" : @"SelectionGoodModel",
             @"sgoods" : @"CustomGoodModel"};
}


@end


@implementation SelectionGoodModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end




@implementation CustomGoodModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end



