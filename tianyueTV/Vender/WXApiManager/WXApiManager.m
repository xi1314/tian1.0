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

- (void)weixinPayTradeNum:(NSString *)tradeNum
         andBlock:(WXApiManagerBlock)block
{
    _block = [block copy];
    
    WXApiRequestHandler *wxRequest = [[WXApiRequestHandler alloc] init];
    [wxRequest wxPrepareTradeNum:tradeNum];
}

#pragma mark - WXApiDelegate
//微信响应回调
- (void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[PayResp class]]){
    
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg = @"";
 
        switch (resp.errCode) {
            case WXSuccess:
            {
                if (_block) {
                    _block();
                }
                
                strMsg = @"支付结果：成功！";
                [MBProgressHUD showSuccess:@"支付成功"];
            }
            
                break;
                
            default:

                strMsg = @"支付结果：失败！";
                [MBProgressHUD showError:@"支付失败"];
                break;
        }
        
        NSLog(@"strMsg  :%@", strMsg);
    }

}

//微信请求回调
- (void)onReq:(BaseReq *)req {
    
}


@end
