//
//  WWMineFiveTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/14.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineFiveTableViewCell.h"

@interface WWMineFiveTableViewCell()



@end

@implementation WWMineFiveTableViewCell

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
    [self initializeUserInterface];
    
    return self;
}

- (void)initializeUserInterface{
    [self addSubview:self.mySwitch];
    [self.mySwitch autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(60)];
    [self.mySwitch autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20)];
    [self.mySwitch autoSetDimension:ALDimensionWidth toSize:kWidthChange(80)];
    
    [self addSubview:self.wwtitleLbael];
    [self.wwtitleLbael autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [self.wwtitleLbael autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.wwtitleLbael autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(300)];
    
    [self addSubview:self.rightLabel];
    [self.rightLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(60)];
    [self.rightLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
}

#pragma mark ----懒加载----
- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = @"1.0";
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.textColor = WWColor(184, 184, 184);
        _rightLabel.font = [UIFont systemFontOfSize:14];
    }
    return _rightLabel;
}

- (UILabel *)wwtitleLbael{
    if (!_wwtitleLbael) {
        _wwtitleLbael = [[UILabel alloc] init];
        _wwtitleLbael.text = @"非WIFI环境提醒";
        _wwtitleLbael.font = [UIFont systemFontOfSize:kWidthChange(32)];
        _wwtitleLbael.textColor = WWColor(98, 98, 98);
    }
    return _wwtitleLbael;
}

//开关按钮
- (UISwitch *)mySwitch{
    if (!_mySwitch) {
        _mySwitch = [[UISwitch alloc] init];
        [_mySwitch setOn:YES animated:YES];
        [_mySwitch setTintColor:WWColor(116, 116, 116)];
        [_mySwitch setOnTintColor:WWColor(199, 5, 25)];
        [_mySwitch addTarget:self action:@selector(oneSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
        _mySwitch.transform=CGAffineTransformMakeScale(0.7,0.7);
        _mySwitch.layer.anchorPoint=CGPointMake(0,0.7);
        

    }
    return _mySwitch;
}

#pragma mark ----Action----
- (void)oneSwitchValueChanged:(UISwitch *)sender{
    if (sender.tag == 0) {
        if (sender.on) {
            
           [[NSUserDefaults standardUserDefaults] setObject:@"remind" forKey:@"WIFIwarning"];
        }else{
            [[NSUserDefaults standardUserDefaults] setObject:@"noRemind" forKey:@"WIFIwarning"];
        }
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
}

@end
