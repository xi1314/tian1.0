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

- (void)respondsToBaseViewBackItem;     //返回按钮

- (void)hiddenBaseMaskView;             //移除遮罩

@end
