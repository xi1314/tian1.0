//
//  PayResultViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayResultViewController : UIViewController

// 支付是否成功
@property (nonatomic, assign) BOOL success;

// 订单金额
@property (nonatomic, copy) NSString *price;


@end
