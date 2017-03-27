//
//  FirstTableViewCell.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/6.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "FirstTableViewCell.h"
#import "UIImage+CustomImage.h"

#import "WWFirstArtisanRecruit.h"

@interface FirstTableViewCell ()
@end
@implementation FirstTableViewCell

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
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addLayout];
    }
    return self;
}
-(UIImageView *)grayLine
{
    if (!_grayLine)
    {
        _grayLine =[[UIImageView alloc]initWithImage:[UIImage createImageWithColor:WWColor(228, 228, 228)]];
        _grayLine.translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:self.grayLine];
    }
    return _grayLine;
}
-(void)addLayout
{    
    [self.grayLine autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.grayLine autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.grayLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.grayLine autoSetDimension:ALDimensionHeight toSize:kHeightChange(10)];
}
@end




















