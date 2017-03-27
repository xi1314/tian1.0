//
//  PersonalWorksCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/27.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "PersonalWorksCell.h"
@interface PersonalWorksCell()

@end

@implementation PersonalWorksCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPureLayout];
    }
    return self;
}


- (void)addPureLayout{
    [self addSubview:self.bgImageView];
    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(15)];
    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(15)];
    [self.bgImageView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
}

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"2008853_093123008780_2"];
    }
    return _bgImageView;
}

@end
