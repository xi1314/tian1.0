//
//  FinalPaymentView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^FinaPayButtonBlock)(NSInteger tag);

@interface FinalPaymentView : UIView

@property (weak, nonatomic) IBOutlet UITextField *priceTextField;   //尾款价格
@property (nonatomic, copy) FinaPayButtonBlock buttonBlock;
+ (instancetype)shareFinalPayInstancetype;
@end
