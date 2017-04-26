//
//  FindHandle.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BaseHandler.h"

@interface FindHandle : BaseHandler

/**
 发现中所有直播间
 
 @param completeBlock 返回值
 */
+ (void)requestForAllLivingRoomWithCompleteBlock:(HandlerBlock)completeBlock;

@end
