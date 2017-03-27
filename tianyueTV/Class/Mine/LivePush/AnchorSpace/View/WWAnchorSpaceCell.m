//
//  WWAnchorSpaceCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/12/7.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWAnchorSpaceCell.h"

@implementation WWAnchorSpaceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addPureLayOut];
    }
    return self;
}



- (void)addPureLayOut{
    
    [self addSubview:self.headImageViewW];
    [self.headImageViewW autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.headImageViewW autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(35)];
    [self.headImageViewW sizeToFit];
    
    [self addSubview:self.titleLbaleW];
    [self.titleLbaleW autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.titleLbaleW autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(120)];
    
    [self addSubview:self.cornerView];
    [self.cornerView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.cornerView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.titleLbaleW withOffset:kWidthChange(5)];
    [self.cornerView autoSetDimensionsToSize:CGSizeMake(kWidthChange(24), kWidthChange(24))];
    
}


#pragma mark ----Getter----
- (UIView *)cornerView{
    if (!_cornerView) {
        _cornerView = [[UIView alloc] init];
        _cornerView.backgroundColor = WWColor(213, 40, 51);
        _cornerView.layer.cornerRadius = kWidthChange(12);
        _cornerView.layer.masksToBounds = YES;
        _cornerView.hidden = YES;
    }
    return _cornerView;
}

- (UILabel *)titleLbaleW{
    if (!_titleLbaleW) {
        _titleLbaleW = [[UILabel alloc] init];
//        _titleLbaleW.text = @"我的粉丝";
        _titleLbaleW.textColor = [UIColor blackColor];
        _titleLbaleW.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _titleLbaleW;
}

- (UIImageView *)headImageViewW{
    if (!_headImageViewW) {
        _headImageViewW = [[UIImageView alloc] init];
    }
    return _headImageViewW;
}

@end
