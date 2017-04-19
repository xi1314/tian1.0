//
//  ChooseView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "ChooseView.h"
#import "ShopModel.h"

@implementation ChooseView

@synthesize sizeView,colorView,countView,stock,stockdic,sizearr,colorarr;

+ (instancetype)shareInstanceTypeWithBool:(BOOL)isSuspend {
    ChooseView *choose = [[NSBundle mainBundle] loadNibNamed:@"ChooseView" owner:self options:nil].firstObject;
    if (isSuspend) {
        choose.labelTopConstraint.constant = 50;
        choose.bigPriceLabel.hidden = NO;
        choose.closeButton.hidden = NO;
        choose.sureButton.hidden = NO;
        choose.priceLabel.hidden = YES;
        choose.priceLabel.hidden = YES;
        choose.shareButton.hidden = YES;
        choose.likeButton.hidden = YES;
        choose.titleLabel.hidden = YES;
        choose.productImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, -54, 108, 108)];
        choose.productImgView.layer.cornerRadius = 54;
        choose.productImgView.layer.masksToBounds = YES;
        choose.productImgView.backgroundColor = [UIColor redColor];
        [choose addSubview:choose.productImgView];
        choose.scrollViewBottom.constant = 90;
    } else {
        choose.productImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, -32, 64, 64)];
        choose.productImgView.layer.cornerRadius = 32;
        choose.productImgView.layer.masksToBounds = YES;
        [choose addSubview:choose.productImgView];
    }
    return choose;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    self.clipsToBounds = NO;
    //购买数量的视图
    countView = [[BuyCountView alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    [self.mainScrollView addSubview:countView];
    [countView.bt_add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    [countView.bt_reduce addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    //库存
    self.goodCount = @"1";
    self.stockLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-210, 0, 200, 50)];
    self.stockLabel.font = [UIFont systemFontOfSize:14];
    self.stockLabel.text = @"库存：10";
    [self.mainScrollView addSubview:self.stockLabel];
    self.stockLabel.textAlignment = NSTextAlignmentRight;

}


#pragma mark - Button method
#pragma mark - 数量加减
-(void)add
{
    int count =[countView.tf_count.text intValue];
    if (count < self.stock) {
        countView.tf_count.text = [NSString stringWithFormat:@"%d",count+1];
        self.goodCount = [NSString stringWithFormat:@"%d", count + 1];
    } else {
        [MBProgressHUD showError:@"数量超出上限"];
    }
}

-(void)reduce {
    int count =[countView.tf_count.text intValue];
    if (count > 1) {
        countView.tf_count.text = [NSString stringWithFormat:@"%d",count-1];
        self.goodCount =[NSString stringWithFormat:@"%d", count - 1];
    }
}


- (IBAction)button_action:(UIButton *)sender {
    if (sender.tag == 212) {//收藏
        sender.selected = !sender.selected;
    }
    if (self.buttonBlock) {
        self.buttonBlock(sender.tag - 210);
    }
}

#pragma mark - Private method
/**
 初始化数据

 @param sizeArr 属性一
 @param sizeName 属性一名称
 @param colorArr 属性二
 @param colorName 属性二名称
 @param stockDic 库存字典
 */
-(void)initTypeViewWithSizeArr:(NSArray *)sizeArr sizeName:(NSString *)sizeName colorArr:(NSArray *)colorArr colorName:(NSString *)colorName stockDic:(NSDictionary *)stockDic
{
    sizearr = sizeArr;
    colorarr = colorArr;
    stockdic = stockDic;
    //尺码
    sizeView = [[TypeView alloc] initWithFrame:CGRectMake(0, 17, self.frame.size.width, 50) andDatasource:sizearr :sizeName];
    sizeView.delegate = self;
    [self.mainScrollView addSubview:sizeView];
    sizeView.frame = CGRectMake(0, 17, self.frame.size.width, sizeView.height);
    //颜色分类
    colorView = [[TypeView alloc] initWithFrame:CGRectMake(0, sizeView.frame.size.height+17, self.frame.size.width, 50) andDatasource:colorarr :colorName];
    colorView.delegate = self;
    [self.mainScrollView addSubview:colorView];
    colorView.frame = CGRectMake(0,sizeView.frame.size.height+17, self.frame.size.width, colorView.height);
    //购买数量
    countView.frame = CGRectMake(0, colorView.frame.size.height + colorView.frame.origin.y+20, 200, 50);
    //库存数量
    self.stockLabel.frame = CGRectMake(SCREEN_WIDTH-210, colorView.frame.size.height+colorView.frame.origin.y+20, 200, 50);
    self.mainScrollView.contentSize = CGSizeMake(self.frame.size.width, countView.frame.size.height+countView.frame.origin.y);
}

#pragma mark - type delegete
-(void)btnindex:(int)tag
{
    // 通过seletIndex是否>=0来判断尺码和颜色是否被选择，－1则是未选择状态
    if (sizeView.seletIndex >= 0 && colorView.seletIndex >= 0) {
        
        //属性一和属性二都选择的时候
        NSString *size =[sizearr objectAtIndex:sizeView.seletIndex];
        NSString *color =[colorarr objectAtIndex:colorView.seletIndex];
        
        for (GoodStockModel *model in self.goodsStock) {
            NSString *type1 = model.commodity_attribute_1;
            NSString *type2 = model.commodity_attribute_2;
            if ([type1 containsString:size] && [type2 containsString:color]) {
                stock = [model.skuStock intValue];
                self.stockLabel.text = [NSString stringWithFormat:@"库存：%@",model.skuStock];
                [self reloadTypeBtn:model :colorarr :colorView];
                [self reloadTypeBtn:model :sizearr :sizeView];
                self.typeID = [NSString stringWithFormat:@"%@",model.ID];
            }
        }
        
    } else if (sizeView.seletIndex ==-1 && colorView.seletIndex == -1) {
        //尺码和颜色都没选的时候
        stock = 100000;
        //全部恢复可点击状态
        [self resumeBtn:colorarr :colorView];
        [self resumeBtn:sizearr :sizeView];
        
    } else if (sizeView.seletIndex ==-1 && colorView.seletIndex >= 0) {
        //只选了属性二
        NSString *color =[colorarr objectAtIndex:colorView.seletIndex];
        //根据所选颜色 取出该颜色对应所有尺码的库存字典
        [self resumeBtn:colorarr :colorView];
        
        for (GoodStockModel *model in self.goodsStock) {
            NSString *string = model.commodity_attribute_1;
            if ([string containsString:color]) {
                self.stockLabel.text = [NSString stringWithFormat:@"库存：%@",model.skuStock];
            }
        }
        stock = 100000;

    } else if (sizeView.seletIndex >= 0 && colorView.seletIndex == -1) {
        NSString *size = [sizearr objectAtIndex:sizeView.seletIndex];
        
        // 只有一种属性
        if (!colorarr.count) {

            for (GoodStockModel *model in self.goodsStock) {
                NSString *type1 = model.commodity_attribute_1;

                if ([type1 containsString:size]) {
                    stock = [model.skuStock intValue];
                    self.stockLabel.text = [NSString stringWithFormat:@"库存：%@",model.skuStock];
                    [self reloadTypeBtn:model :sizearr :sizeView];
                    self.typeID = [NSString stringWithFormat:@"%@",model.ID];
                }
            }
            
        } else {
            //根据所选尺码 取出该尺码对应所有颜色的库存字典
            [self resumeBtn:sizearr :sizeView];
            for (GoodStockModel *model in self.goodsStock) {
                NSString *type = model.commodity_attribute_1;
                if ([type containsString:size]) {
                    self.stockLabel.text = [NSString stringWithFormat:@"库存：%@",model.skuStock];
                }
            }
        }
        stock = 100000;
    }
}

// 恢复按钮的原始状态
-(void)resumeBtn:(NSArray *)arr :(TypeView *)view
{
    for (int i = 0; i< arr.count; i++) {
        UIButton *btn =(UIButton *) [view viewWithTag:100+i];
        btn.enabled = YES;
        btn.selected = NO;
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:WWColor(163, 163, 163) forState:0];
        btn.layer.borderColor = LINE_COLOR.CGColor;
        [btn setTitleColor:THEME_COLOR forState:UIControlStateSelected];
        if (view.seletIndex == i) {
            btn.selected = YES;
            btn.layer.borderColor = THEME_COLOR.CGColor;
        }
    }
}

// 根据所选的尺码或者颜色对应库存量 确定哪些按钮不可选
-(void)reloadTypeBtn:(GoodStockModel *)model :(NSArray *)arr :(TypeView *)view
{
    for (int i = 0; i<arr.count; i++) {
        int count = [model.skuStock intValue];
        UIButton *btn =(UIButton *)[view viewWithTag:100+i];
        btn.selected = NO;
        //库存为零 不可点击
        if (count == 0) {
            btn.enabled = NO;
            [btn setTitleColor:WWColor(163, 163, 163) forState:0];
        } else {
            btn.enabled = YES;
            [btn setTitleColor:WWColor(163, 163, 163) forState:0];
            btn.layer.borderColor = LINE_COLOR.CGColor;
        }
        //根据seletIndex 确定用户当前点了那个按钮
        if (view.seletIndex == i) {
            btn.selected = YES;
            [btn setTitleColor:THEME_COLOR forState:0];
            btn.layer.borderColor = THEME_COLOR.CGColor;
            btn.backgroundColor = [UIColor whiteColor];
        }
    }
}


@end
