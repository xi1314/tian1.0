//
//  TianyueTools.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/10.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "TianyueTools.h"

@implementation TianyueTools


/**
 电话号码判断

 @param mobileNum 输入的号码
 @return 是否为正确的电话号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    
    /**
     
     * 手机号码
     
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     * 联通：130,131,132,152,155,156,185,186
     
     * 电信：133,1349,153,180,189
     
     */
    
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    
    /**
     
     * 中国移动：China Mobile
     
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     
     */
    
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    
    /**
     
     * 中国联通：China Unicom
     
     * 130,131,132,152,155,156,185,186
     
     */
    
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    
    /** 中国电信：China Telecom   133,1349,153,180,189 */
    
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    /** 大陆地区固话及小灵通  区号：010,020,021,022,023,024,025,027,028,029 号码：七位或八位 */
    
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES) || ([regextestcm evaluateWithObject:mobileNum] == YES) || ([regextestct evaluateWithObject:mobileNum] == YES) || ([regextestcu evaluateWithObject:mobileNum] == YES) || ([regextestphs evaluateWithObject:mobileNum] == YES)) {
        
        return YES;
        
    }else{
        
        return NO;
        
    }
    
}


/**
 手机号码验证
 
 @param mobile 输入的手机号码
 @return 是否为正确的手机号码
 */
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    
    //手机号简单校验，以13， 15，18开头，八个 \d 数字字符
    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    //    NSLog(@"phoneTest is %@",phoneTest);
    
    return [phoneTest evaluateWithObject:mobile];
    
}


/**
 邮箱验证

 @param email 输入的邮箱地址
 @return 是否为正确的邮箱地址
 */
+ (BOOL)isValidateEmail:(NSString *)email
{
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
    
}


/**
 车牌号验证

 @param carNo 输入的车牌号
 @return 是否为正确的车牌号
 */
+ (BOOL)validateCarNo:(NSString *)carNo
{
    
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    
    
    return [carTest evaluateWithObject:carNo];
    
}

@end
