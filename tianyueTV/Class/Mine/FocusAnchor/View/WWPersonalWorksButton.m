//
//  WWPersonalWorksButton.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/24.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWPersonalWorksButton.h"

@implementation WWPersonalWorksButton

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
    [self addSubview:self.headImageViewW];
    [self.headImageViewW autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kWidthChange(20)];
    [self.headImageViewW autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.headImageViewW autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.headImageViewW autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kWidthChange(20)];
    
    [self addSubview:self.playImageViewW];
    [self.playImageViewW autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.playImageViewW autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.playImageViewW autoSetDimensionsToSize:CGSizeMake(kWidthChange(100), kWidthChange(100))];
    
    
}

#pragma ----Getters----
- (UIImageView *)playImageViewW{
    if (!_playImageViewW) {
        _playImageViewW = [[UIImageView alloc] init];
        _playImageViewW.image = [UIImage imageNamed:@"播放按钮（无背景）-1"];
    }
    return _playImageViewW;
}

- (UIImageView *)headImageViewW{
    if (!_headImageViewW) {
        _headImageViewW = [[UIImageView alloc] init];
        _headImageViewW.image = [UIImage imageNamed:@"897"];
    }
    return _headImageViewW;
}

@end
