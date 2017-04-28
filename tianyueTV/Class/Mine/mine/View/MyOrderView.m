//
//  MyOrderView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "MyOrderView.h"
#import "WWMyViewButton.h"

@interface MyOrderView ()

// 买家订单
@property (nonatomic, strong) WWMyViewButton *userOrder;

// 卖家订单
@property (nonatomic, strong) WWMyViewButton *sellerOrder;


@end

@implementation MyOrderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initilizeSubviews];
    }
    return self;
}

- (void)initilizeSubviews {
    NSArray *titleArr = @[@"买家订单", @"卖家订单"];
    for (int i = 0; i < 2; i ++) {
        WWMyViewButton *button = [[WWMyViewButton alloc] init];
        button.backImageView.image = [UIImage imageNamed:@""];
        button.titlew.text = titleArr[i];
        button.layer.borderWidth = 1.0;
        button.layer.borderColor = WWColor(212, 212, 212).CGColor;
        button.frame = CGRectMake(kWidthChange(20) + kWidthChange(245) * i, kHeightChange(30), kWidthChange(225), kHeightChange(234));
        button.tag = 200 + i;
        [button addTarget:self action:@selector(respondsToButton_action:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    
}


- (void)respondsToButton_action:(UIButton *)sender {
    NSInteger tag = sender.tag - 200;
    if (self.block) {
        self.block(tag);
    }
}

@end
