//
//  BasicButton.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/6.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "BasicButton.h"

@implementation BasicButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        [self setTitleColor:[UIColor blackColor ] forState:UIControlStateNormal];
        self.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        self.translatesAutoresizingMaskIntoConstraints=NO;
    }
    return self;
}
@end
