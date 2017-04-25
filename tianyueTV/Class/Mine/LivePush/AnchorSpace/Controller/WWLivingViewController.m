//
//  WWLivingViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/16.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWLivingViewController.h"

#import "BarrageHeader.h"
#import "WWSettingViewController.h"

#import "AnchorSpaceModel.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "DMS.h"

#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"
#import "AnchorSpaceHandle.h"

//礼物动画
#import "PresentView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"

//腾讯云#
#import <TXRTMPSDK/TXLivePush.h>
#import "MyLivingView.h"


@class AppDelegate;

@interface WWLivingViewController ()
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
roomNameDelegate,
TIMMessageListener,
TIMRefreshListener,
TIMConnListener,
TIMUserStatusListener,
TXLivePushListener,
AVCaptureVideoDataOutputSampleBufferDelegate>

{
    BOOL _isPause; //直播是否暂停
    DMS * _client;
    int _secondsCountDown; //3s倒计时
    NSTimer *_countDownTimer; //倒计时
    TIMManager *_messageImManager;
    NSString *_groupId;  // 房间信息
    TIMConversation *_chatRoomConversation; // 群会话上下文
    TXLivePush *_txLivePush;  //推流对象
    TXLivePushConfig * _config; //推流设置对象
}

// 房间信息
@property (nonatomic,strong) NSDictionary *roomInafos;

// 标签数组
@property (nonatomic,strong) NSMutableArray *biaoqiansArrays;

// 倒计时蒙层
@property (nonatomic,strong) UIView *lightBlackView;

// 礼物
@property (nonatomic,strong) UIView *giftView;

// 倒计时
@property (nonatomic,strong) UILabel *countDownLabel;

// 推流地址
@property (nonatomic,strong) NSString *pushUrl;

// 话题
@property (nonatomic,strong) NSString *topicID;

// 摄像头
@property (nonatomic, strong) AVCaptureDevice *cameraDevice;


@property (nonatomic, strong) AVCaptureSession *captureSession;


@property (nonatomic, assign) BOOL viewAppeared;

// 聊天室房间号
@property (nonatomic, strong) NSString *GroupId;


@property (nonatomic, strong) NSString *userIdentifiler;


@property (nonatomic, strong) NSString *accountType;


@property (nonatomic, strong) NSString *userSig;

//礼物数组
@property(nonatomic, strong) NSMutableArray *giftArray;

// 直播界面
@property (nonatomic, strong) MyLivingView *livingView;

@end

@implementation WWLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeInterface];
    [self initilizeDatasource];
    
    // 预先设定几组编码质量，之后可以切换
    CGSize videoSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation <= AVCaptureVideoOrientationLandscapeRight) {
        if (orientation > AVCaptureVideoOrientationPortrait) {
            videoSize = CGSizeMake(SCREEN_HEIGHT , SCREEN_WIDTH);
        }
    }

    //直播时监听APP是否进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - Init method
- (void)initilizeInterface {
    self.view.backgroundColor = [UIColor lightGrayColor];
    _livingView = [[MyLivingView alloc] init];
    _livingView.frame = self.view.frame;
    [self.view addSubview:_livingView];
    
    [self button_action];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)initilizeDatasource {
    self.GroupId = @"@TGS#3MZOSFMED";
    [self netWorkRequestGet];
    [self AFNReachability];
    [self setupCameraDevice];
    [self setupChatRoom];
    [self setupPush];
    _isPause = NO;
}

#pragma mark - Live view button method
- (void)button_action {
    @weakify(self);
    self.livingView.livingBlock = ^(NSInteger tag, UIButton *button) {
        @strongify(self);
        switch (tag) {
            case 0: { // 返回
                [self respondsToBackClicked:button];
            } break;
                
            case 1: { // 设置
                [self respondsToSettingClicked:button];
            } break;
                
            case 2: { // 摄像头
                [self respondsToToggleCameraButton:button];
            } break;
                
            case 3: { // 闪光灯
                [self respondsToLightButton:button];
            } break;
                
            case 4: { // 播放
                [self respondsToStarButton:button];
                [self.livingView starLiving];
            } break;
                
            case 5: { // 横竖屏
                [self respondsToSGDButton:button];
                
            } break;
                
            case 6: { // 分享
                [self respondsToShareButton:button];
            } break;
                
            case 7: {
                [self respondsToPauseHandle:button];
                [self.livingView pauseLiving];
                _isPause = YES;
            } break;
                
            default:
                break;
        }
    };
}


#pragma mark -- KVO
//程序进入后台
- (void)onAppDidEnterBackGround:(UIApplication *)app{
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];
    //暂停直播
    [_txLivePush pausePush];
}

//进入程序
- (void)onAppWillEnterForeground:(UIApplication *)app {
    [_txLivePush resumePush];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - TXLivePushListener
- (void)onPushEvent:(int)EvtID withParam:(NSDictionary*)param {
    
}

- (void)onNetStatus:(NSDictionary*) param {
    
}

#pragma mark - 腾讯云聊天相关
/**
 初始化聊天室
 */
- (void)setupChatRoom {
    _messageImManager = [TIMManager sharedInstance];
    // 设置消息回调
    [_messageImManager setMessageListener:self];
    [_messageImManager setRefreshListener:self];
    // 设置链接通知回调
    [_messageImManager setConnListener:self];
      _chatRoomConversation =  [_messageImManager getConversation:TIM_GROUP receiver:self.GroupId];
    
    [[TIMManager sharedInstance] setUserStatusListener:self];
}

/**
 加入聊天室
 */
- (void)dengluchengg {
    @weakify(self);
    [[TIMGroupManager sharedInstance] JoinGroup:self.GroupId msg:nil succ:^{
        @strongify(self);
        NSLog(@"加入成功");
        [self switchToLiveRoom:self.GroupId];
    } fail:^(int code, NSString *msg) {
        NSLog(@"加入失败%d---%@",code,msg);
        
    }];
}

- (void)switchToLiveRoom:(NSString *)groupId
{
    _groupId = groupId;

    _chatRoomConversation = [_messageImManager getConversation:TIM_GROUP receiver:self.GroupId];
    
    [_chatRoomConversation getMessage:10 last:nil succ:^(NSArray * msgList) {
        int index = 0;
        for (TIMMessage * msg in msgList) {
            TIMElem *elem = [msg getElem:index];
            index ++;
            if ([msg isKindOfClass:[TIMMessage class]]) {
                NSLog(@"获取消息:%@", msg);
                
                TIMTextElem *textElem = (TIMTextElem *)elem;
                NSString *msgText = textElem.text;
                [self addMessages:msgText];
            }
        }
        [self reloadDataHandler];
    }fail:^(int code, NSString * err) {
        NSLog(@"获取消息失败:%d->%@", code, err);
    }];
    
    
    //开启子线程
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //获取当前用户消息数目
        NSInteger conversationNum = [_messageImManager ConversationCount];
        for (int i = 0; i < conversationNum; i++) {
            TIMConversation *conversation = [[TIMManager sharedInstance] getConversationByIndex:i];
            [conversation getMessage:1 last:nil succ:^(NSArray *msgs) {
                //获取当前用户最新一条消息
                TIMMessage *lastMsg = msgs[0];
                NSLog(@"%@",lastMsg);
                //                self.senderModule = [[MSMessageSendersModule alloc]initWithConversation:lastMsg];
                //                _senderModule.unreadNum = [NSString stringWithFormat:@"%d",[conversation getUnReadMessageNum]];
                //                [_messageSendersArray addObject:_senderModule];
                if (conversationNum == i+1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //                        [SVProgressHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"更新完毕", @"InfoPlist", nil)];
                        //                        [_messageSendersTableView reloadData];
                    });
                }
            } fail:^(int code, NSString *msg) {
                
            }];
        }
        
    });

}

#pragma mark - 礼物动画
// 礼物消息：消息类型+昵称+时分秒+礼物类型+礼物数量
- (void)starGiftAnimationWithMsg:(TIMMessage *)message {
    TIMTextElem *indexElem = (TIMTextElem *)[message getElem:3];
    TIMTextElem *name = (TIMTextElem *)[message getElem:1];
    TIMTextElem *count = (TIMTextElem *)[message getElem:4];
    NSInteger index = [indexElem.text integerValue];
    NSLog(@"----- index == %ld",(long)index);
    
    GSPChatMessage *msg = [[GSPChatMessage alloc]init];
    msg.text = [NSString stringWithFormat:@" 赠送主播 %@", self.giftArray[1][index]];
    msg.senderChatID = name.text;

    // 礼物模型
    GiftModel *giftModel = [[GiftModel alloc] init];
    giftModel.headImage = [UIImage imageNamed:self.giftArray[0][index]];
    giftModel.name = msg.senderName;
    giftModel.giftImage = [UIImage imageNamed:self.giftArray[0][index]];
    giftModel.giftName = msg.text;
    giftModel.giftCount = [count.text integerValue];
    
    AnimOperationManager* manager = [AnimOperationManager sharedManager];
    manager.parentView = self.view;
    
    [manager animWithUserID:[NSString stringWithFormat:@"%@", msg.senderChatID] model:giftModel finishedBlock:^(BOOL result) {
        
    }];
}

#pragma mark - 收到消息处理
// 收到消息
- (void)onNewMessage:(NSArray *)msgs{
    [self onHandleNewMessage:msgs];
}

- (void)onHandleNewMessage:(NSArray *)msgs {
    for(TIMMessage *msg in msgs) {
        TIMConversationType conType = msg.getConversation.getType;
        
        switch (conType) {
            case TIM_C2C: {
                
                break;
            }
            case TIM_GROUP: {
                if([[msg.getConversation getReceiver] isEqualToString:self.GroupId]) {
                    [self onRecvGroup:msg];
                }
                break;
            }
            case TIM_SYSTEM: {
                // 这里获取的groupid为空，IMSDK的问题
                // 所以在onRecvGroupSystemMessage里面通过sysElem.group来判断
                [self onRecvGroupSystemMessage:msg];
                break;
            }
            default:
                break;
        }
    }
}

- (void)onRecvGroupSystemMessage:(TIMMessage *)msg {
    for (int index = 0; index < [msg elemCount]; index++) {
        TIMElem *elem = [msg getElem:index];
        if ([elem isKindOfClass:[TIMGroupSystemElem class]]) {
            TIMGroupSystemElem *sysElem = (TIMGroupSystemElem *)elem;
            if ([sysElem.group isEqualToString:_groupId]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"消息：%@",sysElem);
                });
            }
        }
    }
}

// 消息格式
// 普通消息：消息类型+昵称+时分秒+消息
// 礼物消息：消息类型+昵称+时分秒+礼物类型+礼物数量
- (void)onRecvGroup:(TIMMessage *)msg {
    // 接受消息的处理代码块
    TIMTextElem *type = (TIMTextElem *)[msg getElem:0];
    if ([type.text isEqualToString:@"1"]) {
        // 普通消息
        TIMTextElem *name = (TIMTextElem *)[msg getElem:1];
        TIMTextElem *text = (TIMTextElem *)[msg getElem:3];
        NSString *msgStr = [name.text stringByAppendingString:[NSString stringWithFormat:@"：%@",text.text]];
        [self addMessages:msgStr];
    } else if ([type.text isEqualToString:@"2"]) {
        [self starGiftAnimationWithMsg:msg];
    }
}

// 添加消息
- (void)addMessages:(NSString *)msg{
    if (msg) {
        [self.livingView.chatView.messageArray addObject:msg];
        if (self.livingView.chatView.messageArray.count > 50) {
            [self.livingView.chatView.messageArray removeObjectAtIndex:0];
        }
        //        [[ws.chatView mutableArrayValueForKey:@"messageArray"] addObject:message.payloadString];
        if (self.livingView.chatView.messageArray.count > 0) {
            
            //     if (ws.chatView.messageArray.count > 7) {
            //                [ws.chatView.chatRoomTableView reloadData];
            //                [ws.chatView.chatRoomTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:ws.chatView.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            //            }else{
            //                [ws reloadDataHandler];
            //            }
            [self reloadDataHandler];
        }
        
    }
}

/**
 刷新聊天数据
 */
- (void)reloadDataHandler {
    //    __strong typeof(self) ws = self;
    //    [UIView animateWithDuration:0.2 animations:^{
    //        [self.chatView.chatRoomTableView reloadData];
    //    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.livingView.chatView.chatRoomTableView reloadData];
        [self.livingView.chatView.chatRoomTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.livingView.chatView.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    });
}


/**
 初始化摄像头
 */
- (void)setupCameraDevice {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (granted) {
            NSArray *cameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            for (AVCaptureDevice *cameraDevice in cameraDevices) {
                self.cameraDevice = cameraDevice;
                if (cameraDevice.position == AVCaptureDevicePositionFront) {
                    break;
                }
            }
            if (self.cameraDevice) {
                //#warning step 1.4 前置摄像头可设置翻转
                //                self.filterManager.frontCameraMirror = self.cameraDevice.position == AVCaptureDevicePositionFront;
                
                [self.cameraDevice lockForConfiguration:nil];
                self.cameraDevice.activeVideoMinFrameDuration = CMTimeMake(1, 20);
                self.cameraDevice.activeVideoMaxFrameDuration = CMTimeMake(1, 10);
                [self.cameraDevice unlockForConfiguration];
                
                AVCaptureDeviceInput *cameraInput = [AVCaptureDeviceInput deviceInputWithDevice:self.cameraDevice error:nil];
                if (cameraInput) {
                    self.captureSession = [[AVCaptureSession alloc] init];
                    //                    self.captureSession.sessionPreset = [self cameraSessionPreset];
                    self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
                    if ([self.captureSession canAddInput:cameraInput]) {
                        [self.captureSession addInput:cameraInput];
                        
                        
                        dispatch_queue_t videoDataQueue = dispatch_queue_create("com.tencent.pitu.videodata", NULL);
                        AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
                        videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
                        [videoDataOutput setSampleBufferDelegate:self queue:videoDataQueue];
                        
                        NSDictionary *captureSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey: @(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)};
                        videoDataOutput.videoSettings = captureSettings;
                        
                        if ([self.captureSession canAddOutput:videoDataOutput]) {
                            [self.captureSession addOutput:videoDataOutput];
                            
                            if (self.viewAppeared || 1) {
                                [self.captureSession startRunning];
                                //                                [self.filterManager startOutputData];
                            }
                        }
                    }
                }
            }
        }
    }];
}

#pragma mark - roomNameDelegate
- (void)returnRoomName:(NSString *)roomName{
//    self.titleLabelW.text = roomName;
}

#pragma mark - 腾讯云推流
/**
 初始化推流设置
 */
- (void)setupPush {
    // 创建 LivePushConfig 对象，该对象默认初始化为基础配置
    _config = [[TXLivePushConfig alloc] init];
    // 在 _config中您可以对推流的参数（如：美白，硬件加速，前后置摄像头等）做一些初始化操作，需要注意 _config不能为nil
    _txLivePush = [[TXLivePush alloc] initWithConfig: _config];
    // 开启硬件编码
    _txLivePush.config.enableHWAcceleration = YES;
    
    // 美颜滤镜
    [_txLivePush setBeautyFilterDepth:7 setWhiteningFilterDepth:3];
    _txLivePush.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        _config.enableHWAcceleration  = NO;
    }else{
        _config.enableHWAcceleration  = YES;
    }
}

/**
 开始直播

 @return 推流结果
 */
- (BOOL)startRtmp{
    //启动推流
//    self.pushUrl = @"rtmp://7526.livepush.myqcloud.com/live/7526_10339ty?bizid=7526&txSecret=ccf158deaf23276fac89e8cecd9e9b6b&txTime=591DC4FF";

    if (self.pushUrl.length == 0) {
        [MBProgressHUD showError:@"无推流地址，请重新登录后重试"];
        return NO;
    }
    
    // 是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }
    
    //是否有麦克风权限
    AVAuthorizationStatus statusAudio = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (statusAudio == AVAuthorizationStatusDenied) {
       
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    if (_txLivePush != nil)
    {
        // _myView 就是step2中需要您指定的view
        [_txLivePush startPreview:self.view];
        
        if ([_txLivePush startPush:self.pushUrl] != 0) {
            [MBProgressHUD showError:@"推流失败，请稍后再试"];
            return NO;
        } else {
            //推流成功，开启房间
            [self openLive];
            NSLog(@"推流器启动成功");
        }
//        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];//防止屏幕锁屏
    }
    return YES;
}

/**
 停止直播
 */
- (void)stopRtmp {
    if(_txLivePush != nil)
    {
        _txLivePush.delegate = nil;
        [_txLivePush stopPush];
        _txLivePush = nil;
    }
    if (self.captureSession) {
        [self.captureSession stopRunning];
    }
    
    self.cameraDevice = nil;
    //    self.filterManager = nil;
    self.captureSession = nil;
    //    [self.previewView removeFromSuperview], self.previewView = nil;
    //取消屏幕锁屏
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


#pragma mark - 网络请求
/**
 获取我的直播间
 */
- (void)netWorkRequestGet{
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    [MBProgressHUD showMessage:nil];
    
    [AnchorSpaceHandle requestForBroadcastAppWithUser:userID completeBlock:^(id respondsObject, NSError *error) {
        
        [MBProgressHUD hideHUD];
        
        if (respondsObject) {
            AnchorSpaceModel *model = (AnchorSpaceModel *)respondsObject;
            if (model.broadcast.count) {
                BroadCastModel *broadCM = model.broadcast[0];
                
                NSString *messageString = broadCM.keyWord;
                if (messageString.length != 0) {
                    
                    NSArray *arr = [messageString componentsSeparatedByString:@"_"];
                    self.biaoqiansArrays = [arr mutableCopy];
                    
                }

                self.pushUrl = broadCM.ql_playAddress;
      
                self.topicID = broadCM.uid;
                
                [self.livingView configViewWithModel:broadCM];
                
            }
        }else {
            [MBProgressHUD showError:@"网路出错"];
        }

    }];
}

/**
 开启直播间
 */
- (void)openLive{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"uid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    param[@"zid"] = @"1";

    [[NetWorkTool sharedTool] requestMethod:POST URL:@"mobileLivebutton" paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"responseObject_open : %@", responseObject);
    }];
}

/**
 关闭直播间
 */
- (void)closeLive{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"uid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    param[@"zid"] = @"0";
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"mobileLivebutton" paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"responseObject_close : %@", responseObject);
    }];
}

#pragma mark - 倒计时
- (void)countDownHandle {
    // 新版UI
    [self.view addSubview:self.lightBlackView];
    
    //倒计时
    [self.lightBlackView addSubview:self.countDownLabel];
    self.countDownLabel.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    _secondsCountDown = 3;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    self.countDownLabel.text = [NSString stringWithFormat:@"%d",_secondsCountDown];
    [self.livingView sizeToFit];
}

- (void)timeFireMethod {
    _secondsCountDown --;
    self.countDownLabel.text = [NSString stringWithFormat:@"%d",_secondsCountDown];
    if (_secondsCountDown == 0) {
        //倒计时结束，开始直播
        [self startRtmp];
        [_countDownTimer invalidate];
        [self.countDownLabel removeFromSuperview];
        [self.lightBlackView removeFromSuperview];
    }
}


#pragma mark - 横竖屏切换
//横竖屏切换点击
- (void)respondsToSGDButton:(UIButton *)sender{
    /*
    NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    
    [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];
    
    
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    
    
    sender.selected = !sender.selected;
    */
    
    if (sender.selected) {
//        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.allowRotate = 1;
        
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        
    }else{
//        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        delegate.allowRotate = 0;
        
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    }
    
    
}

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


#pragma mark - Button method
// 播放点击
- (void)respondsToStarButton:(UIButton *)sender {
    // 判断是否是暂停状态，暂停的话继续
    if (_isPause) {
        [_txLivePush resumePush];
        _isPause = NO;
    } else {
        // 不是暂停，开启推流
        [self countDownHandle];
    }

}

// 暂停按钮
- (void)respondsToPauseHandle:(UIButton *)sender {
    NSLog(@"暂停");
    _isPause = YES;

    if (_txLivePush) {
         [_txLivePush pausePush];
    }
}


// 返回按钮
- (void)respondsToBackClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [[TIMGroupManager sharedInstance] QuitGroup:self.GroupId succ:^{
        NSLog(@"退出成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"退出失败");
    }];
    NSLog(@"返回");
    
    NSString* topic = [NSString stringWithFormat:@"%@",self.topicID];
    [_client unsubscribe:topic
   withCompletionHandler:^{
       NSLog(@"%@",[[NSString alloc] initWithFormat:@"%@%@", @"unsubscribed to topic ",topic]);
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.navigationController popViewControllerAnimated:YES];
       });
   }];
    
    // 当不再需要DMS对象时，务必要断开连接
    [_client disconnectWithCompletionHandler:^(NSUInteger code) {
        NSLog(@"disconnected");
    }];
     
    // 结束推流
    [self stopRtmp];
    // 退出直播房间
    [self closeLive];
}

// 设置
- (void)respondsToSettingClicked:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"WWFirst"];
    WWSettingViewController *setting = [[WWSettingViewController alloc] init];
    setting.isHiddenLivingButton = YES;
    setting.roomInfos = self.roomInafos;
    setting.settingView.biaoqianArray = self.biaoqiansArrays;
    setting.delegate = self;
    [self.navigationController pushViewController:setting animated:YES];
}

// 切换摄像头
- (void)respondsToToggleCameraButton:(UIButton *)sender{
    [_txLivePush switchCamera];
}

// 闪光灯
- (void)respondsToLightButton:(UIButton *)sender{
    if (sender.selected) {
        [_txLivePush toggleTorch:YES];
    } else {
        [_txLivePush toggleTorch:NO];
    }
    sender.selected = !sender.selected;

}


// 分享按钮
- (void)respondsToShareButton:(UIButton *)sender{
    
    //    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
    //    （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                     images:nil
                                        url:[NSURL URLWithString:@"http://www.tianyue.tv"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeAuto];
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateSuccess:
                       {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
}


#pragma mark - 懒加载
// 礼物数组
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

// 倒计时背景蒙层
- (UIView *)lightBlackView {
    if (!_lightBlackView) {
        _lightBlackView = [[UIView alloc] init];
        _lightBlackView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        _lightBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _lightBlackView;
}

// 倒计时显示Label
- (UILabel *)countDownLabel {
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] init];
        _countDownLabel.center = CGPointMake(self.lightBlackView.centerX, self.lightBlackView.centerY);
        _countDownLabel.size = CGSizeMake(50, 50);
        _countDownLabel.font = [UIFont boldSystemFontOfSize:kWidthChange(80)];
        _countDownLabel.textColor = [UIColor whiteColor];
    }
    return _countDownLabel;
}

// 房间信息
- (NSDictionary *)roomInafos {
    if (!_roomInafos) {
        _roomInafos = [[NSDictionary alloc] init];
    }
    return _roomInafos;
}

#pragma mark - 网络监测
//使用AFN框架来检测网络状态的改变
- (void)AFNReachability
{
    
    //1.创建网络监听管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    //2.监听网络状态的改变
    /*
     AFNetworkReachabilityStatusUnknown     = 未知
     AFNetworkReachabilityStatusNotReachable   = 没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 3G
     AFNetworkReachabilityStatusReachableViaWiFi = WIFI
     */
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"3G");
                if ( [[[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIwarning"] isEqualToString:@"remind"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前为非WIFI环境,是否继续？" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *continueAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                        [self oppenLive];
//                        [self startSession];
//                        [self dismissViewControllerAnimated:YES completion:nil];
//                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                               [self dismissViewControllerAnimated:YES completion:nil];
                    }];
                    [alert addAction:continueAction];
                    [alert addAction:cancelAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"WIFI");
                break;
                
            default:
                break;
        }
    }];
    
    //3.开始监听
    [manager startMonitoring];
}


#pragma mark - SuperClass method
/*
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // do something before rotation
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
//        屏幕从竖屏变为横屏时执行
        _config.homeOrientation = HOME_ORIENTATION_LEFT;
        NSLog(@"横屏了");
        
    } else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        _config.homeOrientation = HOME_ORIENTATION_RIGHT;
        
    } else {
        //        屏幕从横屏变为竖屏时执行
        _config.homeOrientation = HOME_ORIENTATION_DOWN;
    }
    [_txLivePush setConfig:_config];
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.livingView removeAllSubviews];
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        //        屏幕从竖屏变为横屏时执行
        NSLog(@"竖屏");
        //        NSLog(@"SCREEN_WIDTH %f SCREEN_HEIGHT %f",[UIScreen mainScreen].bounds.size.width, SCREEN_HEIGHT);
        [self.livingView initilizeSubviews];
        
        
        
    }else{
        //        屏幕从横屏变为竖屏时执行
        [self.livingView initilizeSubviews];
    }
}


- (BOOL)shouldAutorotate
{
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
*/


@end
