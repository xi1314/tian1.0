//
//  WWPcollectionViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/25.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWPcollectionViewCell.h"

@implementation WWPcollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPureLayOut];
    }
    return self;
}


#pragma mark ----添加约束----
- (void)addPureLayOut{
    [self addSubview:self.headImageW];
    [self.headImageW autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(10)];
    [self.headImageW autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.headImageW autoSetDimensionsToSize:CGSizeMake(self.frame.size.width * 0.8, self.frame.size.width * 0.8)];
    
    //昵称
    [self addSubview:self.nameLabelW];
    [self.nameLabelW autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.nameLabelW autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headImageW withOffset:kHeightChange(20)];
    [self.nameLabelW autoSetDimension:ALDimensionWidth toSize:self.frame.size.width * 0.9];
}

#pragma mark ----Getters----
- (UILabel *)nameLabelW{
    if (!_nameLabelW) {
        _nameLabelW = [[UILabel alloc] init];
        _nameLabelW.text = @"德玛西亚之力";
        _nameLabelW.textColor = WWColor(184, 184, 184);
        _nameLabelW.font = [UIFont systemFontOfSize:kWidthChange(20)];
        
    }
    return _nameLabelW;
}

- (UIImageView *)headImageW{
    if (!_headImageW) {
        _headImageW = [[UIImageView alloc] init];
        _headImageW.image = [UIImage imageNamed:@"2008853_093123008780_2"];
        _headImageW.layer.cornerRadius = self.frame.size.width * 0.4;
        _headImageW.layer.masksToBounds = YES;
        
    }
    return _headImageW;
}
@end
