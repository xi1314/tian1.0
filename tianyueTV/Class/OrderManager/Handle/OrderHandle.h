//
//  OrderHandle.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BaseHandler.h"

@interface OrderHandle : BaseHandler


/**
 全部订单（卖家与买家）
 
 @param userID 用户ID
 @param page   页码
 @param isSeller 判断是否为卖家，卖家为1，买家为0
 @param completeBlock 返回值
 */
+ (void)requestForDatasourceWithUser:(NSString *)userID
                                page:(NSInteger)page
                            isSeller:(BOOL)isSeller
                       completeBlock:(HandlerBlock)completeBlock;


/**
 根据状态请求订单（卖家与买家）
 
 @param order 订单状态
 @param shopping 购买状态
 @param pay 支付状态
 @param userID 用户id
 @param page 页码，默认为1
 @param isSeller 判断是否为卖家，卖家为1，买家为0
 @param completeBlock 返回值
 */
+ (void)requestForOrderWithOrder:(NSInteger)order
                        shopping:(NSInteger)shopping
                             pay:(NSInteger)pay
                          userID:(NSString *)userID
                            page:(NSInteger)page
                        isSeller:(BOOL)isSeller
                   completeBlock:(HandlerBlock)completeBlock;


/**
 卖家设置尾款
 
 @param user 用户ID
 @param orderID 订单ID
 @param retainage 尾款价格
 */
+ (void)requestForFinalPaymentWithUser:(NSString *)user
                               orderID:(NSString *)orderID
                             retainage:(NSString *)retainage
                         completeBlock:(HandlerBlock)completeBlock;


/**
 取消订单
 
 @param orderSn 订单编号
 @param completeBlock 返回值
 */
+ (void)requestForCancelOrderWithOrderSn:(NSString *)orderSn
                           completeBlock:(HandlerBlock)completeBlock;


/**
 设置物流信息
 
 @param user userID
 @param orderID 订单编号
 @param companyName 物流公司名称
 @param deliveryNumber 物流单号
 @param completeBlock 返回值
 */
+ (void)requestForDeliveryInfoWithUSer:(NSString *)user
                               orderID:(NSString *)orderID
                           companyName:(NSString *)companyName
                        deliveryNumber:(NSString *)deliveryNumber
                         completeBlock:(HandlerBlock)completeBlock;


/**
 删除订单
 
 @param orderSn 订单编号
 @param tomato 1买家取消 2卖家取消
 @param completeVlock 返回值
 */
+ (void)requestForDeleteOrderWithOrderSn:(NSString *)orderSn
                                  tomato:(NSString *)tomato
                           completeBlock:(HandlerBlock)completeVlock;


/**
 申请退款
 
 @param orderSn 订单编号
 @param user userID
 @param completeBlock 返回值
 */
+ (void)requestForApplyRefoundWithOrderSn:(NSString *)orderSn
                                     user:(NSString *)user
                            completeBlock:(HandlerBlock)completeBlock;


/**
 确认收货
 
 @param orderSn 订单编号
 @param user 用户ID
 @param completeBlock 返回值
 */
+ (void)requestForSureDeliveryWithOrderSn:(NSString *)orderSn
                                     user:(NSString *)user
                            completeBlock:(HandlerBlock)completeBlock;


/**
 申请纠纷
 
 @param orderID 订单ID
 @param user userID
 @param completeBlock 返回值
 */
+ (void)requestForOrderDisputeWithOrderID:(NSString *)orderID
                                     user:(NSString *)user
                            completeBlock:(HandlerBlock)completeBlock;


/**
 已支付定金订单的取消
 
 @param orderSn 订单编号
 @param completeBlock 返回值
 */
+ (void)requestForRefoundWithOrderSn:(NSString *)orderSn
                       completeBlock:(HandlerBlock)completeBlock;


@end



