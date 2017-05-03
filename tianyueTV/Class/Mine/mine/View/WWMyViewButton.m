//
//  WWMyViewButton.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/21.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMyViewButton.h"
@interface WWMyViewButton()


@end


@implementation WWMyViewButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addPurLayOut];
    }
    return self;
}

- (void)addPurLayOut{
    [self addSubview:self.backImageView];
    [self.backImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(55)];
    [self.backImageView autoAlignAxisToSuperviewAxis:ALAxisVertical];
//    [self.backImageView autoSetDimensionsToSize:self.bacimagesize];
    
    [self addSubview:self.titlew];
    [self.titlew autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titlew autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.backImageView withOffset:kHeightChange(36)];
}


- (UILabel *)titlew{
    if (!_titlew) {
        _titlew = [[UILabel alloc] init];
        _titlew.font = [UIFont systemFontOfSize:kWidthChange(18)];
        _titlew.textColor = WWColor(51, 51, 51);
    }
    return _titlew;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc] init];
        _backImageView.image = [UIImage imageNamed:@"my_wodedingyue"];
        [_backImageView sizeToFit];
    }
    return _backImageView;
}

@end
