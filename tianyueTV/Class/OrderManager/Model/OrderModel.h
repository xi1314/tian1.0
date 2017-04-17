//
//  OrderModel.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 卖家订单model
 */
@interface OrderModel : NSObject

// 待付款订单数
@property (nonatomic, copy) NSString *waitPayCount;

// 待确认订单
@property (nonatomic, copy) NSString *waitSureCount;

// 总页数
@property (nonatomic, copy) NSString *totalPage;

// 当前页
@property (nonatomic, copy) NSString *currentPage;

// 所有订单数
@property (nonatomic, copy) NSString *allCount;

// 待收货订单
@property (nonatomic, copy) NSString *waitTakeDeliverCount;

// 选择的状态
@property (nonatomic, copy) NSString *selectStatus;

// 退款数订单
@property (nonatomic, copy) NSString *refundCount;

// 待确认订单
@property (nonatomic, copy) NSString *waitDeliverCount;

// 已取消订单数
@property (nonatomic, copy) NSString *canceledCount;

// 已完成订单数
@property (nonatomic, copy) NSString *completedCount;

// 订单状态
@property (nonatomic, copy) NSString *status;

// 订单数组
@property (nonatomic, strong) NSArray *orderSnList;

@end





/**
 订单数组model
 */
@interface OrderSnModel : NSObject

// 订单数组
@property (nonatomic, strong) NSArray *goodsList;

@end






/**
 订单信息model
 */
@interface GoodsInfoModel : NSObject

// 订单编号
@property (nonatomic, copy) NSString *orderInfoSn;

// 尾款
@property (nonatomic, copy) NSString *retainage;

// 商品名称
@property (nonatomic, copy) NSString *goodsName;

// 商品属性（需拆分成数组）
@property (nonatomic, copy) NSString *goodsAttr;

// 价格
@property (nonatomic, copy) NSString *goodsPrice;

// 图片地址
@property (nonatomic, copy) NSString *goodsImage;

// 商品ID
@property (nonatomic, copy) NSString *goodsId;

// 尾款订单号
@property (nonatomic, copy) NSString *retainageOrderNo;

// 订单状态
@property (nonatomic, copy) NSString *orderStauts;

// 卖家ID
@property (nonatomic, copy) NSString *sellerId;

// 订单ID
@property (nonatomic, copy) NSString *order_id;

// 这条信息的ID
@property (nonatomic, copy) NSString *ID;

// parentId
@property (nonatomic, copy) NSString *parentId;

// 购买数量
@property (nonatomic, copy) NSString *goodsNum;

// 下单时间
@property (nonatomic, copy) NSString *goodsOrder_time;

// 购买状态
@property (nonatomic, copy) NSString *shippingStatus;

// 付款状态
@property (nonatomic, copy) NSString *payStatus;

// 退款状态
@property (nonatomic, copy) NSString *refoundStatus;

// 商品类型 0成品 1定制
@property (nonatomic, copy) NSString *goodsType;

// 定制需求
@property (nonatomic, copy) NSString *content;

// 用户ID
@property (nonatomic, copy) NSString *userId;

/**
 订单状态 0：待付款   1：待确认  2/：待发货  3：已发货  4：交易完成（已完成）                           5：已退款（已完成）   6：已取消（只有代付款有取消操作）  7：（不管是定制还是非定制的退款）                                                                            8：卖家申请纠纷处理（退款）
 */
@property (nonatomic, copy) NSString *order_status_app;

// cell高度
@property (nonatomic, assign) float cellHeight;

// 订单付款编号
@property (nonatomic, copy) NSString *orderSn;

@end










