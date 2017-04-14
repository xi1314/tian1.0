//
//  ChooseView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeView.h"
#import "BuyCountView.h"

typedef void(^ChooseButtonBlock)(NSInteger tag);

@interface ChooseView : UIView
<UITextFieldDelegate,
UIAlertViewDelegate,
TypeSeleteDelegete>

@property (copy, nonatomic) ChooseButtonBlock buttonBlock;

// 滑动视图
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;

// 商品名称
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// 发货地
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

// 价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

// 分享
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

// 喜欢
@property (weak, nonatomic) IBOutlet UIButton *likeButton;

// 商品图片
@property (strong, nonatomic) UIImageView *productImgView;

// 商品库存
@property (strong, nonatomic) NSArray *goodsStock;

// 选择的属性ID
@property (copy, nonatomic) NSString *typeID;

// 购买数量
@property (copy, nonatomic) NSString *goodCount;

//------view悬浮推出时需要用到的属性----
// 判断是否是悬浮页
@property (assign, nonatomic) BOOL isSuspend;

// 价格
@property (weak, nonatomic) IBOutlet UILabel *bigPriceLabel;

// 关闭按钮
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

// 地址label top与view的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;

// 确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureButton;

// 滑动view底边与view的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottom;


//-----商品属性-----
// 尺寸
@property(nonatomic, strong)TypeView *sizeView;

// 颜色
@property(nonatomic, strong)TypeView *colorView;

// 数量选择
@property(nonatomic, strong)BuyCountView *countView;

// 尺寸data
@property(nonatomic, strong)NSArray *sizearr;

// 颜色data
@property(nonatomic, strong)NSArray *colorarr;

// 库存data
@property(nonatomic, strong)NSDictionary *stockdic;

// 库存
@property(nonatomic, strong)UILabel *stockLabel;

// 库存
@property(nonatomic) int stock;

/**
 初始化数据
 
 @param sizeArr 属性一
 @param sizeName 属性一名称
 @param colorArr 属性二
 @param colorName 属性二名称
 @param stockDic 库存字典
 */
- (void)initTypeViewWithSizeArr:(NSArray *)sizeArr sizeName:(NSString *)sizeName colorArr:(NSArray *)colorArr colorName:(NSString *)colorName stockDic:(NSDictionary *)stockDic;


+ (instancetype)shareInstanceTypeWithBool:(BOOL)isSuspend;

@end
