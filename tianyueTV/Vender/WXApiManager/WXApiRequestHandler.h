//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import <Foundation/Foundation.h>
#import "WXApiObject.h"
#import "CommonUtil.h"
#import "NSStack.h"

@interface WXApiRequestHandler : NSObject <NSXMLParserDelegate> {
    BOOL isGetParpert;  // 是否获得prepare_id
    BOOL isCheckStatus; // 是否已获取订单状态
}

// 微信返回prepare_id
@property (nonatomic, copy) NSString *prepareId;

// 查询的订单状态
@property (nonatomic, copy) NSString *tradeStatue;


/**
 调用微信统一订单接口，获取prepareId

 @param bodyString 商品或支付单简要描述
 @param tradeNum 商户订单号
 @param price 总金额(int 换算为分)
 */
- (void)wxPrepareToPay:(NSString *)bodyString
           andTradeNum:(NSString *)tradeNum
              andPrice:(NSString *)price;


/**
 查询微信订单

 @param tradeNum 商户订单号
 */
- (void)checkWeixinPayTradeNum:(NSString *)tradeNum;

@end
