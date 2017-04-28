//
//  LivingHandler.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "LivingHandler.h"
#import "GoodsModel.h"

@implementation LivingHandler

/**
 直播间商品

 @param user 主播id
 @param completeBlcok 返回值
 */
+ (void)requestForLivingRoomGoodWithUser:(NSString *)user
                           CompleteBlock:(HandlerBlock)completeBlcok
{
    NSDictionary *dic = @{@"uId" : user};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_showShop_app paraments:dic finish:^(id responseObject, NSError *error) {
        NSLog(@"hhhhhh   %@",responseObject);
        
        if (responseObject) {
            GoodsModel *GM = [GoodsModel mj_objectWithKeyValues:responseObject];
            completeBlcok(GM.goodsList, nil);
        } else {
            completeBlcok(nil, error);
        }
    }];
}

@end
