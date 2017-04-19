//
//  OrderViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "WaitingOrderViewController.h"
#import "AddressManageViewController.h"
#import "PayOrderView.h"
#import "ShopHandle.h"

@interface OrderViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate>
{
    CGFloat _payMoney;
}

// 地址view背景
@property (weak, nonatomic) IBOutlet UIView *topView;

// footerview使用的属性
// 数量
@property (strong, nonatomic) UILabel *countLabel;

// 合计
@property (strong, nonatomic) UILabel *footerPrice;

// 用户留言
@property (strong, nonatomic) UITextView *messageText;

// 占位label
@property (strong, nonatomic) UILabel *placeLabel;

// label计数
@property (strong, nonatomic) UILabel *labelCount;

// 收货姓名
@property (weak, nonatomic) IBOutlet UILabel *userName;

// 电话
@property (weak, nonatomic) IBOutlet UILabel *userPhone;

// 邮编
@property (weak, nonatomic) IBOutlet UILabel *postalCode;

// 地址
@property (weak, nonatomic) IBOutlet UILabel *address;

// 总合计
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;

// 支付view
@property (strong, nonatomic) PayOrderView *payView;


@end

@implementation OrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBaseViewBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self initilizaDataSource];
    [self initilizeUserInterface];
    NSLog(@"--- %@",self.dataArr);
    [self payOrderButtons];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =NO;
}

#pragma mark - Init method
- (void)initilizaDataSource {
    _payMoney = 0;
    NSInteger totalCount = 0;
    for (int i = 0; i < _dataArr.count; i++) {
        NSDictionary *dic = _dataArr[i];
        NSInteger count = [dic[@"count"] integerValue];
        CGFloat price = [dic[@"price"] floatValue];
        _payMoney += count * price;
        totalCount += count;
        if (i == _dataArr.count - 1) {
            self.footerPrice.text = [NSString stringWithFormat:@"¥%.2f",_payMoney];
            [self.footerPrice sizeToFit];
            self.totalPrice.text = [NSString stringWithFormat:@"¥%.2f",(_payMoney+22.0)];
            self.countLabel.text = [NSString stringWithFormat:@"共计%ld件商品  合计：",totalCount];
            [self.countLabel sizeToFit];
            
            self.payView.priceString = [NSString stringWithFormat:@"%.2f",(_payMoney+22.0)];
        }
    }
}

- (void)initilizeUserInterface {
    //隐藏导航栏底部线条，有可能影响其他界面，需注意
    [self useMethodToFindBlackLineAndHind];
    
    //设置topview阴影
    self.topView.layer.shadowOpacity = 0.8f;
    self.topView.layer.shadowColor = WWColor(241, 241, 241).CGColor;
    self.title = @"确认订单";
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(-5, -5)];
    
    CGFloat paintingWidth = SCREEN_WIDTH;
    CGFloat paintingHeight = self.topView.bounds.size.height;
    CGFloat shadowWidth = 8;
    //添加直线
    [path addLineToPoint:CGPointMake(-5, -3)];
    [path addLineToPoint:CGPointMake(paintingWidth +5, -3)];
    [path addLineToPoint:CGPointMake(paintingWidth +5, paintingHeight+shadowWidth)];
    [path addLineToPoint:CGPointMake(-5, paintingHeight + shadowWidth)];
    self.topView.layer.shadowPath = path.CGPath;
    
    if (self.addressModel) {
        [self configAddressViewWithModel:self.addressModel];
    }
    
}

#pragma mark - Private method
//当设置navigationBar的背景图片或背景色时，使用该方法都可移除黑线，且不会使translucent属性失效
-(void)useMethodToFindBlackLineAndHind
{
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    //隐藏黑线（在viewWillAppear时隐藏，在viewWillDisappear时显示）
    blackLineImageView.hidden = YES;
}

- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

/**
 设置地址

 @param model 数据模型
 */
- (void)configAddressViewWithModel:(AddressInfoModel *)model {
    self.userName.text = model.name;
    self.userPhone.text = [NSString stringWithFormat:@"%@",model.telephone];
    self.postalCode.text = [NSString stringWithFormat:@"%@",model.zipCode];
    self.address.text = [NSString stringWithFormat:@"%@%@%@%@", model.provinceName, model.cityName, model.area, model.address];
}

#pragma mark - Tap method
- (IBAction)topViewTop_action:(UITapGestureRecognizer *)sender {
    
    AddressManageViewController *addressVC = [[AddressManageViewController alloc] init];
    @weakify(self);
    addressVC.block = ^(AddressInfoModel *model){
        @strongify(self);
        [self configAddressViewWithModel:model];
    };
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark - Button method
- (void)respondsToBaseViewBackItem {
    self.navigationController.navigationBar.hidden =YES;
    [self.navigationController popViewControllerAnimated:YES];
}

//提交订单
- (IBAction)commitButton_action:(UIButton *)sender {
    [self requestForOrderPay];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.payView];
    [UIView animateWithDuration:0.3 animations:^{
        self.payView.frame = CGRectMake(0, SCREEN_HEIGHT-365, SCREEN_WIDTH, 365);
    }];
}


// 支付弹窗button
- (void)payOrderButtons {
    @weakify(self);
    self.payView.buttonBlock = ^(NSInteger tag){
        @strongify(self);
        switch (tag) {
            case 0:{ // 关闭
                WaitingOrderViewController *waitingVC = [[WaitingOrderViewController alloc] init];
                waitingVC.dataArr = [self.dataArr mutableCopy];
                [self.navigationController pushViewController:waitingVC animated:YES];
                [self.baseMaskView removeFromSuperview];
            } break;
                
            case 1:{ // 选择支付方式
                
            } break;
                
            case 2:{ // 确认支付
                [self requestForOrderPay];
            } break;
                
            default:
                break;
        }
    };
}

#pragma mark - Newworking request
- (void)requestForOrderPay {
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",_payMoney];
    
    [ShopHandle requestForOrderWithUser:USER_ID count:self.dataArr[0][@"goodsAndNum"] money:moneyStr addressID:@"112" message:self.messageText.text CompleteBlcok:^(id respondsObject, NSError *error) {
        
        if (respondsObject) {
            [MBProgressHUD showSuccess:@"提交成功"];
        } else {
            [MBProgressHUD showError:@"订单提交失败"];
        }
    }];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArr.count) {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:nil options:nil] objectAtIndex:0];
        }
        cell.dataDic = self.dataArr[indexPath.row];
        return cell;
    }
    if (indexPath.row == self.dataArr.count) {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:expressCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.dataArr.count) {
        return 41;
    } else
        return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 170;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [view addSubview:self.footerPrice];
    [view addSubview:self.countLabel];
    [view addSubview:self.messageText];
    [view addSubview:self.placeLabel];
    [view addSubview:self.labelCount];

    self.footerPrice.right = view.right - 10;
    self.footerPrice.top   = view.top + 10;
    
    self.countLabel.right   = self.footerPrice.left;
    self.countLabel.centerY = self.footerPrice.centerY;
    
    self.messageText.frame = CGRectMake(10, self.footerPrice.bottom + 10, SCREEN_WIDTH - 20, 120);

    self.placeLabel.center = self.messageText.center;
    
    self.labelCount.right  = self.messageText.right - 5;
    self.labelCount.bottom = self.messageText.bottom - 5;

    return view;
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.placeLabel.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.placeLabel.hidden = NO;
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSInteger count = textView.text.length;
    self.labelCount.text = [NSString stringWithFormat:@"%ld/80",count];
    if (count > 80) {
        NSString *string = [textView.text substringToIndex:80-1];
        textView.text = string;
        [MBProgressHUD showError:@"字数超出限制"];
    }
    return YES;
}

#pragma mark - Getter method
- (UILabel *)footerPrice {
    if (!_footerPrice) {
        _footerPrice = [[UILabel alloc] init];
        _footerPrice.textColor = THEME_COLOR;
        _footerPrice.textAlignment = NSTextAlignmentRight;
        _footerPrice.font = [UIFont systemFontOfSize:18];
    }
    return _footerPrice;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:14];
    }
    return _countLabel;
}

- (PayOrderView *)payView {
    if (!_payView) {
        _payView = [PayOrderView sharePayOrderInstancetype];
        _payView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 365);
    }
    return _payView;
}

- (UITextView *)messageText {
    if (!_messageText) {
        _messageText = [[UITextView alloc] init];
        _messageText.layer.borderColor = WWColor(195, 194, 194).CGColor;
        _messageText.layer.borderWidth = 1;
        _messageText.font = [UIFont systemFontOfSize:14];
        _messageText.textColor = WWColor(154, 154, 154);
        _messageText.layer.cornerRadius = 3;
        _messageText.delegate = self;
    }
    return _messageText;
}

- (UILabel *)placeLabel {
    if (!_placeLabel) {
        _placeLabel = [[UILabel alloc] init];
        _placeLabel.textColor = WWColor(195, 194, 194);
        _placeLabel.text = @"请输入您的留言或定制需求";
        _placeLabel.font = [UIFont systemFontOfSize:14];
        [_placeLabel sizeToFit];
    }
    return _placeLabel;
}

- (UILabel *)labelCount {
    if (!_labelCount) {
        _labelCount = [[UILabel alloc] init];
        _labelCount.textColor = WWColor(195, 194, 194);
        _labelCount.text = @"0/80";
        _labelCount.font = [UIFont systemFontOfSize:14];
        [_labelCount sizeToFit];
    }
    return _labelCount;
}


@end
