//
//  PayOrderView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "PayOrderView.h"

@implementation PayOrderView

+ (instancetype)sharePayOrderInstancetype {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PayOrderView" owner:self options:nil];
    return arr.firstObject;
}


- (IBAction)orderButtons_action:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag - 220);
    }
}

@end
