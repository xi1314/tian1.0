//
//  LivingSettingView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/5/10.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "LivingSettingView.h"

@interface LivingSettingView ()

// 音量大小
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;

// 亮度
@property (weak, nonatomic) IBOutlet UISlider *brightSlider;

// 透明度
@property (weak, nonatomic) IBOutlet UISlider *alphaSlider;

// 大小
@property (weak, nonatomic) IBOutlet UISlider *sizeSlider;


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
    self.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.3f];
}

@end
