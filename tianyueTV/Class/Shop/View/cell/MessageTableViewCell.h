//
//  MessageTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"

@interface MessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;     //头像
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;        //留言
@property (weak, nonatomic) IBOutlet UILabel *standardLabel;       //规格
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;           //尺寸
@property (strong, nonatomic) NSArray *imageArr;                   //图片数组
@property (nonatomic, strong) MessageModel *cellModel;

@end
