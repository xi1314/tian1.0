//
//  MyItemView.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/3.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "MyItemView.h"

@interface MyItemView ()

@property (nonatomic, strong) UIImageView *imgV_title;
@property (nonatomic, strong) UILabel *lab_title;

@end

@implementation MyItemView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = WWColor(220, 220, 220).CGColor;
        self.backgroundColor = [UIColor whiteColor];
        
        CGFloat topSpace = (frame.size.height - kDeviceWChange(35) - 20)/3.0f;
        
        self.imgV_title = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - kDeviceWChange(35))/2.0f, topSpace, kDeviceWChange(35), kDeviceWChange(35))];
        _imgV_title.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imgV_title];
        
        self.lab_title = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imgV_title.bottom + topSpace, frame.size.width, 20)];
        _lab_title.backgroundColor = [UIColor clearColor];
        _lab_title.font = [UIFont systemFontOfSize:15.0];
        _lab_title.textColor = WWColor(89, 89, 89);
        _lab_title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_lab_title];
        
    }
    return self;
}

- (void)setImageString:(NSString *)image
{
    self.imgV_title.image = [UIImage imageNamed:image];
}

- (void)setTitleString:(NSString *)title;
{
    self.lab_title.text = title;
}

@end
