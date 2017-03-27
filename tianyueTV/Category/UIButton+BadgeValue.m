//
//  UIButton+BadgeValue.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/24.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "UIButton+BadgeValue.h"

NSUInteger const badgeViewTag = 10240;

@implementation UIButton (BadgeValue)
/**
 设置右上角的badge，调用该方法前需要先设置Button title
 
 @param badgeValue badge显示的数字
 @param color      数字的颜色，默认为白色
 */
- (void)setBadgeValue:(NSString *)badgeValue
        withTextColor:(UIColor *)color;
{
    if (!badgeValue || badgeValue.length == 0) { NSLog(@"badgeValue is nil"); return; }
    
    if (!color) { color = [UIColor redColor]; }
    
    if ([badgeValue integerValue] > 99) { badgeValue = @"99+"; }
    
    //计算title的长度
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake(100, 21) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    //计算badgelabel的center
    CGPoint rightTopInsidePoint = CGPointMake(CGRectGetWidth(self.frame) - (CGRectGetWidth(self.frame) * 0.5 - titleSize.width * 0.5) + 2, CGRectGetHeight(self.frame) * 0.5 - titleSize.height * 0.5 + 2);
    
    UILabel *badValueLabel = [[UILabel alloc]init];
    [badValueLabel setTag:badgeViewTag];
    [badValueLabel setTextAlignment:NSTextAlignmentCenter];
    [badValueLabel setTextColor:color];
    [badValueLabel setText:badgeValue];
    [self setSubFrameWithBadge:badValueLabel];
    [badValueLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [badValueLabel setCenter:rightTopInsidePoint];
    /**
     *  处理成圆形
     */
    badValueLabel.layer.masksToBounds = YES;
    badValueLabel.layer.cornerRadius = badValueLabel.frame.size.height / 2;
    badValueLabel.layer.borderWidth = 1;
    badValueLabel.layer.borderColor = color.CGColor;
    
    [self addSubview:badValueLabel];
    [self sendSubviewToBack:self.titleLabel];
}


/**
 计算badgeLabel大小
 
 @param badgeLab badgeLabel
 */
-(void)setSubFrameWithBadge:(UILabel *)badgeLab {
    CGFloat badgeH;
    CGFloat badgeW;
    
    badgeH = 15;
    badgeW = [badgeLab sizeThatFits:CGSizeMake(MAXFLOAT, badgeH)].width;
    if (badgeW > 40) {
        badgeW = 40;
    }
    if (badgeW < badgeH) {
        badgeW = badgeH;
    }
    badgeLab.frame = CGRectMake(0, 0, badgeW, badgeH);
    badgeLab.layer.cornerRadius = badgeH / 2;
}


/**
 移除badgeLabel
 */
- (void)removeBadge;
{
    id badgeView = nil;
    if ([self.layer masksToBounds])
    {
        badgeView = [self.superview viewWithTag:badgeViewTag];
    }
    else
    {
        badgeView = [self viewWithTag:badgeViewTag];
    }
    
    if (badgeView) { [badgeView removeFromSuperview]; }
}
@end
