//
//  LivingSettingView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/5/10.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>


static CGFloat SettingViewWidth = 310;
static CGFloat SettingViewHeight = 205;

typedef void(^LivingSettingBlock)(NSInteger tag);

@interface LivingSettingView : UIView

// 按钮、滑动条回调
@property (nonatomic, copy) LivingSettingBlock block;

/**
 加载xib

 @return 设置view
 */
+ (instancetype)shareLivingSettingInstancetype;

@end
