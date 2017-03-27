
//
//  BuyCountView.m
//  AddShoppingCart
//
//  Created by 主用户 on 16/3/23.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import "BuyCountView.h"

@implementation BuyCountView
@synthesize bt_add,bt_reduce,tf_count,lb;

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 30)];
        lb.text = @"购买数量:";
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont systemFontOfSize:14];
        [self addSubview:lb];
        
        bt_reduce= [UIButton buttonWithType:UIButtonTypeCustom];
        bt_reduce.frame = CGRectMake(CGRectGetMaxX(lb.frame), 15, 20, 20);
        [bt_reduce setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1"] forState:UIControlStateNormal];
        [self addSubview:bt_reduce];
        
        tf_count = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bt_reduce.frame), 10, 40, 30)];
        tf_count.text = @"1";
        tf_count.textAlignment = NSTextAlignmentCenter;
        tf_count.font = [UIFont systemFontOfSize:15];
        [self addSubview:tf_count];
        
        bt_add= [UIButton buttonWithType:UIButtonTypeCustom];
        bt_add.frame = CGRectMake(CGRectGetMaxX(tf_count.frame), 15, 20, 20);
        [bt_add setBackgroundImage:[UIImage imageNamed:@"圆角矩形-1-拷贝-2"] forState:0];
        [self addSubview:bt_add];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
