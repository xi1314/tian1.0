//
//  WWChatRoomView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/12/5.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WWChatRoomView : UIView

// 消息数组
@property (nonatomic,strong) NSMutableArray *messageArray;

// 聊天界面
@property (nonatomic,strong) UITableView *chatRoomTableView;


@property (nonatomic,strong) UIScrollView *chatRoomView;

@end
