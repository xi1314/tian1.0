//
//  SearchViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

// 取消
@property (nonatomic, strong) UIButton *cancelButton;

// 搜索框
@property (nonatomic, strong) UITextField *textField;

@end


@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeInterface];
}


- (void)initilizeInterface {
    self.view.backgroundColor = WWColor(244, 244, 244);
    
    // 取消按钮
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setFrame:CGRectMake(SCREEN_WIDTH - 50, 32, 30, 30)];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:WWColor(144, 144, 144) forState:UIControlStateNormal];
    [_cancelButton setBackgroundColor:[UIColor clearColor]];
    [_cancelButton addTarget:self action:@selector(respondsToCancelButton:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [self.view addSubview:_cancelButton];
    
    // 搜索框
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(18, 30, SCREEN_WIDTH - 80, 32)];
    _textField.layer.cornerRadius = 3;
    _textField.borderStyle = UITextBorderStyleNone;
    _textField.backgroundColor = WWColor(235, 235, 235);
    _textField.tintColor = WWColor(144, 144, 144);
    [self.view addSubview:_textField];
    
    
}

#pragma mark - Button method
- (void)respondsToCancelButton:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
