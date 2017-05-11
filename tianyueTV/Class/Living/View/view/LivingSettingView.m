//
//  LivingSettingView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/5/10.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "LivingSettingView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface LivingSettingView () {
    UISlider *volumeViewSlider;  // 获取系统音量控制
}

// 音量大小
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

// 亮度
@property (weak, nonatomic) IBOutlet UISlider *brightSlider;

// 透明度
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;

// 大小
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;

// 软解
@property (weak, nonatomic) IBOutlet UIButton *softButton;

// 硬解
@property (weak, nonatomic) IBOutlet UIButton *hardButton;

@end

@implementation LivingSettingView


+ (instancetype)shareLivingSettingInstancetype {
    return [[NSBundle mainBundle] loadNibNamed:@"LivingSettingView" owner:nil options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    [self.brightSlider setThumbImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    [self.alphaSlider setThumbImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    [self.sizeSlider setThumbImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    // 获取MPVolumeSlider实例,MPVolumeSlider的父类是slider,可以通过它来控制系统音量
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider *)view;
            break;
        }
    }
    // 监听系统音量变化
    NSError *error;
    [[AVAudioSession sharedInstance] setActive:YES error:&error];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(trackDeviceVolume) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
}


/**
 系统音量变化
 */
- (void)trackDeviceVolume {
    self.volumeSlider.value = volumeViewSlider.value;
}


/**
 按钮点击事件

 @param sender 软解/硬解
 */
- (IBAction)button_action:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = !sender.selected;
    if (sender == self.softButton) {
        self.hardButton.selected = NO;
    } else if (sender == self.hardButton) {
        self.softButton.selected = NO;
    }
    
    if (self.block) {
        self.block(sender.tag - 100);
    }
}


/**
 滑动条滑动事件

 @param sender 活动条
 */
- (IBAction)slider_action:(UISlider *)sender {
    if (sender == self.volumeSlider) {
        volumeViewSlider.value = sender.value;
    } else if (sender == self.brightSlider) {
        [[UIScreen mainScreen]setBrightness:sender.value];
    } else {
        if (self.block) {
            self.block(sender.tag - 100);
        }
    }
    
}




@end
