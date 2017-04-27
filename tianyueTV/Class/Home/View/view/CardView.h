//
//  CardView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/27.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CycleCarouselView.h"
#import "SelectionModel.h"

@interface CardView : UIView

// 图片轮播
@property (nonatomic, strong) CycleCarouselView *cycleView;

/**
 轮播图数组
 
 @param dataArr 图片数组
 */
- (void)configCycleImageArr:(NSArray *)dataArr;

/**
 填充数据
 
 @param model 数据模型
 */
- (void)configCardViewWithModel:(SelectionGoodModel *)model;

@end
