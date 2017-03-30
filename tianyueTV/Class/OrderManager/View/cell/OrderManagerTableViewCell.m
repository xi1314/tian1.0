//
//  OrderManagerTableViewCell.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "OrderManagerTableViewCell.h"

@interface OrderManagerTableViewCell ()

/**
 留言
 */
@property (weak, nonatomic) IBOutlet UITextView *messgeTextView;

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
 cell对应的model
 */
@property (nonatomic, strong) GoodsInfoModel *goodsModel;

@end

@implementation OrderManagerTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.messgeTextView.layer.borderColor = LINE_COLOR.CGColor;
    self.messgeTextView.layer.borderWidth = 1;
    
    self.firstButton.layer.borderWidth    = 1;
    self.firstButton.layer.borderColor    = LINE_COLOR.CGColor;
    
    self.secondButton.layer.borderWidth   = 1;
    self.secondButton.layer.borderColor   = LINE_COLOR.CGColor;
    
    self.thirdButton.layer.borderWidth    = 1;
    self.thirdButton.layer.borderColor    = LINE_COLOR.CGColor;
    
    UIView *rightView      = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(3, 0, 15, 15)];
    imageView.image        = [UIImage imageNamed:@"view_edit"];
    [rightView addSubview:imageView];
    self.finalPaymentText.rightView     = rightView;
    self.finalPaymentText.rightViewMode = UITextFieldViewModeAlways;
}

/**
 刷新cell
 
 @param goodInfoM cell对应的model
 */
- (void)configureCell:(GoodsInfoModel *)goodInfoM
{
    self.goodsModel = goodInfoM;
    
    // 定制需求
    NSString *string;
    if (goodInfoM.content.length != 0) {
        string = [NSString stringWithFormat:@"定制需求:%@",goodInfoM.content];
    } else {
        string = [NSString stringWithFormat:@"定制需求:无"];
    }
    self.messgeTextView.text = string;
    
    self.orderTitle.text = goodInfoM.goodsName;
    self.priceCount.text = [NSString stringWithFormat:@"¥%@x%@", goodInfoM.goodsPrice, goodInfoM.goodsNum];
    self.orderTime.text  = [NSString stringWithFormat:@"下单时间:%@", goodInfoM.goodsOrder_time];
    [self.orderImgView sd_setImageWithURL:[NSURL URLWithString:goodInfoM.goodsImage] placeholderImage:[UIImage imageNamed:@"big-portfolio-img3"]];
    NSArray *arr = [goodInfoM.goodsAttr componentsSeparatedByString:@","];
    for (int i = 0; i < arr.count; i++) {
        NSArray *arr1 = [arr[i] componentsSeparatedByString:@";"];
        if (i == 0) {
            self.size.text = [NSString stringWithFormat:@"%@：%@",arr1[0],arr1[1]];
        }
        if (i == 1) {
            self.color.text = [NSString stringWithFormat:@"%@：%@",arr1[0],arr1[1]];
        }
    }
    // 成品0、定制1
    if ([goodInfoM.goodsType integerValue] == 0) {
        self.typeImgView.image = [UIImage imageNamed:@"iv_finishProduct"];
    } else if ([goodInfoM.goodsType integerValue] == 1) {
        self.typeImgView.image = [UIImage imageNamed:@"im_dingzhi"];
    }
    if (_isSeller) {
        [self judgeStateWithOrder:[goodInfoM.orderStauts integerValue] shopping:[goodInfoM.shippingStatus integerValue] pay:[goodInfoM.payStatus integerValue]];
    } else {
        [self judgeBuyerStateWithOrder:[goodInfoM.orderStauts integerValue] shopping:[goodInfoM.shippingStatus integerValue] pay:[goodInfoM.payStatus integerValue]];
    }
}


#pragma mark - Private method
/**
 判断尾款部分label状态，和按钮状态(卖家)
 
 @param order    订单状态
 @param shopping 购买状态
 @param pay      支付状态
 */
- (void)judgeStateWithOrder:(NSInteger)order shopping:(NSInteger)shopping pay:(NSInteger)pay {
    if (order == 0 && shopping == 0) { // 代付款、待确认
        if (pay == 0) {
            self.finalPayLabel.text = @"等待买家支付";
            // 按钮状态
            self.thirdButton.selected = YES;
        } else if (pay == 2) {
            // 成品0、定制1
            if ([self.goodsModel.goodsType integerValue] == 0) { // 成品已支付
                self.finalPayLabel.text      = @"已支付全款";
                self.finalPayLabel.textColor = WWColor(69, 69, 69);
                self.secondButton.selected   = YES;
                [self.secondButton setTitle:@"取消订单" forState:UIControlStateNormal];
            } else if ([self.goodsModel.goodsType integerValue] == 1) {
                // 判断尾款订单号
                NSString *orderNo = self.goodsModel.retainageOrderNo;
                if ([self.goodsModel.retainage floatValue] == -1) { // 未设置尾款
                    self.finalPaymentText.hidden = NO;
                    self.finalPayLabel.hidden    = YES;
                } else if([self.goodsModel.retainage floatValue] != -1 && orderNo.length == 0) { // 未支付尾款
//                    self.finalPaymentText.hidden = YES;
//                    self.finalPayLabel.hidden    = NO;
//                    self.finalPayLabel.textColor = THEME_COLOR;
                    NSString *string = [NSString stringWithFormat:@"尾款未支付(¥%@)", self.goodsModel.retainage];
                    [self changeStringColor:string];
                } else if (orderNo.length > 0) { // 尾款已支付
                    self.finalPayLabel.text      = @"已支付全款";
                    self.finalPayLabel.textColor = WWColor(69, 69, 69);
                }
                self.thirdButton.selected = YES;
            }
        }
    } else if (order == 1 && shopping == 0 && pay == 2) { // 待发货
        self.finalPayLabel.text = @"已支付全款";
        self.finalPayLabel.textColor = WWColor(69, 69, 69);
        [self.secondButton setTitle:@"立即发货" forState:UIControlStateNormal];
        [self.thirdButton setTitle:@"延长发货" forState:UIControlStateNormal];
    } else if (order == 1 && shopping == 1 && pay == 2) { // 待收货
        self.finalPayLabel.text      = @"已支付全款";
        self.finalPayLabel.textColor = WWColor(69, 69, 69);
        self.thirdButton.selected    = YES;
        [self.secondButton setTitle:@"查看物流" forState:UIControlStateNormal];
    } else if (order == 1 && shopping == 2 && pay == 2) { // 已完成
        
        if ([self.goodsModel.refoundStatus integerValue] == 4) {
            // 已退款的完成
            self.finalPayLabel.text = @"已退款";
        } else {
            // 交易的完成
            self.finalPayLabel.text = @"交易成功";
            self.finalPayLabel.textColor = WWColor(143, 213, 149);
        }
         
    } else if (order == 2) { // 已取消
        self.finalPayLabel.text     = @"已取消";
        self.secondButton.selected  = YES;
        [self.thirdButton setTitle:@"删除订单" forState:UIControlStateNormal];
    } else if (order == 4) { // 退款
        // 申请纠纷中
        if ([self.goodsModel.order_status_app integerValue] == 8) {
            self.finalPayLabel.text = @"等待工作人员协调";
            self.secondButton.selected = YES;
            self.thirdButton.selected = YES;
        } else {
            self.finalPayLabel.hidden = YES;
            [self.secondButton setTitle:@"同意退款" forState:UIControlStateNormal];
            [self.thirdButton setTitle:@"申请纠纷处理" forState:UIControlStateNormal];
        }
    }
}

/**
 判断尾款部分label状态，和按钮状态(买家)
 
 @param order    订单状态
 @param shopping 购买状态
 @param pay      支付状态
 */
- (void)judgeBuyerStateWithOrder:(NSInteger)order shopping:(NSInteger)shopping pay:(NSInteger)pay {
    
    if (order == 0 && shopping == 0) { // 代付款
        if (pay == 0) { // 未支付
            self.finalPayLabel.text = [NSString stringWithFormat:@"未付款(¥%@)", self.goodsModel.goodsPrice];
            [self.secondButton setTitle:@"取消订单" forState:UIControlStateNormal];
        } else if (pay == 2) { //已支付全款或订金
            // 成品0、定制1
            if ([self.goodsModel.goodsType integerValue] == 0) { // 成品已支付
                self.finalPayLabel.text   = @"已支付全款";
                self.thirdButton.selected = YES;
            } else if ([self.goodsModel.goodsType integerValue] == 1) {
                // 判断尾款订单号
                NSString *orderNo = self.goodsModel.retainageOrderNo;
                if ([self.goodsModel.retainage floatValue] == -1) { // 未设置尾款
                    self.finalPayLabel.text   = @"未设置尾款";
                    self.thirdButton.selected = YES;
                } else if([self.goodsModel.retainage floatValue] != -1 && orderNo.length == 0) { // 未支付尾款
                    self.finalPayLabel.text = [NSString stringWithFormat:@"尾款未支付(¥%@)",self.goodsModel.retainage];
                } else if (orderNo.length > 0) { // 尾款已支付
                    self.finalPayLabel.text = [NSString stringWithFormat:@"已支付尾款(¥%@)",self.goodsModel.retainage];
                    self.thirdButton.selected = YES;
                }
            }
        }
    } else if (order == 1 && shopping == 0 && pay == 2) { // 待发货
        self.finalPayLabel.text = @"已支付全款";
        self.thirdButton.selected = YES;
    }  else if (order == 1 && shopping == 1 && pay == 2) { // 待收货
        self.finalPayLabel.text = @"已支付全款";
        [self.secondButton setTitle:@"查看物流" forState:UIControlStateNormal];
        [self.thirdButton setTitle:@"确认收货" forState:UIControlStateNormal];
    } else if (order == 1 && shopping == 2 && pay == 2) { // 已完成
        if ([self.goodsModel.refoundStatus integerValue] == 4) {
            // 已退款的完成
            self.finalPayLabel.text = @"已退款";
        } else {
            // 交易的完成
            self.finalPayLabel.text = @"交易成功";
            self.finalPayLabel.textColor = WWColor(143, 213, 149);
        }
    } else if (order == 2) { // 已取消
        self.finalPayLabel.text     = @"已取消";
        self.secondButton.selected  = YES;
        [self.thirdButton setTitle:@"删除订单" forState:UIControlStateNormal];
    } else if (order == 4) { // 退款
        // 申请纠纷中
        if ([self.goodsModel.order_status_app integerValue] == 8) {
            self.finalPayLabel.text = @"等待工作人员协调";
            self.secondButton.selected = YES;
            self.thirdButton.selected = YES;
        } else {
            self.finalPayLabel.hidden = YES;
            [self.secondButton setTitle:@"同意退款" forState:UIControlStateNormal];
            [self.thirdButton setTitle:@"申请纠纷处理" forState:UIControlStateNormal];
        }
    }
}

/**
 改变字符串颜色
 
 @param string 需要改变的字符串
 */
- (void)changeStringColor:(NSString *)string {
    // 创建对象.
    NSMutableAttributedString *mAttStri = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range = NSMakeRange(5, string.length-5);
    [mAttStri addAttribute:NSForegroundColorAttributeName value:WWColor(48, 48, 48) range:range];
    self.finalPayLabel.attributedText = mAttStri;
}

/**
 * 恢复卖家cell的默认状态，防止复用时数据混乱
 * 将cell中label的颜色默认为主题红
 * 按钮的选择状态默认为NO
 * 三个按钮的title分别为联系买家、取消订单、删除订单
 */
- (void)resumeCellNormalState {
    self.finalPayLabel.hidden    = NO;
    self.finalPayLabel.textColor = THEME_COLOR;
    self.finalPaymentText.hidden = YES;
    self.firstButton.selected    = NO;
    self.secondButton.selected   = NO;
    self.thirdButton.selected    = NO;
    [self.firstButton setTitle:@"联系买家" forState:UIControlStateNormal];
    [self.secondButton setTitle:@"取消订单" forState:UIControlStateNormal];
    [self.thirdButton setTitle:@"删除订单" forState:UIControlStateNormal];
}

/**
 * 恢复买家cell的默认状态，防止复用时数据混乱
 * 将cell中label的颜色默认为主题红
 * 按钮的选择状态默认为NO
 * 三个按钮的title分别为联系卖家、申请退款、支付尾款
 */
- (void)resumeBuyerCellNormalState {
    self.finalPayLabel.hidden    = NO;
    self.finalPayLabel.textColor = THEME_COLOR;
    self.finalPaymentText.hidden = YES;
    self.firstButton.selected    = NO;
    self.secondButton.selected   = NO;
    self.thirdButton.selected    = NO;
    [self.firstButton setTitle:@"联系卖家" forState:UIControlStateNormal];
    [self.secondButton setTitle:@"申请退款" forState:UIControlStateNormal];
    [self.thirdButton setTitle:@"立即付款" forState:UIControlStateNormal];
}

#pragma mark - Button method
- (IBAction)cellButtons_action:(UIButton *)sender {
    if (self.buttonBlock && !sender.selected) {
        self.buttonBlock(sender.tag - 250);
    }
}

@end
