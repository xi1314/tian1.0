//
//  CarpenteroomView.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/17.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

typedef void(^CarpenterBlock)(HomeLiveModel *model);

@interface CarpenteroomView : UIView

// 点击直播间
@property (nonatomic, copy) CarpenterBlock liveBlock;

/**
 刷新匠作间

 @param data model数组
 */
- (void)configCarpenterRoomWithData:(NSArray *)data;

@end
