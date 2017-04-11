//
//  ShopHandle.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/1.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseHandler.h"

@interface ShopHandle : BaseHandler

/**
 地址列表
 
 @param user 用户id
 @param completeBlock 返回值
 */
+ (void)requestForAddressListWithUSer:(NSString *)user
                        completeBlock:(HandlerBlock)completeBlock;

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
                          completeBlock:(HandlerBlock)completeBlock;

/**
 删除地址
 
 @param user 用户id
 @param addressID 地址id
 @param completeBlock 返回值
 */
+ (void)requestForDeleteAddressWithUser:(NSString *)user
                              addressID:(NSString *)addressID
                          completeBlock:(HandlerBlock)completeBlock;

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
                           completeBlock:(HandlerBlock)completeBlock;

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
                        completeBlock:(HandlerBlock)completeBlock;


@end
