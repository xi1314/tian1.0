//
//  CustomPlayerButton.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/11/1.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "CustomPlayerButton.h"

@implementation CustomPlayerButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self  =[super initWithFrame:frame])
    {
        
        [self addLayout];
    }
    return self;
}
-(void)addLayout
{
    [self.decodeButton autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.decodeButton autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.decodeButton autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.decodeButton autoSetDimension:ALDimensionWidth toSize:kHeightChange(60)];
    
    [self.label autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.label autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.label autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.label autoSetDimension:ALDimensionWidth toSize:kHeightChange(150)];
}
-(UIButton *)decodeButton
{
    if (!_decodeButton)
    {
        _decodeButton =[UIButton buttonWithType:UIButtonTypeCustom];
        
        _decodeButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.decodeButton];
    }
    return _decodeButton;
}
-(UILabel *)label
{
    if (!_label)
    {
        _label =[[UILabel alloc]init];
        
        _label.font =[UIFont systemFontOfSize:kHeightChange(45)];
        _label.textColor =[UIColor whiteColor];
        _label.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.label];
    }
    return _label;
}
@end










