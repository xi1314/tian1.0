//
//  BrandComeInView.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/17.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BrandComeInView.h"

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

// 分页指示器
@property (nonatomic, strong) UIPageControl *pageControl;

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
    [self addSubview:self.pageControl];

}

- (void)configBrandViewWithArr:(NSArray *)brandArr {
    for (int i = 0; i < 4; i++) {
        BrandView *brandView = [[BrandView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.scrollView.height)];
        brandView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:brandView];
        
        if (i%2) {
            [brandView setButtonImage:[brandArr subarrayWithRange:NSMakeRange(0, 5)]];
        } else {
            [brandView setButtonImage:[brandArr subarrayWithRange:NSMakeRange(5, 5)]];
        }
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(respondsToTimer) userInfo:nil repeats:YES];
}

#pragma mark - Button method
- (void)respondsToArrowButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.block) {
        // 选中状态为收起，未选中为展开
        self.block(sender.selected);
    }
}

#pragma mark - Timer method
- (void)respondsToTimer {
    
    int index = self.scrollView.contentOffset.x / SCREEN_WIDTH;
    
    self.pageControl.currentPage = index%2;
    
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
        
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _timer.fireDate = [NSDate distantFuture];
    int index = scrollView.contentOffset.x / SCREEN_WIDTH;
    self.pageControl.currentPage = index % 2;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _timer.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
}

#pragma mark - Getter method
- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 60, 30)];
        _label.textColor = WWColor(81, 81, 81);
        _label.font = [UIFont fontWithName:@"PingFangTC-Semibold" size:14];
        _label.text = @"品牌入驻";
        [_label sizeToFit];
    }
    return _label;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.label.bottom, SCREEN_WIDTH, self.height - self.label.height)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*4, _scrollView.height);
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
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

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
        _pageControl.centerX = self.centerX;
        _pageControl.pageIndicatorTintColor = WWColor(234, 234, 234);
        _pageControl.currentPageIndicatorTintColor = WWColor(76, 76, 76);
        _pageControl.userInteractionEnabled = NO;
        _pageControl.numberOfPages = 2;
    }
    return _pageControl;
}

- (void)dealloc {
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
