//
//  LoginHandler.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/4.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BaseHandler.h"
#import "LoginModel.h"

@interface LoginHandler : BaseHandler

/**
 登录
 
 @param phone 用户名
 @param pwd   密码
 @param completeBlock 返回值
 */
+ (void)requestForLoginWithPhone:(NSString *)phone
                             pwd:(NSString *)pwd
                   completeBlock:(HandlerBlock)completeBlock;

@end
