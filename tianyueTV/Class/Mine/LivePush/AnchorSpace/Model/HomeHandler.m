//
//  HomeHandler.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/19.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "HomeHandler.h"

@implementation HomeHandler


/**
 首页商标请求

 @param completeBlock 返回值
 */
+ (void)requestForBrandTrademarkWithCompleteBlock:(HandlerBlock)completeBlock
{
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_Brand_trademark paraments:nil finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject[@"Brandtrademark"], nil);
        } else {
            completeBlock(nil, error);
        }
        
    }];
    
}

@end
