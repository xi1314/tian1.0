

//
//  FinalPaymentView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "FinalPaymentView.h"

@interface FinalPaymentView ()

// 尾款输入框
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

// 提示语
@property (weak, nonatomic) IBOutlet UILabel *remaindLabel;

@end

@implementation FinalPaymentView

+ (instancetype)shareFinalPayInstancetype {
    return [[[NSBundle mainBundle] loadNibNamed:@"FinalPaymentView" owner:self options:nil] objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.remaindLabel.hidden = YES;
    [self.priceTextField addTarget:self action:@selector(respondsToTextFeild:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark -- Button method
- (IBAction)payButton_action:(UIButton *)sender {
    if (self.buttonBlock) {
        if (sender.tag == 240) {
            self.buttonBlock(sender.tag - 240,nil);
        }
        if (sender.tag == 241) { // 确认
            if (!self.remaindLabel.hidden) {
                return;
            }
            self.buttonBlock(sender.tag - 240,self.priceTextField.text);
        }
        self.priceTextField.text = nil;
        self.remaindLabel.hidden = YES;
    }
}

- (void)respondsToTextFeild:(UITextField *)textFeild {
    float inputPrice = [textFeild.text floatValue];
    if (inputPrice > self.price) {
        self.remaindLabel.hidden = NO;
        self.remaindLabel.text = @"*尾款价格不能超出订金价格";
    } else if (inputPrice == 0) {
        self.remaindLabel.hidden = NO;
        self.remaindLabel.text = @"*尾款价格不能为0";
    } else {
        self.remaindLabel.hidden = YES;
    }
}

@end
