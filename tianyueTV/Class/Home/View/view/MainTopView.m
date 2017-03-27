//
//  MainTopView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/6.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "MainTopView.h"
#import "UIImage+CustomImage.h"
@implementation MainTopView

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
-(BasicButton *)recommendedBtn
{
     if (!_recommendedBtn)
    {
        _recommendedBtn =[BasicButton buttonWithType:UIButtonTypeCustom];
        [_recommendedBtn setTitle:@"推荐" forState:UIControlStateNormal];
        //_recommendedBtn.selected =YES;
        [self addSubview:self.recommendedBtn];
    }
   return _recommendedBtn;
}
-(BasicButton *)clothingBtn
{
if (!_clothingBtn)
{
    _clothingBtn =[BasicButton buttonWithType:UIButtonTypeCustom];
    [_clothingBtn setTitle:@"匠人" forState:UIControlStateNormal];
    [self addSubview:self.clothingBtn];
}
    return _clothingBtn;
}
-(BasicButton *)foodBtn
{
    if (!_foodBtn)
    {
        _foodBtn =[BasicButton buttonWithType:UIButtonTypeCustom];
        [_foodBtn setTitle:@"衣" forState:UIControlStateNormal];
        [self addSubview:self.foodBtn];
    }
    return _foodBtn;
}
-(BasicButton *)liveBtn
{
    if (!_liveBtn)
    {
        _liveBtn =[BasicButton buttonWithType:UIButtonTypeCustom];
        [_liveBtn setTitle:@"食" forState:UIControlStateNormal];
        [self addSubview:self.liveBtn];
    }
    return _liveBtn;
}
-(BasicButton *)walkingBtn
{
    if (!_walkingBtn)
    {
        _walkingBtn =[BasicButton buttonWithType:UIButtonTypeCustom];
        [_walkingBtn setTitle:@"住" forState:UIControlStateNormal];
        [self addSubview:self.walkingBtn];
    }
    return _walkingBtn;
}
-(BasicButton *)knowledgeBtn
{
    if (!_knowledgeBtn)
    {
        _knowledgeBtn =[BasicButton buttonWithType:UIButtonTypeCustom];
        [_knowledgeBtn setTitle:@"行" forState:UIControlStateNormal];
        [self addSubview:self.knowledgeBtn];
    }
    return _knowledgeBtn;
}
-(UIImageView *)orangeLine
{
    if (!_orangeLine)
    {
        _orangeLine =[[UIImageView alloc]init];
        _orangeLine.image =[UIImage createImageWithColor:WWColor(219, 99, 18)];
        _orangeLine.translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:self.orangeLine];
    }
    return _orangeLine;
}
-(void)addLayout
{
    [self.orangeLine autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.orangeLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.orangeLine autoSetDimension:ALDimensionHeight toSize:kHeightChange(2)];
    [@[self.orangeLine,self.recommendedBtn]autoMatchViewsDimension:ALDimensionWidth];
    
    [self.recommendedBtn autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.recommendedBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.recommendedBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(2)];
    [self.recommendedBtn autoSetDimension:ALDimensionWidth toSize:kWidthChange(125)];
    
    [self.clothingBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.recommendedBtn];
    [@[self.recommendedBtn,self.clothingBtn,self.foodBtn,self.liveBtn,self.walkingBtn,self.knowledgeBtn]autoAlignViewsToAxis:ALAxisHorizontal];
    [@[self.recommendedBtn,self.clothingBtn,self.foodBtn,self.liveBtn,self.walkingBtn,self.knowledgeBtn]autoMatchViewsDimension:ALDimensionWidth];
    [@[self.recommendedBtn,self.clothingBtn,self.foodBtn,self.liveBtn,self.walkingBtn,self.knowledgeBtn]autoMatchViewsDimension:ALDimensionHeight];
    
    [self.foodBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.clothingBtn];

    [self.liveBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.foodBtn];

    [self.walkingBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.liveBtn];

    [self.knowledgeBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.walkingBtn];    
}
@end























