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

 @param tradeNum 订单号
 @param block 支付回调
 */
- (void)weixinPayTradeNum:(NSString *)tradeNum
                 andBlock:(WXApiManagerBlock)block;



@end



