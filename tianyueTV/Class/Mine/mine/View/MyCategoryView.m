//
//  MyCategoryView.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/3.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "MyCategoryView.h"

@interface MyCategoryView ()

@property (nonatomic, strong) UILabel *lab_num;

@end

@implementation MyCategoryView

- (instancetype)initWithFrame:(CGRect)frame image:(NSString *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imgV_title = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.height)];
        imgV_title.contentMode = UIViewContentModeScaleToFill;
        imgV_title.image = [UIImage imageNamed:image];
        [self addSubview:imgV_title];
        
        UILabel *lab_title = [[UILabel alloc] initWithFrame:CGRectMake(imgV_title.right + 5, 0, 35, frame.size.height)];
        lab_title.backgroundColor = [UIColor clearColor];
        lab_title.font = [UIFont systemFontOfSize:15.0];
        lab_title.textColor = WWColor(89, 89, 89);
        lab_title.text = title;
        [self addSubview:lab_title];
        
        self.lab_num = [[UILabel alloc] initWithFrame:CGRectMake(lab_title.right + 5, 0, 60, frame.size.height)];
        _lab_num.backgroundColor = [UIColor clearColor];
        _lab_num.font = [UIFont systemFontOfSize:15.0];
        _lab_num.textColor = WWColor(209, 0, 0);
        _lab_num.text = @"0";
        [self addSubview:_lab_num];
    }
    return self;
}

- (void)setNum:(NSString *)num
{
    self.lab_num.text = num;
}

@end
