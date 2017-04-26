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
static NSString *findinfCellIndentifer = @"kFindinfCellIndentifer";

@interface HeadlineTableViewCell : UITableViewCell

/**
 刷新头条cell
 
 @param model 数据模型
 */
- (void)configCellWithModel:(HeadNewsModel *)model;

/**
 刷新发现cell
 
 @param model 数据模型
 */
- (void)configFindCellWithModel:(HeadNewsModel *)model;

@end
