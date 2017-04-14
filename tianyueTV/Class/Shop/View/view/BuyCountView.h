//
//  BuyCountView.h
//  AddShoppingCart
//
//  Created by 主用户 on 16/3/23.
//  Copyright © 2016年 江萧. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyCountView : UIView

// label
@property(nonatomic, retain)UILabel *lb;

// 数量减
@property(nonatomic, retain)UIButton *bt_reduce;

// 数量
@property(nonatomic, retain)UILabel *tf_count;

// 数量加
@property(nonatomic, retain)UIButton *bt_add;
@end
