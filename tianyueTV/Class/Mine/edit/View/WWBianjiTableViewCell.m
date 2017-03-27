//
//  WWBianjiTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/21.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWBianjiTableViewCell.h"

@interface WWBianjiTableViewCell()




@end
@implementation WWBianjiTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
        self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
        [self initializeUserInterface];
        return self;
}
    
- (void)initializeUserInterface{
    [self addSubview:self.leftLabel];
    [self.leftLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(10)];
    [self.leftLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.leftLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(250)];
    
    [self addSubview:self.rightLabel];
    [self.rightLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(15)];
    [self.rightLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.leftLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(250)];
    
    
}

#pragma mark ----Getters----
- (UILabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.text = @"未认证";
        _rightLabel.textColor = WWColor(162, 162, 162);
        _rightLabel.textAlignment = NSTextAlignmentRight;
        _rightLabel.font = [UIFont systemFontOfSize:kWidthChange(26)];
        
    }
    return _rightLabel;
}

- (UILabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.text = @"实名认证";
        _leftLabel.textColor = [UIColor blackColor];
        _leftLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
    }
    return _leftLabel;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}






@end
