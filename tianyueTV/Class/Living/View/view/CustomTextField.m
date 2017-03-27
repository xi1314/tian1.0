//
//  CustomTextField.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/31.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "CustomTextField.h"
#import "UIImage+CustomImage.h"
@implementation CustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawPlaceholderInRect:(CGRect)rect
{
    [super drawPlaceholderInRect:CGRectMake(kWidthChange(24), self.frame.size.height * 0.5+0.5, 0, 0)];
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.backgroundColor =WWColor(242, 242, 242);
        [self addLayout];
    }
    return self;
}
-(UIImageView *)line
{
    if (!_line)
    {
        _line =[[UIImageView alloc]init];
        _line.image =[UIImage createImageWithColor:WWColor(214, 209, 209)];
        _line.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.line];
    }
    return _line;
}
-(UIButton *)sendBtn
{
    if (!_sendBtn)
    {
        _sendBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        [_sendBtn setTitleColor:WWColor(165, 165, 165) forState:UIControlStateNormal];
        _sendBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self addSubview:self.sendBtn];
    }
    return _sendBtn;
}
-(void)addLayout
{
    [self.line autoSetDimension:ALDimensionWidth toSize:kWidthChange(1)];
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(6)];
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(6)];
    
    [self.sendBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.sendBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.sendBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.sendBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.line withOffset:kWidthChange(1)];
    [self.sendBtn autoSetDimension:ALDimensionWidth toSize:kWidthChange(100)];
}
@end














