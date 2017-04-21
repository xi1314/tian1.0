//
//  HomeHandler.h
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/19.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BaseHandler.h"

@interface HomeHandler : BaseHandler


/**
 首页商标请求
 
 @param completeBlock 返回值
 */
+ (void)requestForBrandTrademarkWithCompleteBlock:(HandlerBlock)completeBlock;


/**
 首页匠作间请求
 
 @param completeBlock 返回值
 */
+ (void)requestForLivingRoomWithCompleteBlock:(HandlerBlock)completeBlock;


/**
 天越甄选
 
 @param completeBlock 返回值
 */
+ (void)requestForTianyueCategoryWithCompleteBlock:(HandlerBlock)completeBlock;

@end
