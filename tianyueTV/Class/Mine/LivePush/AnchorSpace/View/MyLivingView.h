//
//  MyLivingView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/22.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWChatRoomView.h"
#import "AnchorSpaceModel.h"

typedef void(^MyLivingBlock)(NSInteger tag, UIButton *button);

@interface MyLivingView : UIView

// 按钮点击事件，通过tag值判断
@property (nonatomic, copy) MyLivingBlock livingBlock;

// 聊天视图
@property (nonatomic, strong) WWChatRoomView *chatView;


/**
 开始直播
 */
- (void)starLiving;


/**
 暂停直播
 */
- (void)pauseLiving;


/**
 设置数据
 
 @param model 数据模型
 */
- (void)configViewWithModel:(BroadCastModel *)model;


@end
