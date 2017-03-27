//
//  OrderManagerTableViewCell.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^OrderCellBlock)(NSInteger tag,NSInteger section);
@interface OrderManagerTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (copy, nonatomic) OrderCellBlock buttonBlock;
@property (weak, nonatomic) IBOutlet UITextView *messgeTextView;    //留言
@property (weak, nonatomic) IBOutlet UITextField *finalPaymentText; //设置尾款
@property (strong, nonatomic) NSDictionary *paramDic;               //传值字典

@property (weak, nonatomic) IBOutlet UILabel *orderTime;            //下单时间
@property (weak, nonatomic) IBOutlet UIImageView *orderImgView;     //图片
@property (weak, nonatomic) IBOutlet UILabel *orderTitle;           //名称
@property (weak, nonatomic) IBOutlet UILabel *size;                 //规格
@property (weak, nonatomic) IBOutlet UILabel *color;                //颜色
@property (weak, nonatomic) IBOutlet UILabel *priceCount;           //价格数量
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;      //标示图
@property (weak, nonatomic) IBOutlet UILabel *finalPayLabel;        //尾款价格
@property (weak, nonatomic) IBOutlet UIButton *firstButton;         //第一个按钮
@property (weak, nonatomic) IBOutlet UIButton *secondButton;        //第二个按钮
@property (weak, nonatomic) IBOutlet UIButton *thirdButton;         //第三个按钮
@property (assign, nonatomic) NSInteger sectionTag;                 //判断是哪一个cell
- (CGFloat)calculateCellHeight:(NSString *)content;                 //计算cell高度
- (void)resumeCellNormalState;
@end
