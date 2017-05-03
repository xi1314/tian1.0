//
//  ShopDetailView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/2.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopButtonBlock)(NSInteger tag);

@interface ShopDetailView : UIView

// 点击事件
@property (copy, nonatomic) ShopButtonBlock block;

// 广告栏label
@property (weak, nonatomic) IBOutlet UILabel *bannerLabel;

// 商品展示图
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;

// 切换scrollView
@property (weak, nonatomic) IBOutlet UIScrollView *productScrollView;

// 左切换按钮
@property (weak, nonatomic) IBOutlet UIButton *leftButton;

// 右切换按钮
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

// 加入购物车
@property (weak, nonatomic) IBOutlet UIButton *joinCarButton;

// 立即购买
@property (weak, nonatomic) IBOutlet UIButton *payButton;

// 购物车
@property (weak, nonatomic) IBOutlet UIButton *shoppingCar;


+ (instancetype)shareInstanceType;

@end
