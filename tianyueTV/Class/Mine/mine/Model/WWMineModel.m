//
//  WWMineModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineModel.h"

@implementation WWMineModel
+ (instancetype)shareInstance{
    static WWMineModel *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)firstButtonClicked{
    
}
@end
