//
//  BaseViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_whiteback"] forBarMetrics:UIBarMetricsDefault];
    // item 颜色
    self.navigationController.navigationBar.tintColor = WWColor(51, 51, 51);
    // title字体
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WWColor(51, 51, 51),NSFontAttributeName:[UIFont systemFontOfSize:18]};
}

#pragma mark -- Private method
- (void)touchBaseMaskView {

}


- (void)addbaseMaskViewOnWindow {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.baseMaskView];
}

#pragma mark -- Getter method
- (UIView *)baseMaskView {
    if (!_baseMaskView) {
        _baseMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _baseMaskView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBaseMaskView)];
        [_baseMaskView addGestureRecognizer:tap];
    }
    return _baseMaskView;
}


@end



