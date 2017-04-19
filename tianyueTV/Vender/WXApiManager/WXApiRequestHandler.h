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

@interface WXApiRequestHandler : NSObject
// 微信返回prepare_id
@property (nonatomic, copy) NSString *prepareId;

// 查询的订单状态
@property (nonatomic, copy) NSString *tradeStatue;


/**
 获取prepayid
 
 @param tradeNum 订单号
 */
- (void)wxPrepareTradeNum:(NSString *)tradeNum;


@end
