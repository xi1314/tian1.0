//
//  UIButton+BadgeValue.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (BadgeValue)
/**
 设置右上角的badge
 
 @param badgeValue badge显示的数字
 @param color      数字的颜色，默认为白色
 */
- (void)setBadgeValue:(NSString *)badgeValue
        withTextColor:(UIColor *)color;

/**
 *  移除角标
 */
- (void)removeBadge;
@end
