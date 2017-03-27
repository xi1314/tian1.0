//
//  WWMineFirstViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineFirstViewController.h"
#import "PersonalWorksCell.h"

@interface WWMineFirstViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UIImageView *personalImageView;
@property (nonatomic,strong) UILabel *personalLabel;
@property (nonatomic,strong) UIButton *clickedButtom;
@property (nonatomic,strong) UIView *topBgview;

@property (nonatomic,strong) UICollectionView *worksCollectionView;

@end

@implementation WWMineFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.personalImageView];
    [self.mainScrollView addSubview:self.personalLabel];
    [self.mainScrollView addSubview:self.topBgview];
    

    [self.mainScrollView addSubview:self.worksCollectionView];
    [self.mainScrollView addSubview:self.clickedButtom];

    
    
}

- (void)xiugaigaodu{
            CGRect temp = self.worksCollectionView.frame;
        temp.size.height = self.worksCollectionView.contentSize.height;
    NSLog(@"%f",self.worksCollectionView.frame.size.height);
        self.worksCollectionView.frame = temp;
    NSLog(@"%f",self.worksCollectionView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----UICollectionViewDataSource && UICollectionViewDelegate----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}



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

//返回每个item
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PersonalWorksCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PersonalWorksCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[PersonalWorksCell alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH *0.5 - kWidthChange(15), kHeightChange(200))];
    }
//    cell.backgroundColor = [UIColor blueColor];
    [self xiugaigaodu];
    return cell;
}


#pragma mark ----Actions----
- (void)respondsToClicked:(UIButton *)sender{
    NSLog(@"不在关注");
    
}


#pragma mark ----Getters----
- (UIButton *)clickedButtom{
    if (!_clickedButtom) {
        _clickedButtom = [[UIButton alloc] initWithFrame:CGRectMake(kWidthChange(30), self.worksCollectionView.contentSize.height + kHeightChange(50), SCREEN_WIDTH - kWidthChange(60), kHeightChange(85))];
        _clickedButtom.layer.cornerRadius = kWidthChange(5);
        _clickedButtom.layer.masksToBounds = YES;
        [_clickedButtom setImage:[UIImage imageNamed:@"圆角矩形-3"] forState:UIControlStateNormal];
        [_clickedButtom addTarget:self action:@selector(respondsToClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickedButtom;
}

//作品
- (UICollectionView *)worksCollectionView{
    if (!_worksCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(SCREEN_WIDTH *0.5 - kWidthChange(15), kHeightChange(200));
        _worksCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(kWidthChange(15), kHeightChange(80) + 64, SCREEN_WIDTH - kWidthChange(30), kHeightChange(600)) collectionViewLayout:layout];
        _worksCollectionView.dataSource = self;
        _worksCollectionView.delegate = self;
        _worksCollectionView.scrollEnabled = NO;
        _worksCollectionView.backgroundColor = [UIColor whiteColor];
        [_worksCollectionView registerClass:[PersonalWorksCell class] forCellWithReuseIdentifier:@"PersonalWorksCell"];
    }
    return _worksCollectionView;
}

- (UIView *)topBgview{
    if (!_topBgview) {
        _topBgview = [[UIView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, kHeightChange(22))];
        _topBgview.backgroundColor = WWColor(240, 240, 240);
    }
    return _topBgview;
}

//标题
- (UIImageView *)personalImageView{
    if (!_personalImageView) {
        _personalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kWidthChange(15), kHeightChange(20)+64, kWidthChange(35), kWidthChange(35))];
        _personalImageView.image = [UIImage imageNamed:@"作品_A"];
    }
    return _personalImageView;
}
- (UILabel *)personalLabel{
    if (!_personalLabel) {
        _personalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kWidthChange(60), kHeightChange(20)+64, SCREEN_WIDTH*0.5, kHeightChange(35))];
        _personalLabel.text = @"个人作品及视频";
        _personalLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _personalLabel.textColor = [UIColor blackColor];
//        _personalLabel.backgroundColor = [UIColor greenColor];
    }
    return _personalLabel;
}


//主要的滚动视图
- (UIScrollView *)mainScrollView{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
        _mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT * 2);
    }
    return _mainScrollView;
}

@end
