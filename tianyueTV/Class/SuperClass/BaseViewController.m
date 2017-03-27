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
    //设置导航栏
    self.navigationController.navigationBar.barTintColor = WWColor(248, 248, 248);
    self.navigationController.navigationBar.tintColor = WWColor(51, 51, 51);
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WWColor(51, 51, 51),NSFontAttributeName:[UIFont systemFontOfSize:18]};
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBaseViewBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;
}


- (void)respondsToBaseViewBackItem {
    
}

#pragma mark -- Private method
- (void)maskViewAddTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBaseMaskView)];
    [self.baseMaskView addGestureRecognizer:tap];
}

- (void)hiddenBaseMaskView {
    [self.baseMaskView removeFromSuperview];
}


#pragma mark -- Getter method
- (UIView *)baseMaskView {
    if (!_baseMaskView) {
        _baseMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _baseMaskView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
    }
    return _baseMaskView;
}




@end
