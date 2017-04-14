//
//  MessageTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

@interface MessageTableViewCell : UITableViewCell

// 头像
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;

// 留言
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

// 规格
@property (weak, nonatomic) IBOutlet UILabel *standardLabel;

// 尺寸
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

// 图片数组
@property (strong, nonatomic) NSArray *imageArr;

/**
 刷新cell
 
 @param model 地址model
 */
- (void)configCellWithModel:(MessageModel *)model;

@end
