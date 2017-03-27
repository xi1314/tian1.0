

//
//  FinalPaymentView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "FinalPaymentView.h"

@implementation FinalPaymentView


+ (instancetype)shareFinalPayInstancetype {
    return [[[NSBundle mainBundle] loadNibNamed:@"FinalPaymentView" owner:self options:nil] objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

#pragma mark -- Button method
- (IBAction)payButton_action:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag - 240);
    }
}

@end
