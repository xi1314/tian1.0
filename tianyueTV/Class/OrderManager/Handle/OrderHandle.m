//
//  OrderHandle.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "OrderHandle.h"
#import "OrderModel.h"

@implementation OrderHandle


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
                       completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *params = @{@"userId" : userID,
                             @"currentPage" : @(page)};
    
    NSString *urlString = api_personalOrder_app; // 默认是买家
    if (isSeller) {
        urlString = api_orderInfo_app;  // 卖家
    }
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:urlString paraments:params finish:^(id responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[RET] isEqualToString:SUCCESS]) {
            
            OrderModel *oM = [OrderModel mj_objectWithKeyValues:dict];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                if (oM.orderSnList.count) {
                    for (int i = 0; i < oM.orderSnList.count; i++) {
                        OrderSnModel *orderSnM = oM.orderSnList[i];
                        GoodsInfoModel *goodsInfoM = orderSnM.goodsList[0];
                        
                        OrderHandle *oh = [[OrderHandle alloc] init];
                        goodsInfoM.cellHeight = [oh calculateCellHeight:goodsInfoM.content];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(oM, nil);
                });
            });
            
        }else {
            completeBlock(nil, error);
        }
        
    }];
    
}


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
                   completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *params = @{@"orderStauts" : @(order),
                             @"shippingStatus" : @(shopping),
                             @"payStatus" : @(pay),
                             @"userId" : userID,
                             @"currentPage" : @(page)};
    
    NSString *urlString = api_personalOrder_app;  // 默认是买家
    if (isSeller) {
        urlString = api_orderInfo_app;  // 卖家
    }
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:urlString paraments:params finish:^(id responseObject, NSError *error) {
        
        if (responseObject) {
            NSDictionary *dic = (NSDictionary *)responseObject;
            OrderModel *orderModle = [OrderModel mj_objectWithKeyValues:dic];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                if (orderModle.orderSnList.count) {
                    for (int i = 0; i < orderModle.orderSnList.count; i++) {
                        OrderSnModel *snModle = orderModle.orderSnList[i];
                        GoodsInfoModel *infoModle = snModle.goodsList[0];
                        
                        OrderHandle *handle = [[OrderHandle alloc] init];
                        infoModle.cellHeight = [handle calculateCellHeight:infoModle.content];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(orderModle,nil);
                });
            });
            
        } else {
            completeBlock(nil, error);
        }
    }];
    
}


/**
 计算cell高度
 
 @param content 留言内容
 @return cell动态高度值
 */
- (CGFloat)calculateCellHeight:(NSString *)content {
    // 定制需求
    NSString *string;
    if (content.length != 0) {
        string = [NSString stringWithFormat:@"定制需求:%@",content];
    } else {
        string = [NSString stringWithFormat:@"定制需求:无"];
    }

    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    if (titleSize.height < 30) {
        return 210;
    } else {
        return 195 + titleSize.height;
    }
    return 210;
}


/**
 卖家设置尾款

 @param user 用户ID
 @param orderID 订单ID
 @param retainage 尾款价格
 */
+ (void)requestForFinalPaymentWithUser:(NSString *)user
                               orderID:(NSString *)orderID
                             retainage:(NSString *)retainage
                         completeBlock:(HandlerBlock)completeBlock
{
    
    NSDictionary *dic = @{@"user_id" : user,
                          @"orderId" : orderID,
                          @"retainage" : retainage};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_setRetainage_app paraments:dic finish:^(id responseObject, NSError *error) {
        
        if ([responseObject[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject,nil);
        } else {
            completeBlock(nil,error);
        }
    }];
}


/**
 取消订单

 @param orderSn 订单编号
 @param completeBlock 返回值
 */
+ (void)requestForCancelOrderWithOrderSn:(NSString *)orderSn
                           completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"orderInfoSn" : orderSn};

    [[NetWorkTool sharedTool] requestMethod:POST URL:api_updateOrderStatus_app paraments:dic finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject,nil);
        } else {
            completeBlock(nil,responseObject);
        }
    }];
}


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
                         completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"user_id" : user,
                          @"id" : orderID,
                          @"shipping_name" : companyName,
                          @"shipping_no" : deliveryNumber};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_sureSendGoods_app paraments:dic finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject,nil);
        } else {
            completeBlock(responseObject,error);
        }
        
    }];
}


/**
 删除订单

 @param orderSn 订单编号
 @param tomato 1买家取消 2卖家取消
 @param completeVlock 返回值
 */
+ (void)requestForDeleteOrderWithOrderSn:(NSString *)orderSn
                                  tomato:(NSString *)tomato
                           completeBlock:(HandlerBlock)completeVlock
{
    NSDictionary *dic = @{@"orderInfoSn" : orderSn,
                          @"tomato" : tomato};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_DedeletOrder_app paraments:dic finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeVlock(responseObject,nil);
        } else {
            completeVlock(nil,error);
        }
    }];
}


/**
 申请退款

 @param orderSn 订单编号
 @param user userID
 @param completeBlock 返回值
 */
+ (void)requestForApplyRefoundWithOrderSn:(NSString *)orderSn
                                     user:(NSString *)user
                            completeBlock:(HandlerBlock)completeBlock {
    
    NSDictionary *dic = @{@"orderInfoSn" : orderSn,
                          @"userId" : user};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_applyRefund_app paraments:dic finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject, nil);
        } else {
            completeBlock(nil,error);
        }
    }];
}


/**
 确认收货

 @param orderSn 订单编号
 @param user 用户ID
 @param completeBlock 返回值
 */
+ (void)requestForSureDeliveryWithOrderSn:(NSString *)orderSn
                                     user:(NSString *)user
                            completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"orderInfoSn" : orderSn,
                          @"user_id" : user};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_refundqueren_app paraments:dic finish:^(id responseObject, NSError *error) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"%@,%@",responseObject,error);
        
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject,nil);
        } else {
            completeBlock(nil,error);
        }
    }];
}


/**
 申请纠纷

 @param orderID 订单ID
 @param user userID
 @param completeBlock 返回值
 */
+ (void)requestForOrderDisputeWithOrderID:(NSString *)orderID
                                     user:(NSString *)user
                            completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"order_id" : orderID,
                          @"user_id" : user};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_Order_dispute_app paraments:dic finish:^(id responseObject, NSError *error) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"申请纠纷 %@",responseObject);
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject, nil);
        } else {
            completeBlock(nil, error);
        }
    }];
    
}


/**
 已支付定金订单的取消

 @param orderSn 订单编号
 @param completeBlock 返回值
 */
+ (void)requestForRefoundWithOrderSn:(NSString *)orderSn
                       completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"orderInfoSn" : orderSn};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_updateMJOrder paraments:dic finish:^(id responseObject, NSError *error) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject, nil);
        } else {
            completeBlock(nil, responseObject);
        }
    }];
}


@end


