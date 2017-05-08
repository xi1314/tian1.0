//
//  LivingLandscapeGiftView.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "LivingLandscapeGiftView.h"

@interface LivingLandscapeGiftView ()


@end

@implementation LivingLandscapeGiftView


+ (instancetype)shareGiftViewInstancetype {
    return [[NSBundle mainBundle] loadNibNamed:@"LivingLandscapeGiftView" owner:nil options:nil].firstObject;
}


- (IBAction)tap_action:(UITapGestureRecognizer *)sender {
    NSInteger index = sender.view.tag - 101;
    if (self.block) {
        self.block(index);
    }
}

- (IBAction)chargeButton_action:(UIButton *)sender {
    if (self.block) {
        self.block(sender.tag - 101);
    }
}

@end
