//
//  AddressTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

static NSString *normalCellIdentifier = @"kNormalCellIdentifier";
static NSString *editCellIdentifier = @"kEditCellIdentifier";

@interface AddressTableViewCell : UITableViewCell

// cell model
@property (nonatomic, strong) AddressInfoModel *addressModel;

- (void)configCellWithModel:(AddressInfoModel *)addressModel;

@end
