//
//  WWShopsTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/1/22.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "WWShopsTableViewCell.h"

@implementation WWShopsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
}

@end
