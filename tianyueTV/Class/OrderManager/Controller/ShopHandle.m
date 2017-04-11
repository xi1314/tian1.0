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

/**
 地址列表

 @param user 用户id
 @param completeBlock 返回值
 */
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
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    completeBlock(addM, nil);
                });
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
    
    if (titleSize.height < 18) {
        return 100;
    } else {
        return 92 + titleSize.height;
    }
    return 100;
}

/**
 添加地址

 @param user 用户id
 @param name 收件人姓名
 @param phone 电话
 @param province 省
 @param city 市
 @param area 区
 @param address 详细地址
 @param zipcode 邮编
 @param completeBlock 返回值
 */
+ (void)requestForAddNewAddressWithUser:(NSString *)user
                                   name:(NSString *)name
                                  phone:(NSString *)phone
                               province:(NSString *)province
                                   city:(NSString *)city
                                   area:(NSString *)area
                                address:(NSString *)address
                                zipcode:(NSString *)zipcode
                          completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"userId" : user,
                          @"name" : name,
                          @"telephone" : phone,
                          @"provinceName" : province,
                          @"cityName" : city,
                          @"address" : address,
                          @"zipCode" : zipcode};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_address_new paraments:dic finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject, nil);
        } else {
            completeBlock(nil, error);
        }
    }];
    
}

/**
 删除地址

 @param user 用户id
 @param addressID 地址id
 @param completeBlock 返回值
 */
+ (void)requestForDeleteAddressWithUser:(NSString *)user
                              addressID:(NSString *)addressID
                          completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"userId" : user,
                          @"id" : addressID};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_add_delete paraments:dic finish:^(id responseObject, NSError *error) {
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject, nil);
        } else {
            completeBlock(nil, error);
        }
    }];
}

/**
 设置默认地址

 @param user 用户id
 @param isDefault 1默认，0不是默认
 @param addressID 地址id
 @param completeBlock 返回值
 */
+ (void)reqeustForDefaultAddressWithUser:(NSString *)user
                               isDefault:(NSString *)isDefault
                               addressID:(NSString *)addressID
                           completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"userId" : user,
                          @"id" : addressID,
                          @"isDefault" : isDefault};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_editAdd_app paraments:dic finish:^(id responseObject, NSError *error) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject, nil);
        } else {
            completeBlock(nil, error);
        }
    }];
}

/**
 编辑地址

 @param user 用户id
 @param addressID 地址id
 @param name 收件人姓名
 @param phone 电话
 @param province 省
 @param city 市
 @param area 区
 @param address 详细地址
 @param zipcode 邮编
 @param completeBlock 返回值
 */
+ (void)requestForEditAddressWithUser:(NSString *)user
                            addressID:(NSString *)addressID
                                 name:(NSString *)name
                                phone:(NSString *)phone
                             province:(NSString *)province
                                 city:(NSString *)city
                                 area:(NSString *)area
                              address:(NSString *)address
                              zipcode:(NSString *)zipcode
                        completeBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"userId" : user,
                          @"id" : addressID,
                          @"name" : name,
                          @"telephone" : phone,
                          @"provinceName" : province,
                          @"cityName" : city,
                          @"area" : area,
                          @"address" : address,
                          @"zipCode" : zipcode};
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_editAdd_app paraments:dic finish:^(id responseObject, NSError *error) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject, nil);
        } else {
            completeBlock(nil, error);
        }
    }];
}

/**
 请求省份

 @param provinceID 省份ID
 @param cityID 城市ID
 @param completeBlock 返回值
 */
+ (void)requestForProvinceWithProvinceID:(NSString *)provinceID
                                  cityID:(NSString *)cityID
                           CompleteBlock:(HandlerBlock)completeBlock
{
    NSDictionary *dic = @{@"city_id" : provinceID,
                          @"area_id" : cityID};
    [[NetWorkTool sharedTool] requestMethod:POST URL:api_province_app paraments:dic finish:^(id responseObject, NSError *error) {
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSLog(@"%@",responseObject);
        if ([dic[RET] isEqualToString:SUCCESS]) {
            completeBlock(responseObject, nil);
        } else {
            completeBlock(nil, error);
        }
        
    }];
}

@end
