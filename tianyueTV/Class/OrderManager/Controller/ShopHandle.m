//
//  ShopHandle.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/1.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "ShopHandle.h"
#import "AddressModel.h"

@implementation ShopHandle

+ (void)requestForAddressListWithUSer:(NSString *)user
                        completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"user_id" : user};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_address_list paraments:dic finish:^(id responseObject, NSError *error) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([dic[RET] isEqualToString:SUCCESS]) {
            
            AddressModel *addM = [AddressModel mj_objectWithKeyValues:dic];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                for (int i = 0; i < addM.sAddresses_list.count; i++) {
                    AddressInfoModel *infoM = addM.sAddresses_list[i];
                    infoM.cellHeight = [ShopHandle calculateCellHeight:infoM.address];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completeBlock(addM, nil);
                    });
                }
            });
            
        } else {
            completeBlock (nil, error);
        }
        NSLog(@"%@",responseObject);
    }];
}

/**
 计算cell高度
 
 @param address 地址
 @return cell动态高度值
 */
+ (CGFloat)calculateCellHeight:(NSString *)address {

    CGSize titleSize = [address boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    if (titleSize.height < 30) {
        return 100;
    } else {
        return 90 + titleSize.height;
    }
    return 100;
}

@end
