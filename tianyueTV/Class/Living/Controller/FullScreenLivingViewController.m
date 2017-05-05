//
//  FullScreenLivingViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/21.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "FullScreenLivingViewController.h"
#import "livingView.h"
#import "HostInfoView.h"
#import "TextFieldView.h"
#import "GiftView.h"
//#import "ChatTableViewCell.h"
#import "TopView.h"
#import "BottomView.h"

#import "CustomPlayerButton.h"
#import "SettingView.h"

#import "NSString+Add.h"

#import "IQKeyboardManager.h"
#import "MBProgressHUD+MJ.h"
#import "UIImage+CustomImage.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

#import <BarrageRenderer.h>
#import <MediaPlayer/MediaPlayer.h>

#import "NSSafeObject.h"
#import "DMS.h"
#import "AppDelegate.h"

#import "GiftCollectionViewCell.h"
#import "PresentView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"

#import <ImSDK/ImSDK.h>
#import <TXRTMPSDK/TXLivePlayer.h>


@interface FullScreenLivingViewController ()
<TXLivePlayListener,
UICollectionViewDelegate,
UICollectionViewDataSource>
{
    BOOL _isClear;  // 是否有设置界面
    int _reconnectCount; // 断开后重连的次数
    DMS *_client;
    int _index;
}

@property(nonatomic,strong) BarrageRenderer *renderer;       //弹幕view
//@property(nonatomic,strong)livingView *livingView;          //直播view
@property(nonatomic, strong) UIView *livingView;            //直播view
@property(nonatomic,strong) TextFieldView *textFieldView;    //输入框
@property(nonatomic,strong) GiftView *giftView;              //礼物

@property(nonatomic,strong) TopView *topView;
@property(nonatomic,strong) BottomView *bottomView;

@property(nonatomic,strong) SettingView *settingView;
//播放器
@property(nonatomic, strong) TXLivePlayer *livePlayer;
@property(nonatomic, copy) NSString *flvUrl;        //视频地址
//进度轮
@property(nonatomic,strong) UIActivityIndicatorView *activityIndicatorView;
//互动
@property(nonatomic,strong) UIView *interactiveView;
//礼物排行榜
@property(nonatomic,strong) UITableView *listTableView;
@property(nonatomic,strong) NSMutableArray *danmuArray;
//聊天室
@property(nonatomic,strong) UITableView *chatTableView;
@property(nonatomic,strong) NSMutableArray *messagesArray;
//取消关注需要的参数
@property(nonatomic,copy) NSString *bcfocus;

//礼物数组
@property(nonatomic,strong) NSMutableArray *giftArray;
@property(nonatomic,strong) AnimOperationManager *giftManager;

//消息管理器
@property(nonatomic, strong) TIMManager *im_manager;
//会话对象
@property(nonatomic, strong) TIMConversation *grp_conversation;
//群组ID
@property(nonatomic, copy) NSString *groupID;
@property (nonatomic, strong) NSString *userIdentifiler;

@property (nonatomic, strong) NSString *userSig;

@end

@implementation FullScreenLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.livingView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.giftView];
    [self layout];
    [self startPlayer];
}

//横屏布局
- (void)layout {
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeBottom];

    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.topView autoSetDimension:ALDimensionHeight toSize:fHeightChange(50)];
    
    
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.bottomView autoSetDimension:ALDimensionHeight toSize:50];

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
    //    NSString *flvUrl = @"";
    //    frame 参数被废弃，画面区域的大小改成了时刻铺满您传入的view
    [self.livePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:self.livingView insertIndex:0];
//    self.flvUrl = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
//    [self.livePlayer startPlay:self.flvUrl type:PLAY_TYPE_LIVE_RTMP];
}

#pragma mark - button method
//点击返回竖屏
- (void)backButtonClick:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

// 关注
- (void)focusButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected == YES)
    {
        self.topView.focusButton.selected = YES;
        //        self.hostInfoView.focusImageView.image =[UIImage imageNamed:@"爱心红"];
        [self focusOnRequest];
    }
    else
    {
        self.topView.focusButton.selected = NO;
        //        self.hostInfoView.focusImageView.image =[UIImage imageNamed:@"爱心1"];
        [self cancleFocusRequest];
        
    }
}

// 礼物
- (void)giftButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected == YES)
    {
        self.giftView.hidden = NO;
        self.giftView.frame = CGRectMake(SCREEN_WIDTH - kWidthChange(400), SCREEN_HEIGHT - fWidthChange(260)-fHeightChange(100), kWidthChange(400), kHeightChange(260));
    } else {
        self.giftView.hidden = YES;
    }
}

// 设置
- (void)settingButtonClick:(UIButton *)btn
{
    self.settingView.hidden = NO;
    NSLog(@"setting");
}

// 分享
- (void)shareButtonClick:(id)sender
{
//    [self share];
    NSLog(@"share");
}

// 开始 暂停（横屏）
- (void)startButtonClick:(UIButton *)btn
{
    self.activityIndicatorView.center =self.view.center;
    btn.selected =!btn.selected;
    
    if (btn.selected ==YES)
    {
//        self.livingView.startBtn.selected =YES;
        [self.livePlayer pause];
    }else
    {
//        self.livingView.startBtn.selected =NO;
        [self.livePlayer resume];
    }
}

// 弹幕
- (void)barrageButtonClick:(UIButton *)btn
{
    btn.selected =!btn.selected;
    if (btn.selected ==YES)//弹幕消失
    {
        self.renderer.view.alpha =0;
    }else
    {
        self.renderer.view.alpha =1;
    }
}

#pragma mark - 设置view button method
// 软解
- (void)softBtnClick:(UIButton *)btn
{
    btn.selected=!btn.selected;
    if (btn.selected ==YES)
    {
        self.settingView.hardBtn.decodeButton.selected =YES;
        btn.selected =YES;
        //       [_option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
        NSLog(@"~~~~~1");
    }else
    {
        self.settingView.hardBtn.decodeButton.selected =NO;
        btn.selected =NO;
        //     [_option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        NSLog(@"~~~~~2");
    }
}

// 硬解
- (void)hardBtnClick:(UIButton *)btn
{
    btn.selected =!btn.selected;
    if (btn.selected==YES)
    {
        self.settingView.softBtn.decodeButton.selected =YES;
        btn.selected =YES;
        //       [_option setOptionValue:@(YES) forKey:PLPlayerOptionKeyVideoToolbox];
        NSLog(@"=====3");
        
    }else
    {
        self.settingView.softBtn.decodeButton.selected =NO;
        btn.selected =NO;
        //     [_option setOptionValue:@(NO) forKey:PLPlayerOptionKeyVideoToolbox];
        NSLog(@"=====4");
        
    }
}

// 音量大小
- (void)changerSound:(UISlider *)slider
{
    static UISlider *volumeViewSlider = nil;
    if (volumeViewSlider == nil)
    {
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        
        for (UIView* newView in volumeView.subviews)
        {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"])
            {
                volumeViewSlider = (UISlider*)newView;
                self.settingView.soundSlider.value=volumeViewSlider.value;
                break;
            }
        }
    }
}

// 改变屏幕亮度
- (void)changerBrightness:(UISlider *)slider
{
    [[UIScreen mainScreen]setBrightness:self.settingView.brightnessSlider.value];
}

// 改变弹幕透明度
- (void)changerAlpha:(UISlider *)slider
{
    _renderer.view.alpha =slider.value;
}

// 改变弹幕大小
- (void)changerSize:(UISlider *)slider
{
    
}

//返回按钮
- (void)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self quitChatRoom];

    // 停止播放
    [self.livePlayer stopPlay];
    // 记得销毁view控件
    [self.livePlayer removeVideoWidget];
    
    //停止弹幕渲染，必须调用，否则会引起内存泄漏
    //    [self.renderer stop];
}

#pragma mark - Collection delegate
// 发送礼物
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.giftArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"GiftCollectionViewCell";
    GiftCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.picImage.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@",self.giftArray[0][indexPath.row]]];
    cell.nameLabel.text =[NSString stringWithFormat:@"%@",self.giftArray[1][indexPath.row]];
    cell.priceLabel.text =[NSString stringWithFormat:@"%@",self.giftArray[2][indexPath.row]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GSPChatMessage *msg =[[GSPChatMessage alloc]init];
    msg.text =[NSString stringWithFormat:@" 赠送主播 %@",self.giftArray[1][indexPath.row]];
    msg.senderChatID =[NSString stringWithFormat:@"%ld",(long)indexPath.row];
    // 礼物模型
    GiftModel *giftModel = [[GiftModel alloc] init];
    giftModel.headImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.headUrl]];
    giftModel.name = msg.senderName;
    giftModel.giftImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.giftArray[0][indexPath.row]]];
    giftModel.giftName = msg.text;
    giftModel.giftCount = 1;
    
    [self.giftManager animWithUserID:[NSString stringWithFormat:@"%@",msg.senderChatID] model:giftModel finishedBlock:^(BOOL result) {
        
    }];
    
}

#pragma mark - networking method
// 关注的请求
- (void)focusOnRequest
{
    NSMutableDictionary *paraments = [[NSMutableDictionary alloc] initWithCapacity:2];
    paraments[@"user_id"] = self.uesr_id;
    paraments[@"bCastId"] = self.ID;
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"focusOnBc_app" paraments:paraments finish:^(id responseObject, NSError *error) {
        NSLog(@"!~~~~%@关注~~~~%@", responseObject, error);

        self.bcfocus = responseObject[@"bcfocus"];
//        self.topView.focusLabel.text = [NSString stringWithFormat:@"%@", responseObject[@"count"]];
        self.topView.focusLabel.text = @"0";
    }];
}

// 取消关注的请求
- (void)cancleFocusRequest
{
    NSMutableDictionary *paraments = [[NSMutableDictionary alloc] initWithCapacity:2];
    if (self.guanz_id)
    {
        paraments[@"id"] = self.guanz_id;
    }else
    {
        paraments[@"id"] = self.bcfocus;
    }
    paraments[@"bcId"] = self.ID;
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"deleteFocus_app" paraments:paraments finish:^(id responseObject, NSError *error) {
        NSLog(@"!~~~~%@取消关注~~~~%@", responseObject, error);

        self.topView.focusLabel.text = [NSString stringWithFormat:@"%@", responseObject[@"count"]];
    }];
    
}

// 灵桃越币查询
- (void)scoreQueryRequest {
    NSMutableDictionary *parements =[[NSMutableDictionary alloc] init];
    parements[@"uId"] =self.uesr_id;
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"score_and_integral" paraments:parements finish:^(id responseObject, NSError *error) {
        NSLog(@"---scoreQuery--%@------",responseObject);
        self.giftView.moneyLabel.text =[NSString stringWithFormat:@"%@",responseObject[@"score"]];
        self.giftView.coinsLabel.text =[NSString stringWithFormat:@"%@",responseObject[@"integral"]];
    }];
    
}

#pragma mark - Lazy method
- (BarrageRenderer *)renderer {
    if (!_renderer) {
        _renderer = [[BarrageRenderer alloc]init];
        _renderer.canvasMargin = UIEdgeInsetsMake(10, 10, 10, 10);
        _renderer.view.alpha = 1;
    }
    return _renderer;
}

-(UIView *)livingView
{
    if (!_livingView)
    {
        _livingView = [[UIView alloc] init];
        _livingView.backgroundColor = [UIColor blackColor];
        
    }
    return _livingView;
}

- (NSMutableArray *)danmuArray
{
    if (!_danmuArray) {
        _danmuArray = [NSMutableArray array];
    }
    return _danmuArray;
}

- (TopView *)topView
{
    if (!_topView)
    {
        _topView = [[TopView alloc] init];
        _topView.onlineLabel.text =[NSString stringWithFormat:@"%@",self.onlineNum];
        [_topView.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _topView.translatesAutoresizingMaskIntoConstraints =NO;
        
    }
    return _topView;
}

- (BottomView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[BottomView alloc] init];
        [_bottomView.startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.barrageButton addTarget:self action:@selector(barrageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_bottomView.sendBtn addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.giftBtn addTarget:self action:@selector(giftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.translatesAutoresizingMaskIntoConstraints =NO;
    }
    return _bottomView;
}

- (SettingView *)settingView
{
    if (!_settingView)
    {
        _settingView = [[SettingView alloc]init];
        _settingView.hidden=YES;
        [_settingView.softBtn.decodeButton addTarget:self action:@selector(softBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_settingView.hardBtn.decodeButton addTarget:self action:@selector(hardBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_settingView.soundSlider addTarget:self action:@selector(changerSound:) forControlEvents:UIControlEventValueChanged];
        
        [_settingView.brightnessSlider addTarget:self action:@selector(changerBrightness:) forControlEvents:UIControlEventValueChanged];
        
        [_settingView.alphaSlider addTarget:self action:@selector(changerAlpha:) forControlEvents:UIControlEventValueChanged];
        
        [_settingView.sizeSlider addTarget:self action:@selector(changerSize:) forControlEvents:UIControlEventValueChanged];
        
        [_settingView bringSubviewToFront:self.topView];
        [_settingView bringSubviewToFront:self.bottomView];
        _settingView.translatesAutoresizingMaskIntoConstraints =NO;
    }
    return _settingView;
}


- (GiftView *)giftView
{
    if (!_giftView)
    {
        _giftView = [[GiftView alloc] init];
//        _giftView = [[GiftView alloc] initWithFrame:CGRectMake(0, 0, 260, 200)];
        _giftView.hidden = YES;
        [_giftView bringSubviewToFront:self.chatTableView];
        _giftView.giftCollectionView.delegate = self;
        _giftView.giftCollectionView.dataSource = self;
        [self scoreQueryRequest];
        _giftView.translatesAutoresizingMaskIntoConstraints = NO;

    }
    return _giftView;
}

- (NSMutableArray *)giftArray
{
    if (!_giftArray)
    {
        NSArray *giftPic =[[NSArray alloc]initWithObjects:@"桃子-01-1",@"咖啡-1",@"鼓掌-1", nil];
        NSArray *giftName =[[NSArray alloc]initWithObjects:@"灵桃",@"咖啡",@"鼓掌", nil];
        NSArray *giftPrice =[[NSArray alloc]initWithObjects:@"10越币",@"10越币",@"10越币", nil];
        _giftArray =[[NSMutableArray alloc]initWithObjects:giftPic,giftName,giftPrice, nil];
    }
    return _giftArray;
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

- (void) onNetStatus:(NSDictionary*) param {
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

@end
