//
//  AnchorSpaceHandle.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/18.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BaseHandler.h"

@interface AnchorSpaceHandle : BaseHandler

/**
 我的直播间
 
 @param userID 用户ID
 @param completeBlock 返回值
 */
+ (void)requestForBroadcastAppWithUser:(NSString *)userID
                         completeBlock:(HandlerBlock)completeBlock;

@end
