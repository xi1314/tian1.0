//
//  HostInfoView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/21.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "HostInfoView.h"
#import "UIImage+CustomImage.h"

@implementation HostInfoView

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
    }
    return self;
}
-(UIImageView *)headImageView
{
    if (!_headImageView)
    {
        _headImageView =[[UIImageView alloc]init];
        _headImageView.image =[UIImage imageNamed:@"59ccb7ee60e2fb74"];

        _headImageView.layer.cornerRadius =kWidthChange(40);
        _headImageView.clipsToBounds =YES;
        _headImageView.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.headImageView];
    }
    return _headImageView;
}
-(UILabel*)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel =[[UILabel alloc]init];
        _nameLabel.text =@"手艺意家";
        _nameLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _nameLabel.textColor =WWColor(51, 51, 51);  
        _nameLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)fans
{
    if (!_fans)
    {
        _fans =[[UILabel alloc]init];
        _fans.textColor =WWColor(51, 51, 51);
        _fans.textAlignment =NSTextAlignmentCenter;
        _fans.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _fans.text =@"粉丝:";
        _fans.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.fans];
    }
    return _fans;
}
-(UILabel *)fansCount
{
    if (!_fansCount)
    {
        _fansCount =[[UILabel alloc]init];
        _fansCount.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _fansCount.textColor =WWColor(51, 51, 51);
        _fansCount.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.fansCount];
    }
    return _fansCount;
}
-(UIImageView *)focusImageView
{
    if (!_focusImageView)
    {
        _focusImageView =[[UIImageView alloc]init];
        _focusImageView.image =[UIImage imageNamed:@"爱心1"];
        _focusImageView.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.focusImageView];
    }
    return _focusImageView;
}
-(UIButton *)focusBtn
{
    if (!_focusBtn)
    {
        _focusBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_focusBtn setBackgroundColor:[UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:0.3]];
        [_focusBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_focusBtn setTitle:@"已关注" forState:UIControlStateSelected];
        [_focusBtn setTitleColor:WWColor(106, 108, 108) forState:UIControlStateNormal];
        _focusBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _focusBtn.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.focusBtn];
    }
    return _focusBtn;
}
-(UIImageView *)line
{
    if (!_line)
    {
        _line =[[UIImageView alloc]init];
        _line.image =[UIImage createImageWithColor:WWColor(234, 234, 234)];
        _line.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.line];
    }
    return _line;
}
-(UIButton *)interactiveBtn
{
    if (!_interactiveBtn)
    {
        _interactiveBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_interactiveBtn setTitle:@"互动" forState:UIControlStateNormal];
        [_interactiveBtn setTitleColor:WWColor(106, 108, 108) forState:UIControlStateNormal];
        [_interactiveBtn setTitleColor:WWColor(193, 52, 50) forState:UIControlStateSelected];
        _interactiveBtn.selected =YES;
        _interactiveBtn.tag =55;
        _interactiveBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(28)];
        _interactiveBtn.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.interactiveBtn];
    }
    return _interactiveBtn;
}
-(UIButton *)listBtn
{
    if (!_listBtn)
    {
        _listBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_listBtn setTitle:@"商铺" forState:UIControlStateNormal];
        [_listBtn setTitleColor:WWColor(106, 108, 108) forState:UIControlStateNormal];
        [_listBtn setTitleColor:WWColor(193, 52, 50) forState:UIControlStateSelected];
        _listBtn.selected =NO;
        _listBtn.tag =56;
        _listBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(28)];
        _listBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.listBtn];
    }
    return _listBtn;
}
-(UIImageView *)redLine
{
    if (!_redLine)
    {
        _redLine =[[UIImageView alloc]init];
        _redLine.image =[UIImage createImageWithColor:WWColor(193, 52, 50)];
        _redLine.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.redLine];
    }
    return _redLine;
}

-(void)addLayout
{
    [self.headImageView autoSetDimensionsToSize:CGSizeMake(kWidthChange(80), kHeightChange(80))];
    [self.headImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(10)];
    [self.headImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(15)];
    
    [self.nameLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.headImageView];
    [self.nameLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.headImageView withOffset:kWidthChange(15)];
    [self.nameLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(210)];
    
    [self.focusBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(15)];
    [self.focusBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.line withOffset:-kHeightChange(10)];
    [self.focusBtn autoSetDimension:ALDimensionWidth toSize:kWidthChange(100)];
    
    [self.focusImageView autoSetDimensionsToSize:CGSizeMake(kWidthChange(30), kHeightChange(30))];
    [self.focusImageView autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.focusBtn ];
    
    [self.fansCount autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.focusImageView withOffset:-kWidthChange(35)];
    [self.fansCount autoSetDimension:ALDimensionWidth toSize:kWidthChange(50)];
    
    [self.fans autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.fansCount withOffset:-kWidthChange(5)];
    [self.fans autoSetDimension:ALDimensionWidth toSize:kWidthChange(72)];
    [@[self.fans,self.fansCount,self.focusImageView,self.focusBtn]autoAlignViewsToAxis:ALAxisHorizontal];
    
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.line autoSetDimension:ALDimensionHeight toSize:kHeightChange(1)];
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(100)];
    
    [self.interactiveBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.interactiveBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(1)];
    [self.interactiveBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line];
    [self.interactiveBtn autoSetDimension:ALDimensionWidth toSize:kWidth/2];
    
    [self.listBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.listBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(1)];
    [self.listBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.line];
    [self.listBtn autoSetDimension:ALDimensionWidth toSize:kWidth/2];
    
    [self.redLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.redLine autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.redLine autoSetDimensionsToSize:CGSizeMake(kWidth/2, kHeightChange(2))];
}

@end



















