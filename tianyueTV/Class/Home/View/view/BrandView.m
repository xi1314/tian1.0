//
//  BrandView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/20.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BrandView.h"

@implementation BrandView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeInterface];
    }
    return self;
}

- (void)initializeInterface {
    CGFloat height = self.height - 10;
    CGFloat gap = (SCREEN_WIDTH - height * 5) / 6;
    
    for (int i = 0; i < 10; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(gap + (height + gap) * i, 5, height, height);
        if (i > 4) {
            button.frame = CGRectMake(gap * 2 + (height + gap) * i, 5, height, height);
        }
        button.layer.cornerRadius = height/2;
        button.backgroundColor = [UIColor whiteColor];
        [self addSubview:button];
    }
}

@end
