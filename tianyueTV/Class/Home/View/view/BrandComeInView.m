//
//  BrandComeInView.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/17.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BrandComeInView.h"

@interface BrandComeInView ()

// 品牌入驻
@property (nonatomic, strong) UILabel *label;

// 滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

// 下拉箭头
@property (nonatomic, strong) UIButton *arrowButton;

@end

@implementation BrandComeInView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeInterface];
    }
    return self;
}

- (void)initializeInterface {
    
    self.layer.masksToBounds = YES;
    
    [self addSubview:self.label];
    [self addSubview:self.scrollView];
    [self addSubview:self.arrowButton];
    
    CGFloat height = self.scrollView.height - 10;
    CGFloat gap = (SCREEN_WIDTH - height * 5) / 6;
    
    for (int i = 0; i < 10; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(gap + (height + gap) * i, 5, height, height);
        if (i > 4) {
            button.frame = CGRectMake(gap * 2 + (height + gap) * i, 5, height, height);
        }
        button.layer.cornerRadius = height/2;
        button.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:button];
    }
}

#pragma mark - Button method
- (void)respondsToArrowButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.block) {
        // 选中状态为收起，未选中为展开
        self.block(sender.selected);
    }
}

#pragma mark - Getter method
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 60, 30)];
        _label.text = @"品牌入驻";
        [_label sizeToFit];
        [_label setFont:[UIFont systemFontOfSize:14]];
    }
    return _label;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.label.bottom, SCREEN_WIDTH, self.height - self.label.height)];
        _scrollView.backgroundColor = [UIColor purpleColor];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, _scrollView.height);
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (UIButton *)arrowButton {
    if (!_arrowButton) {
        _arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _arrowButton.frame = CGRectMake(SCREEN_WIDTH - 33, 0, 25, self.label.height);
        [_arrowButton setImage:[UIImage imageNamed:@"home_arrow"] forState:UIControlStateNormal];
        [_arrowButton addTarget:self action:@selector(respondsToArrowButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _arrowButton;
}

@end
