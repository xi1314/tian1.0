//
//  FindingViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "FindingViewController.h"

@interface FindingViewController ()

@end

@implementation FindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initilizeInterface];
}


#pragma mark - Init method
- (void)initilizeInterface {
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_whiteback"] forBarMetrics:UIBarMetricsDefault];
    // item 颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // title字体
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"PingFangTC-Semibold" size:18]};
    
    self.title = @"发现";
}



@end
