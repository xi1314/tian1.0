//
//  MessageModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/9.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "MessageModel.h"

@interface MessageModel ()

@end

@implementation MessageModel

- (void)setParaDic:(NSDictionary *)paraDic {
    _paraDic = paraDic;
    [self setValuesForKeysWithDictionary:paraDic];
    self.headImageStr = _paraDic[@"headUrl"];
    self.message = _paraDic[@"content"];
    NSString *attrStr = _paraDic[@"goodsAttr"];
    NSArray *arr1 = [attrStr componentsSeparatedByString:@","];
    NSString *standrad = arr1[0];
    NSArray *arr2 = [standrad componentsSeparatedByString:@";"];
    self.standard = [NSString stringWithFormat:@"%@:%@",arr2[0],arr2[1]];
    
    NSString *sizeStr = arr1[1];
    NSArray *arr3 = [sizeStr componentsSeparatedByString:@";"];
    self.size = [NSString stringWithFormat:@"%@:%@",arr3[0],arr3[1]];
    
    self.imgArr = [_paraDic[@"goodsImg"] componentsSeparatedByString:@","];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
