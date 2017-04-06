//
//  BuildersViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2017/1/20.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BuildersViewController.h"
#import "LiveModel.h"

@interface BuildersViewController ()

@end

@implementation BuildersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self.collectionView.mj_header beginRefreshing];
//    [self netRequest];
//    self.collectionView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self netRequest];
//    }];
//    self.collectionView.mj_footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self netRequest];
//    }];

}

- (void)netRequest
{

    [[NetWorkTool sharedTool]requestMethod:POST URL:@"mobileAllBroadcastLiving" paraments:nil finish:^(id responseObject, NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
        NSLog(@"---responseObject---%@-----%@----",responseObject,error);
        NSArray *data =responseObject[@"dataList"];
        self.infoArray =[NSMutableArray array];
        [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            LiveModel *model =[[LiveModel alloc]initWithDictionary:obj];
            [self.infoArray addObject:model];
        }];
        NSLog(@"--dataList--%@----",self.infoArray);
        [self.collectionView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
