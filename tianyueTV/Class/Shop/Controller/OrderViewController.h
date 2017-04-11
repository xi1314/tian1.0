//
//  OrderViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AddressModel.h"

@interface OrderViewController : BaseViewController

// 商品数据数组
@property (nonatomic, strong) NSArray *dataArr;

// 默认地址字典
//@property (nonatomic, strong) NSDictionary *addressDic;

// 地址model
@property (nonatomic, strong) AddressInfoModel *addressModel;

@end
