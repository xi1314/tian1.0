//
//  AddressTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell ()

//姓名
@property (weak, nonatomic) IBOutlet UILabel *name;

// 电话
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

// 地址
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowColor = WWColor(241, 241, 241).CGColor;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-5, -5)];
    
    CGFloat paintingWidth = SCREEN_WIDTH;
    CGFloat paintingHeight = self.bounds.size.height;
    CGFloat shadowWidth = 8;
    //添加直线
    [path addLineToPoint:CGPointMake(-5, -3)];
    [path addLineToPoint:CGPointMake(paintingWidth +5, -3)];
    [path addLineToPoint:CGPointMake(paintingWidth +5, paintingHeight+shadowWidth)];
    [path addLineToPoint:CGPointMake(-5, paintingHeight + shadowWidth)];
    self.layer.shadowPath = path.CGPath;
    
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


@end
