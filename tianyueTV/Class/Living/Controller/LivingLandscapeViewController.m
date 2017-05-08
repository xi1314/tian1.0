//
//  LivingLandscapeViewController.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/5.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "LivingLandscapeViewController.h"
#import "LivingLandscapeGiftView.h"
#import <TXRTMPSDK/TXLivePlayer.h>

@interface LivingLandscapeViewController ()
<TXLivePlayListener>

// 直播view
@property (weak, nonatomic) IBOutlet UIView *view_live;

// 直播状态topView
@property (weak, nonatomic) IBOutlet UIView *view_top;

// 直播状态bottomView
@property (weak, nonatomic) IBOutlet UIView *view_bottom;

// 弹幕内容输入框
@property (weak, nonatomic) IBOutlet UITextField *textF_input;

// 播放器
@property(nonatomic, strong) TXLivePlayer *livePlayer;

@end

@implementation LivingLandscapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view_top.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.view_bottom.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.textF_input.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    [self.textF_input setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"]; // 修改placeholder颜色
    
    // 开始播放直播
    [self startPlayer];

}

- (IBAction)btn_back:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 停止播放
    [self.livePlayer stopPlay];
    // 记得销毁view控件
    [self.livePlayer removeVideoWidget];
    
    //停止弹幕渲染，必须调用，否则会引起内存泄漏
    //    [self.renderer stop];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.view_top.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view_top.alpha = 0;
            self.view_bottom.alpha = 0;
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view_top.alpha = 1;
            self.view_bottom.alpha = 1;
        }];
    }
    
}


/**
 播放或暂停按钮响应
 
 @param sender 播放或暂停按钮
 */
- (IBAction)btn_playOrStop_action:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 暂停
        [self.livePlayer pause];
    }else {
        // 恢复
        [self.livePlayer resume];
    }
    
}


/**
 开启或关闭弹幕按钮响应
 
 @param sender 开启或关闭弹幕按钮
 */
- (IBAction)btn_openOrCloseBarrage_action:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        // 关闭
        
    }else {
        // 开启
        
    }
}


/**
 发送消息按钮响应
 
 @param sender 发送消息按钮
 */
- (IBAction)btn_sendMsg_action:(UIButton *)sender {
    
}


/**
 送礼物按钮响应

 @param sender 送礼物按钮
 */
- (IBAction)btn_giveGift_action:(UIButton *)sender {
    
}


#pragma mark - 腾讯视频播放相关
- (TXLivePlayer *)livePlayer {
    if (!_livePlayer) {
        _livePlayer = [[TXLivePlayer alloc] init];
        //        [_livePlayer setupVideoWidget:self.livingView.bounds containView:self.livingView insertIndex:0];
        _livePlayer.delegate = self;
        
        TXLivePlayConfig*  _config = [[TXLivePlayConfig alloc] init];
        //自动模式
        _config.bAutoAdjustCacheTime   = YES;
        _config.minAutoAdjustCacheTime = 1;
        _config.maxAutoAdjustCacheTime = 5;
        [_livePlayer setConfig:_config];
    }
    return _livePlayer;
}

// 开始播放
- (void)startPlayer
{
    //当设备在一定时间内没有触摸动作，iOS会锁屏，设置属性让他不会锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    //  [self.player play];
    //  NSString *flvUrl = @"";
    //  frame 参数被废弃，画面区域的大小改成了时刻铺满您传入的view
    [self.livePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:self.view_live insertIndex:0];
    //  self.flvUrl = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    [self.livePlayer startPlay:@"rtmp://live.hkstv.hk.lxdns.com/live/hks" type:PLAY_TYPE_LIVE_RTMP];
}

#pragma mark - TXLivePlayListener
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary*)param {
    NSLog(@"EvtID  %d",EvtID);
    //播放结束或网络断开
    //    || EvtID == -2301
    if (EvtID == 2006 ) {
        // 停止播放
        [self.livePlayer stopPlay];
        // 销毁view控件
        [self.livePlayer removeVideoWidget];
    }
}

- (void)onNetStatus:(NSDictionary*)param {
    //    NSLog(@"------param %@",param);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


