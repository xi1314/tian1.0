//
//  CarpenteroomView.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/17.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "CarpenteroomView.h"
#import "HomeModel.h"
#import <UIButton+AFNetworking.h>


@interface CarpenteroomView ()
<UIScrollViewDelegate>

// 匠作间
@property (nonatomic, strong) UILabel *headLabel;

// 推荐匠作间
@property (nonatomic, strong) UILabel *recommendLabel;

// 直播滚动视图
@property (nonatomic, strong) UIScrollView *liveScrollView;

// 推荐匠人滚动视图
@property (nonatomic, strong) UIScrollView *recommendScrollView;

// 分页指示器
@property (nonatomic, strong) UIPageControl *livePage;

// 匠作间数组
@property (nonatomic, strong) NSArray *liveData;

// 分割线
@property (nonatomic, strong) UIView *lineView;

// 记录上一个点击的Button
@property (nonatomic, strong) UIButton *lastButton;

@end


@implementation CarpenteroomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeInterface];
    }
    return self;
}

- (void)initializeInterface {
    UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    gapView.backgroundColor = WWColor(235, 230, 230);
    [self addSubview:gapView];
    
    [self addSubview:self.headLabel];
    [self addSubview:self.liveScrollView];
    [self addSubview:self.lineView];
    [self addSubview:self.recommendLabel];
    [self addSubview:self.recommendScrollView];
    [self addSubview:self.livePage];
    
}

- (void)configCarpenterRoomWithData:(NSArray *)data {
    self.liveData = data;
    self.liveScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*data.count, _liveScrollView.height);
    self.livePage.numberOfPages = data.count;
    CGFloat liveWidth = SCREEN_WIDTH - 18*2;
    CGFloat buttonWidth = self.recommendScrollView.height - 20;
    // 在iPhone 5屏幕尺寸显示
    if (SCREEN_WIDTH == 320) {
        buttonWidth = self.recommendScrollView.height - 8;
    }
    CGFloat gapWidth = (SCREEN_WIDTH - 4 * buttonWidth) / 5;
    
    self.recommendScrollView.contentSize = CGSizeMake(data.count * (gapWidth + buttonWidth) + gapWidth, self.recommendScrollView.height);
    
    for (int i = 0; i < data.count; i++) {
        HomeLiveModel *model = (HomeLiveModel *)data[i];
        // 匠作间滚动视图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(18 + (18*2 + liveWidth)*i, 0, liveWidth, self.liveScrollView.height - 26)];
        imageView.userInteractionEnabled = YES;
        [imageView setImageURL:[NSURL URLWithString:model.img_cover]];
        imageView.tag = 100 + i;
        [self.liveScrollView addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToLiveRoom:)];
        [imageView addGestureRecognizer:tap];
        
        // 播放图标
        UIImageView *playImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, liveWidth/5, liveWidth/5)];
        playImage.center = CGPointMake(imageView.width/2, imageView.height/2);
        playImage.image = [UIImage imageNamed:@"home_play"];
        [imageView addSubview:playImage];
        
         // 推荐匠人滚动视图
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((gapWidth + buttonWidth) * i + gapWidth, 5, buttonWidth, buttonWidth);
        button.layer.cornerRadius = buttonWidth / 2;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(respondsToRecommendButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = 100 + i;
        
        [button setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:model.headUrl]];
        [self.recommendScrollView addSubview:button];
        // 默认选中第一个按钮
        if (i == 0) {
            button.layer.borderWidth = 2;
            button.layer.borderColor = WWColor(255, 103, 103).CGColor;
            button.selected = YES;
            _lastButton = button;
        }
    }
}


#pragma mark - Tap method
- (void)respondsToLiveRoom:(UITapGestureRecognizer *)sender {
    NSInteger tag = sender.view.tag - 100;
    NSLog(@"liveData %@; tag %ld",self.liveData,tag);
    if (self.liveBlock) {
        HomeLiveModel *LM = (HomeLiveModel *)self.liveData[tag];
        self.liveBlock(LM);
    }
}

#pragma mark - Button method
- (void)respondsToRecommendButton:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    [self swichButtonState:sender];
    
    // 点击时切换匠作间
    NSInteger index = sender.tag - 100;
 
    // 设置页码
    self.livePage.currentPage = index;
    
    [self.liveScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0)];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;

    // 设置页码
    self.livePage.currentPage = page;
    
    // 设置选择按钮
    UIButton *button = [self viewWithTag:100 + page];
    [self swichButtonState:button];

    // 推荐匠人滚动视图宽度
    CGFloat buttonWidth = self.recommendScrollView.height - 20;
    // 在iPhone 5屏幕尺寸显示
    if (SCREEN_WIDTH == 320) {
        buttonWidth = self.recommendScrollView.height - 8;
    }

    CGFloat gapWidth = (SCREEN_WIDTH - 4 * buttonWidth) / 5;
    
    // 从第四个头像后开始滑动
    if (page >= 3) {
        [self.recommendScrollView setContentOffset:CGPointMake((gapWidth + buttonWidth) * (page - 3), 0) animated:YES];
    }else {
        [self.recommendScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

#pragma mark - Private method
- (void)swichButtonState:(UIButton *)sender {
    // 移除上一个Button选中状态
    _lastButton.layer.borderWidth = 0;
    _lastButton.layer.borderColor = [UIColor clearColor].CGColor;
    _lastButton.selected = NO;
    
    // 设置当前选中的Button
    sender.layer.borderWidth = 2;
    sender.layer.borderColor = WWColor(255, 103, 103).CGColor;
    sender.selected = YES;
    _lastButton = sender;
}

#pragma mark - Getter method
- (UILabel *)headLabel {
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 16, 30, 30)];
        _headLabel.text = @"匠作间";
        _headLabel.font = [UIFont systemFontOfSize:14];
        [_headLabel sizeToFit];
    }
    return _headLabel;
}

- (UIScrollView *)liveScrollView {
    if (!_liveScrollView) {
        _liveScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.headLabel.bottom + 6, SCREEN_WIDTH, self.height*0.62)];
        _liveScrollView.pagingEnabled = YES;
        _liveScrollView.showsHorizontalScrollIndicator = NO;
        _liveScrollView.delegate = self;
    }
    return _liveScrollView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(30, self.liveScrollView.bottom, SCREEN_WIDTH - 60, 1)];
        _lineView.backgroundColor = LINE_COLOR;
    }
    return _lineView;
}

- (UILabel *)recommendLabel {
    if (!_recommendLabel) {
        _recommendLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, self.lineView.bottom + 6, 30, 30)];
        _recommendLabel.text = @"推荐匠作间";
        _recommendLabel.font = [UIFont systemFontOfSize:14];
        [_recommendLabel sizeToFit];
    }
    return _recommendLabel;
}

- (UIScrollView *)recommendScrollView {
    if (!_recommendScrollView) {
        _recommendScrollView = [[UIScrollView alloc] init];
        _recommendScrollView.frame = CGRectMake(0, self.recommendLabel.bottom + 6, SCREEN_WIDTH, self.height - self.recommendLabel.bottom - 6);
        _recommendScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _recommendScrollView;
}

- (UIPageControl *)livePage {
    if (!_livePage) {
        _livePage = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.liveScrollView.bottom - 16, SCREEN_WIDTH, 10)];
        _livePage.currentPage = 0;
        // 设置非选中页的圆点颜色
        _livePage.pageIndicatorTintColor = WWColor(234, 234, 234);
        // 选中页圆点颜色
        _livePage.currentPageIndicatorTintColor = WWColor(255, 103, 103);
    }
    return _livePage;
}

@end
