//
//  FindModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "FindModel.h"

@implementation FindModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"dataList" : @"FindLiveModel"};
}

@end


@implementation FindLiveModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end
