//
//  SearchViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "SearchViewController.h"
#import "FindHandle.h"

// 热门按钮tag
static NSInteger HotButtonTag = 200;

// 历史按钮tag
static NSInteger HistoryButtonTag = 300;

@interface SearchViewController ()
<UITextFieldDelegate>

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
    _historyDataSource = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyWords"];
    [self initilizeDataSource];
    
}

#pragma mark - Init method
- (void)initilizeDataSource {
    [FindHandle requestForHotWordWithCompleteBlock:^(id respondsObject, NSError *error) {
        
        if (respondsObject) {
            _hotDataSource = respondsObject;
            [self initilizeInterface];
        }
    }];
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
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.delegate = self;
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
    CGFloat buttonWidth = 80;
    CGFloat buttonHeight = 25;
    for (int i = 0; i < _hotDataSource.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18 + (buttonWidth + 8) * (i % 4), CGRectGetMaxY(hotLabel.frame) + 10 + (buttonHeight + 10) * (i / 4), buttonWidth, buttonHeight)];
        label.backgroundColor = [UIColor orangeColor];
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _hotDataSource[i];
        label.font = [UIFont systemFontOfSize:11];
        label.userInteractionEnabled = YES;
        label.textColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLabelTap:)];
        [label addGestureRecognizer:tap];
        [self.view addSubview:label];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18 + (buttonWidth + 8) * (i % 4), CGRectGetMaxY(historyLabel.frame) + 10 + (buttonHeight + 10) * (i / 4), buttonWidth, buttonHeight)];
        label.backgroundColor = [UIColor orangeColor];
        label.layer.cornerRadius = 2;
        label.layer.masksToBounds = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _historyDataSource[i];
        label.font = [UIFont systemFontOfSize:11];
        label.userInteractionEnabled = YES;
        label.textColor = [UIColor whiteColor];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLabelTap:)];
        [label addGestureRecognizer:tap];
        [self.view addSubview:label];
    }
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self requestWithWord:textField.text];
    // 开始搜索时，缓存搜索词汇
    NSArray *arr = [[NSUserDefaults standardUserDefaults] objectForKey:@"historyWords"];
    NSMutableArray *historyArr = [NSMutableArray arrayWithArray:arr];
    
    if (![historyArr containsObject:textField.text]) {
        [historyArr insertObject:textField.text atIndex:0];
        [[NSUserDefaults standardUserDefaults] setObject:historyArr forKey:@"historyWords"];
    }
    [self.view endEditing:YES];
    
    return YES;
}

#pragma mark - Button method
- (void)respondsToCancelButton:(UIButton *)sender {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)respondsToButton_action:(UIButton *)sender {
    [self requestWithWord:sender.titleLabel.text];
}


#pragma mark - Tap method
- (void)respondsToLabelTap:(UITapGestureRecognizer *)sender {
    UILabel *label = (UILabel *)sender.view;
    [self requestWithWord:label.text];
}


#pragma mark - Pravite method
- (void)requestWithWord:(NSString *)word {
    [FindHandle requestForLivingRoomWithWord:word completeBlock:^(id respondsObject, NSError *error) {
        NSArray *arr = respondsObject;
        
        if (self.searchBlock) {
            self.searchBlock(arr);
        }
    }];
}

@end
