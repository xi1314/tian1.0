//
//  FinalPaymentView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FinaPayButtonBlock)(NSInteger tag,NSString *price);

@interface FinalPaymentView : UIView

// 点击事件
@property (nonatomic, copy) FinaPayButtonBlock buttonBlock;

// 订金价格
@property (nonatomic, assign) float price;

/**
 加载xib

 @return view
 */
+ (instancetype)shareFinalPayInstancetype;

@end
