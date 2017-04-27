//
//  SelectionTopView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/27.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "SelectionTopView.h"

@interface SelectionTopView ()

// 图片
@property (nonatomic, strong) UIImageView *imageView;

// 名称
@property (nonatomic, strong) UILabel *titleLabel;

// 价格
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation SelectionTopView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self initilizeSubViews];
    }
    return self;
}

- (void)initilizeSubViews {
    // 封面
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) / 3 * 2)];
    _imageView.backgroundColor = [UIColor redColor];
    [self addSubview:_imageView];
    
    // 名称
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.imageView.frame) + 5, self.width, 15)];
    _titleLabel.text = @"巴洛克风格复古钱包";
    _titleLabel.font = [UIFont systemFontOfSize:10];
    _titleLabel.textColor = WWColor(51, 51, 51);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_titleLabel];
    
    // 价格
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame) + 5, self.width, 15)];
    _priceLabel.text = @"¥398";
    _priceLabel.textColor = WWColor(120, 120, 120);
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:_priceLabel];
    
}


@end
