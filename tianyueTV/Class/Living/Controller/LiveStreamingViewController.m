//
//  LiveStreamingViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2017/2/10.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "LiveStreamingViewController.h"

#import <TXRTMPSDK/TXLivePush.h>
#import <TXRTMPSDK/TXLivePlayer.h>


#import "livingView.h"
#import "HostInfoView.h"
#import "TextFieldView.h"

@interface LiveStreamingViewController ()<TXLivePlayListener>
{
    TX_Enum_PlayType _playType;
    TXLivePlayConfig *_config;
    BOOL        _appIsInterrupt;
    BOOL        _play_switch;
    BOOL        _videoPause;

    NSString     *_playUrl;
}
@property(nonatomic,strong)livingView *livingView;
@property(nonatomic,strong)HostInfoView *hostInfoView;
@property(nonatomic,strong)TextFieldView *textFieldView;

//进度轮
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;
//播放器
@property(nonatomic,strong)TXLivePlayer *txLivePlayer;

@end

@implementation LiveStreamingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"TX SDK Version = %@",[[TXLivePush getSDKVersion]componentsJoinedByString:@"."]);//SDK版本信息
    
    _play_switch =NO;
    _videoPause =NO;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (_play_switch == YES)
    {
        if (self.txLivePlayer != nil) {
            self.txLivePlayer.delegate =nil;
            [self.txLivePlayer removeVideoWidget];
        }
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



//在低系统（如7.1.2）可能收不到这个回调，请在onAppDidEnterBackGround和onAppWillEnterForeground里面处理打断逻辑
-(void)onAudioSessionEvent:(NSNotification *)notification
{
    NSDictionary *info = notification.userInfo;
    AVAudioSessionInterruptionType type = [info[AVAudioSessionInterruptionTypeKey] unsignedIntegerValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        if (_play_switch == YES && _appIsInterrupt == NO) {
            if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4) {
                if (!_videoPause) {
                    [_txLivePlayer pause];
                    self.livingView.startBtn.selected =YES;
                }
            }
            _appIsInterrupt = YES;
        }
    }else{
        AVAudioSessionInterruptionOptions options = [info[AVAudioSessionInterruptionOptionKey] unsignedIntegerValue];
        if (options == AVAudioSessionInterruptionOptionShouldResume) {
            if (_play_switch == YES && _appIsInterrupt == YES) {
                if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4) {
                    if (!_videoPause) {
                        [_txLivePlayer resume];
                        self.livingView.startBtn.selected =NO;
                    }
                }
                _appIsInterrupt = NO;
            }
        }
    }
}

-(void)onAppDidEnterBackGround:(UIApplication*)app
{
    if (_play_switch == YES) {
        if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4) {
            if (!_videoPause) {
                [_txLivePlayer pause];
                self.livingView.startBtn.selected =YES;
            }
        }
    }
}
-(void)onAppWillEnterForeground:(UIApplication *)app
{
    [self addActivityIndicatorView];
    if (_play_switch == YES) {
        if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4) {
            if (!_videoPause) {
                [_txLivePlayer resume];
                self.livingView.startBtn.selected =NO;
            }
        }
    }
}
- (void)onAppDidBecomeActive:(UIApplication*)app {
    if (_play_switch == YES && _appIsInterrupt == YES) {
        if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4) {
            if (!_videoPause) {
                [_txLivePlayer resume];
                self.livingView.startBtn.selected =NO;
            }
        }
        _appIsInterrupt = NO;
    }
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAudioSessionEvent:) name:AVAudioSessionInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(void)startPlayer
{
    [self addActivityIndicatorView];
    [UIApplication sharedApplication].idleTimerDisabled =YES;
}
-(BOOL)startRtmp
{
    if (self.txLivePlayer != nil)
    {
        self.txLivePlayer.delegate =self;
        [self.txLivePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:self.livingView insertIndex:0];
        [self.txLivePlayer setRenderMode:RENDER_MODE_FILL_SCREEN];
        int result =[self.txLivePlayer startPlay:_playUrl type:_playType];
        if (result != 0)
        {
            NSLog(@"播放器启动失败");
            return NO;
        }
        _videoPause =NO;
    }
    
    return YES;
}
-(void)stopRtmp
{
    if (self.txLivePlayer != nil)
    {
        self.txLivePlayer.delegate =nil;
        [self.txLivePlayer stopPlay];
        [self.txLivePlayer removeVideoWidget];
    }
}
#pragma mark ---TXLivePlayListener
-(void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (EvtID == PLAY_EVT_PLAY_BEGIN)
        {
            [self.activityIndicatorView stopAnimating];
        }else if (EvtID == PLAY_ERR_NET_DISCONNECT || EvtID == PLAY_EVT_PLAY_END)
        {
            [self stopRtmp];
            _play_switch =NO;
            self.livingView.startBtn.selected = NO;
            [[UIApplication sharedApplication]setIdleTimerDisabled:NO];
            _videoPause =NO;
        }else if (EvtID == PLAY_EVT_PLAY_LOADING)
        {
            [self.activityIndicatorView startAnimating];
        }
        
    });
}
-(void)onNetStatus:(NSDictionary *)param
{
    NSDictionary *dict =param;
    int width =[(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_WIDTH] intValue];
    int height =[(NSNumber *)[dict valueForKey:NET_STATUS_VIDEO_HEIGHT] intValue];
}
- (void)addActivityIndicatorView {
    if (self.activityIndicatorView) {
        return;
    }
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _activityIndicatorView.center = CGPointMake(kWidth/2, kHeightChange(450/2));
    
    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView stopAnimating];
    
    self.activityIndicatorView = _activityIndicatorView;
}
#pragma mark ---lazy---竖屏下添加的控件
-(TXLivePlayer *)txLivePlayer
{
    if (!_txLivePlayer)
    {
        _txLivePlayer =[[TXLivePlayer alloc]init];
        
        if (_config == nil)
        {
            //自动模式
            _config =[[TXLivePlayConfig alloc]init];
            _config.bAutoAdjustCacheTime =YES;
            _config.minAutoAdjustCacheTime =1.0f;
            _config.maxAutoAdjustCacheTime =5.0f;
        }
        _txLivePlayer.enableHWAcceleration =YES;
        [_txLivePlayer setConfig:_config];
    }
    return _txLivePlayer;
}
-(livingView *)livingView
{
    if (!_livingView)
    {
        _livingView =[[livingView alloc]init];
        [_livingView.startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_livingView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_livingView.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_livingView.fullBtn addTarget:self action:@selector(fullBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        _livingView.translatesAutoresizingMaskIntoConstraints=NO;    [self.view addSubview:self.livingView];
    }
    return _livingView;
}
-(HostInfoView *)hostInfoView
{
    if (!_hostInfoView)
    {
        _hostInfoView =[[HostInfoView alloc]init];
//        [_hostInfoView.interactiveBtn addTarget:self action:@selector(interactiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_hostInfoView.listBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_hostInfoView.focusBtn addTarget:self action:@selector(focusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _hostInfoView.backgroundColor =[UIColor whiteColor];
        _hostInfoView.translatesAutoresizingMaskIntoConstraints =NO;    [self.view addSubview:self.hostInfoView];
    }
    return _hostInfoView;
}
-(TextFieldView *)textFieldView
{
    if (!_textFieldView)
    {
        _textFieldView =[[TextFieldView alloc]init];
        _textFieldView.translatesAutoresizingMaskIntoConstraints =NO;
//        [_textFieldView.giftBtn addTarget:self action:@selector(giftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_textFieldView.sendButton addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        _textFieldView.translatesAutoresizingMaskIntoConstraints =NO;
//        [_textFieldView bringSubviewToFront:self.chatTableView];
        [self.view addSubview:self.textFieldView];
    }
    return _textFieldView;
}
#pragma mark  ----touch event
-(void)startBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (sender.selected ==YES)
    {
        if (_play_switch ==YES)
        {
            if (_playType == PLAY_TYPE_VOD_FLV || _playType == PLAY_TYPE_VOD_HLS || _playType == PLAY_TYPE_VOD_MP4 )
            {
                if (_videoPause)
                {
                    [self.txLivePlayer resume];
                }else
                {
                    [self.txLivePlayer pause];
                }
                _videoPause = !_videoPause;
            }else
            {
                _play_switch = NO;
                [self stopRtmp];
                [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
            }
        }else
        {
            if (![self startRtmp])
            {
                return;
            }
            [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        }

    }else
    {
        if (_play_switch)
        {
            _play_switch =NO;
            [self stopRtmp];
        }
    }
}
#pragma mark  ------竖屏下的布局
-(void)addLayout
{
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.livingView autoSetDimension:ALDimensionHeight toSize:kHeightChange(450)];
    
    [self.hostInfoView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.hostInfoView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.hostInfoView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.livingView];
    [self.hostInfoView autoSetDimension:ALDimensionHeight toSize:kHeightChange(165)];

    [self.textFieldView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.textFieldView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.textFieldView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.textFieldView autoSetDimension:ALDimensionHeight toSize:kHeightChange(100)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
