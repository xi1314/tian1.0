//
//  AnchorSpaceHandle.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/18.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AnchorSpaceHandle.h"
#import "AnchorSpaceModel.h"

@implementation AnchorSpaceHandle

/**
 我的直播间

 @param userID 用户ID
 @param completeBlock 返回值
 */
+ (void)requestForBroadcastAppWithUser:(NSString *)userID
                         completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"userId" : userID};
    
    [[NetWorkTool sharedTool] requestMethod:POST serverAddress:SERVERADDRESS URL:api_Broadcast_app paraments:dic finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[RET] isEqualToString:SUCCESS]) {
            
            AnchorSpaceModel *model = [AnchorSpaceModel mj_objectWithKeyValues:dic];
            
            completeBlock(model, nil);
        } else {
            completeBlock(nil, error);
        }
        
    }];
}

@end
