//
//  OrderTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/9.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "OrderTableViewCell.h"

@implementation OrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
//    [self setValuesForKeysWithDictionary:dataDic];
    [self.goodImg sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"img"]]];
    self.goodTitle.text = _dataDic[@"title"];
    self.goodSize.text = _dataDic[@"size"];
    self.goodColor.text = _dataDic[@"color"];
    self.price.text = [NSString stringWithFormat:@"¥%@",_dataDic[@"price"]];
    self.count.text = [NSString stringWithFormat:@"x%@",_dataDic[@"count"]];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
