//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 16/07/2015.
//
//

#import "WXApiManager.h"
#import "CommonUtil.h"

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

    // 请求微信预支付订单
    NSDictionary *dic = @{@"order_id" : tradeNum};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"Order_buy_wxPay" paraments:dic finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dataDic = responseObject[@"info"];
        if ([dataDic[@"result_code"] isEqualToString:@"SUCCESS"]) {
            
            [WXApiManager jumpToBizPay:dataDic[@"appid"] partnerid:dataDic[@"mch_id"] prepayid:dataDic[@"prepay_id"]];
        }
        
    }];
}

#pragma mark - 请求微信支付
/**
 微信支付
 
 @param appid appid
 @param partnerid 商户号
 @param prepayid 预支付id
 */
+ (void)jumpToBizPay:(NSString *)appid
           partnerid:(NSString *)partnerid
            prepayid:(NSString *)prepayid
{
    NSDictionary *params = @{@"appid" : appid,
                             @"partnerid" : partnerid,
                             @"prepayid" : prepayid,
                             @"package" : @"Sign=WXPay",
                             @"noncestr" : [CommonUtil md5:[NSString stringWithFormat:@"%d",arc4random()%10000]],
                             @"timestamp" : [NSString stringWithFormat:@"%d", (unsigned int)[[NSDate date] timeIntervalSince1970]]};
    
    NSString *packageSign = [WXApiManager signRequestParams:params];
    
    //调起微信支付
    PayReq* req  = [[PayReq alloc] init];
    req.partnerId = [params objectForKey:@"partnerid"];
    req.prepayId = [params objectForKey:@"prepayid"];
    req.nonceStr = [params objectForKey:@"noncestr"];
    req.timeStamp = (UInt32)[params[@"timestamp"] longLongValue];
    req.package = [params objectForKey:@"package"];
    req.sign = packageSign;
    [WXApi sendReq:req];
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
    }
}

//微信请求回调
- (void)onReq:(BaseReq *)req {
    
}


#pragma mark - 将参数签名
/**
 数字签名方法
 
 @param params 字典
 @return xml格式的字符串
 */
+ (NSString *)signRequestParams:(NSDictionary *)params {
    NSArray *keys = [params allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    
    NSMutableString *package = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        [package appendString:key];
        [package appendString:@"="];
        [package appendString:[params objectForKey:key]];
        [package appendString:@"&"];
    }
    
    NSString *appKeyString = [NSString stringWithFormat:@"key=%@", WXAPI_APIMIYAO];
    [package appendString:appKeyString];
    
    NSString *packageSign = [[CommonUtil md5:[package copy]] uppercaseString];
    
    return packageSign;
}


@end
