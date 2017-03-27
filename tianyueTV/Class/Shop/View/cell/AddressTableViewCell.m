//
//  AddressTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AddressTableViewCell.h"

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
