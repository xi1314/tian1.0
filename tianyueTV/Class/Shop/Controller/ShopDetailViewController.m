//
//  ShopDetailViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/2.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "ShopDetailViewController.h"
#import "ShopDetailView.h"
#import "ChooseView.h"
#import "ProductDetailVIew.h"
#import "OrderViewController.h"
#import "MessageModel.h"
#import "UIButton+Badge.h"

@interface ShopDetailViewController () {
    NSArray *_sizeArr;      //规格
    NSArray *_colorArr;     //颜色
    NSString *_type1;       //属性名称1
    NSString *_type2;       //属性名称2
    NSString *_chooseViewImgUrl;    //商品图片
    NSString *_priceStr;            //商品价格
    NSArray *_stockArr;             //库存
    NSMutableDictionary *_goodInfoDic;      //存储选择商品的信息
    NSDictionary *_responseDic;
    BOOL _isSuspend;        //是否是推出的选择页
    BOOL _isCar;            //是否是加入购物车
}
@property (nonatomic, strong) ShopDetailView *shopView;
@property (nonatomic, strong) ChooseView *chooseView;                  //商品规格
@property (nonatomic, strong) ProductDetailVIew *productDetailView;    //商品详情
@property (nonatomic, strong) ChooseView *otherChooseView;             //弹出的商品详情页
@property (nonatomic, strong) UIView *maskView;
@end

@implementation ShopDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodID = @"117";
    _isSuspend = NO;
    _isCar = NO;
    [MBProgressHUD showMessage:@"加载中"];
    [self initializeDatasource];
    self.view = self.shopView;
    [self initilizeUserInterface];
    [self loadShopViewButtonMethod];
}

#pragma mark -- initil method
- (void)initializeDatasource {
    _goodInfoDic = [NSMutableDictionary dictionary];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.goodID,@"gId",[USER_Defaults objectForKey:@"user_id"],@"user_id", nil];
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"goods_app" paraments:dic finish:^(id responseObject, NSError *error) {
        if (error) {
            NSLog(@"--- %@",error);
            [MBProgressHUD showError:@"加载失败"];
        }
        NSLog(@"------- 哈哈哈%@",responseObject);
        if (responseObject) {
            [MBProgressHUD hideHUD];
            _responseDic = responseObject;
            [self.shopView.topImageView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"image1"]]];
            _chooseViewImgUrl = responseObject[@"shopLogo"];
            _stockArr = responseObject[@"goodsAttributes"];
            self.chooseView.goodsStock = _stockArr;
            
            [self.chooseView.productImgView sd_setImageWithURL:[NSURL URLWithString:_chooseViewImgUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
            self.chooseView.titleLabel.text = responseObject[@"goodsName"];
            _priceStr = [NSString stringWithFormat:@"¥%@(元)",responseObject[@"goodsPrice"]];
            self.chooseView.priceLabel.text = _priceStr;
            NSArray *attArr = responseObject[@"A_kind_of_attribute"];
            _type1 = attArr[0][@"key"];
            _sizeArr = attArr[0][@"keyval"];
            _type2 = attArr[1][@"key"];
            _colorArr = attArr[1][@"keyval"];
            [self.chooseView initTypeViewWithSizeArr:_sizeArr sizeName:_type1 colorArr:_colorArr colorName:_type2 stockDic:nil];
            if ([responseObject[@"Collection"] integerValue] == 1) {
                self.chooseView.likeButton.selected = YES;
            }
            
            //购物车小红点
            if ([responseObject[@"scart_Num"] integerValue] > 0) {
                self.shopView.shoppingCar.badgeValue = [NSString stringWithFormat:@"%@",responseObject[@"scart_Num"]];
                self.shopView.shoppingCar.badgeBGColor = [UIColor redColor];
                self.shopView.shoppingCar.badgeFont = [UIFont systemFontOfSize:10];
                self.shopView.shoppingCar.badgePadding = 3;
            }
            
            [_goodInfoDic setObject:responseObject[@"goodsName"] forKey:@"title"];
            [_goodInfoDic setObject:responseObject[@"goodsPrice"] forKey:@"price"];
            
            //用户留言
            NSMutableArray *dataArr = [NSMutableArray array];
            NSArray *arr = responseObject[@"messageList"];
            for (NSDictionary *dic in arr) {
                MessageModel *model = [[MessageModel alloc] init];
                model.paraDic = dic;
                [dataArr addObject:model];
            }
            self.productDetailView.dataSource = dataArr;
        }
    }];
    
    //商品详情 h5
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:self.goodID,@"gId", nil];
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"Commoditydetails_app" paraments:dic1 finish:^(id responseObject, NSError *error) {
        if (responseObject) {
            self.productDetailView.htmlStr = responseObject[@"Commoditydetails"];
        }
    }];
}

- (void)initilizeUserInterface {
    [self.shopView.productScrollView addSubview:self.chooseView];
    [self.shopView.productScrollView addSubview:self.productDetailView];
}

#pragma mark -- respondsToTap
- (void)respondsToTap:(UITapGestureRecognizer *)sender {
    [self dismissChooseView];
}

#pragma mark -- Button method
- (void)loadShopViewButtonMethod {
    __weak typeof(self)weakSelf = self;
    self.shopView.block = ^(NSInteger tag){
        switch (tag) {
            case 0: {//加入购物车
                if (self.shopView.productScrollView.contentOffset.x == SCREEN_WIDTH) {
                    [weakSelf loadChooseViewAnimation];
                    _isCar = YES;
                    _isSuspend = YES;
                } else {
                    [weakSelf requestForShoppingCar];
                    _isSuspend = NO;
                }
            } break;
                
            case 1: { //立即购买
                if (self.shopView.productScrollView.contentOffset.x == SCREEN_WIDTH) {
                    [weakSelf loadChooseViewAnimation];
                    _isCar = NO;
                    _isSuspend = YES;
                } else {
                    [weakSelf requestForOrderView];
                    _isSuspend = NO;
                }
            } break;
                
            case 2: {//返回
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } break;
                
            case 3: {//购物车
                
            } break;
                
            default:
                break;
        }
    };
    //推出的属性选择页
    self.otherChooseView.buttonBlock = ^(NSInteger tag){
        switch (tag) {
            case 0: {//关闭
                [weakSelf dismissChooseView];
            } break;
                
            case 1: {//确定
                if (_isCar == 1) {
                    [weakSelf requestForShoppingCar];
                } else {
                    [weakSelf requestForOrderView];
                }
            } break;
                
            default:
                break;
        }
    };
    //原本的属性选择页
    self.chooseView.buttonBlock = ^(NSInteger tag){
        switch (tag) {
            case 2: {//收藏
                if (weakSelf.chooseView.likeButton.selected) {
                    [weakSelf requestForLike];
                } else {
                    [weakSelf requestForCancelLike];
                }
            } break;
                
            case 3: {//分享
                
            } break;
                
            default:
                break;
        }
    };
}


#pragma mark -- Private method
//动画加载chooseview
- (void)loadChooseViewAnimation {
    [self.view addSubview:self.maskView];
    [self.otherChooseView.productImgView sd_setImageWithURL:[NSURL URLWithString:_chooseViewImgUrl] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    self.otherChooseView.bigPriceLabel.text = _priceStr;
    [self.otherChooseView initTypeViewWithSizeArr:_sizeArr sizeName:_type1 colorArr:_colorArr colorName:_type2 stockDic:nil];
    self.otherChooseView.goodsStock = _stockArr;
    [self.view addSubview:self.otherChooseView];
    [UIView animateWithDuration:0.3 animations:^{
        self.otherChooseView.frame = CGRectMake(0, 230, SCREEN_WIDTH, SCREEN_HEIGHT-230);
    }];
}

//动画消失chooseview
- (void)dismissChooseView {
    [UIView animateWithDuration:0.3 animations:^{
        self.otherChooseView.frame = CGRectMake(0, SCREEN_HEIGHT+100, SCREEN_WIDTH, SCREEN_HEIGHT-230);
    } completion:^(BOOL finished) {
        [self.otherChooseView removeFromSuperview];
        [self.maskView removeFromSuperview];
    }];
}

#pragma mark -- Network request
//立即购买
- (void)requestForOrderView {
    if ((_isSuspend && self.otherChooseView.typeID.length == 0) || (!_isSuspend && self.chooseView.typeID.length == 0)) {
        [MBProgressHUD showError:@"请选择商品属性"];
    } else {
        [MBProgressHUD showMessage:nil];
        NSDictionary *dic;
        NSString *typeStr;
        if (_isSuspend) {//推出的 otherChooseView
            [_goodInfoDic setObject:self.otherChooseView.goodCount forKey:@"count"];
            typeStr = self.otherChooseView.typeID;
            //网络请求参数
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_ID,@"userId",self.goodID,@"gid",self.otherChooseView.goodCount,@"storeNum",self.otherChooseView.typeID,@"gTypeInfo", nil];
        } else {
            [_goodInfoDic setObject:self.chooseView.goodCount forKey:@"count"];
            typeStr = self.chooseView.typeID;
            //网络请求参数
            dic = [[NSDictionary alloc] initWithObjectsAndKeys:USER_ID,@"userId",self.goodID,@"gid",self.chooseView.goodCount,@"storeNum",self.chooseView.typeID,@"gTypeInfo", nil];
        }
        [[NetWorkTool sharedTool] requestMethod:POST URL:@"buyAtOnce_app" paraments:dic finish:^(id responseObject, NSError *error) {
            [MBProgressHUD hideHUD];
            NSLog(@"--- %@",responseObject);
            if ([responseObject[@"ret"] isEqualToString:@"success"]) {
                //加入购物车成功
                [_goodInfoDic setObject:_chooseViewImgUrl forKey:@"img"];
                for (NSDictionary *dic in _stockArr) {
                    NSString *strID = [NSString stringWithFormat:@"%@",dic[@"id"]];
                    if ([strID isEqualToString:typeStr]) {
                        NSString *color = dic[@"skuColor"];
                        NSArray *colorArr = [color componentsSeparatedByString:@";"];
                        NSString *colorStr = [NSString stringWithFormat:@"%@:%@",colorArr[0],colorArr[1]];
                        [_goodInfoDic setObject:colorStr forKey:@"color"];
                        
                        NSString *size = dic[@"skuSize"];
                        NSArray *sizeArr = [size componentsSeparatedByString:@";"];
                        NSString *sizeStr = [NSString stringWithFormat:@"%@:%@",sizeArr[0],sizeArr[1]];
                        [_goodInfoDic setObject:sizeStr forKey:@"size"];
                        [_goodInfoDic setObject:responseObject[@"goodsAndNum"] forKey:@"goodsAndNum"];
                        OrderViewController *orderVC = [[OrderViewController alloc] init];
                        orderVC.dataArr = @[_goodInfoDic];
                        [self.navigationController pushViewController:orderVC animated:YES];
                    }
                }
            }
        }];
    }
}

//加入购物车
- (void)requestForShoppingCar {
    if ((_isSuspend && self.otherChooseView.typeID.length == 0) || (!_isSuspend && self.chooseView.typeID.length == 0)) {
        [MBProgressHUD showError:@"请选择商品属性"];
    } else {
        NSDictionary *dic;
        if (_isSuspend) {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:USER_ID,@"user_id",_responseDic[@"goodsId"],@"goods_id",self.otherChooseView.goodCount,@"GoodsNum",self.otherChooseView.typeID,@"GoodsAttr", nil];
        } else {
            dic = [NSDictionary dictionaryWithObjectsAndKeys:USER_ID,@"user_id",_responseDic[@"goodsId"],@"goods_id",self.chooseView.goodCount,@"GoodsNum",self.chooseView.typeID,@"GoodsAttr", nil];
        }
        [[NetWorkTool sharedTool]requestMethod:POST URL:@"addGoodsCart_app" paraments:dic finish:^(id responseObject, NSError *error) {
            NSLog(@"responseObject %@,%@",responseObject,error);
            if ([responseObject[@"ret"] isEqualToString:@"success"]) {
                //加入购物车成功
                [MBProgressHUD showSuccess:@"加入购物车成功"];
                self.shopView.shoppingCar.badgeValue = [NSString stringWithFormat:@"%@",responseObject[@"NUM"]];
                self.shopView.shoppingCar.badgeBGColor = [UIColor redColor];
                self.shopView.shoppingCar.badgeFont = [UIFont systemFontOfSize:10];
                self.shopView.shoppingCar.badgePadding = 3;
            }
        }];
    }
}

//收藏商品
- (void)requestForLike {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:USER_ID,@"user_id",_responseDic[@"goodsId"],@"goodsId", nil];
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"Collection_app" paraments:dic finish:^(id responseObject, NSError *error) {
        NSLog(@"add %@  %@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"收藏成功"];
        }
    }];
}

//取消收藏
- (void)requestForCancelLike {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_responseDic[@"goodsId"],@"gid",USER_ID,@"user_id", nil];
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"Collection_delete" paraments:dic finish:^(id responseObject, NSError *error) {
        NSLog(@"cancel  %@  %@",responseObject,error);
    }];
}

#pragma mark -- Getter method
- (ShopDetailView *)shopView {
    if (!_shopView) {
        _shopView = [ShopDetailView shareInstanceType];
    }
    return _shopView;
}

- (ChooseView *)chooseView {
    if (!_chooseView) {
        _chooseView = [ChooseView shareInstanceTypeWithBool:NO];
        _chooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.shopView.productScrollView.bounds.size.height - 67);
    }
    return _chooseView;
}

- (ProductDetailVIew *)productDetailView {
    if (!_productDetailView) {
        _productDetailView = [ProductDetailVIew shareInstanceType];
        _productDetailView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.shopView.productScrollView.bounds.size.height - 67);
    }
    return _productDetailView;
}

- (ChooseView *)otherChooseView {
    if (!_otherChooseView) {
        _otherChooseView = [ChooseView shareInstanceTypeWithBool:YES];
        _otherChooseView.frame = CGRectMake(0, SCREEN_HEIGHT+100, SCREEN_WIDTH, SCREEN_HEIGHT-230);
    }
    return _otherChooseView;
}

- (UIView *)maskView {
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.4];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToTap:)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}

@end
