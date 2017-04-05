//
//  AddressTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

typedef void(^AddressCellBlock)(NSInteger tag);

static NSString *normalCellIdentifier = @"kNormalCellIdentifier";
static NSString *editCellIdentifier = @"kEditCellIdentifier";

@interface AddressTableViewCell : UITableViewCell

// cell model
@property (nonatomic, strong) AddressInfoModel *addressModel;

// Button点击事件
@property (nonatomic, copy) AddressCellBlock cellBlock;

/**
 刷新cell
 
 @param addressModel cell对应的model
 */
- (void)configCellWithModel:(AddressInfoModel *)addressModel;

/**
 刷新edit cell
 
 @param addressModel 对应的model
 */
- (void)configEditCellWithModel:(AddressInfoModel *)addressModel;


@end
