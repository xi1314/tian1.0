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
#import "PayOrderView.h"
#import "WXApiManager.h"

@interface OrderManagerViewController ()
<UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate>

{
    UIButton *_nowButton;                      // 当前选择按钮（顶部）
    OrderManagerTableViewCell *_selectedCell;  // 选择的cell
}

// 列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 支付弹窗
@property (strong, nonatomic) FinalPaymentView *paymentView;

// 计算高度对象
@property (strong, nonatomic) OrderManagerTableViewCell *orderCell;

// 自定义提示框
@property (strong, nonatomic) DZAlertView *alertView;

// 设置物流弹框
@property (strong, nonatomic) DeliveryView *deliveryView;

// 存储当前请求参数
@property (strong, nonatomic) NSDictionary *nowRequestDic;

// 数据数组
@property (strong, nonatomic) NSMutableArray *datasource;

// 记录上次请求的订单状态
@property (assign, nonatomic) NSInteger orderState;

// 记录上一次的购买状态
@property (assign, nonatomic) NSInteger shoppingState;

// 记录上一次的支付状态
@property (assign, nonatomic) NSInteger payState;

// 页码
@property (assign, nonatomic) NSInteger indexPage;

// 买家支付弹窗
@property (strong, nonatomic) PayOrderView *payOrderView;

// window
@property (strong, nonatomic) UIWindow *window;

@end

@implementation OrderManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBaseViewBackItem)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _indexPage = 1;
    _nowButton = (UIButton *)[self.view viewWithTag:230];
    [self initilizeDatasource];
    [self initilizeUserInterface];
    [self requestForPayButton];
    self.orderCell = [[[NSBundle mainBundle] loadNibNamed:@"OrderManagerTableViewCell" owner:nil options:nil] objectAtIndex:0];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)touchBaseMaskView {
    [self.view endEditing:YES];
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
    // 上拉加载
    @weakify(self);
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        self.indexPage += 1;
        if (_isSeller) {
            if (_nowButton.tag == 230) {
                [self requestForDatasource]; // 卖家刷新全部订单
            } else {
                [self requestForOrderWithOrder:self.orderState shopping:self.shoppingState pay:self.payState];
            }
        } else {
            if (_nowButton.tag == 230) {
                [self requestForPersonalData]; // 买家刷新全部订单
            } else {
                [self requestForBuyerOrderWithOrder:self.orderState shopping:self.shoppingState pay:self.payState];
            }
        }
        
    }];
    
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        self.indexPage = 1;
        if (_isSeller) {
            if (_nowButton.tag == 230) {
                [self requestForDatasource]; // 卖家刷新全部订单
            } else {
                [self requestForOrderWithOrder:self.orderState shopping:self.shoppingState pay:self.payState];
            }
        } else {
            if (_nowButton.tag == 230) {
                [self requestForPersonalData]; // 买家刷新全部订单
            } else {
                [self requestForBuyerOrderWithOrder:self.orderState shopping:self.shoppingState pay:self.payState];
            }
        }
    }];
}

- (void)initilizeUserInterface {
    if (_isSeller) { self.title = @"收到订单"; }
    else { self.title = @"我的订单"; }
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
    [self.tableView.mj_footer setHidden:NO];
    [self.tableView.mj_header setHidden:NO];
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
    self.paymentView.buttonBlock = ^(NSInteger tag,NSString *price) {
        @strongify(self);
        switch (tag) {
            case 0: { // 取消
                [self.baseMaskView removeFromSuperview];
            } break;
                
            case 1: { // 确定
                [self requestForFinalPaymentWithPrice:price];
                [self.baseMaskView removeFromSuperview];
                [MBProgressHUD showMessage:nil];
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
    NSInteger order   = [goodsInfoModel.orderStauts integerValue];
    NSInteger shop = [goodsInfoModel.shippingStatus integerValue];
    NSInteger pay  = [goodsInfoModel.payStatus integerValue];
    int index = (int)[self.datasource indexOfObject:orderSnModel];
    
    @weakify(self);
    if (order == 0 && shop == 0) { // 代付款
        if (tag == 1) {
            if (pay != 0 && !self.isSeller) { // 买家申请退款
                [self applyOrderRefoudWithOrderSn:goodsInfoModel.orderInfoSn index:index];
            } else {
                if (pay == 2) { // 卖家取消已支付定金的订单
                    [self sellerCancelOrderAndRefoundWithOrderSn:goodsInfoModel.orderInfoSn index:index];
                } else { // 取消订单
                    [self requestForCancelOrder:goodsInfoModel.orderInfoSn index:index];
                }
            }
        } else if (tag == 2) {
             // 立即支付
            if (pay == 0) {
                NSString *price = [NSString stringWithFormat:@"%.2f",[goodsInfoModel.goodsPrice floatValue]*[goodsInfoModel.goodsNum floatValue]];
                [self showPayOrderViewAnmation:price index:index];
            } else {
                [self showPayOrderViewAnmation:goodsInfoModel.retainage index:index];
            }
        }
    } else if (order == 1 && shop == 0 && pay == 2) { // 待发货
        if (tag == 1) {
            if (_isSeller) { // 立即发货
                [self.window addSubview:self.baseMaskView];
                [self.baseMaskView addSubview:self.deliveryView];
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
            } else { // 申请退款
                [self applyOrderRefoudWithOrderSn:goodsInfoModel.orderInfoSn index:index];
            }
        }
        if (tag == 2) { // 延长发货
            [self.window addSubview:self.baseMaskView];
            [self.baseMaskView addSubview:self.alertView];
            [self.alertView initDZAlertViewMessage:@"是否延长发货时间" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
                @strongify(self);
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
            } rightHandle:^(UIButton *button) {
                
            }];
        }
    } else if (order == 1 && shop == 1 && pay == 2) { // 待收货
        if (tag == 1) { // 查看物流
            
        } else if (tag == 2) { // 确认收货
            [self makeSureDeliveryWithOrderSn:goodsInfoModel.orderInfoSn index:index];
        }
    } else if (order == 1 && shop == 2 && pay == 2) { // 已完成
        if (tag == 2) { // 删除订单
            [self deleteOrderWithorderSn:goodsInfoModel.orderInfoSn tomato:@"" index:index];
        }
    } else if (order == 2) { // 已取消
        if (tag == 2) {
            if (_isSeller) { // 卖家删除订单
                [self deleteOrderWithorderSn:goodsInfoModel.orderInfoSn tomato:@"2"   index:index];
            } else { // 买家删除
                [self deleteOrderWithorderSn:goodsInfoModel.orderInfoSn tomato:@"1"   index:index];
            }
        }
    } else if (order == 4) { // 退款
        if (tag == 1) { // 同意退款
            [self.window addSubview:self.baseMaskView];
            [self.alertView initDZAlertViewMessage:@"同意退款后订单金额将退还买家，是否继续" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
                @strongify(self);
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
            } rightHandle:^(UIButton *button) {
                @strongify(self);
                [OrderHandle requestForComfirmRefoundWithUser:USER_ID OrderID:goodsInfoModel.order_id refundAmount:goodsInfoModel.goodsPrice completeBlock:^(id respondsObject, NSError *error) {
//                    NSLog(@"refound %@",respondsObject);
                }];
            }];
            [self.baseMaskView addSubview:self.alertView];
        } else if (tag == 2) { // 申请纠纷
            [self applyForDisputeWithOrderID:goodsInfoModel.order_id index:index];
        }
    }
}


#pragma mark - Private method
/**
 立即支付

 @param price 价格
 */
- (void)showPayOrderViewAnmation:(NSString *)price index:(int)index {
    [self.window addSubview:self.baseMaskView];
    self.payOrderView.priceString = price;
    [self.baseMaskView addSubview:self.payOrderView];
    [UIView animateWithDuration:0.3 animations:^{
        self.payOrderView.frame = CGRectMake(0, SCREEN_HEIGHT-365, SCREEN_WIDTH, 365);
    }];
    @weakify(self);
    self.payOrderView.buttonBlock = ^(NSInteger tag) {
        @strongify(self);
        if (tag == 0) { // 关闭
            [self dismissPayViewAnimation];
        }
        if (tag == 2) { // 确认支付
            OrderSnModel *snModel = self.datasource[index];
            GoodsInfoModel *goodModle = snModel.goodsList[0];
            
            [MBProgressHUD showMessage:nil];
            [[WXApiManager sharedManager] weixinPayTradeNum:goodModle.orderSn andBlock:^(BOOL success){
                // 支付成功
                [self dismissPayViewAnimation];
            }];
        }
    };
}

/**
 确认收货

 @param orderSn 订单编号
 @param index cell编号
 */
- (void)makeSureDeliveryWithOrderSn:(NSString *)orderSn index:(int)index {
    [self.window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.alertView];
    @weakify(self);
    [self.alertView initDZAlertViewMessage:@"确认收货" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
        @strongify(self);
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
    } rightHandle:^(UIButton *button) {
        @strongify(self);
        [OrderHandle requestForSureDeliveryWithOrderSn:orderSn user:@"10085" completeBlock:^(id respondsObject, NSError *error) {
            if (respondsObject) {
                [MBProgressHUD showSuccess:@"确认成功"];
                if (_nowButton.tag == 230) {
                    OrderSnModel *sModle = _datasource[index];
                    GoodsInfoModel *goodModel = sModle.goodsList[0];
                    goodModel.orderStauts = @"1";
                    goodModel.payStatus = @"2";
                    goodModel.shippingStatus = @"2";
                } else {
                    [self.datasource removeObjectAtIndex:index];
                }
                [self.tableView reloadData];
            }
        }];
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
    }];
}

/**
 删除订单

 @param orderSn 订单编号
 @param tomato 1买家取消 2 卖家取消
 @param index cell编号
 */
- (void)deleteOrderWithorderSn:(NSString *)orderSn
                        tomato:(NSString *)tomato
                         index:(int)index
{
    [self.window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.alertView];
    @weakify(self);
    [self.alertView initDZAlertViewMessage:@"订单删除后不可恢复，是否继续" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
        @strongify(self);
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
    } rightHandle:^(UIButton *button) {
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
    }];
}

/**
 申请纠纷

 @param orderID 订单ID
 @param index cell index
 */
- (void)applyForDisputeWithOrderID:(NSString *)orderID index:(int)index {
    [self.window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.alertView];
    @weakify(self);
    [self.alertView initDZAlertViewMessage:@"确认让工作人员介入处理吗？是否继续" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
        @strongify(self);
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
    } rightHandle:^(UIButton *button) {
        @strongify(self);
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
        [OrderHandle requestForOrderDisputeWithOrderID:orderID user:@"10085" completeBlock:^(id respondsObject, NSError *error) {
            @strongify(self);
            [MBProgressHUD showMessage:nil];
            if (respondsObject) {
                [MBProgressHUD hideHUD];
                NSLog(@"respondsObject %@",respondsObject);
                OrderSnModel *snM = [_datasource objectAtIndex:index];
                GoodsInfoModel *goodM = snM.goodsList[0];
                goodM.order_status_app = @"8";
                [self.tableView reloadData];
            } else {
                [MBProgressHUD showError:@"申请失败"];
            }
        }];
    }];
}

- (void)sellerCancelOrderAndRefoundWithOrderSn:(NSString *)orderSn
                                         index:(int)index
{
    [self.window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.alertView];
    @weakify(self);
    [self.alertView initDZAlertViewMessage:@"取消订单后，定金会退还买家，是否继续" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
        @strongify(self);
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
     } rightHandle:^(UIButton *button) {
         @strongify(self);
         [self.baseMaskView removeAllSubviews];
         [self.baseMaskView removeFromSuperview];
         [MBProgressHUD showMessage:nil];
         [OrderHandle requestForRefoundWithOrderSn:orderSn completeBlock:^(id respondsObject, NSError *error) {
             @strongify(self);
             if (respondsObject) {
                 [MBProgressHUD hideHUD];
                 if (_nowButton.tag == 230) {
                     OrderSnModel *sModle = _datasource[index];
                     GoodsInfoModel *goodModel = sModle.goodsList[0];
                     goodModel.orderStauts = @"1";
                     goodModel.payStatus = @"2";
                     goodModel.shippingStatus = @"2";
                     goodModel.refoundStatus = @"4";
                 } else {
                     [_datasource removeObjectAtIndex:index];
                 }
                 [self.tableView reloadData];
             } else {
                 [MBProgressHUD showError:@"取消失败"];
             }
         }];
     }];
}

// 动态消失支付页面
- (void)dismissPayViewAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.payOrderView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 365);
    } completion:^(BOOL finished) {
        [self.baseMaskView removeFromSuperview];
    }];
}

#pragma mark - 卖家网络请求
/**
 全部订单（卖家）
 */
- (void)requestForDatasource {

    @weakify(self);
    [OrderHandle requestForDatasourceWithUser:@"10085" page:_indexPage isSeller:self.isSeller completeBlock:^(id respondsObject, NSError *error) {
        
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (respondsObject) {
            if (_indexPage == 1) { // 第一次网络请求
                self.datasource = [NSMutableArray array];
            }
            
            OrderModel *orderM = (OrderModel *)respondsObject;
            // 设置角标
            NSArray *badgeArr = @[orderM.waitPayCount,orderM.waitDeliverCount,orderM.waitTakeDeliverCount,orderM.refundCount];
//            NSLog(@"badgeArr %@",badgeArr);
            for (int i = 0; i < 4; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:231+i];
                [button removeBadgeValue];
                [button setBadgeValue:badgeArr[i] withBackColor:THEME_COLOR];
            }
            
            if (orderM.orderSnList.count) {
                [self.datasource addObjectsFromArray:orderM.orderSnList];
            }
            // 数据少于5条时，停止上拉请求数据
            if (orderM.orderSnList.count < 5) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    [OrderHandle requestForOrderWithOrder:order shopping:shopping pay:pay userID:@"10085" page:_indexPage isSeller:self.isSeller completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (respondsObject) {
            OrderModel *oM = (OrderModel *)respondsObject;
            if (_indexPage == 1) { // 第一次网络请求，清空数据源
                self.datasource = [NSMutableArray array];
                
                if (oM.orderSnList.count) {
                    [self.datasource addObjectsFromArray:oM.orderSnList];
                }
                [self.tableView reloadData];
                // 回到顶部cell
                if (oM.orderSnList.count) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }

            } else {
                
                if (oM.orderSnList.count) {
                    [self.datasource addObjectsFromArray:oM.orderSnList];
                }
                [self.tableView reloadData];
            }
            
            if (oM.orderSnList.count < 5) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            // 设置角标
            NSArray *badgeArr = @[oM.waitPayCount,oM.waitDeliverCount,oM.waitTakeDeliverCount,oM.refundCount];
//            NSLog(@"badgeArr %@",badgeArr);
            for (int i = 0; i < 4; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:231+i];
                [button removeBadgeValue];
                [button setBadgeValue:badgeArr[i] withBackColor:THEME_COLOR];
            }
        } else {
            if (_indexPage == 1) {
                [MBProgressHUD showError:@"暂无订单"];
                self.datasource = [NSMutableArray array];
                [self.tableView.mj_footer setHidden:YES];
                [self.tableView.mj_header setHidden:YES];
            }
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            [self.tableView reloadData];
        }
    }];
}

/**
 卖家设置尾款
 */
- (void)requestForFinalPaymentWithPrice:(NSString *)price {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:_selectedCell];
    OrderSnModel *snModel = _datasource[indexPath.section];
    GoodsInfoModel *goodModle = snModel.goodsList[0];
    
    @weakify(self);
    [OrderHandle requestForFinalPaymentWithUser:@"10085" orderID:goodModle.order_id retainage:price completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if (respondsObject) {
            goodModle.retainage = price;
            [self.tableView reloadData];
        }
    }];
}

/**
 取消订单
 
 @param orderInfo 订单编号
 @param index cell的tag值，判断第几个cell
 */
- (void)requestForCancelOrder:(NSString *)orderInfo
                        index:(int)index
{
    [self.window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.alertView];
    @weakify(self);
    [self.alertView initDZAlertViewMessage:@"是否确认取消订单?" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
        @strongify(self);
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
    } rightHandle:^(UIButton *button) {
        @strongify(self);
        [OrderHandle requestForCancelOrderWithOrderSn:orderInfo completeBlock:^(id respondsObject, NSError *error) {
            @strongify(self);
            [MBProgressHUD hideHUD];
            if (respondsObject) {
                if (_nowButton.tag == 230) {
                    OrderSnModel *snModel = _datasource[index];
                    GoodsInfoModel *goodModel = snModel.goodsList[0];
                    goodModel.orderStauts = @"2";
                } else {
                    [_datasource removeObjectAtIndex:index];
                }
                [self.tableView reloadData];
            }
        }];
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
        [MBProgressHUD showMessage:nil];
    }];
}

/**
 快递信息、发货

 @param orderID 点单编号
 */
- (void)requestForDeliveryInfoWithOrderID:(NSString *)orderID
                                    index:(NSInteger)index
{
    if (self.deliveryView.companySelect.titleLabel.text.length == 0 || self.deliveryView.deliveryNumber.text.length == 0) {
        return;
    }
    @weakify(self);
    [OrderHandle requestForDeliveryInfoWithUSer:@"10085" orderID:orderID companyName:self.deliveryView.companySelect.titleLabel.text deliveryNumber:self.deliveryView.deliveryNumber.text completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            [MBProgressHUD showSuccess:@"发货成功"];
            if (_nowButton.tag == 230) {
                OrderSnModel *sn = _datasource[index];
                GoodsInfoModel *goodModel = sn.goodsList[0];
                goodModel.orderStauts = @"1";
                goodModel.shippingStatus = @"1";
                goodModel.payStatus = @"2";
            } else {
                [_datasource removeObjectAtIndex:index];
            }
            [self.tableView reloadData];
        }
        if (error) {
            [MBProgressHUD showError:@"发货失败"];
        }
        self.deliveryView.deliveryNumber.text = nil;
        self.deliveryView.companySelect.titleLabel.text = nil;
        
    }];
}

#pragma mark - 买家网络请求
/**
 全部订单（买家）
 */
- (void)requestForPersonalData {
    @weakify(self);
    [OrderHandle requestForDatasourceWithUser:@"10085" page:_indexPage isSeller:self.isSeller completeBlock:^(id respondsObject, NSError *error) {
        
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (respondsObject) {
            if (_indexPage == 1) {
                self.datasource = [NSMutableArray array];
            }
            OrderModel *orderM = (OrderModel *)respondsObject;
            
            if (orderM.orderSnList.count) {
                [self.datasource addObjectsFromArray:orderM.orderSnList];
            }
            // 设置角标
            NSArray *badgeArr = @[orderM.waitPayCount,orderM.waitDeliverCount,orderM.waitTakeDeliverCount,orderM.refundCount];
//            NSLog(@"badgeArr %@",badgeArr);
            for (int i = 0; i < 4; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:231+i];
                [button removeBadgeValue];
                [button setBadgeValue:badgeArr[i] withBackColor:THEME_COLOR];
            }
            // 数据少于5条时，停止上拉请求数据
            if (orderM.orderSnList.count < 5) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
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
    [OrderHandle requestForOrderWithOrder:order shopping:shopping pay:pay userID:@"10085" page:_indexPage isSeller:self.isSeller completeBlock:^(id respondsObject, NSError *error) {
        
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        if (self.tableView.mj_header.state == MJRefreshStateRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (respondsObject) {
            OrderModel *oM = (OrderModel *)respondsObject;
            
            if (_indexPage == 1) {
                self.datasource = [NSMutableArray array];
                if (oM.orderSnList.count) {
                    [self.datasource addObjectsFromArray:oM.orderSnList];
                    
                }
                [self.tableView reloadData];
                // 回到第一个cell
                if (oM.orderSnList.count) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
                
            } else {
                if (oM.orderSnList.count) {
                    [self.datasource addObjectsFromArray:oM.orderSnList];
                    
                }
                [self.tableView reloadData];
            }
            
            if (oM.orderSnList.count < 5) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            // 设置角标
            NSArray *badgeArr = @[oM.waitPayCount,oM.waitDeliverCount,oM.waitTakeDeliverCount,oM.refundCount];
//            NSLog(@"badgeArr %@",badgeArr);
            for (int i = 0; i < 4; i++) {
                UIButton *button = (UIButton *)[self.view viewWithTag:231+i];
                [button removeBadgeValue];
                [button setBadgeValue:badgeArr[i] withBackColor:THEME_COLOR];
            }
        } else {
            if (_indexPage == 1) {
                [MBProgressHUD showError:@"暂无订单"];
                self.datasource = [NSMutableArray array];
                [self.tableView.mj_footer setHidden:YES];
                [self.tableView.mj_header setHidden:YES];
            }
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

/**
 申请退款

 @param orderSn 订单编号
 @param index cell编号
 */
- (void)applyOrderRefoudWithOrderSn:(NSString *)orderSn
                              index:(int)index
{
    [self.window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.alertView];
    @weakify(self);
    [self.alertView initDZAlertViewMessage:@"申请退款后，钱款将全额退还，是否继续" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
        @strongify(self);
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
    } rightHandle:^(UIButton *button) {
        @strongify(self);
        [self.baseMaskView removeAllSubviews];
        [self.baseMaskView removeFromSuperview];
        [MBProgressHUD showMessage:nil];
        
        [OrderHandle requestForApplyRefoundWithOrderSn:orderSn user:@"10085" completeBlock:^(id respondsObject, NSError *error) {
            @strongify(self);
            if (respondsObject) {
                [MBProgressHUD showSuccess:@"申请成功"];
                if (_nowButton.tag == 230) {
                    OrderSnModel *sModle = _datasource[index];
                    GoodsInfoModel *goodModel = sModle.goodsList[0];
                    goodModel.orderStauts = @"4";
                } else {
                    [_datasource removeObjectAtIndex:index];
                }
                [self.tableView reloadData];
            } else {
                [MBProgressHUD showError:@"申请失败"];
            }
        }];
    }];
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
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderManagerTableViewCell" owner:nil options:nil] objectAtIndex:0];
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
    // 设置尾款时弹窗
    [self.window addSubview:self.baseMaskView];
    [self.baseMaskView addSubview:self.paymentView];
    _selectedCell = (OrderManagerTableViewCell *)[[textField superview] superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:_selectedCell];
    OrderSnModel *snM = _datasource[indexPath.section];
    GoodsInfoModel *goodM = snM.goodsList[0];
    self.paymentView.price = [goodM.goodsPrice floatValue] * [goodM.goodsNum floatValue];
    return NO;
}

#pragma mark - Getter method
- (FinalPaymentView *)paymentView {
    if (!_paymentView) {
        _paymentView        = [FinalPaymentView shareFinalPayInstancetype];
        _paymentView.frame  = CGRectMake(0, 0, SCREEN_WIDTH-80, 162);
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

- (PayOrderView *)payOrderView {
    if (!_payOrderView) {
        _payOrderView = [PayOrderView sharePayOrderInstancetype];
        _payOrderView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 365);
    }
    return _payOrderView;
}

- (UIWindow *)window {
    if (!_window) {
        _window = [UIApplication sharedApplication].keyWindow;
    }
    return _window;
}

@end




