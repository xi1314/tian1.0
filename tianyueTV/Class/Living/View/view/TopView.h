//
//  TopView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopView : UIView

//返回按钮
@property(nonatomic,strong)UIButton *backButton;
//标题
@property(nonatomic,strong)UILabel *nameLabel;
//分享
@property(nonatomic,strong)UIButton *shareButton;
//关注
@property(nonatomic,strong)UIButton *focusButton;
//设置
@property(nonatomic,strong)UIButton *settingButton;
//关注图片
@property(nonatomic,strong)UIImageView *focusImageView;
@property(nonatomic,strong)UILabel *focusLabel;
//在线图像
@property(nonatomic,strong)UIImageView *onlineImageView;
@property(nonatomic,strong)UILabel *onlineLabel;

@end
