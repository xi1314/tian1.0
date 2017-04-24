//
//  MyLivingView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/22.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "MyLivingView.h"

#define Button_Tag 500

@interface MyLivingView ()

// 导航栏
@property (nonatomic, strong) UIView *topBgView;

// 返回按钮
@property (nonatomic, strong) UIButton *backButton;

// 设置按钮
@property (nonatomic, strong) UIButton *settingButton;

// 直播间名称
@property (nonatomic, strong) UILabel *roomName;

// 当前观看人数的标志
@property (nonatomic, strong) UIImageView *onlineImageView;

// 当前观看人数
@property (nonatomic, strong) UILabel *onlineLabel;

// 当前关注人数的标志
@property (nonatomic, strong) UIImageView *followImageView;

// 关注的人数
@property (nonatomic, strong) UILabel *followLabel;

// 切换摄像头
@property (nonatomic, strong) UIButton *cameraButton;

// 闪光灯
@property (nonatomic, strong) UIButton *lightButton;

// 播放
@property (nonatomic, strong) UIButton *playButton;

// 屏幕旋转
@property (nonatomic, strong) UIButton *swichScreen;

// 分享
@property (nonatomic, strong) UIButton *shareButton;

// 暂停按钮
@property (nonatomic, strong) UIButton *pauseButton;


@end


@implementation MyLivingView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initilizeSubviews];
    }
    return self;
}

/**
 添加控件
 */
- (void)initilizeSubviews {
    // 自定义导航栏
    _topBgView = [[UIView alloc] init];
    _topBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _topBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, NavigationBarHeight);
    [self addSubview:_topBgView];
    
    // 返回
    _backButton = [[UIButton alloc] init];
    [_backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(respondsToButton_action:) forControlEvents:UIControlEventTouchUpInside];
    _backButton.frame = CGRectMake(0, 20, 44, 44);
    _backButton.tag = Button_Tag;
    [_topBgView addSubview:_backButton];
    
    // 设置
    _settingButton = [[UIButton alloc] init];
    [_settingButton setImage:[UIImage imageNamed:@"设置-(2)"] forState:UIControlStateNormal];
    [_settingButton addTarget:self action:@selector(respondsToButton_action:) forControlEvents:UIControlEventTouchUpInside];
    _settingButton.frame = CGRectMake(SCREEN_WIDTH - 44, 20, 44, 44);
    _settingButton.tag = Button_Tag + 1;
    [_topBgView addSubview:_settingButton];
    
    // 房间名称
    _roomName = [[UILabel alloc] init];
    _roomName.font = [UIFont systemFontOfSize:17];
    _roomName.textColor = [UIColor whiteColor];
    _roomName.textAlignment = NSTextAlignmentCenter;
    [_topBgView addSubview:_roomName];
    
    // 聊天视图
    _chatView = [[WWChatRoomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - SCREEN_HEIGHT*0.38, SCREEN_WIDTH, SCREEN_HEIGHT*0.38)];
    _chatView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    [self addSubview:_chatView];
    
    // 观看人数
    _onlineImageView = [[UIImageView alloc] init];
    _onlineImageView.image = [UIImage imageNamed:@"眼睛2"];
    _onlineImageView.frame = CGRectMake(8, _topBgView.bottom + 10, 35, 22);
    [self addSubview:_onlineImageView];
    
    _onlineLabel = [[UILabel alloc] init];
    _onlineLabel.left = _onlineImageView.right + 2;
    _onlineLabel.top = _onlineImageView.bottom - 12;
    _onlineLabel.text = @"122";
    _onlineLabel.font = [UIFont systemFontOfSize:11];
    _onlineLabel.textColor = [UIColor whiteColor];
    [_onlineLabel sizeToFit];
    [self addSubview:_onlineLabel];
    
    // 关注人数
    _followImageView = [[UIImageView alloc] initWithFrame:CGRectMake(_onlineLabel.right + 5, _topBgView.bottom + 7, 22, 25)];
    _followImageView.image = [UIImage imageNamed:@"myFans"];
    [self addSubview:_followImageView];
    
    _followLabel = [[UILabel alloc] init];
    _followLabel.left = _followImageView.right + 2;
    _followLabel.top = _onlineLabel.top;
    _followLabel.textColor = [UIColor whiteColor];
    _followLabel.font = [UIFont systemFontOfSize:11];
    _followLabel.text = @"786";
    [_followLabel sizeToFit];
    [self addSubview:_followLabel];
    
    // 摄像头
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraButton.frame = CGRectMake(SCREEN_WIDTH - 40, _topBgView.bottom + 10, 25, 22);
    [_cameraButton setImage:[UIImage imageNamed:@"反转摄像头"] forState:UIControlStateNormal];
    [_cameraButton addTarget:self action:@selector(respondsToButton_action:) forControlEvents:UIControlEventTouchUpInside];
    _cameraButton.tag = Button_Tag + 2;
    [self addSubview:_cameraButton];
    
    // 闪光灯
    _lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _lightButton.size = CGSizeMake(19, 23);
    _lightButton.top = _cameraButton.bottom + 30;
    _lightButton.centerX = _cameraButton.centerX;
    [_lightButton setImage:[UIImage imageNamed:@"闪光灯自动"] forState:UIControlStateNormal];
    [_lightButton addTarget:self action:@selector(respondsToButton_action:) forControlEvents:UIControlEventTouchUpInside];
    _lightButton.tag = Button_Tag + 3;
    [self addSubview:_lightButton];
    
    // 播放
    _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _playButton.size = CGSizeMake(102, 130);
    _playButton.centerX = _chatView.centerX;
    _playButton.bottom = _chatView.top - 10;
    [_playButton setImage:[UIImage imageNamed:@"大播放"] forState:UIControlStateNormal];
    [_playButton addTarget:self action:@selector(respondsToButton_action:) forControlEvents:UIControlEventTouchUpInside];
    _playButton.tag = Button_Tag + 4;
    [self addSubview:_playButton];
    
    // 屏幕旋转
    _swichScreen = [UIButton buttonWithType:UIButtonTypeCustom];
    _swichScreen.size = CGSizeMake(63, 69);
    _swichScreen.centerY = _playButton.centerY;
    _swichScreen.right = _playButton.left - 30;
    [_swichScreen setImage:[UIImage imageNamed:@"横转竖"] forState:UIControlStateNormal];
    [_swichScreen addTarget:self action:@selector(respondsToButton_action:) forControlEvents:UIControlEventTouchUpInside];
    _swichScreen.tag = Button_Tag + 5;
//    [self addSubview:_swichScreen];
    
    // 分享
    _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareButton.size = CGSizeMake(43, 67);
    _shareButton.centerY = _playButton.centerY;
    _shareButton.left = _playButton.right + 35;
    [_shareButton setImage:[UIImage imageNamed:@"分享(1)w"] forState:UIControlStateNormal];
    [_shareButton addTarget:self action:@selector(respondsToButton_action:) forControlEvents:UIControlEventTouchUpInside];
    _shareButton.tag = Button_Tag + 6;
    [self addSubview:_shareButton];
    
    // 暂停
    _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pauseButton.size = CGSizeMake(23, 28);
    _pauseButton.centerX = _cameraButton.centerX;
    _pauseButton.centerY = _shareButton.centerY;
    _pauseButton.hidden = YES;
    _pauseButton.tag = Button_Tag + 7;
    [_pauseButton setImage:[UIImage imageNamed:@"矩形-5-拷贝"] forState:UIControlStateNormal];
    [_pauseButton addTarget:self action:@selector(respondsToButton_action:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_pauseButton];
}

/**
 设置数据

 @param model 数据模型
 */
- (void)configViewWithModel:(BroadCastModel *)model {
    self.onlineLabel.text = model.onlineNum;
    [self.onlineLabel sizeToFit];
    
    self.followLabel.text = model.focusNum;
    [self.followLabel sizeToFit];
    
    self.roomName.text = model.name;
    [self.roomName sizeToFit];
    self.roomName.center = CGPointMake(_topBgView.width/2, _topBgView.height/2 + 10);
}

/**
 横屏布局
 */
- (void)verticalScreenLayout {
    
}

/**
 竖屏布局
 */
- (void)horizontalScreenLayout {
    
}

/**
 开始直播
 */
- (void)starLiving {
    self.swichScreen.hidden = YES;
    self.playButton.hidden = YES;
    self.shareButton.hidden = YES;
    self.pauseButton.hidden = NO;
}

/**
 暂停直播
 */
- (void)pauseLiving {
    self.swichScreen.hidden = NO;
    self.playButton.hidden = NO;
    self.shareButton.hidden = NO;
    self.pauseButton.hidden = YES;
}

#pragma mark - Button method
- (void)respondsToButton_action:(UIButton *)sender {
    
    NSInteger tag = sender.tag - Button_Tag;
    if (self.livingBlock) {
        self.livingBlock(tag, sender);
    }
}

@end
