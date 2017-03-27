//
//  OrderManagerTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 按钮点击block

 @param tag     按钮tag值
 @param section 按钮所在的section
 */
typedef void(^OrderCellBlock)(NSInteger tag,NSInteger section);

@interface OrderManagerTableViewCell : UITableViewCell
<UITextFieldDelegate>

/**
 Button block
 */
@property (copy, nonatomic) OrderCellBlock buttonBlock;

/**
 留言
 */
@property (weak, nonatomic) IBOutlet UITextView *messgeTextView;

/**
 输入尾款textfield
 */
@property (weak, nonatomic) IBOutlet UITextField *finalPaymentText;

/**
 数据字典
 */
@property (strong, nonatomic) NSDictionary *paramDic;

/**
 订单时间
 */
@property (weak, nonatomic) IBOutlet UILabel *orderTime;

/**
 产品图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *orderImgView;

/**
 名称
 */
@property (weak, nonatomic) IBOutlet UILabel *orderTitle;

/**
 规格
 */
@property (weak, nonatomic) IBOutlet UILabel *size;

/**
 颜色
 */
@property (weak, nonatomic) IBOutlet UILabel *color;

/**
 价格x数量
 */
@property (weak, nonatomic) IBOutlet UILabel *priceCount;

/**
 成品、定制标示
 */
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;

/**
 已设置尾款的价格
 */
@property (weak, nonatomic) IBOutlet UILabel *finalPayLabel;

/**
 第一个按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *firstButton;

/**
 第二个按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

/**
 第三个按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;

/**
 cell标识符，判断当前点击cell index
 */
@property (assign, nonatomic) NSInteger sectionTag;

/**
 计算cell高度
 
 @param content 留言内容
 @return cell动态高度值
 */
- (CGFloat)calculateCellHeight:(NSString *)content;

/**
 复原cell初始状态，避免复用时数据混乱
 */
- (void)resumeCellNormalState;

@end
