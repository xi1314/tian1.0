//
//  ChooseView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeView.h"
#import "BuyCountView.h"

typedef void(^ChooseButtonBlock)(NSInteger tag);

@interface ChooseView : UIView<UITextFieldDelegate,UIAlertViewDelegate,TypeSeleteDelegete> {
//    NSString *_typeID;      //选择的属性ID
//    NSInteger _goodCount;   //购买数量
}
@property (copy, nonatomic) ChooseButtonBlock buttonBlock;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView; //滑动视图
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;          //商品名称
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;        //发货地
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;          //价格
@property (weak, nonatomic) IBOutlet UIButton *shareButton;        //分享
@property (weak, nonatomic) IBOutlet UIButton *likeButton;         //喜欢
@property (strong, nonatomic) UIImageView *productImgView;         //商品图片
@property (strong, nonatomic) NSArray *goodsStock;                 //商品库存
@property (copy, nonatomic) NSString *typeID;                      //选择的属性ID
@property (copy, nonatomic) NSString *goodCount;                   //购买数量

//------view悬浮推出时需要用到的属性----
@property (assign, nonatomic) BOOL isSuspend;                      //判断是否是悬浮页
@property (weak, nonatomic) IBOutlet UILabel *bigPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
//地址label top与view的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelTopConstraint;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;        //确定按钮
//滑动view底边与view的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewBottom;


//-----商品属性-----
@property(nonatomic, strong)TypeView *sizeView;                    //尺寸
@property(nonatomic, strong)TypeView *colorView;                   //颜色
@property(nonatomic, strong)BuyCountView *countView;               //数量选择
@property(nonatomic, strong)NSArray *sizearr;                      //尺寸data
@property(nonatomic, strong)NSArray *colorarr;                     //颜色data
@property(nonatomic, strong)NSDictionary *stockdic;                //库存data
@property(nonatomic, strong)UILabel *stockLabel;                   //库存
@property(nonatomic) int stock;

-(void)initTypeViewWithSizeArr:(NSArray *)sizeArr sizeName:(NSString *)sizeName colorArr:(NSArray *)colorArr colorName:(NSString *)colorName stockDic:(NSDictionary *)stockDic;


//+ (instancetype)shareInstanceType;
+ (instancetype)shareInstanceTypeWithBool:(BOOL)isSuspend;

@end
