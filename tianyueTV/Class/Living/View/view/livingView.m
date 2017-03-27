//
//  livingView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/21.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "livingView.h"
#import "UIImage+CustomImage.h"
@implementation livingView

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
        [self addLayout];
        self.backgroundColor = [UIColor blackColor];
        //[self timeOut];
    }
    return self;
}

-(UIButton *)backBtn
{
    if (!_backBtn)
    {
        _backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"返回1"] forState:UIControlStateNormal];
        _backBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.backBtn];
    }
    return _backBtn;
}

-(UIButton *)shareBtn
{
    if (!_shareBtn)
    {
        _shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"分享(1)"] forState:UIControlStateNormal];
        _shareBtn.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.shareBtn];
    }
    return _shareBtn;
}
-(UIImageView *)eye
{
    if (!_eye)
    {
        _eye =[[UIImageView alloc]init];
        _eye.image =[UIImage imageNamed:@"眼睛1"];
        _eye.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.eye];
    }
    return _eye;
}
-(UILabel *)onlineLabel
{
    if (!_onlineLabel)
    {
        _onlineLabel =[[UILabel alloc]init];
        _onlineLabel.font =[UIFont systemFontOfSize:kWidthChange(24)];
        
        _onlineLabel.textColor =[UIColor whiteColor];
        _onlineLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.onlineLabel];
    }
    return _onlineLabel;
}
-(UIButton *)startBtn
{
    if (!_startBtn)
    {
        _startBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_startBtn setImage:[UIImage imageNamed:@"暂停"] forState:UIControlStateNormal];
        [_startBtn setImage:[UIImage imageNamed:@"播放(1)"] forState:UIControlStateSelected];
        _startBtn.clipsToBounds =YES;
        _startBtn.layer.cornerRadius =kWidthChange(25);
        
        _startBtn.translatesAutoresizingMaskIntoConstraints =NO ;
        [self addSubview:self.startBtn];
    }

    return _startBtn;
}
-(UIButton *)fullBtn
{
    if (!_fullBtn)
    {
        _fullBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        
        [_fullBtn setImage:[UIImage imageNamed:@"全屏"] forState:UIControlStateNormal];
        _fullBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.fullBtn];
    }
    return _fullBtn;
}
-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel =[[UILabel alloc]init];
        _titleLabel.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _titleLabel.textColor =WWColor(215, 213, 213);
        _titleLabel.textAlignment =NSTextAlignmentCenter;
        _titleLabel.text =@"做模型";
        _titleLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.titleLabel];
    }
    return _titleLabel;
}
//-(UIButton *)shopBtn
//{
//    if (!_shopBtn)
//    {
//        _shopBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_shopBtn setImage:[UIImage imageNamed:@"店铺"] forState:UIControlStateNormal];
//        _shopBtn.translatesAutoresizingMaskIntoConstraints =NO;
//        [self addSubview:self.shopBtn];
//    }
//    return _shopBtn;
//}
//-(UIButton *)surpriseBtn
//{
//    if (!_surpriseBtn)
//    {
//        _surpriseBtn =[UIButton buttonWithType:UIButtonTypeCustom];
//        [_surpriseBtn setImage:[UIImage imageNamed:@"202福利领取"] forState:UIControlStateNormal];
//        [_surpriseBtn setImage:[UIImage imageNamed:@"202福利领取-1"] forState:UIControlStateSelected];
//        _surpriseBtn.userInteractionEnabled =NO;
//        _surpriseBtn .translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:self.surpriseBtn];
//    }
//    return _surpriseBtn;
//}
//-(UILabel *)timeLabel
//{
//    if (!_timeLabel)
//    {
//        _timeLabel =[[UILabel alloc]init];
//        _timeLabel.textColor =[UIColor whiteColor];
//        _timeLabel.text =@"2:00";
//        _timeLabel.font =[UIFont systemFontOfSize:kWidthChange(20)];
//        _timeLabel.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.timeLabel];
//    }
//    return _timeLabel;
//}
//礼物倒计时
-(void)timeOut
{
    __block int timeout=50; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                self.surpriseBtn.selected =YES;
                self.surpriseBtn.userInteractionEnabled =YES;
            });
        }else{
            int seconds = timeout ;
            NSString *strTime = [self timeFormatted:seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView animateWithDuration:1 animations:^{
                    self.timeLabel.text =[NSString stringWithFormat:@"%@",strTime];
                }];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
//转换为时分秒
-(NSString *)timeFormatted:(int)totalSeconds
{
    int seconds =totalSeconds%60;
    int minutes =(totalSeconds/60)%60;
    
    return [NSString stringWithFormat:@"%.2d:%.2d",minutes,seconds];
}

-(void)addLayout
{
    [self.backBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50)];
    [self.backBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.backBtn autoSetDimensionsToSize:CGSizeMake(kWidthChange(60), kHeightChange(60))];
    
    [self.shareBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.shareBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50)];
    [self.shareBtn autoSetDimensionsToSize:CGSizeMake(kWidthChange(60), kHeightChange(60))];
    
    [self.titleLabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50)];
    
    [self.eye autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(72)];
    [self.eye autoSetDimensionsToSize:CGSizeMake(kWidthChange(30), kHeightChange(20))];
    [self.eye autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.backBtn withOffset:kWidthChange(15)];
    [@[self.eye,self.titleLabel,self.onlineLabel]autoAlignViewsToAxis:ALAxisHorizontal];
    
    [self.onlineLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.eye withOffset:kWidthChange(11)];
    [self.onlineLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(200)];
    
    [self.fullBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(20)];
    
    [self.startBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(2)];
    [self.startBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(10)];
    [self.startBtn autoSetDimensionsToSize:CGSizeMake(kWidthChange(60), kHeightChange(60))];
    
    [@[self.startBtn,self.fullBtn]autoAlignViewsToAxis:ALAxisHorizontal];
    [@[self.startBtn,self.fullBtn]autoMatchViewsDimension:ALDimensionWidth];
    [@[self.startBtn,self.fullBtn]autoMatchViewsDimension:ALDimensionHeight];
    [self.shopBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.startBtn withOffset:kWidthChange(36)];
    
//    [self.surpriseBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.shopBtn withOffset:kWidthChange(36)];
//    
//    [self.timeLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(10)];
//    [self.timeLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(80)];
//    [self.timeLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.surpriseBtn ];
}
@end
































