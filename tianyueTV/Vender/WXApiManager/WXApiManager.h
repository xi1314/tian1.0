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


/**
 block 微信支付结果回调
 */
typedef void(^WXApiManagerBlock)(BOOL success);

@interface WXApiManager : NSObject <WXApiDelegate> {
    // 微信支付结果回调
    WXApiManagerBlock _block;
}


/**
 单例

 @return 单例对象
 */
+ (instancetype)sharedManager;


/**
 微信支付获取prepareId

 @param tradeNum 订单号
 @param block 支付回调
 */
- (void)weixinPayTradeNum:(NSString *)tradeNum
                 andBlock:(WXApiManagerBlock)block;



@end



