//
//  CycleCarouselView.m
//  CycleCarouselView
//
//  Created by user on 15/10/23.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import "CycleCarouselView.h"

@interface CycleCarouselView () <UIScrollViewDelegate>

// 底部滑动视图
@property (nonatomic, strong) UIScrollView   *baseScroll;

// 轮播数据
@property (nonatomic, strong) NSMutableArray *imgArray;

// pageControl
@property (nonatomic, strong) UIPageControl  *pageCtrl;


@end

@implementation CycleCarouselView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        // 底部滑动视图
        self.baseScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 30)];
        self.baseScroll.backgroundColor = [UIColor clearColor];
        self.baseScroll.pagingEnabled = YES;
        self.baseScroll.delegate = self;
        [self.baseScroll setShowsHorizontalScrollIndicator:NO];
        [self addSubview:self.baseScroll];
        
        // pageControl
        self.pageCtrl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width, 30)];
        self.pageCtrl.currentPageIndicatorTintColor = WWColor(255, 79, 68);
        self.pageCtrl.pageIndicatorTintColor = WWColor(236, 236, 236);
        [self addSubview:self.pageCtrl];

    }
    return self;
}

#pragma mark - 刷新轮播图的数据
/**
 刷新轮播图的数据

 @param array 图片数组
 */
- (void)cycleImages:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    
    if (array.count < 2) {
        self.imgArray = [NSMutableArray arrayWithArray:array];
    }else {
        NSString *img_first = [array firstObject];
        NSString *img_last = [array lastObject];
        self.imgArray = [NSMutableArray arrayWithArray:array];
        [self.imgArray insertObject:img_last atIndex:0];
        [self.imgArray addObject:img_first];
    }
    
    for (UIImageView *temgImg in self.baseScroll.subviews) {
        if ([temgImg isMemberOfClass:[UIImageView class]]) {
            [temgImg removeFromSuperview];
        }
    }
    
    self.pageCtrl.numberOfPages = array.count;
    self.pageCtrl.currentPage = 0;
    
    for (int i = 0; i < self.imgArray.count; i ++) {
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.baseScroll.frame)*i, 0, CGRectGetWidth(self.baseScroll.frame), CGRectGetHeight(self.baseScroll.frame))];
        img.tag = 10 + i;
        img.contentMode = UIViewContentModeScaleToFill;
        img.userInteractionEnabled = YES;

        NSURL *url = [NSURL URLWithString:self.imgArray[i]];
        [img sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"goods_ad_placeholder"]];
    
        [self.baseScroll addSubview:img];
        
        UITapGestureRecognizer *imgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapAction:)];
        [img addGestureRecognizer:imgTap];
         
    }
    
    [self.baseScroll setContentOffset:CGPointMake(CGRectGetWidth(self.baseScroll.frame), 0)];
    [self.baseScroll setContentSize:CGSizeMake(CGRectGetWidth(self.baseScroll.frame) * self.imgArray.count, CGRectGetHeight(self.baseScroll.frame))];
}

#pragma mark - 滑动图片的点击
- (void)imgTapAction:(UITapGestureRecognizer *)tap {
    UIImageView *img = (UIImageView *)tap.view;
    int index = (int)img.tag - 10 - 1;

    if (self.block) {
        self.block(index);
    }

}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    int imgIndex = scrollView.contentOffset.x/CGRectGetWidth(self.baseScroll.frame);
    
    int imgCount = (int)self.imgArray.count;
    
    if (imgIndex == 0) {
        
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.baseScroll.frame) * (imgCount - 2), 0) animated:NO];
        [self.pageCtrl setCurrentPage:self.pageCtrl.numberOfPages - 1];
        
        if (self.block) {
            self.block((int)self.pageCtrl.numberOfPages - 1);
        }

    } else if (imgIndex == imgCount - 1) {
        
        [scrollView setContentOffset:CGPointMake(CGRectGetWidth(self.baseScroll.frame) * 1, 0) animated:NO];
        [self.pageCtrl setCurrentPage:0];
        
        if (self.block) {
            self.block(0);
        }

    } else {
        
        [self.pageCtrl setCurrentPage:imgIndex-1];
        
        if (self.block) {
            self.block(imgIndex-1);
        }

    }
}


@end

