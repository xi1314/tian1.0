//
//  HoneTianyueCategoryView.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/17.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "HomeTianyueCategoryView.h"


@interface HomeTianyueCategoryView ()

@property (nonatomic, strong) UIButton *liveButton;

@end

@implementation HomeTianyueCategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = NO;
//        [self configeCategoryViewWithModel:nil];
    }
    return self;
}


- (void)configeCategoryViewWithModel:(HomeSelectModel *)model {
    CGFloat width = (SCREEN_WIDTH - 30)/2;
    CGFloat height = self.frame.size.height - 20;
    
    NSArray *labelArr = @[@"天越甄选", @"匠人头条"];
    NSArray *imageName = @[@"home_tianyueSelect", @"home_hotNews"];
    
    for (int i = 0; i < 2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10*(i+1) + width*i, 10, width, height)];
        imageView.layer.cornerRadius = 3;
        imageView.layer.masksToBounds = YES;
        imageView.image = [UIImage imageNamed:imageName[i]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 201 + i;
        [self addSubview:imageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToImageTap:)];
        [imageView addGestureRecognizer:tap];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = labelArr[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        label.centerX = imageView.frame.size.width/2;
        label.centerY = imageView.frame.size.height/2;
        [imageView addSubview:label];
    }
    
    [self addSubview:self.liveButton];
    [self bringSubviewToFront:self.liveButton];
}

- (void)respondsToButton:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag - 200);
    }
}

- (void)respondsToImageTap:(UITapGestureRecognizer *)tap {
    NSInteger tag = tap.view.tag - 200;
    if (self.buttonBlock) {
        self.buttonBlock(tag);
    }
}

#pragma mark - Getter method
- (UIButton *)liveButton {
    if (!_liveButton) {
        CGFloat width = SCREEN_WIDTH * 0.14;
        _liveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _liveButton.frame = CGRectMake(SCREEN_WIDTH - (width + 20), -width/2+5, width, width);
        [_liveButton setImage:[UIImage imageNamed:@"live button"] forState:UIControlStateNormal];
        _liveButton.layer.cornerRadius = width/2;
        _liveButton.layer.masksToBounds = YES;
        _liveButton.tag = 200;
        [_liveButton addTarget:self action:@selector(respondsToButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _liveButton;
}


@end
