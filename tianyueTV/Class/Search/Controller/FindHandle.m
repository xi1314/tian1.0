//
//  FindHandle.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "FindHandle.h"

@implementation FindHandle

/**
 发现中所有直播间

 @param completeBlock 返回值
 */
+ (void)requestForAllLivingRoomWithCompleteBlock:(HandlerBlock)completeBlock {
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_mobileAllBroadcastLiving1 paraments:nil finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if (responseObject) {
            FindModel *fm = [FindModel mj_objectWithKeyValues:dic];
            completeBlock(fm, nil);
        } else {
            completeBlock(nil, error);
        }
    }];
}

@end
