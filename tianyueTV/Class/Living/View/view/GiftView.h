//
//  GiftView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/11/29.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftBtn.h"
@interface GiftView : UIView
//我的财富
@property(nonatomic,strong)UILabel *wealthLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *typeLabel;
//充值按钮
@property(nonatomic,strong)UIButton *topupBtn;
//在线获取的金币
@property(nonatomic,strong)UILabel *coinsLabel;
@property(nonatomic,strong)UILabel *typeLabel1;
//分割线
@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,strong)UIImageView *longLine;
//礼物
@property(nonatomic,strong)GiftBtn *giftBtn1;@property(nonatomic,strong)GiftBtn *giftBtn2;
@property(nonatomic,strong)GiftBtn *giftBtn3;@property(nonatomic,strong)GiftBtn *giftBtn4;
@property(nonatomic,strong)GiftBtn *giftBtn5;@property(nonatomic,strong)GiftBtn *giftBtn6;

@property(nonatomic,strong)UICollectionView *giftCollectionView;

@end
