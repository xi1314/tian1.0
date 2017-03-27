//
//  WWBiaoqiaoTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/30.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWBiaoqiaoTableViewCell : UITableViewCell
@property (nonatomic,strong) UIButton *biaoqianButton;//标签按钮
@property (nonatomic,strong) UIButton *changeButton;//修改按钮
@property (nonatomic,strong) UIButton *deleteButton;//删除按钮
@property (nonatomic,copy) void (^ChangeHandler)(NSInteger);
@property (nonatomic,copy) void (^DeleteHandler)(NSInteger);

@end
