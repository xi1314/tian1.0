//
//  WWMineView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WWMyViewButton.h"
@interface WWMineView : UIView
@property (nonatomic,copy) void (^FirstButtonHandler)();
@property (nonatomic,copy) void (^ScondButtonHandler)();
@property (nonatomic,copy) void (^ThirdButtonHandler)();
@property (nonatomic,copy) void (^FourButtonHandler)();
@property (nonatomic,copy) void (^FiveButtonHandler)();
@property (nonatomic,copy) void (^bianjiButtonHandler)();
@property (nonatomic,copy) void (^gestureClickedHandler)();
@property (nonatomic,copy) void (^zhuborenzhengHandler)();
@property (nonatomic,copy) void (^messageClickedHander)();//消息按钮

// 我的订单
@property (nonatomic, copy) void (^OrderClickHander)();


@property (nonatomic,strong) UIImageView *bigHeadView;
@property (nonatomic,strong) UIImageView *headImages;
@property (nonatomic,strong) UILabel *moneyLabel;//越币
@property (nonatomic,strong) UILabel *secondMoney;//第二货币
@property (nonatomic,strong) UIImageView *zhuboImage;//认证标志
@property (nonatomic,strong) UILabel *nameLabel;//昵称
@property (nonatomic,strong) WWMyViewButton *zhuBoRenzheng;//主播认证
@end
