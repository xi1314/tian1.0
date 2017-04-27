//
//  SelectionModel.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/27.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 天越甄选模型
 */
@interface SelectionModel : NSObject

// 标品数组
@property (nonatomic, strong) NSArray *sgoods1;

// 非标品数组
@property (nonatomic, strong) NSArray *sgoods;

@end


/**
 标品模型
 */
@interface SelectionGoodModel : NSObject

// 关键词
@property (nonatomic, copy) NSString *keyWord;

// 促销结束日期
@property (nonatomic, copy) NSString *saleEndDate;

// 图片数组字符串
@property (nonatomic, copy) NSString *goodsImage;

// 库存
@property (nonatomic, copy) NSString *storeNum;

// 描述
@property (nonatomic, copy) NSString *describle;

//
@property (nonatomic, copy) NSString *downTime;

// 喜欢次数
@property (nonatomic, copy) NSString *loveCount;

// 类型ID
@property (nonatomic, copy) NSString *type;

// 商品名称
@property (nonatomic, copy) NSString *name;

// id
@property (nonatomic, copy) NSString *ID;

// 价格
@property (nonatomic, copy) NSString *shopPrice;

// 图片
@property (nonatomic, copy) NSString *appImg;

// 收藏次数
@property (nonatomic, copy) NSString *collectCount;


@end



/**
 非标模型
 */
@interface CustomGoodModel :NSObject

// 关键词
@property (nonatomic, copy) NSString *keyWord;

// 促销结束日期
@property (nonatomic, copy) NSString *saleEndDate;

// 图片数组字符串
@property (nonatomic, copy) NSString *goodsImage;

// 库存
@property (nonatomic, copy) NSString *storeNum;

// 描述
@property (nonatomic, copy) NSString *describle;

//
@property (nonatomic, copy) NSString *downTime;

// 喜欢次数
@property (nonatomic, copy) NSString *loveCount;

// 类型ID
@property (nonatomic, copy) NSString *type;

// 商品名称
@property (nonatomic, copy) NSString *name;

// id
@property (nonatomic, copy) NSString *ID;

// 价格
@property (nonatomic, copy) NSString *shopPrice;

// 图片
@property (nonatomic, copy) NSString *appImg;

// 收藏次数
@property (nonatomic, copy) NSString *collectCount;

@end
