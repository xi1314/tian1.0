//
//  livingView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/21.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface livingView : UIView

//在线
@property(nonatomic,strong)UIImageView *eye;
//在线人数
@property(nonatomic,strong)UILabel *onlineLabel;
//开始按钮
@property(nonatomic,strong)UIButton *startBtn;
//全屏按钮
@property(nonatomic,strong)UIButton *fullBtn;
//返回
@property(nonatomic,strong)UIButton *backBtn;
//分享
@property(nonatomic,strong)UIButton *shareBtn;
//标题
@property(nonatomic,strong)UILabel *titleLabel;
//店铺
@property(nonatomic,strong)UIButton *shopBtn;
//在线获取的礼物
@property(nonatomic,strong)UIButton *surpriseBtn;
//时间表
@property(nonatomic,strong)UILabel *timeLabel;
@end
