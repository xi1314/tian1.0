//
//  NSString+Add.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/30.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "NSString+Add.h"

@implementation NSString (Add)

+(NSString *)getCurrentDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}


@end
