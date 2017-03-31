//
//  OrderManagerTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

/**
 按钮点击block

 @param tag     按钮tag值
 */
typedef void(^OrderCellBlock)(NSInteger tag);

@interface OrderManagerTableViewCell : UITableViewCell
<UITextFieldDelegate>

// Button block
@property (copy, nonatomic) OrderCellBlock buttonBlock;

// 输入尾款textfield
@property (weak, nonatomic) IBOutlet UITextField *finalPaymentText;

// 判断是卖家，或买家
@property (assign, nonatomic) BOOL isSeller;

/**
 复原卖家cell初始状态，避免复用时数据混乱
 */
- (void)resumeCellNormalState;

/**
 复原买家cell初始状态
 */
- (void)resumeBuyerCellNormalState;

/**
 刷新cell

 @param goodInfoM cell对应的model
 */
- (void)configureCell:(GoodsInfoModel *)goodInfoM;

@end
