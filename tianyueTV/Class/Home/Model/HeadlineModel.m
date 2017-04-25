//
//  HeadlineModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/25.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "HeadlineModel.h"

@implementation HeadlineModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"newsList" : @"HeadNewsModel"};
}

@end


@implementation HeadNewsModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"ID" : @"id"};
}

@end
