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


@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate> {
    CGFloat _payMoney;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
//footerview使用的属性
@property (strong, nonatomic) UILabel *countLabel;          //数量
@property (strong, nonatomic) UILabel *footerPrice;         //合计
@property (strong, nonatomic) UITextView *messageText;      //用户留言
@property (strong, nonatomic) UILabel *placeLabel;          //占位label
@property (strong, nonatomic) UILabel *labelCount;          //label计数

@property (weak, nonatomic) IBOutlet UILabel *userName;     //收货姓名
@property (weak, nonatomic) IBOutlet UILabel *userPhone;    //电话
@property (weak, nonatomic) IBOutlet UILabel *postalCode;   //邮编
@property (weak, nonatomic) IBOutlet UILabel *address;      //地址
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;   //总合计

@property (strong, nonatomic) PayOrderView *payView;

//@property (strong, nonatomic) UIView *maskView;

@end

@implementation OrderViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizaDataSource];
    [self initilizeUserInterface];
    NSLog(@"--- %@",self.dataArr);
//    [self.view addSubview:self.payView];
    [self payOrderButtons];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden =NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}


#pragma mark -- Init method
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
            self.totalPrice.text = [NSString stringWithFormat:@"¥%.2f",(_payMoney+22.0)];
            self.countLabel.text = [NSString stringWithFormat:@"共计%ld件商品  合计：",totalCount];
            self.payView.price.text = [NSString stringWithFormat:@"%.2f元",(_payMoney+22.0)];
        }
    }
}

- (void)initilizeUserInterface {
    //隐藏导航栏底部线条，有可能影响其他界面，需注意
    [self useMethodToFindBlackLineAndHind];
//    self.navigationController.navigationBar.barTintColor = WWColor(248, 248, 248);
//    self.navigationController.navigationBar.tintColor = WWColor(51, 51, 51);
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WWColor(51, 51, 51),NSFontAttributeName:[UIFont systemFontOfSize:18]};
//    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBackItem:)];
//    self.navigationItem.leftBarButtonItem = backItem;
    
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
    
    //隐藏支付view
//    self.payView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 365);
}


#pragma mark -- Private method
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


#pragma mark -- Tap method
- (IBAction)topViewTop_action:(UITapGestureRecognizer *)sender {
//    WaitingOrderViewController *orderVC = [[WaitingOrderViewController alloc] init];
//    [self.navigationController pushViewController:orderVC animated:YES];
    
    AddressManageViewController *addressVC = [[AddressManageViewController alloc] init];
    [self.navigationController pushViewController:addressVC animated:YES];
}

#pragma mark -- Button method
//返回
//- (void)respondsToBackItem:(UIBarButtonItem *)sender {
//    self.navigationController.navigationBar.hidden =YES;
//    [self.navigationController popViewControllerAnimated:YES];
//}

- (void)respondsToBaseViewBackItem {
    self.navigationController.navigationBar.hidden =YES;
    [self.navigationController popViewControllerAnimated:YES];
}

//提交订单
- (IBAction)commitButton_action:(UIButton *)sender {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.payView];
    [UIView animateWithDuration:0.3 animations:^{
        self.payView.frame = CGRectMake(0, SCREEN_HEIGHT-365, SCREEN_WIDTH, 365);
    }];
}


//支付弹窗button
- (void)payOrderButtons {
    __weak typeof(self)weakSelf = self;
    self.payView.buttonBlock = ^(NSInteger tag){
        switch (tag) {
            case 0:{//关闭
                [weakSelf hiddenBaseMaskView];
                WaitingOrderViewController *waitingVC = [[WaitingOrderViewController alloc] init];
                waitingVC.dataArr = [weakSelf.dataArr mutableCopy];
                [weakSelf.navigationController pushViewController:waitingVC animated:YES];
            } break;
                
            case 1:{//选择支付方式
                
            } break;
                
            case 2:{//确认支付
                [weakSelf requestForOrderPay];
            } break;
                
            default:
                break;
        }
    };
}

#pragma mark -- Newworking request
- (void)requestForOrderPay {
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",_payMoney];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_ID,@"userId",self.dataArr[0][@"goodsAndNum"],@"goodsAndNum",moneyStr,@"payMoney",@"112",@"addressId",@"test",@"messagedds", nil];
    NSLog(@"%@",dic);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"toPay_app" paraments:dic finish:^(id responseObject, NSError *error) {
        NSLog(@"%@",error);
        NSLog(@"%@",responseObject);
    }];
}


#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArr.count) {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:orderCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.dataDic = self.dataArr[indexPath.row];
        return cell;
    }
    if (indexPath.row == self.dataArr.count) {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:expressCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] objectAtIndex:1];
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
    
    [self.footerPrice autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:view withOffset:-10];
    [self.footerPrice autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    
    [self.countLabel autoPinEdge:ALEdgeTrailing toEdge:ALEdgeLeading ofView:self.footerPrice];
    [self.countLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.footerPrice];
    
    [self.messageText autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.footerPrice withOffset:10];
    [self.messageText autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10];
    [self.messageText autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:10];
    [self.messageText autoSetDimension:ALDimensionHeight toSize:120];
    
    [self.placeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.messageText];
    [self.placeLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:self.messageText];
    
    [self.labelCount autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.messageText withOffset:-5];
    [self.labelCount autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:self.messageText withOffset:-5];
    
    
    return view;
}

#pragma mark -- UITextViewDelegate
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

#pragma mark -- Getter method
- (UILabel *)footerPrice {
    if (!_footerPrice) {
        _footerPrice = [[UILabel alloc] init];
        _footerPrice.textColor = THEME_COLOR;
        _footerPrice.text = @"¥20";
        [_footerPrice sizeToFit];
        _footerPrice.textAlignment = NSTextAlignmentRight;
        _footerPrice.font = [UIFont systemFontOfSize:18];
    }
    return _footerPrice;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:14];
        [_countLabel sizeToFit];
        _countLabel.text = @"共1件商品  合计：";
    }
    return _countLabel;
}

//- (UIView *)maskView {
//    if (!_maskView) {
//        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//        _maskView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
//    }
//    return _maskView;
//}

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
