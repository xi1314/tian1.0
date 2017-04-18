//
//  RecommendedViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2017/1/19.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "RecommendedViewController.h"
//#import "LIvingViewController.h"
#import "SecondTableViewCell.h"
#import "UIImage+CustomImage.h"
#import "MBProgressHUD+MJ.h"
#import "WWFirstArtisanRecruit.h"
#import "BannerViewController.h"
#import "ZQFCycleView.h"
#import "MainCollectionViewCell.h"
#import "BuildersViewController.h"
#import "HomepageViewController.h"

@interface RecommendedViewController ()
<UITableViewDelegate,
UITableViewDataSource,
ZQFCycleViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource>

{
    ZQFCycleView *_cycleView;
}

@property (nonatomic, strong) UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *infoArray;

@end

@implementation RecommendedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.mainTableView.mj_header beginRefreshing];
    [self mainTableView];
    //[self bannerImagesRequest];
}

//轮播图
- (void)bannerImagesRequest
{
//    NSString *url =@"http://192.168.0.88:8080/AppCarouselfigure";
    //NSString *url =@"http://www.tianyue.tv/AppCarouselfigure";
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"AppCarouselfigure" paraments:nil finish:^(id responseObject, NSError *error) {
        
        NSArray *data = responseObject[@"appList"];
        self.bannerArray = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            BannerImageModel *model = [[BannerImageModel alloc] initWithDictionary:obj];
            [self.bannerArray addObject:model];
        }];
        [self.mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0] ,nil] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)netRequest
{
    //NSString *url =@"http://www.tianyue.tv/mobileAllBroadcastLiving";
//    NSString *url =@"http://192.168.0.88:8080/mobileAllBroadcastLiving1";
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"mobileAllBroadcastLiving1" paraments:nil finish:^(id responseObject, NSError *error) {
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        
        NSLog(@"responseObject---%@---%@", responseObject, error);
        NSArray *data = responseObject[@"dataList"];
        self.infoArray = [NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LiveModel *model = [[LiveModel alloc] initWithDictionary:obj];
            [self.infoArray addObject:model];
        }];
        NSLog(@"dataList--%@", self.infoArray);
        [self.mainTableView reloadData];
    }];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row ==0)
    {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cellID"];
        if (!cell)
        {
            cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
        }
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selected = YES;
        
        _cycleView =[[ZQFCycleView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeightChange(270)) delegate:self];
        [_cycleView startPlayWithTimeInterval:5];
        [cell addSubview:_cycleView];
        
        UIImageView *grayLine = [[UIImageView alloc] initWithImage:[UIImage createImageWithColor:WWColor(228, 228, 228)]];
        grayLine.frame = CGRectMake(0, kHeightChange(270), kWidth, kHeightChange(10)) ;
        [cell addSubview:grayLine];
        
        return cell;
        
    }else
    {
        SecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID2"];
        if (!cell)
        {
            cell = [[SecondTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID2"];
        }
        cell.SecondCollectionView.delegate = self;
        cell.SecondCollectionView.dataSource = self;
        cell.SecondCollectionView.tag = 33;
        [cell.SecondCollectionView reloadData];
        if (self.infoArray.count == 0)
        {
            cell.typeLabel.hidden = YES;
            cell.moreBtn.hidden = YES ;
        }else
        {
            cell.typeLabel.hidden = NO;
            cell.moreBtn.hidden = NO ;
        }
        [cell.grayLine removeFromSuperview];
        [cell.moreBtn addTarget:self action:@selector(moreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.moreBtn.tag = indexPath.row;
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.selected = YES;
        return cell;
    }
}
//更多按钮的点击方法
- (void)moreBtnClick:(UIButton *)btn
{
    if (self.returnBlock != nil)
    {
        self.returnBlock(btn.tag);
    }
}
- (void)returnBtn:(ReturnBlock)block
{
    self.returnBlock = block;
}

#pragma mark - UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return kHeightChange(280);
    }else
    {
        return kHeightChange(594);
    }
}
#pragma Mark -----ZQFCycleViewDelegate
- (NSInteger)countOfCycleView:(ZQFCycleView *)cycleView
{
    return self.bannerArray.count;
}
- (void)cycleView:(ZQFCycleView *)cycleView willDisplayImageView:(UIImageView *)imageView index:(NSInteger)index
{
    BannerImageModel *model = self.bannerArray[index];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.chart]]];
}

- (void)cycleView:(ZQFCycleView *)cycleView didDisplayTitleLabel:(UILabel *)titleLabel index:(NSInteger)index
{
    BannerImageModel *model = self.bannerArray[index];
    titleLabel.text = model.carousel_name;
}

- (void)cycleView:(ZQFCycleView *)cycleView didTouchImageView:(UIImageView *)imageView titleLabel:(UILabel *)titleLabel index:(NSInteger)index
{
    NSLog(@"--------点击了第%ld张图片-------",index);
    BannerViewController *vc = [[BannerViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    BannerImageModel *model = self.bannerArray[index];
    vc.titl = model.carousel_name;
    vc.uil = model.uil;
    [self.tabBarController.tabBar setHidden:YES];
    [self presentViewController:nav animated:YES completion:nil];
}

- (UITableView *)mainTableView
{
    if (!_mainTableView)
    {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64-kHeightChange(64))];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = [UIColor whiteColor];
        _mainTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_mainTableView registerClass:[SecondTableViewCell class] forCellReuseIdentifier:@"cellID2"];
        
        _mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self netRequest];
        }];
        _mainTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [self netRequest];
        }];
        [self.view addSubview:self.mainTableView];
    }
    return _mainTableView;
}
#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.infoArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"cell";
    MainCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
        LiveModel *model =self.infoArray[indexPath.row];
        //cell.typeLabel.text =[NSString stringWithFormat:@"%@",model.tytypeId];
        [cell.picImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]]];
        cell.onlineLabel.text=[NSString stringWithFormat:@"%@",model.onlineNum];
        cell.nameLabel.text =[NSString stringWithFormat:@"%@",model.nickName];
        cell.titleLab.text =[NSString stringWithFormat:@"%@",model.name];
    return cell;
}

#pragma mark - CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LiveModel *model =self.infoArray[indexPath.row];
    if (self.itemSelBlock) {
        self.itemSelBlock(model);
    }
    
    /*
    LIvingViewController *livingVC =[[LIvingViewController alloc]init];
    
    livingVC.topic =model.stream;
    livingVC.isPushPOM =model.isPushPOM;
    livingVC.ql_push_flow =model.ql_push_flow;
    livingVC.playAddress =model.playAddress;
    livingVC.uesr_id =model.user_id;
    livingVC.ID =model.ID;
    livingVC.onlineNum =model.onlineNum;
    livingVC.name =model.name;
    livingVC.nickName =model.nickName;
    livingVC.headUrl =model.headUrl;
    
    HomepageViewController *homepageVC = (HomepageViewController *)self.superclass;
    livingVC.hidesBottomBarWhenPushed = YES;
    [homepageVC.navigationController pushViewController:livingVC animated:YES];
     */
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_cycleView stopPlay];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
