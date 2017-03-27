//
//  MainCollectionViewCell.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/9.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "MainCollectionViewCell.h"

@implementation MainCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        [self addLayout];
    }
    return self;
}
-(UIImageView *)picImage
{
    if (!_picImage)
    {
        _picImage =[[UIImageView alloc]init];
        _picImage.image =[UIImage imageNamed:@"背景-副本"];
        _picImage.translatesAutoresizingMaskIntoConstraints=NO;
        [self addSubview:self.picImage];
    }
    return _picImage;
}
-(UILabel *)onlineLabel
{
    if (!_onlineLabel)
    {
        _onlineLabel =[[UILabel alloc]init];
        _onlineLabel.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"眼睛--"]];
        _onlineLabel.text =@"222";
        _onlineLabel.textColor =[UIColor whiteColor];
        _onlineLabel.textAlignment =NSTextAlignmentRight;
        _onlineLabel.font= [UIFont systemFontOfSize:kWidthChange(16)];
        _onlineLabel.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.onlineLabel];
    }
    return _onlineLabel;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel =[[UILabel alloc]init];
        _nameLabel.text =@"周雨枫";
        _nameLabel.textColor =[UIColor whiteColor];
        _nameLabel.font =[UIFont systemFontOfSize:kWidthChange(16)];
        _nameLabel.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        _nameLabel.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)titleLab
{
    if (!_titleLab)
    {
        _titleLab =[[UILabel alloc]init];
        _titleLab.textColor =WWColor(129,129,129);
        _titleLab.text =@"老周做模型";
        _titleLab.font =[UIFont systemFontOfSize:kWidthChange(18)];
        _titleLab.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.titleLab];
    }
    return _titleLab;
}
-(void)addLayout
{
    [self.titleLab autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.titleLab autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.titleLab autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.picImage withOffset:kHeightChange(15)];
    [self.titleLab autoSetDimension:ALDimensionHeight toSize:kHeightChange(20)];
    
    [self.picImage autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.picImage autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.picImage autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.picImage autoSetDimension:ALDimensionHeight toSize:kHeightChange(192)];
    
    [self.onlineLabel autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.onlineLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(2)];
    [self.onlineLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(100), kHeightChange(25))];
    
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.nameLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.picImage];
    [self.nameLabel autoSetDimension:ALDimensionHeight toSize:kHeightChange(28)];
    
}
@end
