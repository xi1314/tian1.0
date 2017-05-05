//
//  MyOrderView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "MyOrderView.h"
#import "WWMyViewButton.h"
#import "MyItemView.h"

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
    CGFloat itemWidth = (SCREEN_WIDTH - 40)/3.0f;
    NSArray *titleArr = @[@"买家订单", @"卖家订单"];
    for (int i = 0; i < 2; i ++) {
        MyItemView *itemV = [[MyItemView alloc] initWithFrame:CGRectMake(10 + (10 + itemWidth) * i, 10 , itemWidth, itemWidth)];
        itemV.tag = 100 + i;
        [self addSubview:itemV];
        
        [itemV setImageString:@"my_order"];
        [itemV setTitleString:titleArr[i]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [itemV addGestureRecognizer:tap];
        
    }
    
}


- (void)tapAction:(UITapGestureRecognizer *)sender {
    MyItemView *itemView = (MyItemView *)sender.view;
    NSInteger tag = itemView.tag - 100;
    if (self.block) {
        self.block(tag);
    }
}

@end
