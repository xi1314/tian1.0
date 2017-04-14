//
//  WXApiManager.m
//  SDKSample
//
//  Created by Jeason on 15/7/14.
//
//

#import "WXApi.h"
#import "WXApiRequestHandler.h"
#import "DataXMLParser.h"
#import "WXApiHeader.h"

@implementation WXApiRequestHandler

#pragma mark - 调用微信统一订单接口，获取prepareId
/**
 调用微信统一订单接口，获取prepareId
 
 @param bodyString 商品或支付单简要描述
 @param tradeNum 商户订单号
 @param price 总金额(int 换算为分)
 */
- (void)wxPrepareToPay:(NSString *)bodyString
           andTradeNum:(NSString *)tradeNum
              andPrice:(NSString *)price {

    if (!bodyString || [bodyString isEqualToString:@""]) {
        bodyString = @"自定义内容";
    }
    NSDictionary *params = @{@"appid" : WXAPI_APPID,
                             @"mch_id" : WXAPI_PARTNERID,
                             @"nonce_str" : [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]],
                             @"body" : bodyString,
                             @"out_trade_no" : tradeNum,
                             @"total_fee" : price,
                             @"spbill_create_ip" : [CommonUtil getIPAddress:YES],
                             @"notify_url" : @"http://www.tianyue.tv/wxpayNotify",
                             @"trade_type" : @"APP"};
    
    NSString *packageSign = [self signRequestParams:params];

    NSMutableDictionary *muParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [muParams setObject:packageSign forKey:@"sign"];

    NSString *xmlParams = [self xmlStringForDict:muParams];
    
    NSString *urlString = @"https://api.mch.weixin.qq.com/pay/unifiedorder";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[xmlParams dataUsingEncoding:NSUTF8StringEncoding]];

    isGetParpert = NO;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        DataXMLParser *parse = [[DataXMLParser alloc] initWithData:data];
        parse.xmlID = 1;
        [parse setDelegate:self];
        [parse parse];
        
    }];
    [dataTask resume];
}

#pragma mark - 请求微信支付
/**
 微信支付

 @param prepareId prepareId
 */
- (void)jumpToBizPay:(NSString *)prepareId {

    NSDictionary *params = @{@"appid" : WXAPI_APPID,
                             @"partnerid" : WXAPI_PARTNERID,
                             @"prepayid" : prepareId,
                             @"package" : @"Sign=WXPay",
                             @"noncestr" : [CommonUtil md5:[NSString stringWithFormat:@"%d",arc4random()%10000]],
                             @"timestamp" : [NSString stringWithFormat:@"%d", (unsigned int)[[NSDate date] timeIntervalSince1970]]};
    
    NSString *packageSign = [self signRequestParams:params];
    
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

#pragma mark - 查询微信订单
/**
 查询微信订单
 
 @param tradeNum 商户订单号
 */
- (void)checkWeixinPayTradeNum:(NSString *)tradeNum {
    NSDictionary *params = @{@"appid" : WXAPI_APPID,
                             @"mch_id" : WXAPI_PARTNERID,
                             @"out_trade_no" : tradeNum,
                             @"nonce_str" : [CommonUtil md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]]};
    
    NSString *packageSign = [self signRequestParams:params];
    
    NSMutableDictionary *muParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [muParams setObject:packageSign forKey:@"sign"];
    
    NSString *xmlParams = [self xmlStringForDict:muParams];
    
    NSString *urlString = @"https://api.mch.weixin.qq.com/pay/orderquery";
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[xmlParams dataUsingEncoding:NSUTF8StringEncoding]];

    isCheckStatus = NO;
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        DataXMLParser *parse = [[DataXMLParser alloc] initWithData:data];
        parse.xmlID = 2;
        [parse setDelegate:self];
        [parse parse];
        
    }];
    [dataTask resume];
 
}

#pragma mark - 将参数签名
/**
 数字签名方法

 @param params 字典
 @return xml格式的字符串
 */
- (NSString *)signRequestParams:(NSDictionary *)params {
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

#pragma mark - NSXMLParserDelegate
//遍例xml的节点
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(NSDictionary<NSString *, NSString *> *)attributeDict {
    
    if ([parser isMemberOfClass:[DataXMLParser class]]) {
        DataXMLParser *dataX = (DataXMLParser *)parser;
        if (dataX.xmlID == 1) {
            //支付
            @synchronized(self) {
                if ([elementName isEqualToString:@"prepay_id"]) {
                    isGetParpert = YES;
                }
            }
        }else if (dataX.xmlID == 2) {
            //查询订单
            @synchronized(self) {
                if ([elementName isEqualToString:@"trade_state"]) {
                    isCheckStatus = YES;
                }
            }
        }
    }
}

//step 3:获取首尾节点间内容
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([parser isMemberOfClass:[DataXMLParser class]]) {
        DataXMLParser *dataX = (DataXMLParser *)parser;
        if (dataX.xmlID == 1) {
            //支付
            @synchronized(self) {
                if (isGetParpert && !self.prepareId) {
                    self.prepareId = string;
                    
                }
            }
            
        }else if (dataX.xmlID == 2) {
            //查询订单
            @synchronized(self) {
                if (isCheckStatus && !self.tradeStatue) {
                    self.tradeStatue = string;
                    
                }
            }
        }
    }
}

// 遇到文档结束时触发
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([parser isMemberOfClass:[DataXMLParser class]]) {
            DataXMLParser *dataX = (DataXMLParser *)parser;
            if (dataX.xmlID == 1) {
                //支付
                isGetParpert = NO;
                if (self.prepareId) {
                    [self jumpToBizPay:self.prepareId];
                }else {
                    
//                    [SVProgressHud showStatus:@"支付失败！"];
                }
            }else if (dataX.xmlID == 2) {
                //查询订单
                isCheckStatus = NO;
                if (self.tradeStatue && [self.tradeStatue isEqualToString:@"SUCCESS"]) {
//                    [SVProgressHud showStatus:@"支付成功！"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEIXINSUCCESSTOPUSH" object:nil userInfo:nil];
                }else {
//                    [SVProgressHud showStatus:@"支付失败！"];
                    
                }
            }
        }
    });
}

#pragma mark - 将字典转换为xml string
//将字典转换为xml string
- (NSString *)xmlStringForDict:(NSDictionary *)dict {
    
    //    NSMutableString *xmlString = [[NSMutableString alloc] initWithString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"];
    NSMutableString *xmlString = [[NSMutableString alloc] initWithString:@"<xml>"];
    NSStack *stack = [[NSStack alloc] init];
    NSArray  *keys = nil;
    NSString *key  = nil;
    NSObject *value    = nil;
    NSObject *subvalue = nil;
    //NSInteger size = 0;
    [stack push:dict];
    while (![stack empty]) {
        value = [stack top];
        [stack pop];
        if (value) {
            if ([value isKindOfClass:[NSString class]]) {
                [xmlString appendFormat:@"</%@>", value];
            }
            else if([value isKindOfClass:[NSDictionary class]])
            {
                keys = [(NSDictionary*)value allKeys];
                //size = [(NSDictionary*)value count];
                for (key in keys) {
                    subvalue = [(NSDictionary*)value objectForKey:key];
                    if ([subvalue isKindOfClass:[NSDictionary class]]) {
                        [xmlString appendFormat:@"<%@>", key];
                        [stack push:key];
                        [stack push:subvalue];
                    }
                    else if([subvalue isKindOfClass:[NSString class]])
                    {
                        [xmlString appendFormat:@"<%@>%@</%@>", key, subvalue, key];
                    }
                }
            }
        }
    }
    [xmlString appendString:@"</xml>"];
    return xmlString;
}

@end
