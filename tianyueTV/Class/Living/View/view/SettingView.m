//
//  SettingView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/31.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "SettingView.h"
#import "UIImage+CustomImage.h"


@implementation SettingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [self addLayout];
    }
    return self;
}
-(void)addLayout
{
    //切换播放器
    [self.changePlayer autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
    [self.changePlayer autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(160)];
    [self.changePlayer autoSetDimensionsToSize:CGSizeMake(kWidthChange(120), kHeightChange(30))];
    
    [self.softBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.changePlayer withOffset:kWidthChange(30)];
    [self.softBtn autoSetDimensionsToSize:CGSizeMake(kWidthChange(80), kHeightChange(60))];
    
    [self.hardBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.softBtn withOffset:kWidthChange(30)];
    [self.hardBtn autoSetDimensionsToSize:CGSizeMake(kWidthChange(80), kHeightChange(60))];
    [@[self.softBtn,self.hardBtn,self.changePlayer]autoAlignViewsToAxis:ALAxisHorizontal];


    //音量大小
    [self.soundLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
    [self.soundLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.changePlayer withOffset:kWidthChange(40)];
    [self.soundLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(120), kHeightChange(30))];
    
    [self.soundSlider autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.soundLabel withOffset:kWidthChange(5)];
    [@[self.soundLabel,self.soundSlider]autoAlignViewsToAxis:ALAxisHorizontal];
    [self.soundSlider autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(20)];

    //屏幕亮度
    [self.brightnessLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
    [self.brightnessLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.soundLabel withOffset:kWidthChange(40)];
    [self.brightnessLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(120), kHeightChange(30))];
    
    [self.brightnessSlider autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.brightnessLabel withOffset:kWidthChange(5)];
    [@[self.brightnessSlider,self.brightnessLabel]autoAlignViewsToAxis:ALAxisHorizontal];
    [self.brightnessSlider autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(20)];

    //弹幕透明度
    [self.alphaLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
    [self.alphaLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.brightnessLabel withOffset:kWidthChange(40)];
    [self.alphaLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(120), kHeightChange(30))];
    
    [self.alphaSlider autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.brightnessLabel withOffset:kWidthChange(5)];
    [@[self.alphaSlider,self.alphaLabel]autoAlignViewsToAxis:ALAxisHorizontal];
    [self.alphaSlider autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(20)];
    
    //弹幕大小
    [self.sizeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
    [self.sizeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.alphaLabel withOffset:kWidthChange(40)];
    [self.sizeLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(120), kHeightChange(30))];
    
    [self.sizeSlider autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.brightnessLabel withOffset:kWidthChange(5)];
    [@[self.sizeSlider,self.sizeLabel]autoAlignViewsToAxis:ALAxisHorizontal];
    [self.sizeSlider autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(20)];

    //弹幕位置
    [self.locationLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
    [self.locationLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.sizeLabel withOffset:kWidthChange(40)];
    [self.locationLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(120), kHeightChange(30))];
    
    [self.topButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(40)];
    [self.topButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.locationLabel withOffset:kWidthChange(20)];
    [self.topButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(100), kWidthChange(40))];
    
    
    [self.middleBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.topButton withOffset:kWidthChange(20)];
    
    [self.bottomBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.middleBtn withOffset:kWidthChange(20)];
    [@[self.topButton,self.middleBtn,self.bottomBtn]autoAlignViewsToAxis:ALAxisHorizontal];
    [@[self.topButton,self.middleBtn,self.bottomBtn]autoMatchViewsDimension:ALDimensionWidth];

}
//切换播放器
-(UILabel *)changePlayer
{
    if (!_changePlayer)
    {
        _changePlayer =[[UILabel alloc]init];
        _changePlayer.font =[UIFont systemFontOfSize:kWidthChange(20)];
        _changePlayer.textColor =[UIColor whiteColor];
        _changePlayer.text =@"切换播放器";
        _changePlayer.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.changePlayer];
    }
    return _changePlayer;
}
-(CustomPlayerButton *)softBtn
{
    if (!_softBtn)
    {
        _softBtn =[[CustomPlayerButton alloc]init];
        [_softBtn.decodeButton setImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
        [_softBtn.decodeButton setImage:[UIImage imageNamed:@"按钮-副本"] forState:UIControlStateSelected];
        _softBtn.label.text =@"软解";
        _softBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.softBtn];
    }
    return _softBtn;
}
-(CustomPlayerButton *)hardBtn
{
    if (!_hardBtn)
    {
        _hardBtn =[[CustomPlayerButton alloc]init];
        [_hardBtn.decodeButton setImage:[UIImage imageNamed:@"按钮-副本"] forState:UIControlStateNormal];
        [_hardBtn.decodeButton setImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateSelected];
        _hardBtn.label.text =@"硬解";
        _hardBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.hardBtn];
    }
    return _hardBtn;
}

//音量大小
-(UILabel *)soundLabel
{
    if (!_soundLabel)
    {
        _soundLabel =[[UILabel alloc]init];
        _soundLabel.font =[UIFont systemFontOfSize:kWidthChange(20)];
        _soundLabel.textColor =[UIColor whiteColor];
        _soundLabel.text =@"音量大小";
        _soundLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.soundLabel];
    }
    return _soundLabel;
}
-(UISlider *)soundSlider
{
    if (!_soundSlider)
    {
        _soundSlider =[[UISlider alloc]init];
        _soundSlider.minimumValue =0;
        _soundSlider.maximumValue =100;
        _soundSlider.value =50;//指定默认值
        _soundSlider.continuous =YES;
        [_soundSlider setThumbImage:[UIImage imageNamed:@"按钮-副本"] forState:UIControlStateNormal];
        _soundSlider.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.soundSlider];
    }
    return _soundSlider;
}
//屏幕亮度
-(UILabel *)brightnessLabel
{
    if (!_brightnessLabel)
    {
        _brightnessLabel =[[UILabel alloc]init];
        _brightnessLabel.font =[UIFont systemFontOfSize:kWidthChange(20)];
        _brightnessLabel.textColor =[UIColor whiteColor];
        _brightnessLabel.text =@"屏幕亮度";
        _brightnessLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.brightnessLabel];
    }
    return _brightnessLabel;
}
-(UISlider *)brightnessSlider
{
    if (!_brightnessSlider)
    {
        _brightnessSlider =[[UISlider alloc]init];
        _brightnessSlider.minimumValue =0;
        _brightnessSlider.maximumValue =1;
        _brightnessSlider.value =0.5;//指定默认值
        _brightnessSlider.continuous =YES;
        [_brightnessSlider setThumbImage:[UIImage imageNamed:@"按钮-副本"] forState:UIControlStateNormal];
        _brightnessSlider.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.brightnessSlider];
    }
    return _brightnessSlider;
}

//弹幕透明度
-(UILabel *)alphaLabel
{
    if (!_alphaLabel)
    {
        _alphaLabel =[[UILabel alloc]init];
        _alphaLabel.font =[UIFont systemFontOfSize:kWidthChange(20)];
        _alphaLabel.textColor =[UIColor whiteColor];
        _alphaLabel.text =@"弹幕透明度";
        _alphaLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.alphaLabel];
    }
    return _alphaLabel;
}
-(UISlider *)alphaSlider
{
    if (!_alphaSlider)
    {
        _alphaSlider =[[UISlider alloc]init];
        _alphaSlider.minimumValue =0;
        _alphaSlider.maximumValue =1;
        _alphaSlider.value =0.5;//指定默认值
        _alphaSlider.continuous =YES;
        [_alphaSlider setThumbImage:[UIImage imageNamed:@"按钮-副本"] forState:UIControlStateNormal];
        _alphaSlider.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.alphaSlider];
    }
    return _alphaSlider;
}

//弹幕大小
-(UILabel *)sizeLabel
{
    if (!_sizeLabel)
    {
        _sizeLabel =[[UILabel alloc]init];
        _sizeLabel.font =[UIFont systemFontOfSize:kWidthChange(20)];
        _sizeLabel.textColor =[UIColor whiteColor];
        _sizeLabel.text =@"弹幕大小";
        _sizeLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.sizeLabel];
    }
    return _sizeLabel;
}
-(UISlider *)sizeSlider
{
    if (!_sizeSlider)
    {
        _sizeSlider =[[UISlider alloc]init];
        _sizeSlider.minimumValue =kWidthChange(13);
        _sizeSlider.maximumValue =kWidthChange(25);
        _sizeSlider.value =kWidthChange(18);//指定默认值
        _sizeSlider.continuous =YES;
        [_sizeSlider setThumbImage:[UIImage imageNamed:@"按钮-副本"] forState:UIControlStateNormal];
        _alphaSlider.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.sizeSlider];
    }
    return _sizeSlider;
}

//弹幕位置
-(UILabel *)locationLabel
{
    if (!_locationLabel)
    {
        _locationLabel =[[UILabel alloc]init];
        _locationLabel.font =[UIFont systemFontOfSize:kWidthChange(20)];
        _locationLabel.textColor =[UIColor whiteColor];
        _locationLabel .text =@"弹幕位置";
        _locationLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.locationLabel];
    }
    return _locationLabel;
}
-(UIButton *)topButton
{
    if (!_topButton)
    {
        _topButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_topButton setImage:[UIImage imageNamed:@"虚线--"] forState:UIControlStateNormal];
        
        _topButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.topButton];
    }
    return _topButton;
}
-(UIButton *)middleBtn
{
    if (!_middleBtn)
    {
        _middleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_middleBtn setImage:[UIImage imageNamed:@"虚线---副本"] forState:UIControlStateNormal];
        
        _middleBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.middleBtn];    }
    return _middleBtn;
}
-(UIButton *)bottomBtn
{
    if (!_bottomBtn)
    {
        _bottomBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomBtn setImage:[UIImage imageNamed:@"虚线---副本-2"] forState:UIControlStateNormal];
        
        _bottomBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.bottomBtn];    }
    return _bottomBtn;
}

@end











