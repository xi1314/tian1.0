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
@property (copy, nonatomic) OrderButtonBlock buttonBlock;
@property (weak, nonatomic) IBOutlet UILabel *price;

+ (instancetype)sharePayOrderInstancetype;
@end
