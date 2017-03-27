//
//  HostInfoView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/21.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostInfoView : UIView

//主播图像
@property(nonatomic,strong)UIImageView *headImageView;
//类型
@property(nonatomic,strong)UILabel *nameLabel;
//粉丝
@property(nonatomic,strong)UILabel *fans;
//粉丝数
@property(nonatomic,strong)UILabel *fansCount;
//关注
@property(nonatomic,strong)UIImageView *focusImageView;

@property(nonatomic,strong)UIButton *focusBtn;
//下边的灰线
@property(nonatomic,strong)UIImageView *line;
//互动
@property(nonatomic,strong)UIButton *interactiveBtn;
//礼物排行榜
@property(nonatomic,strong)UIButton *listBtn;

@property(nonatomic,strong)UIImageView *redLine;
@end
