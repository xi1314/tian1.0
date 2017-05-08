//
//  ChatImageTableViewCell.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "ChatImageTableViewCell.h"

@interface ChatImageTableViewCell ()

@property (nonatomic, strong) UILabel *lab_user;
@property (nonatomic, strong) UIImageView *imgV_gift;
@property (nonatomic, strong) UILabel *lab_giftNum;

@end

@implementation ChatImageTableViewCell

- (UILabel *)lab_user
{
    if (!_lab_user) {
        _lab_user = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 40)];
        _lab_user.backgroundColor = [UIColor clearColor];
        
    }
    return _lab_user;
}

- (UIImageView *)imgV_gift
{
    if (!_imgV_gift) {
        _imgV_gift = [[UIImageView alloc] initWithFrame:CGRectMake(0, 2, 36, 36)];
        _imgV_gift.backgroundColor = [UIColor clearColor];
        _imgV_gift.contentMode = UIViewContentModeScaleToFill;
        
    }
    return _imgV_gift;
}

- (UILabel *)lab_giftNum
{
    if (!_lab_giftNum) {
        _lab_giftNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        _lab_giftNum.backgroundColor = [UIColor clearColor];
        _lab_giftNum.font = [UIFont systemFontOfSize:14.0f];
        _lab_giftNum.textColor = [UIColor blackColor];
        _lab_giftNum.text = @"x 1";
    }
    return _lab_giftNum;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.lab_user];
        [self.contentView addSubview:self.imgV_gift];
        [self.contentView addSubview:self.lab_giftNum];
        
    }
    return self;
}


// 刷新子视图
- (void)configureCell:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@","];
    NSString *userString = [NSString stringWithFormat:@"%@ 赠送", array[0]];
    NSRange allRange = [userString rangeOfString:userString];
    
    NSMutableParagraphStyle *tempParagraph = [[NSMutableParagraphStyle alloc] init];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:userString];
    [attrStr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                             NSForegroundColorAttributeName : WWColor(255, 127, 0),
                             NSParagraphStyleAttributeName : tempParagraph}
                     range:allRange];
    CGRect rect = [attrStr boundingRectWithSize:CGSizeMake(200, 40) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    _lab_user.frame = CGRectMake(15, 0, rect.size.width, 40);
    _lab_user.attributedText = attrStr;

    self.imgV_gift.image = [UIImage imageNamed:array[1]];
    self.imgV_gift.frame = CGRectMake(_lab_user.right + 10, 2, 36, 36);
    
    self.lab_giftNum.frame = CGRectMake(_imgV_gift.right + 5, 0, 40, 40);
    
}


@end


