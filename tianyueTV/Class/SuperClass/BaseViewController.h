//
//  BaseViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong) UIView *baseMaskView;


/**
 添加遮罩到window
 */
- (void)addbaseMaskViewOnWindow;

/**
 返回按钮
 */
- (void)respondsToBaseViewBackItem;

/**
 点击遮罩
 */
- (void)touchBaseMaskView;

@end
