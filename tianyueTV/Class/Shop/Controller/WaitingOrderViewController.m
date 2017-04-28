//
//  WaitingOrderViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/14.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "WaitingOrderViewController.h"
#import "OrderTableViewCell.h"
#import "PayOrderView.h"
#import "PayResultViewController.h"

@interface WaitingOrderViewController ()
<UITableViewDelegate,
UITableViewDataSource>
{
    NSArray *_titleArr;
    CGFloat _payMoney;   // 商品价格(不含快递)
    CGFloat _postage;    // 邮费
}

// 顶部视图
@property (weak, nonatomic) IBOutlet UIView *topView;

// 列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

// 支付窗口
@property (strong, nonatomic) PayOrderView *payView;

// ---footer view
@property (strong, nonatomic) UILabel *footerPrice;

@end

@implementation WaitingOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBaseViewBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    [self initilizeDatasource];
    [self initilizeUserInterface];
    [self payOrderButtons];
}


#pragma mark - init method
- (void)initilizeDatasource {
    _titleArr = @[@"订单编号",@"支付交易号",@"创建时间"];
    for (int i = 0; i < _dataArr.count; i++) {
        NSDictionary *dic = _dataArr[i];
        NSInteger count = [dic[@"count"] integerValue];
        CGFloat price = [dic[@"price"] floatValue];
        _payMoney += count * price;
        if (i == _dataArr.count - 1) {
            self.footerPrice.text = [NSString stringWithFormat:@"¥%.2f",(_payMoney + _postage)];
            self.payView.priceString = [NSString stringWithFormat:@"¥%.2f",(_payMoney + _postage)];
        }
    }
}

- (void)initilizeUserInterface {
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
    
    self.cancelButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelButton.layer.borderWidth = 1;

}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.dataArr.count + 1;
    }
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
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
    }
    if (indexPath.section == 1) {
        OrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoCellIndentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderTableViewCell" owner:self options:nil] objectAtIndex:2];
        }
        cell.infoType.text = _titleArr[indexPath.row];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == self.dataArr.count) {
            return 41;
        } else
            return 100;
    } else
        return 41;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return CGFLOAT_MIN;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] init];
        label.text = @"实付款（含运费）";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = WWColor(51, 51, 51);
        [view addSubview:label];
        [view addSubview:self.footerPrice];
        
        [label autoPinEdge:ALEdgeLeading toEdge:ALEdgeLeading ofView:view withOffset:10];
        [label autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [self.footerPrice autoPinEdge:ALEdgeTrailing toEdge:ALEdgeTrailing ofView:view withOffset:-10];
        [self.footerPrice autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    header.backgroundColor = WWColor(250, 250, 250);
    return header;
}


#pragma mark - Button method
// 返回
- (void)respondsToBaseViewBackItem {
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

// 取消订单
- (IBAction)cancelOrderButton_action:(UIButton *)sender {
    
}


// 立即支付
- (IBAction)payOrderButton_action:(UIButton *)sender {
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
            case 0:{//关闭
                [self hiddenBaseMaskView];
            } break;
                
            case 1:{//选择支付方式
                
            } break;
                
            case 2:{//确认支付
                [self requestForOrderPay];
            } break;
                
            default:
                break;
        }
    };
}

- (void)hiddenBaseMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.payView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 365);
    } completion:^(BOOL finished) {
        [self.baseMaskView removeFromSuperview];
    }];
}

#pragma mark - Networking request
/**
 支付订单
 */
- (void)requestForOrderPay {
    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",_payMoney];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_ID,@"userId",self.dataArr[0][@"goodsAndNum"],@"goodsAndNum",moneyStr,@"payMoney",@"112",@"addressId",@"test",@"messagedds", nil];
    
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:GET URL:@"toPay_app" paraments:dic finish:^(id responseObject, NSError *error) {
        @strongify(self);
        
        PayResultViewController *resultVC = [[PayResultViewController alloc] init];
        if (responseObject) {
            
        }
        
        NSLog(@"%@",error);
        NSLog(@"%@",responseObject);
    }];
}


#pragma mark - Getter method
- (UILabel *)footerPrice {
    if (!_footerPrice) {
        _footerPrice = [[UILabel alloc] init];
        [_footerPrice sizeToFit];
        _footerPrice.textColor = THEME_COLOR;
        _footerPrice.font = [UIFont systemFontOfSize:14];
        _footerPrice.text = @"¥467.00";
    }
    return _footerPrice;
}

- (PayOrderView *)payView {
    if (!_payView) {
        _payView = [PayOrderView sharePayOrderInstancetype];
        _payView .frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 365);
    }
    return _payView;
}

@end
