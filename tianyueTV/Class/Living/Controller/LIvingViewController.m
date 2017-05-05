//
//  LIvingViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "LIvingViewController.h"

#import "livingView.h"
#import "HostInfoView.h"
#import "TextFieldView.h"
#import "GiftView.h"
#import "ChatTableViewCell.h"
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


#import <MediaPlayer/MediaPlayer.h>

#import <BarrageRenderer.h>
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

#import "ShopDetailViewController.h"
#import "FullScreenLivingViewController.h"
#import "LivingHandler.h"
#import "GoodsModel.h"
#import "GoodsTableViewCell.h"


@class AppDelegate;
@interface LIvingViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, TIMMessageListener, TXLivePlayListener, TIMRefreshListener, TIMConnListener, TIMUserStatusListener>
{
    //是否全屏
    BOOL _isFullScreen;
    //是否有设置界面
    BOOL _isClear;
    //断开后重连的次数
    int _reconnectCount;
    DMS *_client;
    int _index;
}
@property(nonatomic,strong)livingView *livingView;          //直播view
@property(nonatomic,strong)HostInfoView *hostInfoView;      //主播信息
@property(nonatomic,strong)TextFieldView *textFieldView;
@property(nonatomic,strong)GiftView *giftView;

@property(nonatomic,strong)TopView *topView;
@property(nonatomic,strong)BottomView *bottomView;

@property(nonatomic,strong)SettingView *settingView;
//播放器
@property(nonatomic, strong) TXLivePlayer *livePlayer;
@property(nonatomic, copy) NSString *flvUrl;        //视频地址

//进度轮
@property(nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;
//互动
@property(nonatomic,strong)UIView *interactiveView;
//礼物排行榜
@property(nonatomic,strong)UITableView *listTableView;
//弹幕view
@property(nonatomic,strong)BarrageRenderer *renderer;
@property(nonatomic,strong)NSMutableArray *danmuArray;
//聊天室
@property(nonatomic,strong)UITableView *chatTableView;
@property(nonatomic,strong)NSMutableArray *messagesArray;
//取消关注需要的参数
@property(nonatomic,copy)NSString *bcfocus;

//礼物数组
@property(nonatomic,strong)NSMutableArray *giftArray;
@property(nonatomic,strong)AnimOperationManager *giftManager;

//消息管理器
@property(nonatomic, strong) TIMManager *im_manager;
//会话对象
@property(nonatomic, strong) TIMConversation *grp_conversation;
//群组ID
@property(nonatomic, copy) NSString *groupID;
@property (nonatomic, strong) NSString *userIdentifiler;
@property (nonatomic, strong) NSString *userSig;

// 商品数组
@property (nonatomic, strong) NSArray *goodsDataArr;

@end

@implementation LIvingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.groupID = @"@TGS#3MZOSFMED";
    [self joinChatRoom];
    
    _isFullScreen =NO;
    _isClear =NO;
    _reconnectCount =0;
    _index=0;
    //隐藏导航条
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    /*
    //手机
    if ([self.isPushPOM isEqualToString:@"1"])
    {
        self.flvUrl = self.ql_push_flow;
    } else //奥点云
    {
        self.flvUrl =self.playAddress;
    }
    */
     
    self.flvUrl = self.ql_push_flow;
    
    [self addLayout];
    
    [self initBarrageRenderer];
    [self.renderer start];
    
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
               [[[UIAlertView alloc] initWithTitle:nil message:@"网络错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                break;
                
            default:
         //      [self startPlayer];
                self.livingView.startBtn.selected = NO;
                self.bottomView.startButton.selected = NO;
                break;
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //在本控制器禁掉IQKeyboard的使用
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    //增加通知中心监听，当键盘出现或消失时收到消息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UIKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //直播开始
    [self startPlayer];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.view endEditing:YES];
    //别的控制器恢复IQKeyboard的使用
    [IQKeyboardManager sharedManager].enable =YES;
    
    //  [self.player resume];
    //  [self.player stop];
}

- (void)dealloc {
    
    //删除通知中心监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.renderer stop];
}

//进入直播间判断是否已经关注过
-(void)isFocusRequest
{
    //NSString *url =@"http://192.168.0.88:8081/follow_app";
//    NSString *url =@"http://www.tianyue.tv/follow_app";
    NSMutableDictionary *paraments =[[NSMutableDictionary alloc]init];
    paraments[@"user_id"] =self.uesr_id;
    paraments[@"id"] =self.ID;
    
    NSLog(@" ---uesr_id%@--ID%@--",self.uesr_id,self.ID);
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"follow_app" paraments:paraments finish:^(id responseObject, NSError *error) {
        
        NSLog(@" ------isFocusRequest---%@---",responseObject);
        if ([responseObject[@"ret"] isEqualToString:@"0"])
        {
            self.hostInfoView.focusBtn.selected =NO;
            self.hostInfoView.focusImageView.image =[UIImage imageNamed:@"爱心1"];
            
            self.topView.focusButton.selected =NO;
            
        }else if([responseObject[@"ret"] isEqualToString:@"1"])
        {
            self.hostInfoView.focusBtn.selected =YES;
            self.hostInfoView.focusImageView.image =[UIImage imageNamed:@"爱心红"];
            self.topView.focusButton.selected =YES;
            self.guanz_id =responseObject[@"guanz_id"];
        }
        self.followl =responseObject[@"followL"];
        self.hostInfoView.fansCount.text=[NSString stringWithFormat:@"%@",self.followl];
        self.topView.focusLabel.text =[NSString stringWithFormat:@"%@",self.followl];
        if (!self.followl)
        {
            self.hostInfoView.fansCount.text =@"--";
            self.topView.focusLabel.text =@"--";
        }
    }];
}

#pragma mark -- 腾讯视频播放相关
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

//开始播放
-(void)startPlayer
{
    [self addActivityIndicatorView];
    //当设备在一定时间内没有触摸动作，iOS会锁屏，设置属性让他不会锁屏
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
//    frame 参数被废弃，画面区域的大小改成了时刻铺满您传入的view
    [self.livePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:self.livingView insertIndex:0];
//    self.flvUrl = @"rtmp://live.hkstv.hk.lxdns.com/live/hks";
    
//    self.flvUrl = @"rtmp://7526.liveplay.myqcloud.com/live/7526_10339ty";
    
    [self.livePlayer startPlay:self.flvUrl type:PLAY_TYPE_LIVE_RTMP];
}

//添加进度轮
- (void)addActivityIndicatorView {
    if (self.activityIndicatorView) {
        return;
    }
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    _activityIndicatorView.center = CGPointMake(SCREEN_WIDTH/2, kHeightChange(450/2));

    [self.view addSubview:_activityIndicatorView];
    [_activityIndicatorView stopAnimating];
    
    self.activityIndicatorView = _activityIndicatorView;
}

//创建播放器
-(void)setUpPlayer
{
//    if (self.player.status != PLPlayerStatusError)
//    {
//        // add player view
//        UIView *playerView = self.player.playerView;
//        playerView.frame =self.livingView.bounds;
//        if ([self.isPushPOM isEqualToString:@"1"])
//        {
//            playerView.autoresizingMask =              UIViewAutoresizingFlexibleWidth
//            | UIViewAutoresizingFlexibleHeight;
//            playerView.contentMode = UIViewContentModeScaleAspectFit;
//        }else
//        {
//            playerView.autoresizingMask =              UIViewAutoresizingFlexibleWidth
//            | UIViewAutoresizingFlexibleHeight;
//        }
//        [self.view addSubview:playerView];
//        //把播放器放在父视图的最底下
//        [self.livingView insertSubview:playerView atIndex:0];
//    }
}


#pragma mark -- TXLivePlayListener
-(void) onPlayEvent:(int)EvtID withParam:(NSDictionary*)param {
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

-(void) onNetStatus:(NSDictionary*) param {
//    NSLog(@"------param %@",param);
}



#pragma mark --键盘显示
-(void)UIKeyboardWillShow:(NSNotification *)notification
{
    //键盘最后位置的大小
    CGRect keyBoardFrame =[notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //键盘的高
    CGFloat height =keyBoardFrame.origin.y;
    //键盘弹出的节奏
    NSInteger curve =[notification.userInfo[UIKeyboardAnimationCurveUserInfoKey]integerValue];
    //键盘弹出动画的执行时间
    CGFloat animationDuration =[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]floatValue];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:animationDuration];
    if (_isFullScreen==NO)
    {
        self.textFieldView.frame =CGRectMake(0,height-self.textFieldView.frame.size.height, self.textFieldView.frame.size.width, self.textFieldView.frame.size.height);

    }else
    {
        self.bottomView.frame =CGRectMake(0,height-self.bottomView.frame.size.height, self.bottomView.frame.size.width, self.bottomView.frame.size.height);
    }
    [UIView commitAnimations];
}
#pragma mark --键盘隐藏
-(void)UIKeyboardWillHide:(NSNotification *)notification
{
    if (_isFullScreen == NO)
    {
        CGRect frame =self.textFieldView.frame;
        frame.origin.y =self.view.frame.size.height-self.textFieldView.frame.size.height;
        self.textFieldView.frame =frame;
    }else
    {
    CGRect frame =self.bottomView.frame;
    frame.origin.y =self.view.frame.size.height-self.bottomView.frame.size.height;
    self.bottomView.frame =frame;
    }
}
#pragma mark ---lazy---竖屏下添加的控件
- (TIMManager *)im_manager {
    if (!_im_manager) {
        _im_manager = [TIMManager sharedInstance];
//        [_im_manager setEnv:0];
//        [_im_manager initSdk:[@"1400024555" intValue] accountType:@"10441"];
        [_im_manager setMessageListener:self];//设置消息回调
        [_im_manager setRefreshListener:self];
        [_im_manager setConnListener:self];//设置链接通知回调
        [_im_manager setUserStatusListener:self];
//        [_im_manager disableStorage]
    }
    return _im_manager;
}

- (TIMConversation *)grp_conversation {
    if (!_grp_conversation) {
        _grp_conversation = [self.im_manager getConversation:TIM_GROUP receiver:self.groupID
                             ];
    }
    return _grp_conversation;
}

- (livingView *)livingView
{
    if (!_livingView)
    {
        _livingView =[[livingView alloc]init];
        _livingView.onlineLabel.text =[NSString stringWithFormat:@"%@",self.onlineNum];
        _livingView.titleLabel.text =[NSString stringWithFormat:@"%@",self.name];
        [_livingView.startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_livingView.backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_livingView.shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_livingView.fullBtn addTarget:self action:@selector(fullBtnClcik:) forControlEvents:UIControlEventTouchUpInside];
        [_livingView.surpriseBtn addTarget:self action:@selector(surpriseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _livingView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addSubview:self.livingView];
    }
    return _livingView;
}

- (HostInfoView *)hostInfoView
{
    if (!_hostInfoView)
    {
        _hostInfoView =[[HostInfoView alloc]init];
        
//        [_hostInfoView.interactiveBtn addTarget:self action:@selector(interactiveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        [_hostInfoView.listBtn addTarget:self action:@selector(listBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_hostInfoView.focusBtn addTarget:self action:@selector(focusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _hostInfoView.backgroundColor =[UIColor whiteColor];
        _hostInfoView.nameLabel.text =[NSString stringWithFormat:@"%@",self.nickName];
        [_hostInfoView.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.headUrl]]];
        [self isFocusRequest];

        _hostInfoView.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.hostInfoView];
        
        @weakify(self);
        _hostInfoView.block = ^(NSInteger tag) {
            @strongify(self);
            if (tag == 0) { // 互动
                [self interactiveBtnClick];
            } else if (tag == 1) { // 匠人推荐
                [self listBtnClick];
            } else { // 定制
                
            }
        };
    }
    return _hostInfoView;
}

- (UITableView *)chatTableView
{
    if (!_chatTableView)
    {
        _chatTableView =[[UITableView alloc]init];
        _chatTableView.rowHeight =kHeightChange(55);
        _chatTableView.delegate =self;
        _chatTableView.dataSource =self;
        _chatTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
        _chatTableView.backgroundColor =[UIColor greenColor];
        _chatTableView.backgroundColor =WWColor(235, 235, 235);
        _chatTableView.showsVerticalScrollIndicator=NO;
        _chatTableView.translatesAutoresizingMaskIntoConstraints=NO;
        [self.view addSubview:self.chatTableView];
    }
    return _chatTableView;
}

- (NSMutableArray *)messagesArray
{
    if (!_messagesArray)
    {
//        _messagesArray =[[NSMutableArray alloc] initWithCapacity:50];
        _messagesArray = [NSMutableArray array];
    }
    return _messagesArray;
}

- (UITableView *)listTableView
{
    if (!_listTableView)
    {
        _listTableView =[[UITableView alloc]init];
        _listTableView.hidden =YES;
        _listTableView.rowHeight =kHeightChange(120);
        _listTableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.listTableView];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _listTableView.showsVerticalScrollIndicator = NO;
    }
    return _listTableView;
}

- (TextFieldView *)textFieldView
{
    if (!_textFieldView)
    {
        _textFieldView =[[TextFieldView alloc]init];
        _textFieldView.translatesAutoresizingMaskIntoConstraints =NO;
        [_textFieldView.giftBtn addTarget:self action:@selector(giftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_textFieldView.sendButton addTarget:self action:@selector(sendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _textFieldView.translatesAutoresizingMaskIntoConstraints =NO;
        [_textFieldView bringSubviewToFront:self.chatTableView];
        [self.view addSubview:self.textFieldView];
    }
    return _textFieldView;
}

-(GiftView *)giftView
{
    if (!_giftView)
    {
        _giftView =[[GiftView alloc]init];
        _giftView.hidden=YES;
        [_giftView bringSubviewToFront:self.chatTableView];
        _giftView.giftCollectionView.delegate =self;
        _giftView.giftCollectionView.dataSource =self;
        [self scoreQueryRequest];
        _giftView.translatesAutoresizingMaskIntoConstraints =NO;[self.view addSubview:self.giftView];
    }
    return _giftView;
}
#pragma mark  ----灵桃和越币的查询
-(void)scoreQueryRequest
{
//    NSString *url =@"http://192.168.0.88:8080/score_and_integral";
    //NSString *url =@"http://www.tianyue.tv/score_and_integral";
    NSMutableDictionary *parements =[[NSMutableDictionary alloc]init];
    parements[@"uId"] =self.uesr_id;
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"score_and_integral" paraments:parements finish:^(id responseObject, NSError *error) {
        NSLog(@"---scoreQuery--%@------",responseObject);
        self.giftView.moneyLabel.text =[NSString stringWithFormat:@"%@",responseObject[@"score"]];
        self.giftView.coinsLabel.text =[NSString stringWithFormat:@"%@",responseObject[@"integral"]];
    }];
    
}
//灵桃送礼
-(void)integralRequest
{
//    NSString *url =@"http://192.168.0.88:8080/modifyIntegral_app";
    NSMutableDictionary *parements =[[NSMutableDictionary alloc]init];
    parements[@"userId"] =self.uesr_id;
    parements[@"receiveId"]=self.nickName;
    parements[@"score"] =@"10";
    parements[@"num"] =@"1";
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"modifyIntegral_app" paraments:parements finish:^(id responseObject, NSError *error) {
      
        NSLog(@"---integralRequest--%@------",responseObject);

        
    }];
}

//越币送礼
-(void)scoreRequest
{
//    NSString *url =@"http://192.168.0.88:8080/modifyScore_app";
    NSMutableDictionary *parements =[[NSMutableDictionary alloc]init];
    parements[@"userId"] =self.uesr_id;
    parements[@"receiveId"]=self.nickName;
    parements[@"score"] =@"10";
    parements[@"num"] =@"1";
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"modifyScore_app" paraments:parements finish:^(id responseObject, NSError *error) {
        NSLog(@"---scoreRequest--%@------",responseObject);
    }];
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

    [self.giftView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.giftView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.giftView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.textFieldView ];
    [self.giftView autoSetDimension:ALDimensionHeight toSize:kHeightChange(260)];
    
    [self.chatTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.hostInfoView];
    [self.chatTableView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.chatTableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.textFieldView];
    [self.chatTableView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];

    [self.textFieldView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.textFieldView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.textFieldView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.textFieldView autoSetDimension:ALDimensionHeight toSize:kHeightChange(100)];

    [self.listTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.hostInfoView withOffset:kHeightChange(2)];
    [self.listTableView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.listTableView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.listTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
}

#pragma mark ------竖屏下按钮的触发事件
//互动
-(void)interactiveBtnClick
{
    self.listTableView.hidden = YES;
}

//商城
-(void)listBtnClick
{
    self.listTableView.hidden = NO;
    [self requestGoodDataSource];
}



//竖屏下关注按钮的点击事件
-(void)focusBtnClick:(UIButton *)btn
{
    btn.selected =!btn.selected;
    if (btn.selected ==YES)
    {
        self.topView.focusButton.selected =YES;
        self.hostInfoView.focusImageView.image =[UIImage imageNamed:@"爱心红"];
        [self focusOnRequest];
    }else
    {
        self.topView.focusButton.selected =NO;
        self.hostInfoView.focusImageView.image =[UIImage imageNamed:@"爱心1"];
        [self cancleFocusRequest];
    }
}
//分享
-(void)shareBtnClick:(id)sender
{
    [self share];
}
//在线时间获取的小礼物
-(void)surpriseBtnClick:(UIButton *)btn
{
    if (btn.selected ==YES)
    {
        
    }
        
}
//开始 暂停（竖屏）
-(void)startBtnClick:(UIButton *)btn
{
    if (_isFullScreen == NO)
    {
        _activityIndicatorView.center = CGPointMake(SCREEN_WIDTH/2, kHeightChange(450/2));
        btn.selected =!btn.selected;
        
        if (btn.selected ==YES)
        {
            self.bottomView.startButton.selected =YES;
            [self.livePlayer pause];
        }else
        {
            self.bottomView.startButton.selected =NO;
            [self.livePlayer resume];
        };
    }
}
//礼物按钮
-(void)giftBtnClick:(UIButton *)btn
{
    btn.selected =!btn.selected;
    if (btn.selected ==YES)
    {
        self.giftView.hidden =NO;
    }else
    {
        self.giftView.hidden =YES;
    }
}

#pragma mark -----礼物-----
- (AnimOperationManager *)giftManager {
    if (!_giftManager) {
        _giftManager = [AnimOperationManager sharedManager];
        _giftManager.parentView = self.view;
        _giftManager.parentView.alpha =1;
    }
    return _giftManager;
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


#pragma mark -- Collection delegate
//发送礼物
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

#pragma mark - 聊天室
//加入群聊聊天室
- (void)joinChatRoom {
    if ([USER_Defaults boolForKey:@"IM_Login"]) {
        [[TIMGroupManager sharedInstance] JoinGroup:self.groupID msg:nil succ:^{
            [MBProgressHUD showSuccess:@"加入成功"];
        } fail:^(int code, NSString *msg) {
            NSLog(@"加入失败%d---%@",code,msg);
//            [MBProgressHUD showError:msg];
        }];
    } else {
        [MBProgressHUD showError:@"sdk登录失败"];
    }
}

//退出群聊聊天室
- (void)quitChatRoom {
    [[TIMGroupManager sharedInstance] QuitGroup:self.groupID succ:^() {
        NSLog(@"succ");
    } fail:^(int code, NSString* err) {
        NSLog(@"failed code: %d %@", code, err);
    }];
}

//竖屏下发送按钮
-(void)sendBtnClick:(UIButton *)btn
{
    if (self.textFieldView.textField.text.length >0)
    {
        _index +=1;
        [self sendMassage];
    }
    [self.view endEditing:YES];
}

//消息发送
//普通消息：消息类型+昵称+时分秒+消息
//礼物消息：消息类型+昵称+时分秒+礼物类型+礼物数量
//1.普通，2礼物
- (void)sendMassage {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    TIMTextElem *text_elem = [[TIMTextElem alloc] init];
    if (_isFullScreen) {
        //横屏
        [text_elem setText:self.bottomView.textField.text];
    } else {
        [text_elem setText:self.textFieldView.textField.text];
    }
    
    TIMTextElem *name_elem = [[TIMTextElem alloc] init];
    [name_elem setText:USER_NICK];
    TIMTextElem *type_elem = [[TIMTextElem alloc] init];
    [type_elem setText:@"1"];
    TIMTextElem *time_elem = [[TIMTextElem alloc] init];
    [time_elem setText:dateString];
    
    TIMMessage *msg = [[TIMMessage alloc] init];
    [msg addElem:type_elem];
    [msg addElem:name_elem];
    [msg addElem:time_elem];
    [msg addElem:text_elem];
    
    __weak typeof(self)weakSelf =self;
    [self.grp_conversation sendMessage:msg succ:^(){
        self.textFieldView.textField.text =@"";
        NSLog(@"SendMsg Succ");
        //发送成功，加入消息数组
        //处理接收消息
        TIMMessage * message = msg;
        TIMTextElem *name = (TIMTextElem *)[message getElem:1];
        TIMTextElem *text = (TIMTextElem *)[message getElem:3];
        NSString *msgStr = [name.text stringByAppendingString:[NSString stringWithFormat:@":%@",text.text]];
        [weakSelf.messagesArray addObject:msgStr];
        //发送弹幕
//        [weakSelf sendBarrage];
        //处理横屏的情况
        if (_isFullScreen) {
            self.bottomView.textField.text = @"";
            [weakSelf sendBarrage];
            _index +=1;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.messagesArray.count >50)
            {
                [weakSelf.messagesArray removeObjectAtIndex:0];
            }
            [weakSelf.chatTableView reloadData];
            [weakSelf.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:weakSelf.messagesArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    }fail:^(int code, NSString * err) {
        NSLog(@"SendMsg Failed:%d->%@", code, err);
    }];
}


#pragma mark ---- 收到消息处理------
//收到消息
- (void)onNewMessage:(NSArray *)msgs{
    for (NSInteger i =0; i<msgs.count; i++) {
//        TIMMessage *lastMsg =msgs[i];
        TIMMessage * message = msgs[i];
        TIMTextElem *name = (TIMTextElem *)[message getElem:1];
        TIMTextElem *text = (TIMTextElem *)[message getElem:3];
        NSString *msgStr = [name.text stringByAppendingString:[NSString stringWithFormat:@":%@",text.text]];
        [self.messagesArray addObject:msgStr];
        _index += 1;
        //横屏状态发送弹幕
        if (_isFullScreen) {
            [self sendBarrage];
        }
    }
    [self.chatTableView reloadData];
    NSLog(@"-----收到的消息 %@",msgs);
}



#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.listTableView) {
        return self.goodsDataArr.count;
    }
    return self.messagesArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.listTableView) {
        GoodsTableViewCell *cell = [self.listTableView dequeueReusableCellWithIdentifier:goodCellIndentifer];
        
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:nil options:nil].firstObject;
        }
        GoodsDetailModel *detailM = (GoodsDetailModel *)self.goodsDataArr[indexPath.row];
        [cell configCellWithModel:detailM];
        
        return cell;
    }
    
    static NSString *cellID =@"chatCell";
    ChatTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell =[[ChatTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.row <= 49) {
        cell.textLabel.text =[NSString stringWithFormat:@"%@",self.messagesArray[indexPath.row]];
    }
    if (indexPath.row > 49)
    {
        cell.textLabel.text =[NSString stringWithFormat:@"%@",self.messagesArray[49]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.listTableView) {
        return 100;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.listTableView) {
        ShopDetailViewController *shopVC = [[ShopDetailViewController alloc] init];
        GoodsDetailModel *GM = (GoodsDetailModel *)self.goodsDataArr[indexPath.row];
        shopVC.goodID = GM.ID;
        [self.navigationController pushViewController:shopVC animated:YES];
    }
}

#pragma mark - 全屏
- (void)fullBtnClcik:(id)sender
{
    // 停止播放
    [self.livePlayer stopPlay];
    // 记得销毁view控件
    [self.livePlayer removeVideoWidget];
    
    
    FullScreenLivingViewController *fullVC = [[FullScreenLivingViewController alloc] init];
    [self presentViewController:fullVC animated:NO completion:nil];
    
    /*
    if (_isFullScreen ==NO)
    {
         [self LandscapeLeft];
//        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.allowRotate = 1;
//        
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation" ];
//        //上一句话是防止手动先把设备置为横屏,导致下面的语句失效.
//        [UIView animateWithDuration:0.5f animations:^{
//            [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//        }];
       
//        _isFullScreen =YES;
//        _isClear =NO;
//        UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTag:)];
//        [tapGestureRecognizer setNumberOfTapsRequired:1];
//            
//        UITapGestureRecognizer *tapGestureRecognizer1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTag:)];
//        [tapGestureRecognizer1 setNumberOfTapsRequired:1];
////        [self.player.playerView addGestureRecognizer:tapGestureRecognizer];
//        [self.livingView  addGestureRecognizer:tapGestureRecognizer1];
        
    }
     */
}

//点击屏幕让设置界面消失
-(void)handleTag:(UITapGestureRecognizer *)tap
{
    if (_isFullScreen ==YES)
    {
            if (self.settingView.hidden ==NO)
            {
                self.settingView.hidden =YES;
            }else
                if (_isClear ==NO)
                {
                    self.topView.hidden =YES;
                    self.bottomView.hidden =YES;
                    _isClear =YES;
                }else
                {
                    self.topView.hidden =NO;
                    self.bottomView.hidden =NO;
                    _isClear =NO;
                }
    }
}

//横屏、全屏下需要显示的控件
-(void)LandscapeLeft
{

//    [self layout];
//
//    self.activityIndicatorView.center =self.view.center;
//    self.livingView.hidden=NO;
//    self.hostInfoView.hidden =YES;
//    self.textFieldView.hidden =YES;
//    self.chatTableView.hidden=YES;
//    self.giftView.hidden =YES;
//    
//    self.giftManager.parentView.alpha =1;
//    self.renderer.view.alpha =1;
//    self.settingView.hidden =YES;
//    self.topView.hidden =YES;
//    self.bottomView.hidden =YES;
//    
//    __block LIvingViewController/*主控制器*/ *weakSelf = self;
//    [UIView animateWithDuration:1 animations:^{
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            weakSelf.topView.hidden =NO;
//            weakSelf.bottomView.hidden =NO;
//        });
//    }];
}

#pragma mark ------横屏下添加的控件
-(void)initBarrageRenderer
{
    self.renderer = [[BarrageRenderer alloc]init];
    self.renderer.canvasMargin = UIEdgeInsetsMake(10, 10, 10, 10);
    self.renderer.view.alpha = 1;
    [self.view addSubview:self.renderer.view];
}

-(NSMutableArray *)danmuArray
{
    if (!_danmuArray)
    {
        _danmuArray =[[NSMutableArray alloc]init];
    }
    return _danmuArray;
}

-(TopView *)topView
{
    if (!_topView)
    {
        _topView =[[TopView alloc]init];
        _topView.hidden =YES;
        _topView.onlineLabel.text =[NSString stringWithFormat:@"%@",self.onlineNum];
        [_topView.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_topView.settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _topView.translatesAutoresizingMaskIntoConstraints =NO;
       
    }
    return _topView;
}

-(BottomView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView= [[BottomView alloc]init];
        _bottomView.hidden =YES;
        [_bottomView.startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.barrageButton addTarget:self action:@selector(barrageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.sendBtn addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.giftBtn addTarget:self action:@selector(giftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _bottomView.translatesAutoresizingMaskIntoConstraints =NO;
    }
    return _bottomView;
}

-(SettingView *)settingView
{
    if (!_settingView)
    {
        _settingView =[[SettingView alloc]init];
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

//横屏布局
-(void)layout
{
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.livingView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [self.view addSubview:self.topView];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.topView autoSetDimension:ALDimensionHeight toSize:fHeightChange(100)];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom ];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeading ];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.bottomView autoSetDimension:ALDimensionHeight toSize:fHeightChange(100)];

    [self.view addSubview:self.settingView];
    [self.settingView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.settingView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.settingView autoSetDimension:ALDimensionWidth toSize:kWidthChange(400)];
    [self.settingView autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
}

#pragma mark ------横屏下按钮的触发事件
//点击返回竖屏
-(void)backButtonClick:(id)sender
{
    if (_isFullScreen == YES)
    {
//        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.allowRotate = 0;
//
//        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
//        [UIView animateWithDuration:0.5f animations:^{
//            [[UIDevice currentDevice]setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait]  forKey:@"orientation"];
//        }];
        [self Portrait];    //重置竖屏界面的空间
        [self addLayout];   //重新布局
        _isFullScreen =NO;
    }
}

//点击返回竖屏需要显示的控件
-(void)Portrait
{
    _activityIndicatorView.center =CGPointMake(SCREEN_WIDTH/2, kHeightChange(450/2));
    self.livingView.hidden =NO;
    self.hostInfoView.hidden =NO;
    self.textFieldView.hidden =NO;
    self.chatTableView.hidden=NO;
    [self.chatTableView reloadData];
    self.giftView.hidden =YES;
    self.settingView.hidden =YES;
    self.topView.hidden =YES;
    self.bottomView.hidden =YES;
    
    self.renderer.view.alpha = 1;
    self.giftManager.parentView.alpha =1;
}

//关注
-(void)focusButtonClick:(UIButton *)btn
{
    btn.selected =!btn.selected;
    if (btn.selected ==YES)
    {
        self.topView.focusButton.selected =YES;
        self.hostInfoView.focusImageView.image =[UIImage imageNamed:@"爱心红"];
        [self focusOnRequest];
    }
    else
    {
        self.topView.focusButton.selected =NO;
        self.hostInfoView.focusImageView.image =[UIImage imageNamed:@"爱心1"];
        [self cancleFocusRequest];

    }
}

//关注的请求
-(void)focusOnRequest
{
    NSMutableDictionary *paraments =[[NSMutableDictionary alloc]initWithCapacity:2];
    paraments[@"user_id"]= self.uesr_id;
    paraments[@"bCastId"] =self.ID;
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"focusOnBc_app" paraments:paraments finish:^(id responseObject, NSError *error) {
        NSLog(@"!~~~~%@关注~~~~%@",responseObject,error);
        self.hostInfoView.fansCount.text =[NSString stringWithFormat:@"%@",responseObject[@"count"]];
        self.bcfocus =responseObject[@"bcfocus"];
        self.topView.focusLabel.text =[NSString stringWithFormat:@"%@",responseObject[@"count"]];
    }];
}

//取消关注的请求
-(void)cancleFocusRequest
{
//    NSString *url =@"http://www.tianyue.tv/deleteFocus_app";
    //NSString *url =@"http://192.168.0.88:8081/deleteFocus_app";
    NSMutableDictionary *paraments =[[NSMutableDictionary alloc]initWithCapacity:2];
    if (self.guanz_id)
    {
        paraments[@"id"]= self.guanz_id;
    }else
    {
        paraments[@"id"]=self.bcfocus;
    }
    paraments[@"bcId"] =self.ID;
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"deleteFocus_app" paraments:paraments finish:^(id responseObject, NSError *error) {
        NSLog(@"!~~~~%@取消关注~~~~%@",responseObject,error);
        self.hostInfoView.fansCount.text =[NSString stringWithFormat:@"%@",responseObject[@"count"]];
        self.topView.focusLabel.text =[NSString stringWithFormat:@"%@",responseObject[@"count"]];
    }];

}

//礼物
- (void)giftButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected == YES)
    {
        self.giftView.hidden = NO;
        self.giftView.frame = CGRectMake(SCREEN_WIDTH -kWidthChange(400), SCREEN_HEIGHT-fWidthChange(260)-fHeightChange(100), kWidthChange(400), kHeightChange(260));
    }else
    {
        self.giftView.hidden = YES;
    }
}

//设置
- (void)settingButtonClick:(UIButton *)btn
{
    self.settingView.hidden = NO;
}

//分享
-(void)shareButtonClick:(id)sender
{
    [self share];
}

//开始 暂停（横屏）
- (void)startButtonClick:(UIButton *)btn
{
    if (_isFullScreen == YES)
    {
        self.activityIndicatorView.center = self.view.center;
        btn.selected =!btn.selected;
        
        if (btn.selected ==YES)
        {
            self.livingView.startBtn.selected = YES;
            [self.livePlayer pause];
        }else
        {
            self.livingView.startBtn.selected = NO;
            [self.livePlayer resume];
        }
    }
}

//弹幕
- (void)barrageButtonClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (btn.selected == YES)//弹幕消失
    {
        self.renderer.view.alpha = 0;
    }else
    {
        self.renderer.view.alpha = 1;
    }
}

#pragma mark  ------弹幕
//横屏发送按钮点击方法
- (void)sendButtonClick:(UIButton *)btn
{
    if (self.bottomView.textField.text.length >0)
    {
        [self sendMassage];
    }
    [self.view endEditing:YES];
}

- (void)sendBarrage
{
//    self.renderer.view.alpha = 1;
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
    }
}

- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction
{
    return [self walkTextSpriteDescriptorWithDirection:direction side:BarrageWalkSideDefault];
}

- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(BarrageWalkDirection)direction side:(BarrageWalkSide)side
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    if (self.messagesArray != nil && ![self.messagesArray isKindOfClass:[NSNull class]] && self.messagesArray.count != 0)
    {
       if ([self.messagesArray[self.messagesArray.count -1] rangeOfString:@"赠送礼物"].location !=NSNotFound)
       {
           [self.messagesArray removeObject:self.messagesArray[self.messagesArray.count -1]];
       } else if ([self.messagesArray[self.messagesArray.count -1] rangeOfString:@":"].location !=NSNotFound) {
           NSArray *array =[self.messagesArray[self.messagesArray.count -1] componentsSeparatedByString:@":"];
            descriptor.params[@"text"] = array[1];
       }
    }
    descriptor.params[@"textColor"] = [UIColor whiteColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] =@(side);
    return descriptor;
}


#pragma mark  ------设置
//软解
-(void)softBtnClick:(UIButton *)btn
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
//硬解
-(void)hardBtnClick:(UIButton *)btn
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

//音量大小
-(void)changerSound:(UISlider *)slider
{
    static UISlider * volumeViewSlider = nil;
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
//改变屏幕亮度
-(void)changerBrightness:(UISlider *)slider
{
    [[UIScreen mainScreen]setBrightness:self.settingView.brightnessSlider.value];
}

//改变弹幕透明度
-(void)changerAlpha:(UISlider *)slider
{
    _renderer.view.alpha =slider.value;
}

//改变弹幕大小
-(void)changerSize:(UISlider *)slider
{
    
}

//返回按钮
-(void)backBtnClick:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    [self quitChatRoom];
    
    // 停止播放
    [self.livePlayer stopPlay];
    // 记得销毁view控件
    [self.livePlayer removeVideoWidget];
    
    //停止弹幕渲染，必须调用，否则会引起内存泄漏
//    [self.renderer stop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private
- (void)requestGoodDataSource {
    @weakify(self);
    [LivingHandler requestForLivingRoomGoodWithUser:self.uesr_id CompleteBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        
        if (respondsObject) {
            self.goodsDataArr = respondsObject;
            [self.listTableView reloadData];
        }
    }];
}


-(CGRect)rectWithText:(NSString *)text
{
    NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
    para.lineBreakMode = NSLineBreakByWordWrapping;
    
    return [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kWidthChange(30)],NSParagraphStyleAttributeName:para} context:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)share
{
    //1.创建分享参数
    NSArray *imageArray =@[[UIImage imageNamed:@"组-1-拷贝-3"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/i
    if (imageArray)
    {
        NSMutableDictionary *shareParams =[NSMutableDictionary dictionary];
        
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:@"http://mob.com"]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
            
            switch (state) {
                case SSDKResponseStateSuccess:
                    [MBProgressHUD showSuccess:@"分享成功"];
                    break;
                case SSDKResponseStateFail:
                    [MBProgressHUD showError:@"分享失败"];
                    break;
                default:
                    break;
            }
            
        }];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}


@end
