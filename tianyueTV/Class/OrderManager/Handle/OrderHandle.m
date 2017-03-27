//
//  OrderHandle.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "OrderHandle.h"

@implementation OrderHandle

/**
 全部订单（卖家）
 
 @param userID 用户ID
 @param page   页码
 @param responseObject 返回值
 */
+ (void)requestForDatasourceWithUser:(NSString *)userID
                                page:(NSInteger)page
                      responseObject:(OrderHandleBlock)responseObject;
{
    NSString *pageStr    = [NSString stringWithFormat:@"%ld",page];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:userID,@"userId",pageStr,@"currentPage", nil];
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"orderInfo_app" paraments:dic finish:^(id responseObject, NSError *error) {
    
//        if (self.handleBlock) {
//            self.handleBlock(responseObject, error);
//        }
    }];
}
@end
