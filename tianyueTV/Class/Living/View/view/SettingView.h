//
//  SettingView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/31.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPlayerButton.h"
@interface SettingView : UIView

@property(nonatomic,strong)UILabel *changePlayer;
@property(nonatomic,strong)CustomPlayerButton *softBtn;
@property(nonatomic,strong)CustomPlayerButton *hardBtn;

@property(nonatomic,strong)UILabel *soundLabel;
@property(nonatomic,strong)UISlider *soundSlider;

@property(nonatomic,strong)UILabel *brightnessLabel;
@property(nonatomic,strong)UISlider *brightnessSlider;

@property(nonatomic,strong)UILabel *alphaLabel;
@property(nonatomic,strong)UISlider *alphaSlider;

@property(nonatomic,strong)UILabel *sizeLabel;
@property(nonatomic,strong)UISlider *sizeSlider;

@property(nonatomic,strong)UILabel *locationLabel;
@property(nonatomic,strong)UIButton *topBtn;
@property(nonatomic,strong)UIButton *middleBtn;
@property(nonatomic,strong)UIButton *bottomBtn;

@property(nonatomic,strong)UIButton *topButton;
@property(nonatomic,strong)UIButton *middleButton;
@property(nonatomic,strong)UIButton *bottmButton;

@end
