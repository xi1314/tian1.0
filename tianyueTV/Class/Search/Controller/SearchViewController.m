//
//  SearchViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "SearchViewController.h"

// 热门按钮tag
static NSInteger HotButtonTag = 200;

// 历史按钮tag
static NSInteger HistoryButtonTag = 300;

@interface SearchViewController ()

// 取消
@property (nonatomic, strong) UIButton *cancelButton;

// 搜索框
@property (nonatomic, strong) UITextField *textField;

// 热门数组
@property (nonatomic, strong) NSArray *hotDataSource;

// 历史数组
@property (nonatomic, strong) NSArray *historyDataSource;


@end


@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _hotDataSource = @[@"", @"", @"", @"", @"", @""];
    _historyDataSource =@[@"", @"", @""];
    [self initilizeInterface];
}

#pragma mark - Init method
- (void)initilizeDataSource {
    
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
    _textField.placeholder = @"搜索你想要的内容或者房间号";
    _textField.font = [UIFont systemFontOfSize:11];
    _textField.textColor = [UIColor darkGrayColor];
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:_textField];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 5, 20, 20)];
    imageView.image = [UIImage imageNamed:@"nav_search"];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
    [leftView addSubview:imageView];
    
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    // 热门搜索
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(self.textField.frame) + 20, 100, 30)];
    hotLabel.text = @"热门搜索";
    hotLabel.font = [UIFont systemFontOfSize:13];
    [hotLabel sizeToFit];
    hotLabel.textColor = WWColor(145, 145, 145);
    [self.view addSubview:hotLabel];
    
    // 热门按钮
    CGFloat buttonWidth = 70;
    CGFloat buttonHeight = 20;
    for (int i = 0; i < _hotDataSource.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(18 + (buttonWidth + 8) * (i % 4), CGRectGetMaxY(hotLabel.frame) + 10 + (buttonHeight + 10) * (i / 4), buttonWidth, buttonHeight);
        button.backgroundColor = [UIColor orangeColor];
        button.layer.cornerRadius = 2;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button setTitle:@"热点词语" forState:UIControlStateNormal];
        button.tag = HotButtonTag + i;
        [self.view addSubview:button];
    }
    
    // 分割线
    NSInteger count = self.hotDataSource.count / 4 + 1;
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(hotLabel.frame) + count * buttonHeight + 10 * (count + 1), SCREEN_WIDTH - 36, 1)];
    lineView.backgroundColor = LINE_COLOR;
    [self.view addSubview:lineView];
    
    // 历史搜索
    UILabel *historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, CGRectGetMaxY(lineView.frame) + 10, 100, 30)];
    historyLabel.text = @"历史搜索";
    historyLabel.font = [UIFont systemFontOfSize:13];
    [historyLabel sizeToFit];
    historyLabel.textColor = WWColor(145, 145, 145);
    [self.view addSubview:historyLabel];
    
    for (int i = 0; i < _historyDataSource.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(18 + (buttonWidth + 8) * (i % 4), CGRectGetMaxY(historyLabel.frame) + 10 + (buttonHeight + 10) * (i / 4), buttonWidth, buttonHeight);
        button.backgroundColor = [UIColor orangeColor];
        button.layer.cornerRadius = 2;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:11];
        [button setTitle:@"历史词语" forState:UIControlStateNormal];
        button.tag = HistoryButtonTag + i;
        [self.view addSubview:button];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Button method
- (void)respondsToCancelButton:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

@end
