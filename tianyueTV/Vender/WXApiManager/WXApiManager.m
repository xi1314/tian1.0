//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "WXApiRequestHandler.h"

@implementation WXApiManager

#pragma mark - LifeCycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WXApiManager alloc] init];
    });
    return instance;
}

- (void)weixinPay:(NSString *)bodyString
      andTradeNum:(NSString *)tradeNum
         andPrice:(NSString *)price
         andBlock:(WXApiManagerBlock)block {
    
    _block = [block copy];
    
    WXApiRequestHandler *wxRequest = [[WXApiRequestHandler alloc] init];
    [wxRequest wxPrepareToPay:bodyString andTradeNum:tradeNum andPrice:price];
}

- (void)checkWeixinPay:(NSString *)tradeNum {
    WXApiRequestHandler *wxRequest = [[WXApiRequestHandler alloc] init];
    [wxRequest checkWeixinPayTradeNum:tradeNum];
}

#pragma mark - WXApiDelegate
//微信响应回调
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
    
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = @"";
//        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
 
        switch (resp.errCode) {
            case WXSuccess:
            {
                if (_block) {
                    _block();
                }
                
                strMsg = @"支付结果：成功！";
            }
//                strMsg = @"支付结果：成功！";
//                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
            
                break;
                
            default:
//                strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                strMsg = @"支付结果：失败！";
                break;
        }
        
        NSLog(@"strMsg  :%@", strMsg);
    }

}

//微信请求回调
- (void)onReq:(BaseReq *)req {
    
}


@end
