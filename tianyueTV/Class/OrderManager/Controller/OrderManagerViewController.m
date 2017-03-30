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
    NSInteger _indexPage;                      // 页码
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
        _indexPage += 1;
        if (_isSeller) {
            if (_nowButton.tag == 230) {
                [self requestForDatasource]; // 卖家刷新全部订单
            } else {
                [self updateOrderData]; // 卖家刷新其他状态订单
            }
        } else {
            if (_nowButton.tag == 230) {
                [self requestForPersonalData]; // 买家刷新全部订单
            } else {
                [self updateBuyerOrderData]; // 买家刷新其他订单状态
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
    _datasource         = [NSMutableArray array];
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
                [self requestForOrderWithOrder:0 shopping:4 pay:2];
            } else {
                [self requestForBuyerOrderWithOrder:0 shopping:4 pay:2];
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
 @param sectionTag 点击cell的section
 */
- (void)cellButtons_action:(NSInteger)tag
                sectionTag:(NSInteger)sectionTag {
    NSLog(@"sectionTag %ld", sectionTag);
    NSDictionary *dataDic = _datasource[sectionTag][@"goodsList"][0];
    UIWindow *window      = [UIApplication sharedApplication].keyWindow;
    NSInteger order       = [dataDic[@"orderStauts"] integerValue];
    NSInteger shop        = [dataDic[@"shippingStatus"] integerValue];
    NSInteger pay         = [dataDic[@"payStatus"] integerValue];
    if (order == 0 && shop == 0 && pay == 0) { // 代付款
        if (tag == 1) { // 取消订单
            [window addSubview:self.baseMaskView];
            [self.baseMaskView addSubview:self.alertView];
            @weakify(self);
            [self.alertView initDZAlertViewMessage:@"是否确认取消订单?" leftTitle:@"否" rightTitle:@"是" leftHandle:^(UIButton *button) {
                @strongify(self);
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
            } rightHandle:^(UIButton *button) {
                NSLog(@"sectionTag %ld",sectionTag);
                [self requestForCancelOrder:dataDic[@"orderInfoSn"] index:sectionTag];
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
                [MBProgressHUD showMessage:nil];
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
                    [self requestForDeliveryInfoWithSection:sectionTag];
                }
            };
        }
    } else if (order == 0 && shop == 0 && pay == 2) { // 待确认
        if (tag == 1) { // 取消订单
            
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
                [self requstForDeleteOrder:sectionTag];
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
                
            }];
        }
    } else if (shop == 4 && pay == 2) { // 退款
        
    }
}


/**
 cell按钮点击事件
 
 @param tag 判断点击哪一个Button 0-2
 @param orderSnModel cell对应的model对象
 */
- (void)cellButtons_action:(NSInteger)tag
                     model:(OrderSnModel *)orderSnModel {
    
    GoodsInfoModel *goodsInfoModel = orderSnModel.goodsList[0];

    UIWindow *window      = [UIApplication sharedApplication].keyWindow;
    NSInteger order       = [goodsInfoModel.orderStauts integerValue];
    NSInteger shop        = [goodsInfoModel.shippingStatus integerValue];
    NSInteger pay         = [goodsInfoModel.payStatus integerValue];
    if (order == 0 && shop == 0 && pay == 0) { // 代付款
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
                
                int index = (int)[self.datasource indexOfObject:orderSnModel];
                [self requestForCancelOrder:goodsInfoModel.orderInfoSn index:index];
                [self.baseMaskView removeAllSubviews];
                [self.baseMaskView removeFromSuperview];
                [MBProgressHUD showMessage:nil];
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
                    
                    int index = (int)[self.datasource indexOfObject:orderSnModel];
                    [self requestForDeliveryInfoWithSection:index];
                }
            };
        }
    } else if (order == 0 && shop == 0 && pay == 2) { // 待确认
        if (tag == 1) { // 取消订单
            
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
                int index = (int)[self.datasource indexOfObject:orderSnModel];
                
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

#pragma mark - Networking method
/**
 全部订单（卖家）
 */
- (void)requestForDatasource {

    @weakify(self);
    [OrderHandle requestForDatasourceWithUser:@"10085" page:_indexPage completeBlock:^(id respondsObject, NSError *error) {
        
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        
        if (respondsObject) {
            
            OrderModel *orderM = (OrderModel *)respondsObject;

            if (orderM.orderSnList.count) {
                [_datasource addObjectsFromArray:orderM.orderSnList];
            }
            
            [self.tableView reloadData];
            
//            if (_datasource.count) {
//                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
//            }
            
        }
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
                             pay:(NSInteger)pay {
    NSString *orderStr    = [NSString stringWithFormat:@"%ld",order];
    NSString *shoppingStr = [NSString stringWithFormat:@"%ld",shopping];
    NSString *payStr      = [NSString stringWithFormat:@"%ld",pay];
    NSString *page        = [NSString stringWithFormat:@"%ld",_indexPage];
    NSDictionary *dic     = [[NSDictionary alloc] initWithObjectsAndKeys:@"10085",@"userId",page,@"currentPage",orderStr,@"orderStauts",shoppingStr,@"shippingStatus",payStr,@"payStatus", nil];
    _nowRequestDic = dic;
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"orderInfo_app" paraments:dic finish:^(id responseObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            NSArray *arr = responseObject[@"orderSnList"];
            if (arr.count) {
                [_datasource addObjectsFromArray:responseObject[@"orderSnList"]];
            }
            NSLog(@"_datasource %@",_datasource);
            [self.tableView reloadData];
            if (_datasource.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        } else if ([responseObject[@"ret"] isEqualToString:@"error"]) {
            [MBProgressHUD showError:@"暂无订单"];
            [self.tableView reloadData];
        }
    }];
}


/**
 上拉加载其他分类订单（卖家）
 */
- (void)updateOrderData {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithDictionary:_nowRequestDic];
    [paramDic setObject:[NSString stringWithFormat:@"%ld",_indexPage] forKey:@"currentPage"];
    NSLog(@"_nowRequestDic %@",paramDic);
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"orderInfo_app" paraments:paramDic finish:^(id responseObject, NSError *error) {
        @strongify(self);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [MBProgressHUD hideHUD];
            NSArray *arr = responseObject[@"orderSnList"];
            if (arr.count) {
                [_datasource addObjectsFromArray:responseObject[@"orderSnList"]];
            }
            NSLog(@"_datasource %@",_datasource);
            [self.tableView reloadData];
        } else if ([responseObject[@"ret"] isEqualToString:@"error"]) {

        }
    }];
}

/**
 卖家设置尾款（卖家）
 */
- (void)requestForFinalPayment {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:_selectedCell];
    NSString *idStr        = [NSString stringWithFormat:@"%@",_datasource[indexPath.section][@"goodsList"][0][@"order_id"]];
    NSDictionary *dic      = [NSDictionary dictionaryWithObjectsAndKeys:@"10085",@"user_id",idStr,@"orderId",self.paymentView.priceTextField.text,@"retainage", nil];
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"setRetainage_app" paraments:dic finish:^(id responseObject, NSError *error) {
        @strongify(self);
        NSLog(@"%@",responseObject);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [self.baseMaskView removeFromSuperview];
        }
    }];
}

/**
 全部订单（买家）
 */
- (void)requestForPersonalData {
    NSString *page    = [NSString stringWithFormat:@"%ld",_indexPage];
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"10085",@"userId",page,@"currentPage", nil];
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"personalOrder_app" paraments:dic finish:^(id responseObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        NSLog(@"responseObject %@",responseObject);
        NSLog(@"error %@",error);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            NSArray *arr = responseObject[@"orderSnList"];
            if (arr.count) {
                [_datasource addObjectsFromArray:responseObject[@"orderSnList"]];
            }
//            NSLog(@"_datasource %@",_datasource);
            [self.tableView reloadData];
            if (_datasource.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
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
    NSString *orderStr    = [NSString stringWithFormat:@"%ld",order];
    NSString *shoppingStr = [NSString stringWithFormat:@"%ld",shopping];
    NSString *payStr      = [NSString stringWithFormat:@"%ld",pay];
    NSString *page        = [NSString stringWithFormat:@"%ld",_indexPage];
    NSDictionary *dic     = [[NSDictionary alloc] initWithObjectsAndKeys:@"10085",@"userId",page,@"currentPage",orderStr,@"orderStauts",shoppingStr,@"shippingStatus",payStr,@"payStatus", nil];
    _nowRequestDic = dic;
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"personalOrder_app" paraments:dic finish:^(id responseObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            NSArray *arr = responseObject[@"orderSnList"];
            if (arr.count) {
                [_datasource addObjectsFromArray:responseObject[@"orderSnList"]];
            }
            NSLog(@"_datasource %@",_datasource);
            [self.tableView reloadData];
            if (_datasource.count) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        } else if ([responseObject[@"ret"] isEqualToString:@"error"]) {
            [MBProgressHUD showError:@"暂无订单"];
            [self.tableView reloadData];
        }
    }];
}

/**
 上拉加载其他分类订单（买家）
 */
- (void)updateBuyerOrderData {
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] initWithDictionary:_nowRequestDic];
    [paramDic setObject:[NSString stringWithFormat:@"%ld",_indexPage] forKey:@"currentPage"];
    NSLog(@"_nowRequestDic %@",paramDic);
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"personalOrder_app" paraments:paramDic finish:^(id responseObject, NSError *error) {
        @strongify(self);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [MBProgressHUD hideHUD];
            NSLog(@"responseObject %@ error %@",responseObject,error);
            NSArray *arr = responseObject[@"orderSnList"];
            if (arr.count) {
                [_datasource addObjectsFromArray:responseObject[@"orderSnList"]];
            }
            NSLog(@"_datasource %@",_datasource);
            [self.tableView reloadData];
        } else if ([responseObject[@"ret"] isEqualToString:@"error"]) {
            
        }
    }];
}

/**
 取消订单（卖家）

 @param orderInfo 订单编号
 @param index cell的tag值，判断第几个cell
 */
- (void)requestForCancelOrder:(NSString *)orderInfo
                        index:(int)index {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:orderInfo,@"orderInfoSn", nil];
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"updateOrderStatus_app" paraments:dic finish:^(id responseObject, NSError *error) {
        NSLog(@"--- %@",responseObject);
        @strongify(self);
        [MBProgressHUD hideHUD];
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [_datasource removeObjectAtIndex:index];
            [self.tableView reloadData];
        }
    }];
}


/**
 快递信息、发货

 @param section cell的tag值
 */
- (void)requestForDeliveryInfoWithSection:(NSInteger)section {
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"10085",@"user_id",_datasource[section][@"goodsList"][0][@"order_id"],@"id",self.deliveryView.companySelect.titleLabel.text,@"shipping_name",self.deliveryView.deliveryNumber.text,@"shipping_no", nil];
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"sureSendGoods_app" paraments:dic finish:^(id responseObject, NSError *error) {
        @strongify(self);
        NSLog(@"%@",responseObject);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [self.baseMaskView removeFromSuperview];
            [_datasource removeObjectAtIndex:section];
            [self.tableView reloadData];
        }
        if (error) {
            [self.baseMaskView removeFromSuperview];
            [MBProgressHUD showError:@"发货失败"];
        }
        self.deliveryView.deliveryNumber.text = nil;
        self.deliveryView.companySelect.titleLabel.text = nil;
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
    
    /*
    cell.paramDic    = _datasource[indexPath.section][@"goodsList"][0];
    [cell calculateCellHeight:_datasource[indexPath.section][@"goodsList"][0][@"content"]];
    cell.sectionTag  = indexPath.section;
    */
    
    @weakify(self);
    cell.buttonBlock = ^(NSInteger tag) {
        @strongify(self);
//        [self cellButtons_action:tag sectionTag:indexPath.section];
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
