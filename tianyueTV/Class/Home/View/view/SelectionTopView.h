//
//  SelectionTopView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/27.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionModel.h"

@interface SelectionTopView : UIView

/**
 数据填充
 
 @param model 数据模型
 */
- (void)configSelectionViewWithModel:(CustomGoodModel *)model;

@end
