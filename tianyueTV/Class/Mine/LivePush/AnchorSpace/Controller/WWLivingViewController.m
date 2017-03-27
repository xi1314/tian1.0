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



#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
//#import "PLMediaStreamingKit.h"
#import "DMS.h"

#import "WWChatRoomView.h"
#import "AppDelegate.h"
#import "MBProgressHUD+MJ.h"

//礼物动画
#import "PresentView.h"
#import "GiftModel.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "GSPChatMessage.h"

//腾讯云#
#import <TXRTMPSDK/TXLivePush.h>

#import <ImSDK/TIMCallbackExt.h>
//#import "WWMsgHandle.h"
//#import "WWMsgModel.h"


@class AppDelegate;

@interface WWLivingViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,roomNameDelegate,TIMMessageListener,TIMRefreshListener,TIMConnListener,TIMUserStatusListener,TXLivePushListener,AVCaptureVideoDataOutputSampleBufferDelegate>

{
//    UIImagePickerController *_picker;
    BOOL _isPause;         //直播是否暂停
    DMS * _client;
    
    int _secondsCountDown; //3s倒计时
    NSTimer *_countDownTimer;//倒计时

    TIMManager *_messageImManager;
    
    NSString                *_groupId;                // 房间信息
    TIMConversation         *_chatRoomConversation;   // 群会话上下文
    
    TXLivePush              *_txLivePush;             //推流对象
    TXLivePushConfig        * _config;                //推流设置对象
}



//@property (nonatomic,strong) UIView *Wview;

@property (nonatomic, strong) NSString *roomID;
@property (nonatomic, strong) dispatch_queue_t sessionQueue;
@property (nonatomic, strong) UIButton *toggleCameraButton;//切换摄像头
@property (nonatomic, strong) UIButton *shareButton;//分享
@property (nonatomic, strong) UIButton *shanguangdengButton;// 闪光灯
@property (nonatomic, strong) UIButton *changeButton;//横竖屏切换
@property (nonatomic, strong) UIImageView *headBackImage;//封面
@property (nonatomic, strong) UITextField *titleTextField;//标题
@property (nonatomic, strong) UIView *titleTextFieldBackView;//标题的背景
@property (nonatomic, strong) UIView *bottomView;//底部背景
@property (nonatomic, strong) UIButton *startButton;//开始暂停按钮
@property (nonatomic, strong) UIButton *backButton;//返回


@property (nonatomic, strong) UIView *topBgView;//上部背景视图
@property (nonatomic, strong) UIImageView *numWatchImageView;//当前观看人数的标志
@property (nonatomic, strong) UILabel *numWatchLabel;//当前观看人数
@property (nonatomic, strong) UIImageView *numGuanzhuImageView;//当前关注人数的标志
@property (nonatomic, strong) UILabel *numGuanzhuLabel;//关注的人数
@property (nonatomic,strong) UILabel *titleLabelW;//标题
@property (nonatomic,strong) UIButton *settingButton;//设置

@property (nonatomic,strong) NSDictionary *roomInafos;//房间信息
@property (nonatomic,strong) NSMutableArray *biaoqiansArrays;//标签数组


//niew UI
@property (nonatomic,strong) UIView *lightBlackView;//倒计时蒙层
@property (nonatomic,strong) UIView *giftView;//礼物
@property (nonatomic,strong) UILabel *countDownLabel;//倒计时
@property (nonatomic,strong) UIButton *pauseButton;//暂停按钮


@property (nonatomic,strong) WWChatRoomView *chatView;


@property (nonatomic,strong) NSString *onlineNum;//在线人数
@property (nonatomic,strong) NSString *focusNum;//关注人数
@property (nonatomic,strong) NSString *pushUrl;//推流地址
@property (nonatomic,strong) NSString *topicID;//话题


@property (nonatomic, strong) AVCaptureDevice *cameraDevice;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, assign) BOOL viewAppeared;
@property (nonatomic, strong) NSString *GroupId;
@property (nonatomic, strong) NSString *userIdentifiler;
@property (nonatomic, strong) NSString *accountType;
@property (nonatomic, strong) NSString *userSig;

//礼物数组
@property(nonatomic,strong)NSMutableArray *giftArray;

@end

@implementation WWLivingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.GroupId = @"@TGS#3MZOSFMED";
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self netWorkRequestGet];
    // 预先设定几组编码质量，之后可以切换
    CGSize videoSize = CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
    //    CGSize videoSize = CGSizeMake(800,480);
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation <= AVCaptureVideoOrientationLandscapeRight) {
        if (orientation > AVCaptureVideoOrientationPortrait) {
            videoSize = CGSizeMake(SCREEN_HEIGHT , SCREEN_WIDTH);
        }
    }
    
    [self _addMosonary];
    [self AFNReachability];
    [self setupCameraDevice];
    [self setupChatRoom];
    [self setupPush];
    _isPause = NO;

    //直播时监听APP是否进入后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppDidEnterBackGround:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
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
- (void)onAppWillEnterForeground:(UIApplication *)app{
    [_txLivePush resumePush];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark ----TXLivePushListener-----
-(void) onPushEvent:(int)EvtID withParam:(NSDictionary*)param {
    
}

-(void) onNetStatus:(NSDictionary*) param {
    
}



#pragma mark ----腾讯云聊天相关----
- (void)setupChatRoom{
    _messageImManager = [TIMManager sharedInstance];
    [_messageImManager setMessageListener:self];//设置消息回调
    [_messageImManager setRefreshListener:self];
    [_messageImManager setConnListener:self];//设置链接通知回调
      _chatRoomConversation =  [_messageImManager getConversation:TIM_GROUP receiver:self.GroupId];
    
    [[TIMManager sharedInstance] setUserStatusListener:self];
}

- (void)dengluchengg{
    __weak typeof(self) weakSelf = self;
    [[TIMGroupManager sharedInstance] JoinGroup:self.GroupId msg:nil succ:^{
        NSLog(@"加入成功");
        [weakSelf switchToLiveRoom:self.GroupId];
    } fail:^(int code, NSString *msg) {
        NSLog(@"加入失败%d---%@",code,msg);
        
//        [weakSelf switchToLiveRoom:self.GroupId];
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

#pragma mark -----礼物动画-----
//礼物消息：消息类型+昵称+时分秒+礼物类型+礼物数量
- (void)starGiftAnimationWithMsg:(TIMMessage *)message {
    TIMTextElem *indexElem = (TIMTextElem *)[message getElem:3];
    TIMTextElem *name = (TIMTextElem *)[message getElem:1];
    TIMTextElem *count = (TIMTextElem *)[message getElem:4];
    NSInteger index = [indexElem.text integerValue];
    NSLog(@"----- index == %ld",(long)index);
    
    GSPChatMessage *msg =[[GSPChatMessage alloc]init];
    msg.text = [NSString stringWithFormat:@" 赠送主播 %@",self.giftArray[1][index]];
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
    
    [manager animWithUserID:[NSString stringWithFormat:@"%@",msg.senderChatID] model:giftModel finishedBlock:^(BOOL result) {
        
    }];
}

#pragma mark ---- 收到消息处理------
//收到消息
- (void)onNewMessage:(NSArray *)msgs{
    // TODO 可以将onThread改为另外的线程
//    [self performSelector:@selector(onHandleNewMessage:) onThread:[NSThread currentThread] withObject:msgs waitUntilDone:NO];
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

//消息格式
//普通消息：消息类型+昵称+时分秒+消息
//礼物消息：消息类型+昵称+时分秒+礼物类型+礼物数量
- (void)onRecvGroup:(TIMMessage *)msg {
    //接受消息的处理代码块
    TIMTextElem *type = (TIMTextElem *)[msg getElem:0];
    if ([type.text isEqualToString:@"1"]) {
        //普通消息
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
        [self.chatView.messageArray addObject:msg];
        if (self.chatView.messageArray.count > 50) {
            [self.chatView.messageArray removeObjectAtIndex:0];
        }
        //        [[ws.chatView mutableArrayValueForKey:@"messageArray"] addObject:message.payloadString];
        if (self.chatView.messageArray.count > 0) {
            
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

//#param mark --------=========




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


#pragma mark -------
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    // do something before rotation
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
//        屏幕从竖屏变为横屏时执行
        NSLog(@"横屏了");
        
    }else{
//        屏幕从横屏变为竖屏时执行
        NSLog(@"书评了");
    }
}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // do something after rotation
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
        return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
//    return NO;
}



- (void)respondsToSettingClicked:(UIButton *)sender{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"WWFirst"];
    WWSettingViewController *setting = [[WWSettingViewController alloc] init];
    setting.isHiddenLivingButton = YES;
    setting.roomInfos = self.roomInafos;
    setting.settingView.biaoqianArray = self.biaoqiansArrays;
    setting.delegate = self;
    [self.navigationController pushViewController:setting animated:YES];
}


- (void)reloadDataHandler{
    //    __strong typeof(self) ws = self;
    //    [UIView animateWithDuration:0.2 animations:^{
    //        [self.chatView.chatRoomTableView reloadData];
    //    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chatView.chatRoomTableView reloadData];
        [self.chatView.chatRoomTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatView.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
    });
    
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self.chatView.chatRoomTableView reloadData];
    //        [self.chatView.chatRoomTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatView.messageArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    //    });
    NSLog(@"zhhash");
}


#pragma mark ---roomNameDelegate----
- (void)returnRoomName:(NSString *)roomName{
    self.titleLabelW.text = roomName;
}




#pragma mark ---腾讯云推流-----
- (void)setupPush {
    // 创建 LivePushConfig 对象，该对象默认初始化为基础配置
    _config = [[TXLivePushConfig alloc] init];
    //在 _config中您可以对推流的参数（如：美白，硬件加速，前后置摄像头等）做一些初始化操作，需要注意 _config不能为nil
    _txLivePush = [[TXLivePush alloc] initWithConfig: _config];
    //开启硬件编码
    _txLivePush.config.enableHWAcceleration = YES;
    //美颜滤镜
    [_txLivePush setBeautyFilterDepth:7 setWhiteningFilterDepth:3];
    _txLivePush.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        _config.enableHWAcceleration  = NO;
    }else{
        _config.enableHWAcceleration  = YES;
    }
}


//开始直播
-(BOOL)startRtmp{
    //启动推流
    self.pushUrl = @"rtmp://7526.livepush.myqcloud.com/live/7526_133558?bizid=7526&txSecret=482eff8be5b1b66f529f418856eac624&txTime=58B992FF";
    
    if (self.pushUrl.length == 0) {
        //        [self toastTip:@"无推流地址，请重新登录后重试!"];
        [MBProgressHUD showError:@"无推流地址，请重新登录后重试"];
        return NO;
    }
    
    //是否有摄像头权限
    AVAuthorizationStatus statusVideo = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (statusVideo == AVAuthorizationStatusDenied) {
        //        [self toastTip:@"获取摄像头权限失败，请前往隐私-相机设置里面打开应用权限"];
        //        [self.logicView closeVCWithError:kErrorMsgOpenCameraFailed Alert:YES Result:NO];
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
        //        [self toastTip:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限"];
        //        [self.logicView closeVCWithError:kErrorMsgOpenMicFailed Alert:YES Result:NO];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"获取麦克风权限失败，请前往隐私-麦克风设置里面打开应用权限" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        return NO;
    }
    
    
    if(_txLivePush != nil)
    {
        [_txLivePush startPreview:self.view];  //_myView 就是step2中需要您指定的view
//        [_txLivePush startPush:self.pushUrl];
        
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

//停止直播
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


#pragma mark ----网络请求----
- (void)netWorkRequestGet{
    //    NSString *url = @"http://www.tianyue.tv/broadcast_app";
    //    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    //    param[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    //    [MBProgressHUD showMessage:nil];
    //    [[NetWorkTool sharedTool] requestMethod:POST URL:url paraments:param finish:^(id responseObject, NSError *error) {
    //        NSLog(@"%@_______________________________%@",responseObject,error);
    //        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
    //            [MBProgressHUD hideHUD];
    //            NSString *messageString = responseObject[@"broadcast"][0][@"keyWord"];
    //            if (messageString.length != 0) {
    //
    //                NSArray *arr = [messageString componentsSeparatedByString:@"_"];
    //                self.biaoqiansArrays = [arr mutableCopy];
    //
    //            }
    //            self.titleLabelW.text = responseObject[@"broadcast"][0][@"name"];
    //            self.roomInafos = responseObject[@"broadcast"][0];
    //            self.pushUrl = self.roomInafos[@"ql_playAddress"];
    //            NSLog(@"%@",self.pushUrl);
    ////            self.onlineNum = self.roomInafos[@"onlineNum"];
    ////            self.focusNum = self.roomInafos[@"focusNum"];
    //            self.topicID = self.roomInafos[@"uid"];
    //
    //            self.numWatchLabel.text = [NSString stringWithFormat:@"%@",self.roomInafos[@"onlineNum"]];
    //            self.numGuanzhuLabel.text = [NSString stringWithFormat:@"%@",self.roomInafos[@"focusNum"]];
    //             [self chatRoom];
    //        }else{
    //            [MBProgressHUD showError:@"网路出错"];
    //        }
    //    }];
}


- (void)openLive{
//    NSString *urlString = @"http://www.tianyue.tv/mobileLivebutton";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"uid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    param[@"zid"] = @"1";
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"mobileLivebutton" paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"responseObject:%@",responseObject);
    }];
}

- (void)closeLive{
//    NSString *urlString = @"http://www.tianyue.tv/mobileLivebutton";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"uid"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    param[@"zid"] = @"0";
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"mobileLivebutton" paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"responseObject:%@",responseObject);
    }];
}


#pragma mark -----倒计时-----
- (void)countDownHandle{
    //新版UI
    [self.view addSubview:self.lightBlackView];
    [self.lightBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        
    }];
    
    //倒计时
    [self.lightBlackView addSubview:self.countDownLabel];
    [self.countDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.lightBlackView.mas_centerX).with.offset(0);
        make.centerY.equalTo(self.lightBlackView.mas_centerY).with.offset(0);
    }];
    
    _secondsCountDown = 3;
    _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    self.countDownLabel.text = [NSString stringWithFormat:@"%d",_secondsCountDown];
}

- (void)timeFireMethod{
    _secondsCountDown --;
    self.countDownLabel.text = [NSString stringWithFormat:@"%d",_secondsCountDown];
    if (_secondsCountDown == 0) {
        //倒计时结束，开始直播
        [self startRtmp];
        [_countDownTimer invalidate];
        [self.lightBlackView removeFromSuperview];
        //        [self.countDownLabel removeFromSuperview];
    }
}



#pragma mark ----添加约束----
- (void)_addMosonary{
    //底部
    [self.view addSubview:self.bottomView];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.bottomView autoSetDimension:ALDimensionHeight toSize:0.38*SCREEN_HEIGHT];
    
    //聊天页面
    [self.bottomView addSubview:self.chatView];
    [self.chatView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.chatView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.chatView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.chatView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    
    //下边按钮
    
    

    //上部的背景
    [self.view addSubview:self.topBgView];
    [self.topBgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.topBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.topBgView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.topBgView autoSetDimension:ALDimensionHeight toSize:64];
    
    // 摄像头切换
    [self.view addSubview:self.toggleCameraButton];
    [self.toggleCameraButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.toggleCameraButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topBgView];
    [self.toggleCameraButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];
//    [self.toggleCameraButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.bottom.equalTo(self.bottomView.mas_top).with.offset(-0.3*SCREEN_HEIGHT);
//        make.width.mas_equalTo(0.12*SCREEN_WIDTH);
//        make.height.mas_equalTo(0.15*SCREEN_WIDTH);
//    }];
    
    [self.view addSubview:self.changeButton];
    [self.changeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(58)];
    //    [self.changeButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toggleCameraButton];
    [self.changeButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    //    [self.changeButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];
    [self.changeButton sizeToFit];
    
    //闪光灯
    [self.view addSubview:self.shanguangdengButton];
    [self.shanguangdengButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.shanguangdengButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toggleCameraButton];
    [self.shanguangdengButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];
//    [self.shanguangdengButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.changeButton.mas_bottom).with.offset(0);
//        make.right.equalTo(self.view.mas_right).with.offset(0);
//        make.width.mas_equalTo(0.12*SCREEN_WIDTH);
//        make.height.mas_equalTo(0.15*SCREEN_WIDTH);
//    }];
    
    
    //分享
    [self.view addSubview:self.shareButton];
    [self.shareButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(58)];
    //    [self.shareButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.shanguangdengButton];
    [self.shareButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    //    [self.shareButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];
    [self.shareButton sizeToFit];
    
    
    [self.view addSubview:self.startButton];
    //    [self.startButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.shareButton withOffset:kHeightChange(10)];
//    [self.startButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.startButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.startButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    //    [self.startButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(120), kWidthChange(120))];
    //    [self.startButton sizeToFit];
    //    [self.startButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];
    [self.startButton sizeToFit];
    
    
    /*
     //封面
     [self.view addSubview:self.headBackImage];
     [self.headBackImage mas_makeConstraints:^(MASConstraintMaker *make) {
     //        make.top.equalTo(self.view.mas_top).with.offset(0.31 *SCREEN_HEIGHT);
     //        make.bottom.equalTo(self.view.mas_bottom).with.offset(-0.485*SCREEN_HEIGHT);
     make.width.mas_equalTo(SCREEN_WIDTH *0.5);
     make.height.mas_equalTo(SCREEN_WIDTH*0.3);
     make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
     make.centerY.equalTo(self.view.mas_centerY).with.offset(0);
     //        make.left.equalTo(self.view.mas_left).with.offset(0.25*SCREEN_WIDTH);
     //        make.right.equalTo(self.view.mas_right).with.offset(-0.25*SCREEN_WIDTH);
     
     }];
     
     //标题背景
     [self.view addSubview:self.titleTextFieldBackView];
     [self.titleTextFieldBackView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.centerX.equalTo(self.headBackImage.mas_centerX).with.offset(0);
     //        make.left.equalTo(self.view.mas_left).with.offset(0.298*SCREEN_WIDTH);
     //        make.right.equalTo(self.view.mas_right).with.offset(-0.298*SCREEN_WIDTH);
     make.width.equalTo(self.headBackImage.mas_width).with.offset(-40);
     make.bottom.equalTo(self.headBackImage.mas_top).with.offset(-0.02*SCREEN_WIDTH);
     make.height.mas_equalTo(0.066 *SCREEN_WIDTH);
     }];
     
     //标题
     [self.titleTextFieldBackView addSubview:self.titleTextField];
     [self.titleTextField mas_makeConstraints:^(MASConstraintMaker *make) {
     //        make.centerY.equalTo(self.headBackImage.mas_centerY).with.offset(0);
     make.centerX.equalTo(self.headBackImage.mas_centerX).with.offset(0);
     //        make.left.equalTo(self.view.mas_left).with.offset(0.308*SCREEN_WIDTH);
     //        make.right.equalTo(self.view.mas_right).with.offset(-0.308*SCREEN_WIDTH);
     make.width.equalTo(self.headBackImage.mas_width).with.offset(-40);
     make.bottom.equalTo(self.headBackImage.mas_top).with.offset(-0.02*SCREEN_WIDTH);
     make.height.mas_equalTo(0.066 *SCREEN_WIDTH);
     }];
     */
    

    
    
    //返回按钮
    [self.topBgView addSubview:self.backButton];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [self.backButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(75), kWidthChange(75))];
    [self.backButton sizeToFit];

    //标题按钮
    [self.topBgView addSubview:self.titleLabelW];
    [self.titleLabelW autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titleLabelW autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    
    //设置按钮
    [self.topBgView addSubview:self.settingButton];
    [self.settingButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [self.settingButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.settingButton sizeToFit];
    
    //观看人数标志
    [self.view addSubview:self.numWatchImageView];
    [self.numWatchImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.numWatchImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topBgView withOffset:kHeightChange(20)];
    [self.numWatchImageView sizeToFit];
    
    [self.view addSubview:self.numWatchLabel];
    [self.numWatchLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.numWatchImageView];
    [self.numWatchLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.numWatchImageView];
    
    //关注人数的标志
    [self.view addSubview:self.numGuanzhuImageView];
    [self.numGuanzhuImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.numWatchImageView withOffset:kWidthChange(80)];
    [self.numGuanzhuImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.numWatchImageView];
    [self.numGuanzhuImageView sizeToFit];
    
    [self.view addSubview:self.numGuanzhuLabel];
    [self.numGuanzhuLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.numGuanzhuImageView];
    [self.numGuanzhuLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.numGuanzhuImageView];
    
    //暂停按钮
    [self.view addSubview:self.pauseButton];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(kWidthChange(-20));
//        make.size.mas_equalTo(CGSizeMake(kWidthChange(90), kHeightChange(112)));
        make.top.equalTo(self.toggleCameraButton.mas_bottom).with.offset(kHeightChange(200));
    }];
    [self.pauseButton sizeToFit];
    
    
}

#pragma mark ---横竖屏切换----
//横竖屏切换点击
- (void)respondsToSGDButton:(UIButton *)sender{
    
    self.changeButton.enabled = NO;
    sender.selected = !sender.selected;
    
    /*
    if (sender.selected) {
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.allowRotate = 1;
        
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
        [self hengpingChangge];
        
    }else{
        AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        delegate.allowRotate = 0;
        
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
        [self shupingChange];
    }
    */
     
    self.changeButton.enabled = YES;
    
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

#pragma mark ----竖屏切换-----
- (void)shupingChange{
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(kHeightChange(510));
    }];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.bottomView layoutIfNeeded];

    }];
    

    [self.chatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom).with.offset(0);
        make.right.equalTo(self.bottomView.mas_right).with.offset(0);
        make.left.equalTo(self.bottomView.mas_left).with.offset(0);
        make.top.equalTo(self.bottomView.mas_top).with.offset(0);
    }];
    
    [self.chatView.chatRoomTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatView.mas_top).with.offset(0);
        make.left.equalTo(self.chatView.mas_left).with.offset(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(kHeightChange(430));
    }];
    
//     [self.topBgView removeFromSuperview];
    [self.view addSubview:self.topBgView];
    [self.topBgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.topBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.topBgView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.topBgView autoSetDimension:ALDimensionHeight toSize:64];
    
    // 摄像头切换
     [self.toggleCameraButton removeFromSuperview];
    [self.view addSubview:self.toggleCameraButton];
    [self.toggleCameraButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.toggleCameraButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topBgView];
    [self.toggleCameraButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];
 
    //闪光灯
     [self.shanguangdengButton removeFromSuperview];
    [self.view addSubview:self.shanguangdengButton];
    [self.shanguangdengButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.shanguangdengButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.toggleCameraButton withOffset:kHeightChange(40)];
    [self.shanguangdengButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];
 
    [self.changeButton removeFromSuperview];
    [self.view addSubview:self.changeButton];
    [self.changeButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(58)];
    [self.changeButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.changeButton sizeToFit];
    
    //分享
    [self.shareButton removeFromSuperview];
    [self.view addSubview:self.shareButton];
    [self.shareButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(58)];
    [self.shareButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.shareButton sizeToFit];
    
    [self.startButton removeFromSuperview];
    [self.view addSubview:self.startButton];
    [self.startButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.startButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.startButton sizeToFit];
    
    //观看人数标志
    [self.numWatchImageView removeFromSuperview];
    [self.view addSubview:self.numWatchImageView];
    [self.numWatchImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.numWatchImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topBgView withOffset:kHeightChange(20)];
    [self.numWatchImageView sizeToFit];
    
    [self.numWatchLabel removeFromSuperview];
    [self.view addSubview:self.numWatchLabel];
    [self.numWatchLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.numWatchImageView];
    [self.numWatchLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.numWatchImageView];
    
    //关注人数的标志
    [self.numGuanzhuImageView removeFromSuperview];
    [self.view addSubview:self.numGuanzhuImageView];
    [self.numGuanzhuImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.numWatchImageView withOffset:kWidthChange(80)];
    [self.numGuanzhuImageView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.numWatchImageView];
    [self.numGuanzhuImageView sizeToFit];
    
    [self.numGuanzhuLabel removeFromSuperview];
    [self.view addSubview:self.numGuanzhuLabel];
    [self.numGuanzhuLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.numGuanzhuImageView];
    [self.numGuanzhuLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.numGuanzhuImageView];
    
    //暂停按钮
    [self.view addSubview:self.pauseButton];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(kWidthChange(-20));
        //        make.size.mas_equalTo(CGSizeMake(kWidthChange(90), kHeightChange(112)));
        make.top.equalTo(self.toggleCameraButton.mas_bottom).with.offset(kHeightChange(200));
    }];
    [self.pauseButton sizeToFit];
}

#pragma mark ----横屏切换-----
- (void)hengpingChangge{
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.38*SCREEN_HEIGHT);
    }];
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.bottomView layoutIfNeeded];
        
    }];
    
    //聊天页面
    [self.chatView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bottomView.mas_bottom).with.offset(0);
        make.right.equalTo(self.bottomView.mas_right).with.offset(0);
        make.left.equalTo(self.bottomView.mas_left).with.offset(0);
        make.top.equalTo(self.bottomView.mas_top).with.offset(0);
    }];

    // 摄像头切换
    [self.toggleCameraButton removeFromSuperview];
    [self.view addSubview:self.toggleCameraButton];
    [self.toggleCameraButton autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.toggleCameraButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topBgView];
    [self.toggleCameraButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];


    //闪光灯
    [self.shanguangdengButton removeFromSuperview];
    [self.view addSubview:self.shanguangdengButton];
    [self.shanguangdengButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    [self.shanguangdengButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.toggleCameraButton];
    [self.shanguangdengButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];



    [self.startButton removeFromSuperview];
    [self.view addSubview:self.startButton];
    [self.startButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.startButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.view withOffset:kHeightChange(-150)];
//    [self.startButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(370)];
    [self.startButton sizeToFit];
    
    //分享
    [self.shareButton removeFromSuperview];
    [self.view addSubview:self.shareButton];
    [self.shareButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.startButton withOffset:kWidthChange(0)];
    [self.shareButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.startButton withOffset:kWidthChange(115)];
    [self.shareButton sizeToFit];
//    [self.shareButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(90), kHeightChange(112))];
    
    
    [self.changeButton removeFromSuperview];
    [self.view addSubview:self.changeButton];
    [self.changeButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.startButton withOffset:kWidthChange(-115)];
 
    [self.changeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.startButton withOffset:kWidthChange(0)];
    [self.changeButton sizeToFit];
    
    [self.chatView.chatRoomTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chatView.mas_top).with.offset(0);
        make.left.equalTo(self.chatView.mas_left).with.offset(0);
        make.width.mas_equalTo(SCREEN_HEIGHT);
        make.height.mas_equalTo(0.38*SCREEN_HEIGHT - kHeightChange(100));
    }];
    
    
    //暂停按钮
    [self.view addSubview:self.pauseButton];
    [self.pauseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(kWidthChange(-20));
        make.top.equalTo(self.toggleCameraButton.mas_bottom).with.offset(kHeightChange(400));
    }];
    [self.pauseButton sizeToFit];
    
}

#pragma mark ----Action----
//播放点击
- (void)respondsToStarButton:(UIButton *)sender{
//    sender.selected = !sender.selected;
    //判断是否是暂停状态，暂停的话继续
    if (_isPause) {
        [_txLivePush resumePush];
    } else {
        //不是暂停，开启推流
        [self countDownHandle];
    }
    
    self.startButton.hidden = YES;
    self.shareButton.hidden = YES;
    self.changeButton.hidden = YES;
    self.pauseButton.hidden = NO;
}

//暂停按钮
- (void)respondsToPauseHandle:(UIButton *)sender{
    NSLog(@"暂停");
    _isPause = YES;
    self.startButton.hidden = NO;
    self.shareButton.hidden = NO;
    self.changeButton.hidden = NO;
    sender.hidden = YES;

    if (_txLivePush) {
         [_txLivePush pausePush];
    }
}


- (void)removeallviews{
    [self.bottomView removeFromSuperview];
    [self.startButton removeFromSuperview];
    [self.toggleCameraButton removeFromSuperview];
    [self.changeButton removeFromSuperview];
    [self.shanguangdengButton removeFromSuperview];
    [self.shareButton removeFromSuperview];
    [self.backButton removeFromSuperview];
}

//返回按钮
- (void)respondsToBackClicked:(UIButton *)sender{
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
    
    //当不再需要DMS对象时，务必要断开连接
    [_client disconnectWithCompletionHandler:^(NSUInteger code) {
        NSLog(@"disconnected");
    }];
    
    /*
    //    WWIndextViewController *index = [[WWIndextViewController alloc] init];
    //    [self.navigationController popToViewController:index animated:YES];
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 0;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    //       [self _notifyServerExitRoom];//退出房间
    */
     
     
    //结束推流
    [self stopRtmp];
    //退出直播房间
    [self closeLive];
}



// 添加封面
- (void)respondsToBtn:(UIButton *)sender{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请选择图片的来源" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *action) {
                                                // 此处处理点击取消按钮逻辑
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        //    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //    }
        //sourceType = UIImagePickerControllerSourceTypeCamera; //照相机
        //sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //图片库
        //sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum; //保存的相片
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];//初始化
        picker.delegate = self;
        picker.allowsEditing = YES;//设置可编辑
        picker.sourceType = sourceType;
        //        [self presentModalViewController:picker animated:YES];//进入照相界面
        [self presentViewController:picker animated:YES completion:nil];
        
        
        NSLog(@"相机");
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //pickerImage.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            
        }
        pickerImage.delegate = self;
        pickerImage.allowsEditing = NO;
        //        [self presentModalViewController:pickerImage animated:YES];
        [self presentViewController:pickerImage animated:YES completion:nil];
        NSLog(@"相机");
    }]];
    
    [self presentViewController: alert animated:YES completion:nil];
    NSLog( @"添加图片");
}

//切换摄像头
- (void)respondsToToggleCameraButton:(UIButton *)sender{
    sender.selected = !sender.selected;
    //    dispatch_async(self.sessionQueue, ^{
    //        [self.cameraStreamingSession toggleCamera];
    //    });
    [_txLivePush switchCamera];
}

//闪光灯
- (void)respondsToshanguanButton:(UIButton *)sender{
    if (sender.selected) {
        [_txLivePush toggleTorch:YES];
    } else {
        [_txLivePush toggleTorch:NO];
    }
    sender.selected = !sender.selected;

}


//分享按钮
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
    NSLog(@"点击了分享按钮");
}


#pragma mark ----懒加载----
//礼物数组
-(NSMutableArray *)giftArray
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

//暂停按钮
- (UIButton *)pauseButton{
    if (!_pauseButton) {
        _pauseButton = [[UIButton alloc] init];
        [_pauseButton setBackgroundImage:[UIImage imageNamed:@"矩形-5-拷贝"] forState:UIControlStateNormal];
        [_pauseButton addTarget:self action:@selector(respondsToPauseHandle:) forControlEvents:UIControlEventTouchUpInside];
        _pauseButton.hidden = YES;
    }
    return _pauseButton;
}

//倒计时背景蒙层
- (UIView *)lightBlackView{
    if (!_lightBlackView) {
        _lightBlackView = [[UIView alloc] init];
        _lightBlackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _lightBlackView;
}

//倒计时显示Label
- (UILabel *)countDownLabel{
    if (!_countDownLabel) {
        _countDownLabel = [[UILabel alloc] init];
        _countDownLabel.font = [UIFont boldSystemFontOfSize:kWidthChange(80)];
        _countDownLabel.textColor = [UIColor whiteColor];
    }
    return _countDownLabel;
}



//房间信息
-(NSDictionary *)roomInafos{
    if (!_roomInafos) {
        _roomInafos = [[NSDictionary alloc] init];
    }
    return _roomInafos;
}


//聊天页面
- (WWChatRoomView *)chatView{
    if (!_chatView) {
        _chatView = [[WWChatRoomView alloc] initWithFrame:self.view.frame];
        _chatView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    return _chatView;
}

- (UILabel *)numGuanzhuLabel{
    if (!_numGuanzhuLabel) {
        _numGuanzhuLabel = [[UILabel alloc] init];
        _numGuanzhuLabel.text = @"2345";
        _numGuanzhuLabel.textColor = WWColor(209, 208, 208);
        _numGuanzhuLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _numGuanzhuLabel;
}

//关注的人数的标志
- (UIImageView *)numGuanzhuImageView{
    if (!_numGuanzhuImageView) {
        _numGuanzhuImageView = [[UIImageView alloc] init];
        _numGuanzhuImageView.image = [UIImage imageNamed:@"我的粉丝-(2)"];
    }
    return _numGuanzhuImageView;
}

//观看人数
- (UILabel *)numWatchLabel{
    if (!_numWatchLabel) {
        _numWatchLabel = [[UILabel alloc] init];
        _numWatchLabel.text = @"12k";
        _numWatchLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _numWatchLabel.textColor = WWColor(209, 208, 208);
    }
    return _numWatchLabel;
}

//观看人数标志
- (UIImageView *)numWatchImageView{
    if (!_numWatchImageView) {
        _numWatchImageView = [[UIImageView alloc] init];
        _numWatchImageView.image = [UIImage imageNamed:@"眼睛2"];
    }
    return _numWatchImageView;
}

//设置按钮
- (UIButton *)settingButton{
    if (!_settingButton) {
        _settingButton = [[UIButton alloc] init];
        [_settingButton setImage:[UIImage imageNamed:@"设置-(2)"] forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(respondsToSettingClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;
}

//标题
- (UILabel *)titleLabelW{
    if (!_titleLabelW) {
        _titleLabelW = [[UILabel alloc] init];
        _titleLabelW.text =@"我的直播间";
        _titleLabelW.font= [UIFont systemFontOfSize:17];
        _titleLabelW.textColor = [UIColor whiteColor];
    }
    return _titleLabelW;
}

//上部的背景
- (UIView *)topBgView{
    if (!_topBgView) {
        _topBgView = [[UIView alloc] init];
        _topBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }
    return _topBgView;
}

//返回按钮
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"返回_白"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(respondsToBackClicked:) forControlEvents:UIControlEventTouchUpInside];
//        _backButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
//        _backButton.layer.cornerRadius = 0.05*SCREEN_WIDTH;
    }
    return _backButton;
}

- (UIButton *)startButton{
    if (!_startButton) {
        _startButton = [[UIButton alloc] init];
        //        _startButton.backgroundColor = [UIColor whiteColor];
//        [_startButton setBackgroundImage:[UIImage imageNamed:@"椭圆-1-副本-1"] forState:UIControlStateNormal];
        [_startButton setImage:[UIImage imageNamed:@"大播放"] forState:UIControlStateNormal];
//        [_startButton setImage:[UIImage imageNamed:@"矩形-5-拷贝"] forState:UIControlStateSelected];
//        [_startButton setTitle:@"开始" forState:UIControlStateNormal];
//                [_startButton setTitle:@"暂停" forState:UIControlStateSelected];
//        [_startButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_startButton addTarget:self action:@selector(respondsToStarButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startButton;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
//        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
    }
    return _bottomView;
}

- (UIButton *)toggleCameraButton{
    if (!_toggleCameraButton) {
        _toggleCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
//        _toggleCameraButton.backgroundColor = [UIColor blackColor];
//        _toggleCameraButton.alpha = 0.5f;
        //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
        [_toggleCameraButton setImage:[UIImage imageNamed:@"反转摄像头"] forState:UIControlStateNormal];//给button添加image
//        _toggleCameraButton.imageEdgeInsets = UIEdgeInsetsMake(0,5,21,_changeButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//        [_toggleCameraButton setTitle:@"前摄像头" forState:UIControlStateNormal];//设置button的title
//        [_toggleCameraButton setTitle:@"后摄像头" forState:UIControlStateSelected];
//        _toggleCameraButton.titleLabel.font = [UIFont systemFontOfSize:8];//title字体大小
//        _toggleCameraButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//        [_toggleCameraButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _toggleCameraButton.titleEdgeInsets = UIEdgeInsetsMake(20, -_changeButton.titleLabel.bounds.size.width-28, 0, 0);
        [_toggleCameraButton addTarget:self action:@selector(respondsToToggleCameraButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _toggleCameraButton;
}

- (UIView *)titleTextFieldBackView{
    if (!_titleTextFieldBackView) {
        _titleTextFieldBackView = [[UIView alloc] init];
        _titleTextFieldBackView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];;
        
    }
    return _titleTextFieldBackView;
}

//横竖屏切换
- (UIButton *)changeButton{
    if (!_changeButton) {
        
        _changeButton = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
//        _changeButton.backgroundColor = [UIColor blackColor];
//        _changeButton.alpha = 0.5f;
        //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
        [_changeButton setImage:[UIImage imageNamed:@"横转竖"] forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(respondsToSGDButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _changeButton;
}

//闪光灯
- (UIButton *)shanguangdengButton{
    if (!_shanguangdengButton) {
        
        _shanguangdengButton = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
//        _shanguangdengButton.backgroundColor = [UIColor blackColor];
//        _shanguangdengButton.alpha = 0.5f;
        //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
        [_shanguangdengButton setImage:[UIImage imageNamed:@"闪光灯自动"] forState:UIControlStateNormal];//给button添加image
//        _shanguangdengButton.imageEdgeInsets = UIEdgeInsetsMake(0,5,21,_changeButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//        [_shanguangdengButton setTitle:@"闪光灯开" forState:UIControlStateNormal];//设置button的title
//        [_shanguangdengButton setTitle:@"闪关灯关" forState:UIControlStateSelected];
//        _shanguangdengButton.titleLabel.font = [UIFont systemFontOfSize:8];//title字体大小
//        _shanguangdengButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//        [_shanguangdengButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _shanguangdengButton.titleEdgeInsets = UIEdgeInsetsMake(20, -_changeButton.titleLabel.bounds.size.width-22, 0, 0);
        [_shanguangdengButton addTarget:self action:@selector(respondsToshanguanButton:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _shanguangdengButton;
}

//分享
- (UIButton *)shareButton{
    if (!_shareButton) {
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];//button的类型
//        _shareButton.backgroundColor = [UIColor blackColor];
//        _shareButton.alpha = 0.5f;
        //    在UIButton中有三个对EdgeInsets的设置：ContentEdgeInsets、titleEdgeInsets、imageEdgeInsets
        [_shareButton setImage:[UIImage imageNamed:@"分享(1)w"] forState:UIControlStateNormal];//给button添加image
//        _shareButton.imageEdgeInsets = UIEdgeInsetsMake(0,5,21,_changeButton.titleLabel.bounds.size.width);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
//        [_shareButton setTitle:@"分享直播" forState:UIControlStateNormal];//设置button的title
//        //        [_shareButton setTitle:@"后摄像头" forState:UIControlStateSelected];
//        _shareButton.titleLabel.font = [UIFont systemFontOfSize:8];//title字体大小
//        _shareButton.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
//        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _shareButton.titleEdgeInsets = UIEdgeInsetsMake(20, -_changeButton.titleLabel.bounds.size.width-26, 0, 0);
        [_shareButton addTarget:self action:@selector(respondsToShareButton:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _shareButton;
}

//封面
- (UIImageView *)headBackImage{
    if (!_headBackImage) {
        _headBackImage = [[UIImageView alloc] init];
        _headBackImage.backgroundColor = [UIColor blackColor];
        _headBackImage.alpha = 0.5f;
        _headBackImage.layer.cornerRadius = 5.0f;
        _headBackImage.userInteractionEnabled = YES;
        _headBackImage.image = [UIImage imageNamed:@"矩形-3"];
        UIButton *button = [[UIButton alloc] init];
        [button setImage:[UIImage imageNamed:@"加号-(2)"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(respondsToBtn:) forControlEvents:UIControlEventTouchUpInside];
        //        button.center = _headBackImage.center;
        [_headBackImage addSubview:button];
        [button autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [button autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [button autoSetDimensionsToSize:CGSizeMake(kWidthChange(105), kWidthChange(105))];
//        [button mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(_headBackImage.mas_centerY).with.offset(0);
//            //            make.bottom.equalTo(self.view.mas_bottom).with.offset(-0.3*SCREEN_HEIGHT);
//            make.centerX.equalTo(_headBackImage.mas_centerX).with.offset(0);
//            make.width.mas_equalTo(0.14*SCREEN_WIDTH);
//            make.height.mas_equalTo(0.14*SCREEN_WIDTH);
//        }];
//        
    }
    return _headBackImage;
}

//标题
- (UITextField *)titleTextField{
    if (!_titleTextField) {
        _titleTextField = [[UITextField alloc] init];
        _titleTextField.placeholder = @"请输入房间标题";
        _titleTextField.textAlignment = NSTextAlignmentCenter;
        _titleTextField.textColor = [UIColor whiteColor];
        _titleTextField.font = [UIFont systemFontOfSize:0.025*SCREEN_HEIGHT];
        _titleTextField.alpha = 0.5f;
        _titleTextField.backgroundColor = [UIColor blackColor];
        [_titleTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _titleTextField.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"修改_直播"]];
        
        _titleTextField.rightViewMode = UITextFieldViewModeAlways;
        
    }
    return _titleTextField;
}


#pragma mark ----网络监测----
//使用AFN框架来检测网络状态的改变
-(void)AFNReachability
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




#pragma mark -----UINavigationControllerDelegate && UIImagePickerControllerDelegate----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    self.headBackImage.image = image;
    self.headBackImage.alpha = 1.0f;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark -----
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    /*
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.allowRotate = 0;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
   
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
    */
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}




@end
