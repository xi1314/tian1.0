//
//  ZSCustomTextField.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/11/4.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "ZSCustomTextField.h"

@implementation ZSCustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 重写这个方法是为了使Placeholder居中，如果不写会出现类似于下图中的效果，文字稍微偏上了一些
- (void)drawPlaceholderInRect:(CGRect)rect
{
    [super drawPlaceholderInRect:CGRectMake(kWidthChange(3), self.frame.size.height * 0.5+0.5, 0, 0)];
}
@end
