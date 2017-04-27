//
//  CardView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/27.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "CardView.h"
#import "CycleCarouselView.h"

@interface CardView ()

// 图片轮播
@property (nonatomic, strong) CycleCarouselView *cycleView;

// 标题
@property (nonatomic, strong) UILabel *titleLabel;

// 价格
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initilizeSubViews];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)initilizeSubViews {
    self.backgroundColor = [UIColor whiteColor];
    // 封面
    _cycleView = [[CycleCarouselView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 3 * 2)];
    _cycleView.backgroundColor = [UIColor redColor];
    [self addSubview:_cycleView];
    
    // 名称
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(_cycleView.frame) + 26, self.frame.size.width, 23)];
    _titleLabel.text = @"巴洛克风格复古钱包";
    _titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    _titleLabel.textColor = WWColor(51, 51, 51);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    // 价格
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) + 10, self.width, 20)];
    _priceLabel.text = @"¥398";
    _priceLabel.textColor = WWColor(120, 120, 120);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:_priceLabel];
    
}

@end
