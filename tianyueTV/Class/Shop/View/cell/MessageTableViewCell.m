//
//  MessageTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "MessageTableViewCell.h"

@implementation MessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
//    self.layer.cornerRadius
//    self.layer.masksToBounds
}

#pragma mark -- Setter method
- (void)setCellModel:(MessageModel *)cellModel {
    _cellModel = cellModel;
    [self.userHeadImg sd_setImageWithURL:[NSURL URLWithString:_cellModel.headImageStr]];
    self.messageLabel.text = _cellModel.message;
    self.standardLabel.text = _cellModel.standard;
    self.sizeLabel.text = _cellModel.size;
    
    self.imageArr = _cellModel.imgArr;
    for (int i = 0; i < self.imageArr.count; i++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:105+i];
        imageView.hidden = NO;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageArr[i]]];
    }
}

@end
