//
//  MineThirdTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/31.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "MineThirdTableViewCell.h"

@implementation MineThirdTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self initializeUserInterface];
    self.backgroundColor = WWColor(246, 244, 244);
    
    return self;
}

- (void)initializeUserInterface{
    [self addSubview:self.typeButtons];
    [self.typeButtons autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(10)];
    [self.typeButtons autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(30)];
    [self.typeButtons autoSetDimensionsToSize:CGSizeMake(75, 35)];
    
}


- (UIButton *)buttons{
    if (!_buttons) {
        _buttons = [[UIButton alloc] init];
        _buttons.layer.borderWidth = kWidthChange(2);
        _buttons.layer.borderColor = WWColor(208, 206, 206).CGColor;
        _buttons.backgroundColor = WWColor(246, 244, 244);
        [_buttons setTitle:@"木工" forState:UIControlStateNormal];
    }
    return _buttons;
}

//分类按钮
- (UIButton *)typeButtons{
    if (!_typeButtons) {
        _typeButtons = [[UIButton alloc] init];
        [_typeButtons setTitle:@"手工" forState:UIControlStateNormal];
        _typeButtons.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
//        _typeButtons.titleLabel.textColor = [UIColor blackColor];
//        [_typeButtons setTintColor:[UIColor blackColor]];
        [_typeButtons setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }
    return _typeButtons;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
