//
//  OrderHandle.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "OrderHandle.h"
#import "OrderModel.h"

@implementation OrderHandle

/**
 全部订单（卖家）
 
 @param userID 用户ID
 @param page   页码
 @param completeBlock 返回值
 */
+ (void)requestForDatasourceWithUser:(NSString *)userID
                                page:(NSInteger)page
                       completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *params = @{@"userId" : userID,
                             @"currentPage" : @(page)};

    [[NetWorkTool sharedTool] requestMethod:POST URL:api_orderInfo_app paraments:params finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dict = (NSDictionary *)responseObject;
        if ([dict[RET] isEqualToString:SUCCESS]) {
            
            OrderModel *oM = [OrderModel mj_objectWithKeyValues:dict];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                if (oM.orderSnList.count) {
                    for (int i = 0; i < oM.orderSnList.count; i++) {
                        OrderSnModel *orderSnM = oM.orderSnList[i];
                        GoodsInfoModel *goodsInfoM = orderSnM.goodsList[0];
                        
                        OrderHandle *oh = [[OrderHandle alloc] init];
                        goodsInfoM.cellHeight = [oh calculateCellHeight:goodsInfoM.content];
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(oM, nil);
                });
            });
            
        }else {
            completeBlock(nil, error);
        }
        
    }];

}

/**
 计算cell高度
 
 @param content 留言内容
 @return cell动态高度值
 */
- (CGFloat)calculateCellHeight:(NSString *)content {
    // 定制需求
    NSString *string;
    if (content.length != 0) {
        string = [NSString stringWithFormat:@"定制需求:%@",content];
    } else {
        string = [NSString stringWithFormat:@"定制需求:无"];
    }

    CGSize titleSize = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    if (titleSize.height < 30) {
        return 210;
    } else {
        return 195 + titleSize.height;
    }
    return 210;
}

@end
