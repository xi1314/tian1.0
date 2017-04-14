//
//  NSStack.m
//  Jiahaoyou2
//
//  Created by Jester Pendragon on 16/1/5.
//  Copyright © 2016年 XinJiYe. All rights reserved.
//

#import "NSStack.h"

@implementation NSStack

- (id)init {
    self = [super init];
    if (self) {
        _stackArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (BOOL)empty {
    return ((_stackArray == nil) || ([_stackArray count] == 0));
}

- (id)top {
    id value = nil;
    if (_stackArray&&[_stackArray count])
    {
        value = [_stackArray lastObject];
    }
    return value;
}

- (void)pop {
    if (_stackArray&&[_stackArray count])
    {
        [_stackArray removeLastObject];
    }
}

- (void)push:(id)value {
    [_stackArray addObject:value];
}

@end
