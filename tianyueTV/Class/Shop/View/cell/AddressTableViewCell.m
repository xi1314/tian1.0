//
//  AddressTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell ()

// 姓名
@property (weak, nonatomic) IBOutlet UILabel *name;

// 电话
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

// 地址
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

// 姓名（edit）
@property (weak, nonatomic) IBOutlet UILabel *name_edit;

// 电话（edit）
@property (weak, nonatomic) IBOutlet UILabel *phone_edit;

// 地址（edit）
@property (weak, nonatomic) IBOutlet UILabel *address_edit;


@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

/**
 刷新cell

 @param addressModel cell对应的model
 */
- (void)configCellWithModel:(AddressInfoModel *)addressModel {
    self.addressModel = addressModel;
    self.name.text = self.addressModel.name;
    self.phoneLabel.text = self.addressModel.telephone;
    self.addressLabel.text = self.addressModel.address;
}

/**
 刷新edit cell

 @param addressModel 对应的model
 */
- (void)configEditCellWithModel:(AddressInfoModel *)addressModel {
    self.addressModel = addressModel;
    self.name_edit.text = self.addressModel.name;
    self.phone_edit.text = self.addressModel.telephone;
    self.address_edit.text = self.addressModel.address;
}

#pragma mark -- Button method
- (IBAction)cellButtons_action:(UIButton *)sender {
    NSLog(@"%ld",sender.tag);
    if (self.cellBlock) {
        self.cellBlock(sender.tag - 100);
    }
}


@end
