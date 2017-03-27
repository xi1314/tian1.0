//
//  BaseHandler.h
//  tianyueTV
//
//  Created by MAC on 2017/3/27.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 网络请求完成后的回调block

 @param respondsObject 请求成功后返回的数据
 @param error 请求失败后返回的数据
 */
typedef void(^HandlerBlock)(id respondsObject,NSError *error);

@interface BaseHandler : NSObject

@end
