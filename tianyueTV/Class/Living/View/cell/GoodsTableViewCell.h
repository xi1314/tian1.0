//
//  GoodsTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsModel.h"

static NSString *goodCellIndentifer = @"kGoodCellIndentifer";

@interface GoodsTableViewCell : UITableViewCell

/**
 刷新cell
 
 @param model 数据模型
 */
- (void)configCellWithModel:(GoodsDetailModel *)model;

@end
