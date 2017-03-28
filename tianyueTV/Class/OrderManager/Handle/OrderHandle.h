//
//  OrderHandle.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BaseHandler.h"

@interface OrderHandle : BaseHandler

/**
 全部订单（卖家）
 
 @param userID 用户ID
 @param page   页码
 @param responseObject 返回值
 */
+ (void)requestForDatasourceWithUser:(NSString *)userID
                                page:(NSInteger)page
                      responseObject:(HandlerBlock)responseObject;

@end
