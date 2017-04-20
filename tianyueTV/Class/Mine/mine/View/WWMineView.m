//
//  WWMineView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineView.h"
#import "WWHyperlinksButton.h"


@interface WWMineView()
- (void)initializeUserInterface; /**< 初始化用户界面 */

//@property (nonatomic,strong) UIView *littleHeadView;
@property (nonatomic,strong) UIView *bottomView;



@property (nonatomic,strong) UILabel *priceLabel;//单价
//@property (nonatomic,strong) UILabel *qianmingLabel;//个性签名


@property (nonatomic,strong) UIImageView *yuebiImageView;//越币标示图片
@property (nonatomic,strong) UIImageView *lingtaoImageView;//灵🍑图片

@property (nonatomic,strong) UILabel *secondPrice;//第二货币单价

@property (nonatomic,strong) UIButton *rechargeButton;//充值按钮
@property (nonatomic,strong) UIButton *bianjiButton;//编辑按钮
@property (nonatomic,strong) UIView *moneyBgView;//货币背景

// 线条
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIView *lineV;
@property (nonatomic,strong) UIView *lineH;

// 按钮
@property (nonatomic,strong) WWMyViewButton *myGuanZhu;//我的关注
@property (nonatomic,strong) WWMyViewButton *playHistory;//播放历史

@property (nonatomic,strong) WWMyViewButton *zhanghaoanquan;//账号安全
@property (nonatomic,strong) WWMyViewButton *settingButton;//设置按钮


@property (nonatomic,strong) UIButton *firstButton;//个人作品及视频
@property (nonatomic,strong) UILabel *firstlongLbael;
@property (nonatomic,strong) UILabel *firstshortLabel;
@property (nonatomic,strong) UIButton *secondButton;//关注的主播
@property (nonatomic,strong) UILabel *secondlongLabel;
@property (nonatomic,strong) UILabel *secondshortLabel;
@property (nonatomic,strong) UIButton *thirdButton;//我的直播
@property (nonatomic,strong) UILabel *thirdlongLabel;
@property (nonatomic,strong) UIButton *forthButton;//越币充值
@property (nonatomic,strong) UILabel *forthlongLabel;
//@property (nonatomic,strong) UIButton *fiveButton;//设置
@property (nonatomic,strong) UILabel *fivelongLabel;
@property (nonatomic,strong) UIButton *messageButton;//信息



@end

@implementation WWMineView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self initializeUserInterface];
    }
    return self;
}

- (void)initializeUserInterface{
    [self addSubview:self.bigHeadView];
//    [self.bigHeadView autoConstrainAttribute:ALAttributeTop toAttribute:ALAttributeTop ofView:self];
    [self.bigHeadView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.bigHeadView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.bigHeadView autoPinEdgeToSuperviewEdge:ALEdgeRight];
//    [self.bigHeadView autoConstrainAttribute:ALAttributeLeft toAttribute:ALAttributeLeft ofView:self];
//    [self.bigHeadView autoConstrainAttribute:ALAttributeRight toAttribute:ALAttributeRight ofView:self];
    [self.bigHeadView autoSetDimension:ALDimensionHeight toSize:kHeightChange(375) + 20];
   
    
    [self addSubview:self.bottomView];
    [self.bottomView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bigHeadView withOffset:0];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:0];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:0];
    [self.bottomView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];

    
//    [self addSubview:self.line];
//    [self.line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bigHeadView];
//    [self.line autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self withOffset:0.6667*SCREEN_WIDTH];
//    [self.line autoSetDimensionsToSize:CGSizeMake(1, 0.3823*SCREEN_HEIGHT)];
//
//    
//    [self addSubview:self.lineV];
//    [self.lineV autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.3333*SCREEN_WIDTH];
//    [self.lineV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bigHeadView];
//    [self.lineV autoSetDimensionsToSize:CGSizeMake(1, 0.3823*SCREEN_HEIGHT)];
////    [self.lineV mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.left.equalTo(self.view.mas_left).with.offset(0.3333*SCREEN_WIDTH);
////        make.top.equalTo(self.bigHeadView.mas_bottom).with.offset(0);
////        make.height.mas_equalTo(0.3823*SCREEN_HEIGHT);
////        make.width.mas_equalTo(1);
////    }];
//    
//    [self addSubview:self.lineH];
//    [self.lineH autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bigHeadView withOffset:0.3823*SCREEN_HEIGHT * 0.5];
//    [self.lineH autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//    [self.lineH autoSetDimensionsToSize:CGSizeMake(SCREEN_WIDTH, 1)];

    // 头像
    [self.bigHeadView addSubview:self.headImages];
    [self.headImages autoSetDimensionsToSize:CGSizeMake(kWidthChange(174), kWidthChange(174))];
    [self.headImages autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(80)+ 20];
    [self.headImages autoAlignAxisToSuperviewAxis:ALAxisVertical];

    
    //认证标志
    [self.bigHeadView addSubview:self.zhuboImage];
//    [self.zhuboImage autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.headImages];
    [self.zhuboImage autoSetDimensionsToSize:CGSizeMake(kHeightChange(40), kHeightChange(45))];
    [self.zhuboImage autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(292)];
    [self.zhuboImage autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.headImages withOffset:kHeightChange(2)];
    NSString *bcard = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"bCard"];
    NSInteger bcar = [bcard integerValue];
    if (bcar == 1) {
        self.zhuboImage.hidden = NO;
    }
    
    //昵称
    [self addSubview:self.nameLabel];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(270)];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(270)];
    [self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headImages withOffset:kHeightChange(45)];



    
    //编辑按钮
    [self addSubview:self.bianjiButton];
    [self.bianjiButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.bianjiButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50)];
    [self.bianjiButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(88), 40)];
    
    //货币背景视图
    
    [self.bottomView addSubview:self.moneyBgView];
    [self.moneyBgView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.moneyBgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.moneyBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.moneyBgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(110)];
    
    
    
    //我的财富
//    [self.moneyBgView addSubview:self.myMoney];
//    [self.myMoney autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
//    [self.myMoney autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
//    [self.myMoney autoSetDimension:ALDimensionWidth toSize:kWidthChange(180)];
    
    //越币图片
    [self.moneyBgView addSubview:self.yuebiImageView];
    [self.yuebiImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.yuebiImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.yuebiImageView autoSetDimensionsToSize:CGSizeMake(kWidthChange(40), kWidthChange(40))];
    
    
    //越币
   
//    [self.moneyLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:kHeightChange(14)];
    [self.moneyBgView addSubview:self.priceLabel];
    [self.priceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.yuebiImageView withOffset:kWidthChange(15)];
    [self.priceLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.moneyBgView addSubview:self.moneyLabel];
    [self.moneyLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.priceLabel withOffset:kWidthChange(15)];
    [self.moneyLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    

    
    
    
    //充值按钮
    [self.moneyBgView addSubview:self.rechargeButton];
    [self.rechargeButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.rechargeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(40)];
    [self.rechargeButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(140), kHeightChange(50))];
    
    //灵桃图片
    [self.moneyBgView addSubview:self.lingtaoImageView];
    [self.lingtaoImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.moneyLabel withOffset:kWidthChange(110)];
    [self.lingtaoImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.lingtaoImageView autoSetDimensionsToSize:CGSizeMake(kWidthChange(40), kWidthChange(40))];
    
    //第二货币
    [self.moneyBgView addSubview:self.secondPrice];
    [self.secondPrice autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lingtaoImageView withOffset:kWidthChange(15)];
    [self.secondPrice autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.moneyBgView addSubview:self.secondMoney];
    [self.secondMoney autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.secondMoney autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.secondPrice withOffset:kWidthChange(15)];
    
    
    //我的关注
    [self.bottomView addSubview:self.myGuanZhu];
    [self.myGuanZhu autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.moneyBgView withOffset:kHeightChange(30)];
    [self.myGuanZhu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.myGuanZhu autoSetDimensionsToSize:CGSizeMake(kWidthChange(225), kHeightChange(234))];
    
    //播放历史
    [self.bottomView addSubview:self.playHistory];
    [self.playHistory autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.moneyBgView withOffset:kHeightChange(30)];
    [self.playHistory autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.playHistory autoSetDimensionsToSize:CGSizeMake(kWidthChange(225), kHeightChange(234))];
    
    //主播认证
    [self.bottomView addSubview:self.zhuBoRenzheng];
    [self.zhuBoRenzheng autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.moneyBgView withOffset:kHeightChange(30)];
    [self.zhuBoRenzheng autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.zhuBoRenzheng autoSetDimensionsToSize:CGSizeMake(kWidthChange(225), kHeightChange(234))];
    NSInteger baudit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"baudit"] integerValue];
    if (baudit == 1) {
      self.zhuBoRenzheng.titlew.text = @"我的直播间";
    }
    
    //账号安全
    [self.bottomView addSubview:self.zhanghaoanquan];
    [self.zhanghaoanquan autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.myGuanZhu withOffset:kHeightChange(14)];
    [self.zhanghaoanquan autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.zhanghaoanquan autoSetDimensionsToSize:CGSizeMake(kWidthChange(225), kHeightChange(234))];
    
    //设置
    [self.bottomView addSubview:self.settingButton];
    [self.settingButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.playHistory withOffset:kHeightChange(14)];
    [self.settingButton autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.settingButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(225), kHeightChange(234))];
    
    //设置
    [self.bigHeadView addSubview:self.messageButton];
    [self.messageButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kHeightChange(20)];
    [self.messageButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(0)+ 20];
    
//    //信息
//    [self.bigHeadView addSubview:self.messageButton];
//    [self.messageButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kHeightChange(20)];
//    [self.messageButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20)+ 20];
    
    
//    // 个人作品及视频
//    [self addSubview:self.firstButton];
//    [self.firstButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bigHeadView withOffset:kHeightChange(69)];
//    [self.firstButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.lineV withOffset:kWidthChange(-92)];
//    [self.firstButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(72), kWidthChange(72))];
//    
//    [self addSubview:self.firstlongLbael];
//    [self.firstlongLbael autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.firstButton withOffset:kHeightChange(35)];
//    [self.firstlongLbael autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//    [self.firstlongLbael autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.lineV withOffset:0];
//    
//    [self addSubview:self.firstshortLabel];
//    [self.firstshortLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.firstlongLbael withOffset:kHeightChange(5)];
//    [self.firstshortLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//    [self.firstshortLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.lineV withOffset:0];
//    
//    //关注的主播
//    [self addSubview:self.secondButton];
//    [self.secondButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bigHeadView withOffset:kHeightChange(69)];
//    [self.secondButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.line withOffset:kWidthChange(-92)];
//    [self.secondButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(72), kWidthChange(72))];
//    
//    [self addSubview:self.secondlongLabel];
//    [self.secondlongLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.secondButton withOffset:kHeightChange(35)];
//     [self.secondlongLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineV withOffset:0];
//    [self.secondlongLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.line withOffset:0];
//    
//    //我的直播
//    [self addSubview:self.thirdButton];
//    [self.thirdButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bigHeadView withOffset:kHeightChange(69)];
//    [self.thirdButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(92)];
//    [self.thirdButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(72), kWidthChange(72))];
//    
//    [self addSubview:self.thirdlongLabel];
//    [self.thirdlongLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.thirdButton withOffset:kHeightChange(35)];
//    [self.thirdlongLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
//    [self.thirdlongLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.line withOffset:0];
//    //越币充值
//    [self addSubview:self.forthButton];
//    [self.forthButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lineH withOffset:kHeightChange(69)];
//    [self.forthButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.lineV withOffset:kWidthChange(-92)];
//    [self.forthButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(72), kWidthChange(72))];
//    
//    [self addSubview:self.forthlongLabel];
//    [self.forthlongLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.forthButton withOffset:kHeightChange(35)];
//    [self.forthlongLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
//    [self.forthlongLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.lineV withOffset:0];
//
//    
//    //设置
//    [self addSubview:self.fiveButton];
//    [self.fiveButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.lineH withOffset:kHeightChange(69)];
//    [self.fiveButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.line withOffset:kWidthChange(-92)];
//    [self.fiveButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(72), kWidthChange(72))];
//    
//    [self addSubview:self.fivelongLabel];
//    [self.fivelongLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.fiveButton withOffset:kHeightChange(35)];
//    [self.fivelongLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineV withOffset:0];
//    [self.fivelongLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.line withOffset:0];
}

#pragma mark ----懒加载----


- (UIImageView *)lingtaoImageView{
    if (!_lingtaoImageView) {
        _lingtaoImageView = [[UIImageView alloc] init];
        _lingtaoImageView.image = [UIImage imageNamed:@"桃子(1)"];
    }
    return _lingtaoImageView;
}

- (UIImageView *)yuebiImageView{
    if (!_yuebiImageView) {
        _yuebiImageView = [[UIImageView alloc] init];
        _yuebiImageView.image = [UIImage imageNamed:@"图层-13"];
    }
    return _yuebiImageView;
}

- (WWMyViewButton *)settingButton{
    if (!_settingButton) {
        _settingButton = [[WWMyViewButton alloc] init];
        //        _zhanghaoanquan.bacimagesize = CGSizeMake(kWidthChange(62), kHeightChange(54));
        
        _settingButton.backImageView.image = [UIImage imageNamed:@"设置-2"];
        _settingButton.titlew.text = @"设置";
        _settingButton.layer.borderWidth = 1.0;
        _settingButton.layer.borderColor = WWColor(212, 212, 212).CGColor;
        [_settingButton addTarget:self action:@selector(respondsToFiveButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingButton;

}

- (WWMyViewButton *)zhanghaoanquan{
    if (!_zhanghaoanquan) {
        _zhanghaoanquan = [[WWMyViewButton alloc] init];
//        _zhanghaoanquan.bacimagesize = CGSizeMake(kWidthChange(62), kHeightChange(54));
    
        _zhanghaoanquan.backImageView.image = [UIImage imageNamed:@"专业安全"];
        _zhanghaoanquan.titlew.text = @"账号安全";
        _zhanghaoanquan.layer.borderWidth = 1.0;
        _zhanghaoanquan.layer.borderColor = WWColor(212, 212, 212).CGColor;
        [_zhanghaoanquan addTarget:self action:@selector(respondsToForthButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zhanghaoanquan;
}
- (WWMyViewButton *)zhuBoRenzheng{
    if (!_zhuBoRenzheng) {
        _zhuBoRenzheng = [[WWMyViewButton alloc] init];
//        _zhuBoRenzheng.bacimagesize = CGSizeMake(kWidthChange(62), kHeightChange(54));
        _zhuBoRenzheng.backImageView.image = [UIImage imageNamed:@"直播_1"];
        _zhuBoRenzheng.titlew.text = @"主播认证";
        _zhuBoRenzheng.layer.borderWidth = 1.0;
        _zhuBoRenzheng.layer.borderColor = WWColor(212, 212, 212).CGColor;
        [_zhuBoRenzheng addTarget:self action:@selector(respondsTozhuBoRenzheng:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zhuBoRenzheng;
}
- (WWMyViewButton *)playHistory{
    if (!_playHistory) {
        _playHistory = [[WWMyViewButton alloc] init];
//        _playHistory.bacimagesize = CGSizeMake(kWidthChange(62), kHeightChange(54));
        _playHistory.backImageView.image = [UIImage imageNamed:@"历史"];
        _playHistory.titlew.text = @"播放历史";
        _playHistory.layer.borderWidth = 1.0;
        _playHistory.layer.borderColor = WWColor(212, 212, 212).CGColor;
        [_playHistory addTarget:self action:@selector(respondsToSecondButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playHistory;
}
- (WWMyViewButton *)myGuanZhu{
    if (!_myGuanZhu) {
        _myGuanZhu = [[WWMyViewButton alloc] init];
//        _myGuanZhu.bacimagesize = CGSizeMake(kWidthChange(62), kHeightChange(54));
        _myGuanZhu.backImageView.image = [UIImage imageNamed:@"矩形-1-拷贝-2"];
        _myGuanZhu.titlew.text = @"我的关注";
        _myGuanZhu.layer.borderWidth = 1.0;
        _myGuanZhu.layer.borderColor = WWColor(212, 212, 212).CGColor;
        [_myGuanZhu addTarget:self action:@selector(firstButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myGuanZhu;
}

//第二货币单价
-(UILabel *)secondPrice{
    if (!_secondPrice) {
        _secondPrice = [[UILabel alloc] init];
        _secondPrice.text = @"灵桃";
        _secondPrice.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _secondPrice.textColor = WWColor(84, 84, 84);
    }
    return _secondPrice;
}
//第二货币
- (UILabel *)secondMoney{
    if (!_secondMoney) {
        _secondMoney = [[UILabel alloc] init];
        
//        _secondMoney.text            = @"0";
        _secondMoney.textAlignment   = NSTextAlignmentCenter;
        _secondMoney.font            = [UIFont systemFontOfSize:kWidthChange(28)];
        _secondMoney.textColor       = WWColor(193, 52, 50);
        
    }
    return _secondMoney;
}



//充值按钮
- (UIButton *)rechargeButton{
    if (!_rechargeButton) {
        _rechargeButton = [[UIButton alloc] init];
        [_rechargeButton setTitle:@"越币充值" forState:UIControlStateNormal];
        _rechargeButton.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(20)];
//        _rechargeButton.titleLabel.textColor = WWColor(214, 71, 76);
        [_rechargeButton setTitleColor:WWColor(214, 71, 76) forState:UIControlStateNormal];
//        [_rechargeButton setBackgroundImage:[UIImage imageNamed:@"redCornerJuxing"] forState:UIControlStateNormal];
        [_rechargeButton setBackgroundColor:[UIColor whiteColor]];
      
        [_rechargeButton addTarget:self action:@selector(respondsToRechargeButton:) forControlEvents:UIControlEventTouchUpInside];
        _rechargeButton.layer.cornerRadius = kWidthChange(15);
        _rechargeButton.layer.masksToBounds = YES;
        _rechargeButton.layer.borderWidth = 1.0f;
        _rechargeButton.layer.borderColor = WWColor(214, 71, 76).CGColor;
    }
    return _rechargeButton;
}

//越币单价
- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.text = @"越币";
        _priceLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _priceLabel.textColor = WWColor(84, 84, 84);
    }
    return _priceLabel;
}



//货币背景视图
- (UIView *)moneyBgView{
    if (!_moneyBgView) {
        _moneyBgView = [[UIView alloc] init];
        _moneyBgView.backgroundColor = [UIColor whiteColor];
        _moneyBgView.layer.borderWidth = 1.0f;
        _moneyBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _moneyBgView;
}

//信息
- (UIButton *)messageButton{
    if (!_messageButton) {
        _messageButton = [[WWHyperlinksButton alloc] init];
//        [_messageButton setImage:[UIImage imageNamed:@"信息"] forState:UIControlStateNormal];
        [_messageButton setTitle:@"反馈" forState:UIControlStateNormal];
//        [_messageButton setTitle:@"设置" forState:UIControlStateNormal];
        _messageButton.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(26)];
//        _messageButton.titleLabel.textColor = WWColor(232, 232, 232);
        [_messageButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        
        [_messageButton addTarget:self action:@selector(respondsToMessageButton:) forControlEvents:UIControlEventTouchUpInside];
//        _messageButton.hidden = YES;
    }
    return _messageButton;
}

//设置
//- (UIButton *)fiveButton{
//    if (!_fiveButton) {
//        _fiveButton = [[UIButton alloc] init];
////        [_fiveButton setImage:[UIImage imageNamed:@"设置"] forState:UIControlStateNormal];
//        [_fiveButton setTitle:@"设置" forState:UIControlStateNormal];
//        _fiveButton.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(36)];
//        _fiveButton.titleLabel.textColor = WWColor(232, 232, 232);
//        [_fiveButton addTarget:self action:@selector(respondsToFiveButton:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _fiveButton;
//}
- (UILabel *)fivelongLabel{
    if (!_fivelongLabel) {
        _fivelongLabel                  = [[UILabel alloc] init];
        _fivelongLabel.text             = @"设置";
        _fivelongLabel.textColor        = [UIColor blackColor];
        _fivelongLabel.font             = [UIFont systemFontOfSize:kWidthChange(26)];
        _fivelongLabel.textAlignment    = NSTextAlignmentCenter;
    }
    return _fivelongLabel;
}

//越币充值
- (UIButton *)forthButton{
    if (!_forthButton) {
        _forthButton = [[UIButton alloc] init];
        [_forthButton setImage:[UIImage imageNamed:@"下载(20)"] forState:UIControlStateNormal];
        [_forthButton addTarget:self action:@selector(respondsToForthButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forthButton;
}
- (UILabel *)forthlongLabel{
    if (!_forthlongLabel) {
        _forthlongLabel                 = [[UILabel alloc] init];
        _forthlongLabel.text            = @"账号安全";
        _forthlongLabel.textColor       = [UIColor blackColor];
        _forthlongLabel.font            = [UIFont systemFontOfSize:kWidthChange(26)];
        _forthlongLabel.textAlignment   = NSTextAlignmentCenter;
    }
    return _forthlongLabel;
}

//我的直播
- (UIButton *)thirdButton{
    if (!_thirdButton) {
        _thirdButton = [[UIButton alloc] init];
        [_thirdButton setImage:[UIImage imageNamed:@"群直播card-icon"] forState:UIControlStateNormal];
        [_thirdButton addTarget:self action:@selector(respondsToThirdButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _thirdButton;
}
- (UILabel *)thirdlongLabel{
    if (!_thirdlongLabel) {
        _thirdlongLabel                 = [[UILabel alloc] init];
        _thirdlongLabel.text            = @"我的直播";
        _thirdlongLabel.textColor       = [UIColor blackColor];
        _thirdlongLabel.font            = [UIFont systemFontOfSize:kWidthChange(26)];
        _thirdlongLabel.textAlignment   = NSTextAlignmentCenter;
    }
    return _thirdlongLabel;
}

//关注的主播
- (UIButton *)secondButton{
    if (!_secondButton) {
        _secondButton = [[UIButton alloc] init];
        [_secondButton setImage:[UIImage imageNamed:@"下载(19)"] forState:UIControlStateNormal];
        [_secondButton addTarget:self action:@selector(respondsToSecondButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondButton;
}
- (UILabel *)secondlongLabel{
    if (!_secondlongLabel) {
        _secondlongLabel                = [[UILabel alloc] init];
        _secondlongLabel.text           = @"我的订阅";
        _secondlongLabel.textColor      = [UIColor blackColor];
        _secondlongLabel.font           = [UIFont systemFontOfSize:kWidthChange(26)];
        _secondlongLabel.textAlignment  = NSTextAlignmentCenter;
    }
    return _secondlongLabel;
}
- (UILabel *)secondshortLabel{
    if (!_secondshortLabel) {
        _secondshortLabel               = [[UILabel alloc] init];
        _secondshortLabel.textColor     = [UIColor blackColor];
        _secondshortLabel.text          =@"";
        _secondshortLabel.font          = [UIFont systemFontOfSize:kWidthChange(26)];
        _secondshortLabel.textAlignment = NSTextAlignmentCenter;
        _secondshortLabel.hidden        = YES;
        
    }
    return _secondshortLabel;
}

//个人作品及视频
- (UIButton *)firstButton{
    if (!_firstButton) {
        _firstButton = [[UIButton alloc] init];
        [_firstButton setImage:[UIImage imageNamed:@"下载(21)"] forState:UIControlStateNormal];
        [_firstButton addTarget:self action:@selector(firstButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstButton;
}
- (UILabel *)firstlongLbael{
    if (!_firstlongLbael) {
        _firstlongLbael                 = [[UILabel alloc] init];
        _firstlongLbael.text            = @"个人资料";
        _firstlongLbael.textColor       = [UIColor blackColor];
        _firstlongLbael.font            = [UIFont systemFontOfSize:kWidthChange(26)];
        _firstlongLbael.textAlignment   = NSTextAlignmentCenter;
    }
    return _firstlongLbael;
}
- (UILabel *)firstshortLabel{
    if (!_firstshortLabel) {
        _firstshortLabel            = [[UILabel alloc] init];
        _firstshortLabel.textColor  = [UIColor blackColor];
        _firstshortLabel.text       =@"";
        _firstshortLabel.font       = [UIFont systemFontOfSize:12];
        _firstshortLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _firstshortLabel;
}

// 编辑按钮
- (UIButton *)bianjiButton{
    if (!_bianjiButton) {
        _bianjiButton           = [[UIButton alloc] init];
        [_bianjiButton setTitle:@"编辑" forState:UIControlStateNormal];
        _bianjiButton.tintColor = [UIColor whiteColor];
        [_bianjiButton addTarget:self action:@selector(respondsToBianjiButton:) forControlEvents:UIControlEventTouchUpInside];
        _bianjiButton.hidden    = YES;
    }
    return _bianjiButton;
}


// 越币
- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel                 = [[UILabel alloc] init];
//        _moneyLabel.text            = @"0";
        _moneyLabel.textAlignment   = NSTextAlignmentCenter;
        _moneyLabel.font            = [UIFont systemFontOfSize:kWidthChange(28)];
        _moneyLabel.textColor       = WWColor(193, 52, 50);
    }
    return _moneyLabel;
}
//[[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"nickName"] forKey:@"nickName"];
//[[NSUserDefaults standardUserDefaults]setObject:responseObject[@"user"][@"bCard"] forKey:@"bCard"];
//昵称
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel                  = [[UILabel alloc] init];
//        _nameLabel.text             = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
        _nameLabel.text = @"萌萌哒小猪";
        _nameLabel.textColor        = [UIColor whiteColor];
        _nameLabel.textAlignment    = NSTextAlignmentCenter;
        _nameLabel.font             = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _nameLabel;
}

// 认证标志
- (UIImageView *)zhuboImage{
    if (!_zhuboImage) {
        _zhuboImage                 = [[UIImageView alloc] init];
        _zhuboImage.backgroundColor = [UIColor clearColor];
        _zhuboImage.image           = [UIImage imageNamed:@"主播"];
        _zhuboImage.hidden          = YES;
    }
    return _zhuboImage;
}

// 头像
- (UIImageView *)headImages{
    if (!_headImages) {
        _headImages                     = [[UIImageView alloc] init];
        _headImages.layer.cornerRadius  = kWidthChange(87);
        _headImages.layer.masksToBounds = YES;
//        _headImages.image               = [UIImage imageNamed:@"897"];
        _headImages.layer.borderColor   = [UIColor whiteColor].CGColor;
        //        _headImages.layer.backgroundColor
        _headImages.layer.borderWidth   = 2.0f;
        _headImages.userInteractionEnabled = YES;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureClicked)];
        [_headImages addGestureRecognizer:gesture];
    }
    return _headImages;
}


// 线条
-(UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = WWColor(235, 235, 235);
    }
    return _line;
}

-(UIView *)lineV{
    if (!_lineV) {
        _lineV = [[UIView alloc] init];
        _lineV.backgroundColor = WWColor(235, 235, 235);
    }
    return _lineV;
}

-(UIView *)lineH{
    if (!_lineH) {
        _lineH = [[UIView alloc] init];
        _lineH.backgroundColor = WWColor(235, 235, 235);
    }
    return _lineH;
}
// 下面背景
- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView                 = [[UIView alloc] initWithFrame:CGRectMake(0,0.351 *SCREEN_HEIGHT, self.frame.size.width, 1)];
        _bottomView.backgroundColor = WWColor(242, 242, 242);
        //        _bottomView.layer.borderWidth = 1.0f;
    }
    return _bottomView;
}

-(UIImageView *)bigHeadView{
    if (!_bigHeadView) {
        _bigHeadView                            = [[UIImageView alloc] init];
        UIImage *images                         = [UIImage imageNamed:@"897"];
        _bigHeadView.image                      = images;
        // 实现模糊效果
        UIBlurEffect *blur                      = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView    = [[UIVisualEffectView alloc] initWithEffect:blur];
        visualEffectView.frame                  = self.frame;
        visualEffectView.alpha                  = 1.0;
        visualEffectView.userInteractionEnabled = YES;
        _bigHeadView.userInteractionEnabled     = YES;
        [_bigHeadView addSubview:visualEffectView];
    }
    return _bigHeadView;
}

#pragma mark ----点击事件----
//信息按钮
- (void)respondsToMessageButton:(UIButton *)sender{
    NSLog(@"点击了信息按钮");
    if (self.messageClickedHander) {
        self.messageClickedHander();
    }
}

//充值按钮
- (void)respondsToRechargeButton:(UIButton *)sender{
    NSLog(@"充值");
}

- (void)gestureClicked{
    
    if ((self.gestureClickedHandler)) {
        self.gestureClickedHandler();
    }
}

//主播认证
- (void)respondsTozhuBoRenzheng:(UIButton *)sender{
    if (self.zhuborenzhengHandler) {
        self.zhuborenzhengHandler();
    }
}

- (void)respondsToFiveButton:(UIButton *)sender{
    if (self.FiveButtonHandler) {
        self.FiveButtonHandler();
    }
    NSLog(@"设置");
}

- (void)respondsToForthButton:(UIButton *)sender{
    if (self.FourButtonHandler) {
        self.FourButtonHandler();
    }
    NSLog(@"越币充值");
}

- (void)respondsToThirdButton:(UIButton *)sender{
    if (self.ThirdButtonHandler) {
        self.ThirdButtonHandler();
    }
    NSLog(@"我的直播");
}

- (void)respondsToSecondButton:(UIButton *)sender{
    if (self.ScondButtonHandler) {
        self.ScondButtonHandler();
    }
    NSLog(@"关注的主播");
}

- (void)respondsToBianjiButton:(UIButton *)sender{
    if (self.bianjiButtonHandler) {
        self.bianjiButtonHandler();
    }
    NSLog(@"编辑");
}

- (void)firstButtonClicked:(UIButton *)sender{
       if (self.FirstButtonHandler) {
        self.FirstButtonHandler();
    }
    NSLog(@"个人作品给及视频");
}



@end
