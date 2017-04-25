//
//  HeadlineTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/25.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadlineModel.h"

static NSString *headlineCellIndentifer = @"kHeadlineCellIndentifer";

@interface HeadlineTableViewCell : UITableViewCell

/**
 刷新cell
 
 @param model 数据模型
 */
- (void)configCellWithModel:(HeadNewsModel *)model;

@end
