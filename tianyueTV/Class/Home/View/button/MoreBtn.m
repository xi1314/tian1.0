//
//  MoreBtn.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/8.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "MoreBtn.h"

@implementation MoreBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if ( self =[super initWithFrame:frame])
    {
        [self addLayout];
    }
    return self;
}
-(UILabel *)label
{
    if (!_label)
    {
        _label =[[UILabel alloc]init];
        _label.text =@"更多";
        _label.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _label.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.label];
    }
    return _label;
}
-(UIImageView *)pic
{
    if (!_pic)
    {
        _pic =[[UIImageView alloc]init];
        _pic.image=[UIImage imageNamed:@"右箭头-拷贝-2"];
        _pic.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.pic];
    }
    return _pic;
}
-(void)addLayout
{
    [self.label autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.label autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.label autoSetDimensionsToSize:CGSizeMake(kWidthChange(60), kHeightChange(30))];
    
    [self.pic autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.pic autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.pic autoSetDimensionsToSize:CGSizeMake(kWidthChange(15), kHeightChange(30))];
}
@end












