//
//  GoodsTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "GoodsTableViewCell.h"

@interface GoodsTableViewCell ()

// 图片
@property (weak, nonatomic) IBOutlet UIImageView *goodImg;

// 名称
@property (weak, nonatomic) IBOutlet UILabel *goodTitle;

// 价格
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;

// 库存
@property (weak, nonatomic) IBOutlet UILabel *goodStock;

@end

@implementation GoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/**
 刷新cell

 @param model 数据模型
 */
- (void)configCellWithModel:(GoodsDetailModel *)model {
    [self.goodImg setImageWithURL:[NSURL URLWithString:model.goodsImage]];
    self.goodTitle.text = model.name;
    self.goodPrice.text = [NSString stringWithFormat:@"¥%@",model.shopPrice];
    self.goodStock.text = [NSString stringWithFormat:@"库存：%@",model.storeNum];
}

@end
