//
//  ShopModel.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/13.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject

// 商品价格
@property (nonatomic, copy) NSString *goodsPrice;

// 是否被收藏
@property (nonatomic, copy) NSString *Collection;

// 购物车数量
@property (nonatomic, copy) NSString *scart_Num;

// 店铺logo
@property (nonatomic, copy) NSString *shopLogo;

// 图片
@property (nonatomic, copy) NSString *image1;

// 直播间ID
@property (nonatomic, copy) NSString *bcast;

// 商品名称
@property (nonatomic, copy) NSString *goodsName;

// 商品ID
@property (nonatomic, copy) NSString *goodsId;

// 店铺名称
@property (nonatomic, copy) NSString *shopName;

// 商品库存
@property (nonatomic, strong) NSArray *goodsAttributes;

// 商品属性
@property (nonatomic, strong) NSArray *A_kind_of_attribute;

// 用户评论
@property (nonatomic, strong) NSArray *messageList;

@end



/**
 商品库存
 */
@interface GoodStockModel : NSObject

// 库存
@property (nonatomic, copy) NSString *skuStock;

// 信息ID
@property (nonatomic, copy) NSString *ID;

// 属性图片
@property (nonatomic, copy) NSString *skuIamgeUrl;

// 属性一
@property (nonatomic, copy) NSString *commodity_attribute_1;

// 价格
@property (nonatomic, copy) NSString *skugPrice;

// 属性二
@property (nonatomic, copy) NSString *commodity_attribute_2;

@end


/**
 属性model
 */
@interface AttributeModel : NSObject

// 属性名称
@property (nonatomic, copy) NSString *key;

// 属性值
@property (nonatomic, strong) NSArray *keyval;

@end



/**
 用户留言model
 */
@interface MessageModel : NSObject

// 用户id
@property (nonatomic, copy) NSString *userId;

//
@property (nonatomic, copy) NSString *evalStatus;

// 用户头像
@property (nonatomic, copy) NSString *headUrl;

// 评论id
@property (nonatomic, copy) NSString *ID;

// 时间
@property (nonatomic, copy) NSString *time;

// 商品属性
@property (nonatomic, copy) NSString *goodsAttr;

//
@property (nonatomic, copy) NSString *tipCount;

// 评论内容
@property (nonatomic, copy) NSString *content;

// 商品图片
@property (nonatomic, copy) NSString *goodsImg;

// 商品属性
@property (nonatomic, copy) NSString *type;

// 商品id
@property (nonatomic, copy) NSString *gid;



@end











