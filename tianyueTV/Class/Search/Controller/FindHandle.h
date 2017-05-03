//
//  FindHandle.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BaseHandler.h"
#import "FindModel.h"

@interface FindHandle : BaseHandler

/**
 发现中所有直播间
 
 @param completeBlock 返回值
 */
+ (void)requestForAllLivingRoomWithCompleteBlock:(HandlerBlock)completeBlock;

/**
 热词搜索
 
 @param completeBlock 返回值
 */
+ (void)requestForHotWordWithCompleteBlock:(HandlerBlock)completeBlock;

/**
 搜索直播间
 
 @param word 关键词
 @param completeBlock 返回值
 */
+ (void)requestForLivingRoomWithWord:(NSString *)word
                       completeBlock:(HandlerBlock)completeBlock;

@end
