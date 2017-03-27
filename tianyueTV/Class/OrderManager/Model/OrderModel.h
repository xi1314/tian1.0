//
//  OrderModel.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

/**
 点单编号
 */
@property (nonatomic, copy) NSString *orderSn;

/**
 尾款
 */
@property (nonatomic, copy) NSString *retainage;

/**
 商品名称
 */
@property (nonatomic, copy) NSString *goodName;

/**
 商品属性（需拆分成数组）
 */
@property (nonatomic, copy) NSString *goodAttr;

/**
 价格
 */
@property (nonatomic, copy) NSString *price;

/**
 图片地址
 */
@property (nonatomic, copy) NSString *imageString;

/**
 商品ID
 */
@property (nonatomic, copy) NSString *goodID;

/**
 尾款订单号
 */
@property (nonatomic, copy) NSString *retainageSn;

/**
 订单状态
 */
@property (nonatomic, copy) NSString *orderStauts;

/**
 卖家ID
 */
@property (nonatomic, copy) NSString *sellerID;

/**
 订单ID
 */
@property (nonatomic, copy) NSString *orderID;

/**
 这条信息的ID
 */
@property (nonatomic, copy) NSString *infoID;

/**
 ID
 */
@property (nonatomic, copy) NSString *parentID;

/**
 购买数量
 */
@property (nonatomic, copy) NSString *goodCount;

/**
 下单时间
 */
@property (nonatomic, copy) NSString *orderTime;

/**
 购买状态
 */
@property (nonatomic, copy) NSString *shopStauts;

/**
 商品类型 0成品 1定制
 */
@property (nonatomic, copy) NSString *goodType;

/**
 定制需求
 */
@property (nonatomic, copy) NSString *message;

/**
 用户ID
 */
@property (nonatomic, copy) NSString *userID;

@end
