//
//  WWBiaoqiaoTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/30.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWBiaoqiaoTableViewCell.h"
@interface WWBiaoqiaoTableViewCell()

@end

@implementation WWBiaoqiaoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self addLayout];
    }
    
    return self;
}


- (void)addLayout{
    [self.contentView addSubview:self.biaoqianButton];
    [self.biaoqianButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(15)];
    [self.biaoqianButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kWidthChange(22)];
    [self.biaoqianButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kWidthChange(22)];
    
//        [self.biaoqianButton autoSetDimension:ALDimensionWidth toSize:kWidthChange(200)];
    
    [self.contentView addSubview:self.deleteButton];
    [self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(15)];
    [self.deleteButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.deleteButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(35), kWidthChange(35))];
    
    [self.contentView addSubview:self.changeButton];
    [self.changeButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.changeButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(40), kWidthChange(40))];
    [self.changeButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.deleteButton withOffset:kWidthChange(-64)];
}

- (void)respondsToDeleteClicked:(UIButton *)sender{
    if (self.DeleteHandler) {
        self.DeleteHandler(sender.tag);
    }
}

- (void)respondsTochangeClicked:(UIButton *)sender{
    if (self.ChangeHandler) {
        self.ChangeHandler(sender.tag);
    }
}

- (UIButton *)changeButton{
    if (!_changeButton) {
        _changeButton = [[UIButton alloc] init];
        [_changeButton setBackgroundImage:[UIImage imageNamed:@"修改-拷贝-2"] forState:UIControlStateNormal];
        [_changeButton addTarget:self action:@selector(respondsTochangeClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeButton;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"叉-(1)-1"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(respondsToDeleteClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}

- (UIButton *)biaoqianButton{
    if (!_biaoqianButton) {
        _biaoqianButton = [[UIButton alloc] init];
        _biaoqianButton.backgroundColor = WWColor(229, 110, 6);
        _biaoqianButton.layer.cornerRadius = kWidthChange(10);
        //        _biaoqianButton.textColor = [UIColor whiteColor];
        //        _biaoqianButton.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _biaoqianButton.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _biaoqianButton.translatesAutoresizingMaskIntoConstraints =NO;
        _biaoqianButton.layer.masksToBounds = YES;
    }
    return _biaoqianButton;
}


@end
