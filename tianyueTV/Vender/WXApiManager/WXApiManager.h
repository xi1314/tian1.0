//
//  WXApiManager.h
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiHeader.h"

typedef void(^WXApiManagerBlock)(void);

@interface WXApiManager : NSObject <WXApiDelegate> {
    WXApiManagerBlock _block;
}

+ (instancetype)sharedManager;

/**
 微信支付

 @param bodyString 商品或支付单简要描述
 @param tradeNum 商户订单号
 @param price 总金额(int 换算为分)
 @param block 支付后回调
 */
- (void)weixinPay:(NSString *)bodyString
      andTradeNum:(NSString *)tradeNum
         andPrice:(NSString *)price
         andBlock:(WXApiManagerBlock)block;


/**
 查看微信订单

 @param tradeNum  商户订单号
 */
- (void)checkWeixinPay:(NSString *)tradeNum;

@end
