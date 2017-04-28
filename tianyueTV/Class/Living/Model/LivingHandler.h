//
//  LivingHandler.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHandler.h"

@interface LivingHandler : BaseHandler

/**
 直播间商品
 
 @param user 主播id
 @param completeBlcok 返回值
 */
+ (void)requestForLivingRoomGoodWithUser:(NSString *)user
                           CompleteBlock:(HandlerBlock)completeBlcok;

@end
