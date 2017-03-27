//
//  ShopDetailView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/2.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "ShopDetailView.h"

@interface ShopDetailView ()<UIScrollViewDelegate>


@end

@implementation ShopDetailView

+ (instancetype)shareInstanceType {
    return [[NSBundle mainBundle] loadNibNamed:@"ShopDetailView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productScrollView.clipsToBounds = NO;
    self.productScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2, self.productScrollView.frame.size.height);
    self.productScrollView.delegate = self;
    self.productScrollView.autoresizesSubviews = NO;

    
    self.joinCarButton.layer.borderWidth = 0.5f;
    self.joinCarButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark -- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.productScrollView.contentOffset.x >= SCREEN_WIDTH ) {
        self.leftButton.selected = NO;
        self.rightButton.selected = YES;
    } else if (self.productScrollView.contentOffset.x <= SCREEN_WIDTH ) {
        self.leftButton.selected = YES;
        self.rightButton.selected = NO;
    }
}

#pragma mark -- Button method
- (IBAction)leftButton_action:(UIButton *)sender {
    if (!sender.selected) {
        [self.productScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}

- (IBAction)rightButton_action:(UIButton *)sender {
    if (!sender.selected) {
        [self.productScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    }
}

- (IBAction)shopButton_action:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag - 200);
    }
}

@end
