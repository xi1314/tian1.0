//
//  TianyueTools.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/10.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TianyueTools : NSObject


/**
 电话号码判断(包括手机和座机)
 
 @param mobileNum 输入的号码
 @return 是否为正确的电话号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;


/**
 手机号码验证
 
 @param mobile 输入的手机号码
 @return 是否为正确的手机号码
 */
+ (BOOL)isValidateMobile:(NSString *)mobile;


/**
 邮箱验证
 
 @param email 输入的邮箱地址
 @return 是否为正确的邮箱地址
 */
+ (BOOL)isValidateEmail:(NSString *)email;


/**
 车牌号验证
 
 @param carNo 输入的车牌号
 @return 是否为正确的车牌号
 */
+ (BOOL)validateCarNo:(NSString *)carNo;

@end



