//
//  HoneTianyueCategoryView.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/17.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

typedef void(^CategoryBlock)(void);

@interface HomeTianyueCategoryView : UIView

// Button点击block
@property (nonatomic, copy) CategoryBlock buttonBlock;

/**
 设置图片

 @param model 数据model
 */
- (void)configeCategoryViewWithModel:(HomeSelectModel *)model;

@end
