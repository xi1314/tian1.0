//
//  WWPesonalShowViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/21.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWPesonalShowViewController.h"
//#import "WWPersonalView.h"
#import "WWPersonalWorksButton.h"
#import "WWPcollectionViewCell.h"

@interface WWPesonalShowViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSMutableArray <WWPersonalWorksButton *>*WorksButtonArray;
@property (nonatomic,strong) UIScrollView *scrollViewW;
@property (nonatomic,strong) UIView *bottomView;
//@property (nonatomic,strong) WWPersonalView *personView;

@property (nonatomic,strong) UIImageView *bigHeadView;//上部的背景
@property (nonatomic,strong) UIImageView *headImages;//头像
@property (nonatomic,strong) UILabel *nameLabel;//昵称
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *qianmingLabel;//个性签名
@property (nonatomic,strong) UILabel *guanzhuTitleLbael;//他关注的主播
@property (nonatomic,strong) UIButton *zankaiButton;//展开按钮
@property (nonatomic,strong) UILabel *personalWorksLabel;//他的个人作品及视频
@property (nonatomic,strong) UICollectionView *buttonCollecton;

@end

@implementation WWPesonalShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人展示";
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    self.scrollViewW.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollViewW];
    [self addPureLayOut];
    [self.scrollViewW addSubview:self.bottomView];
    
//    CGFloat height = CGRectGetMaxY(self.bottomView.frame);
        CGFloat height =CGRectGetMaxY([self.WorksButtonArray lastObject].frame);
    self.scrollViewW.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), height);
     UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked)];
    leftItem.image = [UIImage imageNamed:@"back_black"];
    leftItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark ---Getters---

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UIScrollView *)scrollViewW{
    if (!_scrollViewW) {
        _scrollViewW = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _scrollViewW.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 2);
    }
    return _scrollViewW;
}




#pragma mark ----Actions----
- (void)backItemClicked{
    self.tabBarController.tabBar.hidden = NO;
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
   
}



- (void)respondsToZhankaiClicked:(UIButton *)sender{
   
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        NSLog(@"展开");
        CGRect temp = self.buttonCollecton.frame;
        if (self.buttonCollecton.contentSize.height > kHeightChange(700)) {
            //            temp.size.height = kHeightChange(700);
            temp.size.height = self.buttonCollecton.contentSize.height;
        }else{
            temp.size.height = self.buttonCollecton.contentSize.height;
        }
        self.buttonCollecton.frame = temp;
        self.personalWorksLabel.center = CGPointMake(self.personalWorksLabel.center.x,
                                                     self.personalWorksLabel.center.y + self.buttonCollecton.frame.size.height - kHeightChange(220));
        NSLog(@"asasbdjasas%f",self.buttonCollecton.frame.size.height);
        for (int i = 0; i < self.WorksButtonArray.count; i ++) {
            self.WorksButtonArray[i].center = CGPointMake(self.WorksButtonArray[i].center.x,
                                                          self.WorksButtonArray[i].center.y + self.buttonCollecton.frame.size.height - kHeightChange(220));
        }
        
    }else{
        NSLog(@"收起");
        self.personalWorksLabel.center = CGPointMake(self.personalWorksLabel.center.x,
                                                     self.personalWorksLabel.center.y - self.buttonCollecton.frame.size.height + kHeightChange(220));
        for (int i = 0; i < self.WorksButtonArray.count; i ++) {
            self.WorksButtonArray[i].center = CGPointMake(self.WorksButtonArray[i].center.x,
                                                          self.WorksButtonArray[i].center.y - self.buttonCollecton.frame.size.height + kHeightChange(220));
        }
        NSLog(@"asasbdjasas%f",self.buttonCollecton.frame.size.height);
        CGRect temp = self.buttonCollecton.frame;
        temp.size.height = kHeightChange(220);
        self.buttonCollecton.frame = temp;
        
        
    }
    
    CGFloat height =CGRectGetMaxY([self.WorksButtonArray lastObject].frame);
    self.scrollViewW.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), height);
    
    
}

#pragma mark ----UICollectionViewDataSource && UICollectionViewDelegate----
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return kWidthChange(20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kHeightChange(0);
}

//返回分区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
//返回每个分区的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 13;
}
//返回每个item

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    WWPcollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    if (!cell) {
        cell = [[WWPcollectionViewCell alloc] initWithFrame:CGRectMake(0, 0, kWidthChange(150), kHeightChange(200))];
    }
    
    return cell;
}


#pragma mark ----添加约束----

- (void)addPureLayOut{
    
    [self.scrollViewW addSubview:self.bigHeadView];

    // 头像
    [self.scrollViewW addSubview:self.headImages];
    [self.headImages autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(54) + 64];
    [self.headImages autoAlignAxis:ALAxisVertical toSameAxisOfView:self.bigHeadView];
    [self.headImages autoSetDimensionsToSize:CGSizeMake(kWidthChange(166), kWidthChange(166))];

    //昵称
    [self.bigHeadView addSubview:self.nameLabel];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(270)];
    [self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(270)];
    [self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headImages withOffset:kHeightChange(14)];
    
    //类型
    [self.bigHeadView addSubview:self.typeLabel];
    [self.typeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(200)];
    [self.typeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(200)];
    [self.typeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:kHeightChange(14)];

    //个性签名
    [self.bigHeadView addSubview:self.qianmingLabel];
    [self.qianmingLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(140)];
    [self.qianmingLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(140)];
    [self.qianmingLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeLabel withOffset:kHeightChange(16)];
    
    //他关注的主播
    [self.scrollViewW addSubview:self.guanzhuTitleLbael];

    //暂开按钮
    [self.scrollViewW addSubview:self.zankaiButton];

    [self.scrollViewW addSubview:self.buttonCollecton];

    // 他的个人作品及视屏
    [self.scrollViewW addSubview:self.personalWorksLabel];

    for (int i = 0; i < 2; i ++) {
        for (int j = 0; j < 2; j ++) {
            WWPersonalWorksButton *worksButton = [[WWPersonalWorksButton alloc] initWithFrame:CGRectMake( i*SCREEN_WIDTH *0.5, kHeightChange(750) +j* SCREEN_WIDTH *0.5+ 64, SCREEN_WIDTH *0.5, SCREEN_WIDTH *0.5)];
            [self.scrollViewW addSubview:worksButton];
            [self.WorksButtonArray addObject:worksButton];
        }
    }
    
    
    
}



#pragma mark ----Getters----
//存放个人作品数组
- (NSMutableArray<WWPersonalWorksButton *> *)WorksButtonArray{
    if (!_WorksButtonArray) {
        _WorksButtonArray = [[NSMutableArray alloc] init];
    }
    return _WorksButtonArray;
}

// 他的个人作品及视屏
- (UILabel *)personalWorksLabel{
    if (!_personalWorksLabel) {
        _personalWorksLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidthChange(15), kHeightChange(700) + 64, kWidthChange(450), kHeightChange(40))];
        _personalWorksLabel.text = @"他的个人作品及视频";
        _personalWorksLabel.font = [UIFont systemFontOfSize:kWidthChange(30)];
        _personalWorksLabel.textColor = [UIColor blackColor];
        
    }
    return _personalWorksLabel;
}


- (UICollectionView *)buttonCollecton{
    if (!_buttonCollecton) {
        //创建一个layout布局类
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每个item的大小为100*100
        layout.itemSize = CGSizeMake(kWidthChange(150), kHeightChange(200));
        //创建collectionView 通过一个布局策略layout来创建
        _buttonCollecton = [[UICollectionView alloc]initWithFrame:CGRectMake(kWidthChange(40), kHeightChange(420) + 64 + kHeightChange(54), SCREEN_WIDTH - kWidthChange(80), kHeightChange(220))collectionViewLayout:layout];
        //代理设置
        _buttonCollecton.delegate = self;
        _buttonCollecton.dataSource = self;
        _buttonCollecton.scrollEnabled = NO;
        //注册item类型 这里使用系统的类型
        [_buttonCollecton registerClass:[WWPcollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
        _buttonCollecton.backgroundColor = [UIColor whiteColor];
    }
    return _buttonCollecton;
}

//展开按钮
- (UIButton *)zankaiButton{
    if (!_zankaiButton) {
        _zankaiButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - kWidthChange(65), kHeightChange(420) + 64, kWidthChange(50), kHeightChange(30))];
        [_zankaiButton setImage:[UIImage imageNamed:@"展开(1)"] forState:UIControlStateNormal];
        [_zankaiButton addTarget:self action:@selector(respondsToZhankaiClicked:) forControlEvents:UIControlEventTouchUpInside];
        _zankaiButton.backgroundColor = [UIColor blackColor];
    }
    return _zankaiButton;
}

//他关注的主播
- (UILabel *)guanzhuTitleLbael{
    if (!_guanzhuTitleLbael) {
        _guanzhuTitleLbael = [[UILabel alloc] initWithFrame:CGRectMake(kWidthChange(15), kHeightChange(420) + 64, SCREEN_WIDTH, kHeightChange(50))];
        _guanzhuTitleLbael.text = @"他关注的主播";
        _guanzhuTitleLbael.font = [UIFont systemFontOfSize:kWidthChange(30)];
        _guanzhuTitleLbael.textColor = [UIColor blackColor];
    }
    return _guanzhuTitleLbael;
}

//个性签名
- (UILabel *)qianmingLabel{
    if (!_qianmingLabel) {
        _qianmingLabel = [[UILabel alloc] init];
        _qianmingLabel.text = @"个性签名: 手艺是一门艺术，在生活中传承";
        _qianmingLabel.font = [UIFont systemFontOfSize:0.032*SCREEN_WIDTH];
        _qianmingLabel.textColor = [UIColor whiteColor];
        
    }
    return _qianmingLabel;
}

// 越币
- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.text = @"手工艺  |  粉丝：8923";
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
        _typeLabel.textColor = [UIColor whiteColor];
    }
    return _typeLabel;
}

//背景
- (UIImageView *)bigHeadView{
    if (!_bigHeadView) {
        
        _bigHeadView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, kHeightChange(420))];
        UIImage *images = [UIImage imageNamed:@"897"];
        _bigHeadView.backgroundColor = [UIColor blueColor];
        _bigHeadView.image = images;
        // 实现模糊效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        visualEffectView.frame = CGRectMake(0, 0, SCREEN_WIDTH, kHeightChange(420));
        visualEffectView.alpha = 1.0;
        visualEffectView.userInteractionEnabled = YES;
        [_bigHeadView addSubview:visualEffectView];
    }
    return _bigHeadView;
}

// 头像
- (UIImageView *)headImages{
    if (!_headImages) {
        _headImages = [[UIImageView alloc] init];
        _headImages.layer.cornerRadius = kWidthChange(83);
        _headImages.layer.masksToBounds = YES;
        _headImages.image = [UIImage imageNamed:@"897"];
        _headImages.layer.borderColor = [UIColor whiteColor].CGColor;
        //        _headImages.layer.backgroundColor
        _headImages.layer.borderWidth = 2.0f;
    }
    return _headImages;
}

//昵称
- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"飞翔的荷兰人";
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:kWidthChange(30)];
    }
    return _nameLabel;
}



@end
