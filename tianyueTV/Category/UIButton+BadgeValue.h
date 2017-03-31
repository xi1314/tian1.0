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
 设置右上角的badge，调用该方法前需要先设置Button title
 
 @param badgeValue badge显示的数字
 @param color      badgeValue的背景色，text为白色
 */
- (void)setBadgeValue:(NSString *)badgeValue
        withBackColor:(UIColor *)color;

/**
 *  移除角标
 */
- (void)removeBadgeValue;
@end
