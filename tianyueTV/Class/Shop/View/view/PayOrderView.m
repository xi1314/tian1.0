//
//  PayOrderView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "PayOrderView.h"

@interface PayOrderView()

/**
 支付价格
 */
@property (weak, nonatomic) IBOutlet UILabel *price;

@end

@implementation PayOrderView

+ (instancetype)sharePayOrderInstancetype {
    NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"PayOrderView" owner:self options:nil];
    return arr.firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
}


- (IBAction)orderButtons_action:(UIButton *)sender {
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag - 220);
    }
}

- (void)setPriceString:(NSString *)priceString {
    _priceString = priceString;
    self.price.text = [NSString stringWithFormat:@"%@元",self.priceString];
}

@end
