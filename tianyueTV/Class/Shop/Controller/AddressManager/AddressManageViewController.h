//
//  AddressManageViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

typedef void(^AddressBlock)(AddressInfoModel *addressModel);

@interface AddressManageViewController : UIViewController

// 是否是编辑状态
@property (nonatomic, assign) BOOL isEdit;

// 选择地址后回调
@property (nonatomic, copy) AddressBlock block;

@end
