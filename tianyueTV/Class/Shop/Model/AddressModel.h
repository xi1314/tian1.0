//
//  AddressModel.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/1.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 地址列表
 */
@interface AddressModel : NSObject

// 地址列表
@property (nonatomic, strong) NSArray *sAddresses_list;

@end



/**
 地址详情
 */
@interface AddressInfoModel : NSObject
// 街道地址
@property (nonatomic, copy) NSString *address;

//姓名
@property (nonatomic, copy) NSString *name;

// 信息ID
@property (nonatomic, copy) NSString *ID;

// 1默认地址 0其他地址
@property (nonatomic, copy) NSString *isDefault;

// 电话
@property (nonatomic, copy) NSString *telephone;

// 省市
@property (nonatomic, copy) NSString *provinceName;

// 邮编
@property (nonatomic, copy) NSString *zipCode;

// 区
@property (nonatomic, copy) NSString *cityName;

// cell高度
@property (nonatomic, assign) float cellHeight;

// 是否是编辑状态
@property (nonatomic, assign) BOOL isEdit;

// cell的索引
@property (nonatomic, assign) int index;

@end
