//
//  ContentViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2017/1/20.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "ContentViewController.h"
#import "MainCollectionViewCell.h"
#import "LiveModel.h"
#import "LIvingViewController.h"

@interface ContentViewController ()
<UICollectionViewDelegate,
UICollectionViewDataSource>


@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self collectionView];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize =CGSizeMake(kWidthChange(340), kHeightChange(237));
        flowLayout.minimumLineSpacing =kWidthChange(15);
        flowLayout.minimumInteritemSpacing =kWidthChange(30);
        flowLayout.sectionInset =UIEdgeInsetsMake(kHeightChange(25), kWidthChange(20), kHeightChange(25), kWidthChange(20));
        flowLayout.scrollDirection =UICollectionViewScrollDirectionVertical;
        
        _collectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, kHeightChange(10), kWidth, kHeight-kHeightChange(74)-64) collectionViewLayout:flowLayout];
        _collectionView.delegate =self;
        _collectionView.dataSource =self;
                
        _collectionView.backgroundColor =[UIColor whiteColor];
        [_collectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
        [self.view addSubview:self.collectionView];
        //[self.collectionView insertSubview:self.view atIndex:0];
    }
    return _collectionView;
}

#pragma mark  ----CollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.infoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *cellIdentifier =@"cell1";
    MainCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    
    LiveModel *model =self.infoArray[indexPath.row];
    //cell.typeLabel.text =[NSString stringWithFormat:@"%@",model.tytypeId];
    [cell.picImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]]];
    cell.onlineLabel.text=[NSString stringWithFormat:@"%@",model.onlineNum];
    cell.nameLabel.text =[NSString stringWithFormat:@"%@",model.nickName];
    cell.titleLab.text =[NSString stringWithFormat:@"%@",model.name];
    return cell;
}

#pragma mark  ----CollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LIvingViewController *livingVC =[[LIvingViewController alloc]init];
    
    LiveModel *model =self.infoArray[indexPath.row];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
