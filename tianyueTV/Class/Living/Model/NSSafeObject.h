//
//  NSSafeObject.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/11/25.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSafeObject : NSObject

//防止调用不存在方法 崩溃的
-(instancetype)initWithObject:(id)object;
-(instancetype)initWithObject:(id)object withSelector:(SEL)selector;
-(void)excute;

@end
