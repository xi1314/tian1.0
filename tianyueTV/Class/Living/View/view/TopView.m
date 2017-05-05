//
//  TopView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "TopView.h"

@implementation TopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self addLayout];
    }
    return self;
}


-(UIButton *)backButton
{
    if (!_backButton)
    {
        _backButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        _backButton.translatesAutoresizingMaskIntoConstraints =NO;
    }
    return _backButton;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel =[[UILabel alloc]init];
        _nameLabel.textColor =[UIColor whiteColor];
        _nameLabel.font =[UIFont systemFontOfSize:kHeightChange(24)];
        _nameLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.nameLabel];
    }
    return _nameLabel;
}
-(UIButton *)shareButton
{
    if (!_shareButton)
    {
        _shareButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [_shareButton setImage:[UIImage imageNamed:@"11"] forState:UIControlStateNormal];
        _shareButton.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.shareButton];
    }
    return _shareButton;
}
-(UIButton *)focusButton
{
    if (!_focusButton)
    {
        _focusButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_focusButton setImage:[UIImage imageNamed:@"爱心1"] forState:UIControlStateNormal];
        [_focusButton setImage:[UIImage imageNamed:@"爱心红"] forState:UIControlStateSelected];
        _focusButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.focusButton];
    }
    return _focusButton;
}

-(UIButton *)settingButton
{
    if (!_settingButton)
    {
        _settingButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
        _settingButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.settingButton];
        
    }
    return _settingButton;

}
-(UIImageView *)focusImageView
{
    if (!_focusImageView)
    {
        _focusImageView =[[UIImageView alloc]init];
        _focusImageView.image =[UIImage imageNamed:@"myFans"];
        
        _focusImageView.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.focusImageView];
    }
    return _focusImageView;
}
-(UILabel *)focusLabel
{
    if (!_focusLabel)
    {
        _focusLabel = [[UILabel alloc]init];
        _focusLabel.font = [UIFont systemFontOfSize:kWidthChange(20)];
        _focusLabel.textColor = [UIColor whiteColor];
        _focusLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.focusLabel];
    }
    return _focusLabel;
}
-(UIImageView *)onlineImageView
{
    if (!_onlineImageView)
    {
        _onlineImageView =[[UIImageView alloc]init];
        _onlineImageView.image =[UIImage imageNamed:@"眼睛90"];
        _onlineImageView.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.onlineImageView];
    }
    return _onlineImageView;
}
-(UILabel *)onlineLabel
{
    if (!_onlineLabel)
    {
        _onlineLabel =[[UILabel alloc]init];
        _onlineLabel.textColor =[UIColor whiteColor];
        _onlineLabel.font =[UIFont systemFontOfSize:kWidthChange(20)];
        _onlineLabel.text =@"200";
        _onlineLabel.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.onlineLabel];
    }
    return _onlineLabel;
}


-(void)addLayout
{
    [self addSubview:self.backButton];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeBottom   withInset:kHeightChange(15)];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(10)];
    [self.backButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(55), kHeightChange(55))];
    
    [self.nameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.backButton withOffset:kWidthChange(10)];
    [self.nameLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(200)];
    
    [@[self.backButton,self.settingButton,self.shareButton,self.focusButton,self.nameLabel,self.onlineImageView,self.focusImageView]autoAlignViewsToAxis:ALAxisHorizontal];
    [@[self.backButton,self.settingButton,self.shareButton,self.focusButton,self.focusImageView]autoMatchViewsDimension:ALDimensionWidth];
    [@[self.backButton,self.settingButton,self.shareButton,self.focusButton,self.focusImageView]autoMatchViewsDimension:ALDimensionHeight];
    [self.settingButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(10)];
    
    [self.shareButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.settingButton withOffset:-kWidthChange(40)];
    
    [self.focusButton autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.shareButton withOffset:-kWidthChange(40)];
    
    [self.focusImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.focusButton withOffset:-kWidthChange(70)];
    
    [self.focusLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.focusImageView];
    [self.focusLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(60)];
    [self.focusLabel autoPinEdgeToSuperviewEdge:ALEdgeBottom   withInset:kHeightChange(15)];
    
    [self.onlineImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.focusImageView withOffset:-kWidthChange(70)];
    
    [@[self.focusLabel,self.onlineLabel]autoMatchViewsDimension:ALDimensionWidth];
    [@[self.focusLabel,self.onlineLabel]autoMatchViewsDimension:ALDimensionHeight];
    [@[self.focusLabel,self.onlineLabel]autoAlignViewsToAxis:ALAxisHorizontal];
    [self.onlineLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.onlineImageView];
}
@end


















