//
//  NSStack.h
//  Jiahaoyou2
//
//  Created by Jester Pendragon on 16/1/5.
//  Copyright © 2016年 XinJiYe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSStack : NSObject {
    NSMutableArray *_stackArray;
}

- (BOOL)empty;

- (id)top;

- (void)pop;

- (void)push:(id)value;

@end
