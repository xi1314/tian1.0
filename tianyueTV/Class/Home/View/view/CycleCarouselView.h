//
//  CycleCarouselView.h
//  CycleCarouselView
//
//  Created by user on 15/10/23.
//  Copyright (c) 2015年 user. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 轮播图点击回调

 @param index 图片索引
 */
typedef void(^CycleCarouselViewBlock)(int index);


@interface CycleCarouselView : UIView

// 选择图片后回调
@property (nonatomic, copy) CycleCarouselViewBlock block;

/**
 刷新轮播图的数据
 
 @param array 图片数组
 */
- (void)cycleImages:(NSArray *)array;


@end





