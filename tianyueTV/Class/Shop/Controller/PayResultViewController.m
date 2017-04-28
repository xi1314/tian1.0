//
//  PayResultViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "PayResultViewController.h"

@interface PayResultViewController ()

// 状态图片
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

// 支付状态
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

// 支付金额
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

// 支付方式
@property (weak, nonatomic) IBOutlet UILabel *payWayLabel;

// 确认按钮
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation PayResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"确认订单";
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBackItem:)];
//    self.navigationItem.leftBarButtonItem = backItem;
    
    if (_success) {
        self.imageView.image = [UIImage imageNamed:@"order_paySuccess"];
        self.stateLabel.text = @"恭喜你支付成功！";
        self.stateLabel.textColor = WWColor(0, 186, 55);
        self.payWayLabel.hidden = NO;
        self.priceLabel.hidden = NO;
        self.priceLabel.text = [NSString stringWithFormat:@"付款金额：%@元",_price];
        [self.button setTitle:@"完成" forState:UIControlStateNormal];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark - Button method
- (IBAction)button_action:(id)sender {
    [self.navigationController popToViewController:self.navigationController.viewControllers[2] animated:YES];
}




@end
