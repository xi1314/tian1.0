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

}

/**
 刷新cell

 @param model 地址model
 */
- (void)configCellWithModel:(MessageModel *)model {
    [self.userHeadImg setImageURL:[NSURL URLWithString:model.headUrl]];
    self.messageLabel.text = model.content;
    
    NSArray *attr = [model.goodsAttr componentsSeparatedByString:@","];
    NSArray *attr1 = [attr[0] componentsSeparatedByString:@";"];
    NSArray *attr2 = [attr[1] componentsSeparatedByString:@";"];
    self.standardLabel.text = [NSString stringWithFormat:@"%@:%@",attr1[0],attr1[1]];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@:%@",attr2[0],attr2[1]];
    
    self.imageArr = [model.goodsImg componentsSeparatedByString:@","];
    for (int i = 0; i < self.imageArr.count; i++) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:105+i];
        imageView.hidden = NO;
        [imageView setImageURL:[NSURL URLWithString:self.imageArr[i]]];
    }
}


@end
