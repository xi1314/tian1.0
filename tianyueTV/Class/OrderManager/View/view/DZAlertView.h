//
//  DZAlertView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/20.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftHandleBlock)(UIButton *button);
typedef void(^RightHandleBlock)(UIButton *button);
typedef void(^HandleBlock)(UIButton *button);

@interface DZAlertView : UIView

+ (instancetype)shareDZAlertViewInstanceType;

/**
 自定义弹框

 @param message 提示内容
 @param leftTitle 左按钮title
 @param rightTitle 右按钮title
 @param leftHandle 左按钮点击操作
 @param rightHandle 右按钮点击操作
 */
- (void)initDZAlertViewMessage:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftHandle:(LeftHandleBlock)leftHandle rightHandle:(RightHandleBlock)rightHandle;

@end
