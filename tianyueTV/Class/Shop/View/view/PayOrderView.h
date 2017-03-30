//
//  PayOrderView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OrderButtonBlock)(NSInteger tag);

@interface PayOrderView : UIView

/**
 点击事件
 */
@property (copy, nonatomic) OrderButtonBlock buttonBlock;

/**
 支付价格
 */
@property (copy, nonatomic) NSString *priceString;

/**
 加载xib

 @return view
 */
+ (instancetype)sharePayOrderInstancetype;

@end
