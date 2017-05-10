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
#import "PresentView.h"
#import "AnimOperation.h"
#import "AnimOperationManager.h"
#import "LoginModel.h"
#import <BarrageRenderer.h>

#import "LivingSettingView.h"


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

// 礼物按钮
@property (weak, nonatomic) IBOutlet UIButton *giftButton;

// 弹幕数组
@property(nonatomic,strong)NSMutableArray *messagesArray;

// 播放器
@property (nonatomic, strong) TXLivePlayer *livePlayer;

// 礼物view
@property (nonatomic, strong) LivingLandscapeGiftView *giftView;

// 礼物动画管理类
@property (nonatomic, strong) AnimOperationManager *giftManager;

// 弹幕view
@property (nonatomic, strong) BarrageRenderer *renderView;

// 直播设置
@property (nonatomic, strong) LivingSettingView *settingView;


@end

@implementation LivingLandscapeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view_top.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.view_bottom.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    self.textF_input.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    // 修改placeholder颜色
    [self.textF_input setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // 开始播放直播
    [self startPlayer];
    // 礼物
    [self initilizeGiftView];
    // 弹幕
    [self initBarrageRender];
    // 开始渲染弹幕
    [self.renderView start];
    
    [self initSettingView];
    
    // 接收聊天室的信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMessageAction:) name:@"ReceiveMessageNotification" object:nil];

    

}

- (IBAction)btn_back:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // 停止播放
    [self.livePlayer stopPlay];
    
    // 记得销毁view控件
    [self.livePlayer removeVideoWidget];
    
    // 停止弹幕渲染，必须调用，否则会引起内存泄漏
    [self.renderView stop];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 点击屏幕，隐藏控件
    if (self.view_top.alpha == 1) {
        [UIView animateWithDuration:0.5 animations:^{
            self.view_top.alpha = 0;
            self.view_bottom.alpha = 0;
        }];
        if (self.giftButton.selected) {
            [UIView animateWithDuration:0.5 animations:^{
                _giftView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - GiftViewHeight - self.view_bottom.height, GiftViewWidth, GiftViewHeight);
            }];
            self.giftButton.selected = NO;
        }
    } else {
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
    if (self.textF_input.text.length > 0)
    {
        if ([self.delegate respondsToSelector:@selector(giftSendBack:text:)]) {
            [self.delegate giftSendBack:nil text:self.textF_input.text];
        }
        
        [self.messagesArray addObject:self.textF_input.text];
        
        if (self.messagesArray.count > 50)
        {
            [self.messagesArray removeObjectAtIndex:0];
        }
        [self sendBarrage];
        
        self.textF_input.text = @"";
    }
    [self.view endEditing:YES];
}


/**
 送礼物按钮响应

 @param sender 送礼物按钮
 */
- (IBAction)btn_giveGift_action:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        [UIView animateWithDuration:0.5 animations:^{
            _giftView.frame = CGRectMake(SCREEN_WIDTH - GiftViewWidth, SCREEN_HEIGHT - GiftViewHeight - self.view_bottom.height, GiftViewWidth, GiftViewHeight);
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            _giftView.frame = CGRectMake(SCREEN_WIDTH, SCREEN_HEIGHT - GiftViewHeight - self.view_bottom.height, GiftViewWidth, GiftViewHeight);
        }];
    }
    
}

#pragma mark - 腾讯视频播放相关
- (TXLivePlayer *)livePlayer {
    if (!_livePlayer) {
        _livePlayer = [[TXLivePlayer alloc] init];
        //        [_livePlayer setupVideoWidget:self.livingView.bounds containView:self.livingView insertIndex:0];
        _livePlayer.delegate = self;
        
        TXLivePlayConfig *_config = [[TXLivePlayConfig alloc] init];
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
//    [self.livePlayer startPlay:@"rtmp://live.hkstv.hk.lxdns.com/live/hks" type:PLAY_TYPE_LIVE_RTMP];
}


- (AnimOperationManager *)giftManager {
    if (!_giftManager) {
        _giftManager = [AnimOperationManager sharedManager];
        _giftManager.parentView = self.view;
        _giftManager.parentView.alpha = 1;
    }
    return _giftManager;
}

- (void)initilizeGiftView {
    _giftView = [LivingLandscapeGiftView shareGiftViewInstancetype];
    _giftView.frame = CGRectMake(SCREEN_HEIGHT, SCREEN_WIDTH - GiftViewHeight - self.view_bottom.height, GiftViewWidth, GiftViewHeight);
    [self.view_live addSubview:_giftView];
    
    @weakify(self);
    _giftView.block = ^(NSInteger tag){
        
        @strongify(self);

        NSArray *array = @[@{@"pic" : @"桃子-01-1",
                             @"name" : @"灵桃",
                             @"price" : @"10越币"},
                           
                           @{@"pic" : @"咖啡-1",
                             @"name" : @"咖啡",
                             @"price" : @"10越币"},
                           
                           @{@"pic" : @"鼓掌-1",
                             @"name" : @"鼓掌",
                             @"price" : @"10越币"}];
        
        switch (tag) {
            case 0:
            case 1:
            case 2: { // 灵桃 咖啡 鼓掌
                
                NSDictionary *dict = array[tag];
                
                [self giftAnimation:dict andIndex:(int)tag];
                
                if ([self.delegate respondsToSelector:@selector(giftSendBack:text:)]) {
                    [self.delegate giftSendBack:dict[@"pic"] text:nil];
                }
                
            } break;
                
            case 3: { // 充值
                
            } break;
                
            default:
                break;
        }
    };
}

// 发送礼物展示的动画
- (void)giftAnimation:(NSDictionary *)dict andIndex:(int)index
{
    LoginModel *loginM = [self gainObjectFromUsersDefaults:@"loginSuccess"];
    
    // 礼物模型
    GiftModel *giftModel = [[GiftModel alloc] init];
    giftModel.headImageUrl = loginM.headUrl;
    giftModel.name = loginM.nickName;
    giftModel.giftImage = [UIImage imageNamed:dict[@"pic"]];
    giftModel.giftName = [NSString stringWithFormat:@"  %@", dict[@"name"]];
    giftModel.giftCount = 1;
    
    [self.giftManager animWithUserID:[NSString stringWithFormat:@"%d", index] model:giftModel finishedBlock:^(BOOL result) {
        
    }];
}

- (void)initBarrageRender {
    self.renderView = [[BarrageRenderer alloc] init];
    self.renderView.canvasMargin = UIEdgeInsetsMake(45, 10, 10, 10);
//    self.renderView.view.alpha = 0;
    [self.view addSubview:self.renderView.view];
}

- (void)initSettingView {
    self.settingView = [LivingSettingView shareLivingSettingInstancetype];
    self.settingView.frame = CGRectMake(0, 50, SettingViewWidth, 315);
    [self.view addSubview:self.settingView];
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


#pragma mark - 弹幕
- (void)sendBarrage
{
    NSLog(@"开始发送");
    NSInteger spriteNumber = [_renderView spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderView receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L]];
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
    /*
    if (self.messagesArray != nil && ![self.messagesArray isKindOfClass:[NSNull class]] && self.messagesArray.count != 0)
    {
        if ([self.messagesArray[self.messagesArray.count -1] rangeOfString:@"赠送礼物"].location != NSNotFound)
        {
            [self.messagesArray removeObject:self.messagesArray[self.messagesArray.count -1]];
        } else if ([self.messagesArray[self.messagesArray.count -1] rangeOfString:@":"].location !=NSNotFound) {
            NSArray *array =[self.messagesArray[self.messagesArray.count -1] componentsSeparatedByString:@":"];
            descriptor.params[@"text"] = array[1];
        }
    }
     */
    descriptor.params[@"text"] = self.messagesArray[self.messagesArray.count - 1];
    descriptor.params[@"textColor"] = [UIColor whiteColor];
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"side"] = @(side);
    NSLog(@"descriptor %@",descriptor);
    return descriptor;
}

- (NSMutableArray *)messagesArray
{
    if (!_messagesArray)
    {
        _messagesArray = [NSMutableArray array];
    }
    return _messagesArray;
}



// 处理接收到的聊天室信息
- (void)receiveMessageAction:(NSNotification *)notification
{
    NSDictionary *dict = (NSDictionary *)notification.userInfo;
    
    [self.messagesArray addObject:dict[@"text"]];
    
    if (self.messagesArray.count > 50)
    {
        [self.messagesArray removeObjectAtIndex:0];

    }
    
    [self sendBarrage];
}
 
- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


