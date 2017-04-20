//
//  BrandComeInView.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/17.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BrandComeInView.h"
#import "BrandView.h"

@interface BrandComeInView ()
<UIScrollViewDelegate>

// 品牌入驻
@property (nonatomic, strong) UILabel *label;

// 滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

// 下拉箭头
@property (nonatomic, strong) UIButton *arrowButton;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

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
    
    for (int i = 0; i < 4; i++) {
        BrandView *brandView = [[BrandView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.scrollView.height)];
        brandView.backgroundColor = [UIColor purpleColor];
        [self.scrollView addSubview:brandView];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(respondsToTimer) userInfo:nil repeats:YES];
}

#pragma mark - Button method
- (void)respondsToArrowButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.block) {
        // 选中状态为收起，未选中为展开
        self.block(sender.selected);
    }
}

#pragma mark -- Timer method
- (void)respondsToTimer {
    
    int index = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    
    [self.scrollView setContentOffset:CGPointMake(SCREEN_WIDTH * (index + 1), 0) animated:YES];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x >= 3 * SCREEN_WIDTH) {
        // 向右，滑到第四个view时，将scroll view的偏移量重置为第二个view
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        
    } else if (scrollView.contentOffset.x <= 0){
        // 向左，滑到第一个view时，将scroll view的偏移量重置为第三个view
        self.scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * 2, 0);
        
    } else{
        return;
    }
    
}

/**
 *  滚动视图开始拖 动：暂停timer
 *
 *  @param scrollView 滚动视图
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _timer.fireDate = [NSDate distantFuture];
}

/**
 *  滚动视图停止拖动：启动timer
 *
 *  @param scrollView 滚动视图
 *  @param decelerate bool
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:2];
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
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, _scrollView.height);
        _scrollView.pagingEnabled = YES;
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        _scrollView.delegate = self;
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
