//
//  WWFirstArtisanRecruit.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/1/5.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "WWFirstArtisanRecruit.h"

#import "WWAnchorSpaceViewController.h"
#import "WWRealNameViewController.h"
#import "WWResultingViewController.h"
#import "WWResultStatusViewController.h"

@interface WWFirstArtisanRecruit ()

@property (nonatomic,strong) UIImageView *topImageView;//上边的图片
@property (nonatomic,strong) UIButton *ImmediateEntryButton;//即刻入驻按钮

@end

@implementation WWFirstArtisanRecruit

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *banckItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(backHandle)];
    banckItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = banckItem;
    self.title = @"首轮匠人大招募";
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark ----Actions---
- (void)respondsToImmediateEntryButton:(UIButton *)sender{
    NSInteger baudit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"baudit"] integerValue];
    if (baudit == 1) {
        WWAnchorSpaceViewController *anchorSpac = [[WWAnchorSpaceViewController alloc] init];
        [self.navigationController pushViewController:anchorSpac animated:YES];
    }else{
        NSString *bcard = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"bCard"];
        NSInteger bcar = [bcard integerValue];
        if (bcar == 2) {
            
            //        [MBProgressHUD showSuccess:@"已提交审核"];
            WWResultingViewController *resulting = [[WWResultingViewController alloc] init];
            [self.navigationController pushViewController:resulting animated:YES];
            
            
        }else if (bcar == 1){
            //        [MBProgressHUD showSuccess:@"你已经实名认证"];
            WWResultStatusViewController *success = [[WWResultStatusViewController alloc] init];
            [self.navigationController pushViewController:success animated:YES];
            
        }else{
            
            WWRealNameViewController *realName = [[WWRealNameViewController alloc] init];
            [self.navigationController pushViewController:realName animated:YES];
            //        WWResultStatusViewController *success = [[WWResultStatusViewController alloc] init];
            //        [self.navigationController pushViewController:success animated:YES];
        }

      

    }
}

- (void)backHandle{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ----setUI----
- (void)setUI{
    [self.view addSubview:self.topImageView];
    [self.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];
    [self.topImageView sizeToFit];
    
    [self.view addSubview:self.ImmediateEntryButton];
    [self.ImmediateEntryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(kHeightChange(-231));
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);

    }];
    
    [self.ImmediateEntryButton sizeToFit];
}

#pragma mark ----Getters----
- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"【天越源作，在乎每个源头的你】"];
    }
    return _topImageView;
}

- (UIButton *)ImmediateEntryButton{
    if (!_ImmediateEntryButton) {
        _ImmediateEntryButton = [[UIButton alloc] init];
//        _ImmediateEntryButton.backgroundColor = [UIColor greenColor];
        [_ImmediateEntryButton setBackgroundImage:[UIImage imageNamed:@"即刻入驻"] forState:UIControlStateNormal];
        [_ImmediateEntryButton addTarget:self action:@selector(respondsToImmediateEntryButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ImmediateEntryButton;
}

@end
