//
//  OrderManagerViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "OrderManagerViewController.h"
#import "OrderManagerTableViewCell.h"
#import "FinalPaymentView.h"
#import "DeliveryView.h"
#import "DZAlertView.h"
#import "UIButton+BadgeValue.h"
#import "OrderHandle.h"
#import "OrderModel.h"

@interface OrderManagerViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate>

{
//    NSInteger _indexPage;                      // 页码
    UIButton *_nowButton;                      // 当前选择按钮（顶部）
    OrderManagerTableViewCell *_selectedCell;  // 选择的cell
}

/**
 列表
 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**
 支付弹窗
 */
@property (strong, nonatomic) FinalPaymentView *paymentView;

/**
 计算高度对象
 */
@property (strong, nonatomic) OrderManagerTableViewCell *orderCell;

/**
 自定义提示框
 */
@property (strong, nonatomic) DZAlertView *alertView;

/**
 设置物流弹框
 */
@property (strong, nonatomic) DeliveryView *deliveryView;

/**
 存储当前请求参数
 */
@property (strong, nonatomic) NSDictionary *nowRequestDic;

/**
 数据数组
 */
@property (strong, nonatomic) NSMutableArray *datasource;

/**
 记录上次请求的订单状态
 */
@property (assign, nonatomic) NSInteger orderState;

/**
 记录上一次的购买状态
 */
@property (assign, nonatomic) NSInteger shoppingState;

/**
 记录上一次的支付状态
 */
@property (assign, nonatomic) NSInteger payState;

/**
 页码
 */
@property (assign, nonatomic) NSInteger indexPage;

@end

@implementation OrderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _indexPage = 1;
    _nowButton = (UIButton *)[self.view viewWithTag:230];
    [self initilizeDatasource];
    [self initilizeUserInterface];
    [self requestForPayButton];
    self.orderCell = [[[NSBundle mainBundle] loadNibNamed:@"OrderManagerTableViewCell" owner:self options:nil] objectAtIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

#pragma mark - init method
- (void)initilizeDatasource {
    [MBProgressHUD showMessage:@"加载中"];
    _datasource = [NSMutableArray array];
    if (_isSeller) {
        [self requestForDatasource];
    } else {
        [self requestForPersonalData];
    }
    
    for (int i = 0; i < 8; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:230+i];
        [button addTarget:self action:@selector(respondsToStatuButtons:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)initilizeUserInterface {
    if (_isSeller) { self.title = @"收到订单"; }
    else { self.title = @"我的订单"; }
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.indexPage += 1;
        if (_isSeller) {
            if (_nowButton.tag == 230) {
                [self requestForDatasource]; // 卖家刷新全部订单
            } else {
                [self requestForOrderWithOrder:self.orderState shopping:self.shoppingState pay:self.payState];
//                [self updateOrderData]; // 卖家刷新其他状态订单
            }
        } else {
            if (_nowButton.tag == 230) {
                [self requestForPersonalData]; // 买家刷新全部订单
            } else {
                [self requestForBuyerOrderWithOrder:self.orderState shopping:self.shoppingState pay:self.payState];
//                [self updateBuyerOrderData]; // 买家刷新其他订单状态
            }
        }
        
    }];
}


#pragma mark - Button method
- (void)respondsToBaseViewBackItem {
    self.navigationController.navigationBar.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 顶部状态按钮
 */
- (void)respondsToStatuButtons:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    _indexPage          = 1;
    sender.selected     = YES;
    _nowButton.selected = NO;
    _nowButton          = sender;
    [MBProgressHUD showMessage:@"加载中"];
    switch (sender.tag - 230) {
        case 0: { // 全部订单
            if (_isSeller) {
                
                [self requestForDatasource];
            } else {
                [self requestForPersonalData];
            }
        } break;
            
        case 1: { // 待付款、确认
            if (_isSeller) {
                [self requestForOrderWithOrder:0 shopping:0 pay:0];
            } else {
                [self requestForBuyerOrderWithOrder:0 shopping:0 pay:0];
            }
        } break;
            
        case 2: { // 待发货
            if (_isSeller) {
                [self requestForOrderWithOrder:1 shopping:0 pay:2];
            } else {
                [self requestForBuyerOrderWithOrder:1 shopping:0 pay:2];
            }
        } break;
            
        case 3: { // 待收货
            if (_isSeller) {
                [self requestForOrderWithOrder:1 shopping:1 pay:2];
            } else {
                [self requestForBuyerOrderWithOrder:1 shopping:1 pay:2];
            }
        } break;
            
        case 4: { // 退款
            if (_isSeller) {
                [self requestForOrderWithOrder:4 shopping:0 pay:2];
            } else {
                [self requestForBuyerOrderWithOrder:4 shopping:0 pay:2];
            }
        } break;
            
        default:
            break;
    }
}

/**
 设置尾款弹窗按钮
 */
- (void)requestForPayButton {
    @weakify(self);
    self.paymentView.buttonBlock = ^(NSInteger tag){
        @strongify(self);
        switch (tag) {
            case 0: { // 取消
                [self.baseMaskView removeFromSuperview];
            } break;
                
            case 1: { // 确定
                if (self.paymentView.priceTextField.text.length > 0) {
                    [self requestForFinalPayment];
                }
            } break;
                
            default:
                break;
        }
    };
}

/**
 cell按钮点击事件
 
 @param tag 判断点击哪一个Button 0-2
 @param orderSnModel cell对应的model对象
 */
- (void)cellButtons_action:(NSInteger)tag
                     model:(OrderSnModel *)orderSnModel {
    
    GoodsInfoModel *goodsInfoModel = orderSnModel.goodsList[0];

    UIWindow *window  = [UIApplication sharedApplication].keyWindow;
    NSInteger order   = [goodsInfoModel.orderStauts integerValue];
    NSInteger shop = [goodsInfoModel.shippingStatus integerValue];
    NSInteger pay  = [goodsInfoModel.payStatus integerValue];
    int index = (int)[self.datasource indexOfObject:orderSnModel];
    if (order == 0 && shop == 0) { // 代付款
        if (tag == 1) { // 取消订单
            [window addSubview:self.baseMaskView];
            [self.baseMaskView addSubview:self.alertView];
            @weakify(self);
            [self.alertView initDZAlertViewMessage:@"是否确认取消订单?" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
                @strongify(self);
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
            } rightHandle:^(UIButton *button) {
                @strongify(self);
                
                [self requestForCancelOrder:goodsInfoModel.orderInfoSn index:index];
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
                [MBProgressHUD showMessage:nil];
            }];
        } else if (tag == 2) { // 确认订单，进入待发货
            [window addSubview:self.baseMaskView];
            [self.baseMaskView addSubview:self.alertView];
            @weakify(self);
            [self.alertView initDZAlertViewMessage:@"欣然接货，开始备货" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
                @strongify(self);
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
            } rightHandle:^(UIButton *button) {
                
            }];
        }
    } else if (order == 1 && shop == 0 && pay == 2) { // 待发货
        if (tag == 1) { // 立即发货
            [window addSubview:self.baseMaskView];
            [self.baseMaskView addSubview:self.deliveryView];
            @weakify(self);
            self.deliveryView.buttonBlock = ^(NSInteger tag){
                @strongify(self);
                if (tag == 2) { // 取消
                    [self.deliveryView.companySelect setTitle:@"" forState:UIControlStateNormal];
                    self.deliveryView.deliveryNumber.text = nil;
                    [self.baseMaskView removeAllSubviews];
                    [self.baseMaskView removeFromSuperview];
                } else if (tag == 3) { // 确定
                    [self.baseMaskView removeAllSubviews];
                    [self.baseMaskView removeFromSuperview];
                    [self requestForDeliveryInfoWithOrderID:goodsInfoModel.order_id index:index];
                }
            };
        } else {
            
        }
    } else if (order == 1 && shop == 1 && pay == 2) { // 待收货
        
    } else if (order == 1 && shop == 2 && pay == 2) { // 已完成
        if (tag == 2) {
            [window addSubview:self.baseMaskView];
            [self.baseMaskView addSubview:self.alertView];
            @weakify(self);
            [self.alertView initDZAlertViewMessage:@"订单删除后不可恢复，是否继续" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
                @strongify(self);
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
            } rightHandle:^(UIButton *button) {
                @strongify(self);
                
                [self requstForDeleteOrder:index];
            }];
        }
    } else if (order == 2) { // 已取消
        if (tag == 2) { // 删除订单
            [window addSubview:self.baseMaskView];
            [self.baseMaskView addSubview:self.alertView];
            @weakify(self);
            [self.alertView initDZAlertViewMessage:@"订单删除后不可恢复，是否继续" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
                @strongify(self);
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
            } rightHandle:^(UIButton *button) {
                @strongify(self);
                [self requestForDeleteOrderWithOrderSn:goodsInfoModel.orderInfoSn tomato:@"" index:index];
            }];
        }
    } else if (shop == 4 && pay == 2) { // 退款
        
    }
}


#pragma mark - Private method
- (void)hiddenBaseMaskView {
    [super hiddenBaseMaskView];
    [self.view endEditing:YES];
}

#pragma mark - 卖家网络请求
/**
 全部订单（卖家）
 */
- (void)requestForDatasource {

    @weakify(self);
    [OrderHandle requestForDatasourceWithUser:@"10085" page:_indexPage urlName:api_orderInfo_app completeBlock:^(id respondsObject, NSError *error) {
        
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        
        if (respondsObject) {
            if (_indexPage == 1) {
                self.datasource = [NSMutableArray array];
            }
            
            OrderModel *orderM = (OrderModel *)respondsObject;
    
            if (orderM.orderSnList.count) {
                [self.datasource addObjectsFromArray:orderM.orderSnList];
            }

        }
        
        [self.tableView reloadData];
        
    }];
}

/**
 根据状态请求订单（卖家)

 @param order 订单类型
 @param shopping 购买类型
 @param pay 支付类型
 */
- (void)requestForOrderWithOrder:(NSInteger)order
                        shopping:(NSInteger)shopping
                             pay:(NSInteger)pay
{
    self.orderState = order;
    self.shoppingState = shopping;
    self.payState = pay;
    
    @weakify(self);
    [OrderHandle requestForOrderWithOrder:order shopping:shopping pay:pay userID:@"10085" page:_indexPage urlName:api_orderInfo_app completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        
        if (respondsObject) {
            OrderModel *oM = (OrderModel *)respondsObject;
            if (_indexPage == 1) { // 第一次网络请求，清空数据源
                self.datasource = [NSMutableArray array];
                
                if (oM.orderSnList.count) {
                    [self.datasource addObjectsFromArray:oM.orderSnList];
                }
                [self.tableView reloadData];
                // 回到顶部cell
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            } else {
                
                if (oM.orderSnList.count) {
                    [self.datasource addObjectsFromArray:oM.orderSnList];
                }
                [self.tableView reloadData];
            }
            
        } else {
            if (_indexPage == 1) {
                [MBProgressHUD showError:@"暂无订单"];
            }
            [self.tableView reloadData];
        }
    }];
}

/**
 卖家设置尾款
 */
- (void)requestForFinalPayment {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:_selectedCell];
    OrderSnModel *snModel = _datasource[indexPath.section];
    GoodsInfoModel *goodModle = snModel.goodsList[0];
    
    @weakify(self);
    [OrderHandle requestForFinalPaymentWithUser:@"10085" orderID:goodModle.order_id retainage:self.paymentView.priceTextField.text completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            goodModle.retainage = self.paymentView.priceTextField.text;
            [self.tableView reloadData];
            
            self.paymentView.priceTextField.text = nil;
            [self.baseMaskView removeFromSuperview];
        }
    }];
}

/**
 取消订单（卖家）
 
 @param orderInfo 订单编号
 @param index cell的tag值，判断第几个cell
 */
- (void)requestForCancelOrder:(NSString *)orderInfo
                        index:(int)index
{
    @weakify(self);
    [OrderHandle requestForCancelOrderWithOrderSn:orderInfo completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if (respondsObject) {
            [_datasource removeObjectAtIndex:index];
            [self.tableView reloadData];
        }
    }];
}

/**
 快递信息、发货

 @param orderID 点单编号
 */
- (void)requestForDeliveryInfoWithOrderID:(NSString *)orderID
                                    index:(NSInteger)index
{
    @weakify(self);
    [OrderHandle requestForDeliveryInfoWithUSer:@"10085" orderID:orderID companyName:self.deliveryView.companySelect.titleLabel.text deliveryNumber:self.deliveryView.deliveryNumber.text completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            [MBProgressHUD showSuccess:@"发货成功"];
            [_datasource removeObjectAtIndex:index];
            [self.tableView reloadData];
        }
        if (error) {
            [MBProgressHUD showError:@"发货失败"];
        }
        self.deliveryView.deliveryNumber.text = nil;
        self.deliveryView.companySelect.titleLabel.text = nil;
        
    }];
}

/**
 删除订单

 @param orderSn 订单编号
 @param tomato 1买家取消 2 卖家取消
 @param index index
 */
- (void)requestForDeleteOrderWithOrderSn:(NSString *)orderSn
                                  tomato:(NSString *)tomato
                                   index:(int)index
{
    @weakify(self);
    [OrderHandle requestForDeleteOrderWithOrderSn:orderSn tomato:tomato completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            [MBProgressHUD showSuccess:@"删除成功"];
            [_datasource removeObjectAtIndex:index];
            [self.tableView reloadData];
            [self.baseMaskView removeAllSubviews];
            [self.baseMaskView removeFromSuperview];
        } else {
            [MBProgressHUD showError:@"删除失败"];
        }
    }];
}

#pragma mark - 买家网络请求
/**
 全部订单（买家）
 */
- (void)requestForPersonalData {
    @weakify(self);
    [OrderHandle requestForDatasourceWithUser:@"10085" page:_indexPage urlName:api_personalOrder_app completeBlock:^(id respondsObject, NSError *error) {
        
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        
        if (respondsObject) {
            if (_indexPage == 1) {
                self.datasource = [NSMutableArray array];
            }
            OrderModel *orderM = (OrderModel *)respondsObject;
            
            if (orderM.orderSnList.count) {
                [self.datasource addObjectsFromArray:orderM.orderSnList];
            }
            
            [self.tableView reloadData];
        }
    }];
     
}

/**
 根据状态请求订单（买家)
 
 @param order 订单类型
 @param shopping 购买类型
 @param pay 支付类型
 */
- (void)requestForBuyerOrderWithOrder:(NSInteger)order
                        shopping:(NSInteger)shopping
                             pay:(NSInteger)pay {
    self.orderState = order;
    self.shoppingState = shopping;
    self.payState = pay;
    
    @weakify(self);
    [OrderHandle requestForOrderWithOrder:order shopping:shopping pay:pay userID:@"10085" page:_indexPage urlName:api_personalOrder_app completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        
        if (respondsObject) {
            NSLog(@"respondsObject %@",respondsObject);
            OrderModel *oM = (OrderModel *)respondsObject;
            
            if (_indexPage == 1) {
                self.datasource = [NSMutableArray array];
                if (oM.orderSnList.count) {
                    [self.datasource addObjectsFromArray:oM.orderSnList];
                    
                }
                [self.tableView reloadData];
                // 回到第一个cell
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            } else {
                if (oM.orderSnList.count) {
                    [self.datasource addObjectsFromArray:oM.orderSnList];
                    
                }
                [self.tableView reloadData];
            }
        } else {
            if (_indexPage == 1) {
                [MBProgressHUD showError:@"暂无订单"];
            }
            [self.tableView reloadData];
        }
    }];
}


/**
 删除订单

 @param index cell tag值
 */
- (void)requstForDeleteOrder:(NSInteger)index {
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderManagerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kOrderManagerTableViewCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderManagerTableViewCell" owner:self options:nil] objectAtIndex:0];
        cell.finalPaymentText.delegate = self;
    }
    if (_isSeller) {
        [cell resumeCellNormalState]; // 卖家cell默认状态
    } else {
        [cell resumeBuyerCellNormalState]; // 买家cell默认状态
    }
    cell.isSeller = self.isSeller;
    
    OrderSnModel *orderSnM = _datasource[indexPath.section];
    GoodsInfoModel *goodsInfoM = orderSnM.goodsList[0];
    [cell configureCell:goodsInfoM];
  
    @weakify(self);
    cell.buttonBlock = ^(NSInteger tag) {
        @strongify(self);

        [self cellButtons_action:tag model:orderSnM];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderSnModel *orderSnM = _datasource[indexPath.section];
    GoodsInfoModel *goodsInfoM = orderSnM.goodsList[0];
    
    return goodsInfoM.cellHeight;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.paymentView];
    _selectedCell = (OrderManagerTableViewCell *)[[textField superview] superview];
    return NO;
}

#pragma mark - Getter method
- (FinalPaymentView *)paymentView {
    if (!_paymentView) {
        _paymentView        = [FinalPaymentView shareFinalPayInstancetype];
        _paymentView.frame  = CGRectMake(0, 0, SCREEN_WIDTH-80, 152);
        _paymentView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-20);
    }
    return _paymentView;
}

- (DZAlertView *)alertView {
    if (!_alertView) {
        _alertView        = [DZAlertView shareDZAlertViewInstanceType];
        _alertView.frame  = CGRectMake(0, 0, SCREEN_WIDTH-80, 152);
        _alertView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-20);
    }
    return _alertView;
}

- (DeliveryView *)deliveryView {
    if (!_deliveryView) {
        _deliveryView        = [DeliveryView shareDeliveryInstanetype];
        _deliveryView.frame  = CGRectMake(0, 0, SCREEN_WIDTH-40, 235);
        _deliveryView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-40);
    }
    return _deliveryView;
}

@end
