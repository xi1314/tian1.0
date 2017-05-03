//
//  FindHandle.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "FindHandle.h"
#import "FindModel.h"

@implementation FindHandle

/**
 发现中所有直播间

 @param completeBlock 返回值
 */
+ (void)requestForAllLivingRoomWithCompleteBlock:(HandlerBlock)completeBlock
{
    
    
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


/**
 热词搜索

 @param completeBlock 返回值
 */
+ (void)requestForHotWordWithCompleteBlock:(HandlerBlock)completeBlock {
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_ApphotWordslist paraments:nil finish:^(id responseObject, NSError *error) {
    
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if (responseObject) {
            
            NSString *string = dic[@"Textarea_rc"];
            NSArray *arr = [string componentsSeparatedByString:@","];
            completeBlock(arr, nil);
        } else {
            
            completeBlock(nil, error);
        }
    }];
}

/**
 搜索直播间

 @param word 关键词
 @param completeBlock 返回值
 */
+ (void)requestForLivingRoomWithWord:(NSString *)word
                       completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"name" : word};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_Querycorrespondence paraments:dic finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([dic[RET] isEqualToString:SUCCESS]) {
            SearchModel *SM = [SearchModel mj_objectWithKeyValues:dic];
            completeBlock(SM.BroadCastUser, nil);
        } else {
            completeBlock(nil, error);
        }
    }];
}

@end
