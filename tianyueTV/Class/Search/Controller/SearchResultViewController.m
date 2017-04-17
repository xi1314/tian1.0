//
//  SearchResultViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/27.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "SearchResultViewController.h"
#import "MainCollectionViewCell.h"
#import "LIvingViewController.h"
#import "LiveModel.h"

@interface SearchResultViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource>

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =self.titl;
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Do any additional setup after loading the view.

    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.view.backgroundColor =[UIColor whiteColor];
    [self customBackBtn];
    [self collcetionView];
    [self.collcetionView reloadData];
}

- (UICollectionView *)collcetionView
{
    if (!_collcetionView)
    {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize =CGSizeMake(kWidthChange(340), kHeightChange(237));
        flowLayout.minimumLineSpacing =kWidthChange(15);
        flowLayout.minimumInteritemSpacing =kWidthChange(30);
        flowLayout.sectionInset =UIEdgeInsetsMake(kHeightChange(25), kWidthChange(20), kHeightChange(25), kWidthChange(20));
        flowLayout.scrollDirection =UICollectionViewScrollDirectionVertical;
        _collcetionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeight) collectionViewLayout:flowLayout];
        _collcetionView.delegate =self;
        _collcetionView.dataSource =self;
        _collcetionView.backgroundColor =[UIColor  whiteColor];
        [_collcetionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self.view addSubview:self.collcetionView];
    }
    return _collcetionView;
}

#pragma mark  ----CollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.results.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier =@"cell";
    MainCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    LiveModel *model =self.results[indexPath.row];
    [cell.picImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]]];
    cell.onlineLabel.text =[NSString stringWithFormat:@"%@",model.onlineNum];
    cell.nameLabel.text =[NSString stringWithFormat:@"%@",model.nickName];
    cell.titleLab.text =[NSString stringWithFormat:@"%@",model.name];
    
    return cell;
}

#pragma mark  ----CollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    LIvingViewController *livingVC =[[LIvingViewController alloc]init];
    LiveModel *model =self.results[indexPath.row];
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
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:livingVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)customBackBtn
{
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem =backItem;
    
}

- (void)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



