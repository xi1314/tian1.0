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

// 默认地址（edit）
@property (weak, nonatomic) IBOutlet UIButton *defaultButton;

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
    self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", self.addressModel.provinceName,self.addressModel.cityName,self.addressModel.area,self.addressModel.address];
    if ([self.addressModel.isDefault isEqualToString:@"1"]) {
        NSString *string = [NSString stringWithFormat:@"[默认地址]%@%@%@%@", self.addressModel.provinceName,self.addressModel.cityName,self.addressModel.area,self.addressModel.address];
        [self changeStringColor:string];
    }
}

/**
 刷新edit cell

 @param addressModel 对应的model
 */
- (void)configEditCellWithModel:(AddressInfoModel *)addressModel {
    self.addressModel = addressModel;
    self.name_edit.text = self.addressModel.name;
    self.phone_edit.text = self.addressModel.telephone;

    self.address_edit.text = [NSString stringWithFormat:@"%@%@%@%@", self.addressModel.provinceName,self.addressModel.cityName,self.addressModel.area,self.addressModel.address];

    if ([self.addressModel.isDefault isEqualToString:@"1"]) {
        self.defaultButton.selected = YES;
    } else {
        self.defaultButton.selected = NO;
    }
}

#pragma mark - Button method
- (IBAction)cellButtons_action:(UIButton *)sender {
    if (self.cellBlock) {
        self.cellBlock(sender.tag - 100,self.addressModel);
    }
}

#pragma mark - Pravite method
/**
 改变字符串颜色
 
 @param string 需要改变的字符串
 */
- (void)changeStringColor:(NSString *)string {
    if (![string containsString:@"[默认地址]"]) {
        return;
    }
    // 创建对象.
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(0, 6);
    [mAttStri addAttribute:NSForegroundColorAttributeName value:WWColor(255, 207, 113) range:range];
    self.addressLabel.attributedText = mAttStri;
    self.address_edit.attributedText = mAttStri;
}


@end
