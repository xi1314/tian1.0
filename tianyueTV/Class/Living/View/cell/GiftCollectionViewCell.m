//
//  GiftCollectionViewCell.m
//  tianyueTV
//
//  Created by wwwwwwww on 2017/1/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "GiftCollectionViewCell.h"

@implementation GiftCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self= [super initWithFrame:frame])
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
        _picImage.layer.cornerRadius =5.0f;
        _picImage.clipsToBounds =YES;
        _picImage.image =[UIImage imageNamed:@"酒杯-拷贝"];
        _picImage.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.picImage];
    }
    return _picImage;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel =[[UILabel alloc]init];
        _nameLabel.text =@"匠💖酒";
        _nameLabel.font =[UIFont systemFontOfSize:kWidthChange(26)];
        _nameLabel.textColor =WWColor(91, 91, 91);
        _nameLabel.textAlignment =NSTextAlignmentCenter;
        
        _nameLabel.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.nameLabel];
    }
    return _nameLabel;
}
-(UILabel *)priceLabel
{
    if (!_priceLabel)
    {
        _priceLabel =[[UILabel alloc]init];
        _priceLabel.textAlignment =NSTextAlignmentCenter;
        _priceLabel.textColor =WWColor(225, 126, 66);
        _priceLabel.font =[UIFont systemFontOfSize:kWidthChange(18)];
        _priceLabel.text =@"10越币";
        
        _priceLabel.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.priceLabel];
    }
    return _priceLabel;
}
-(void)addLayout
{
    [self.picImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(1)];
    [self.picImage autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(1)];
    [self.picImage autoSetDimensionsToSize:CGSizeMake(kWidthChange(110), kHeightChange(110))];
    
    [self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.picImage withOffset:kHeightChange(2)];
    [@[self.nameLabel,self.picImage,self.priceLabel]autoMatchViewsDimension:ALDimensionWidth];
    [@[self.priceLabel,self.nameLabel,self.picImage]autoAlignViewsToAxis:ALAxisVertical];
    
    [self.priceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:kHeightChange(2)];
}
@end
