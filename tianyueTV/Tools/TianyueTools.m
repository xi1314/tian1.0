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
 电话号码判断(包括手机和座机)

 @param mobileNum 输入的号码
 @return 是否为正确的电话号码
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    // 判断手机
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];

    /** 大陆地区固话及小灵通  区号：010,020,021,022,023,024,025,027,028,029 号码：七位或八位 */
    
    NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestphs = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if (([phoneTest evaluateWithObject:mobileNum] == YES) || ([regextestphs evaluateWithObject:mobileNum] == YES)) {
        
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
    
    //手机号简单校验，以13， 15，17，18开头
    
    NSString *phoneRegex = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    //    NSLog(@"phoneTest is %@",phoneTest);
    
    return [phoneTest evaluateWithObject:mobile];
    
}


/**
 判断手机运营商

 @param telephone 手机号码
 @return 运营商类型
 */
+ (TelVenderType)mobileOrUniconOrTele:(NSString *)telephone
{
    // 判断移动手机 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
    NSString *chinaMobile = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chinaMobile];
    
    if ([phoneTest evaluateWithObject:telephone]) {
        return TelVender_mobile;
    }
    
    
    // 判断联通手机 130,131,132,155,156,185,186,145,176,1709
    NSString *chinaUnicom = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    
    NSPredicate *unicomTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chinaUnicom];
    
    if ([unicomTest evaluateWithObject:telephone]) {
        return TelVender_unicom;
    }
    
    // 判断电信手机 133,153,180,181,189,177,1700
    NSString *chinaTele = @"(^1(3[3]|5[3]|7[7]|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    NSPredicate *teleTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", chinaTele];
    
    if ([teleTest evaluateWithObject:telephone]) {
        return TelVender_Telecommunications;
    }
    
    return -1; // 手机运营商错误的情况下返回
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





