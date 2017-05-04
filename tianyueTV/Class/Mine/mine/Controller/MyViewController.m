//
//  MyViewController.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/5/3.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "MyViewController.h"
#import "MyCategoryView.h"
#import "MyItemView.h"
#import "WWMineFiveViewController.h"

@interface MyViewController ()

@property (nonatomic, strong) UIScrollView *baseScroll;
@property (nonatomic, strong) UIView *view_head;
@property (nonatomic, strong) MyCategoryView *view_yuebi;
@property (nonatomic, strong) MyCategoryView *view_lingtao;
@property (nonatomic, strong) NSArray *itemArray;


@end

@implementation MyViewController

- (NSArray *)itemArray
{
    return @[@{@"image" : @"my_wodedingyue",
               @"title" : @"我的订阅"},
             
             @{@"image" : @"my_playHistory",
               @"title" : @"播放历史"},
             
             @{@"image" : @"my_startLive",
               @"title" : @"开始直播"},
             
             @{@"image" : @"my_accountSecurity",
               @"title" : @"账号安全"},
             
             @{@"image" : @"my_setting",
               @"title" : @"设置"},
             
             @{@"image" : @"my_order",
               @"title" : @"我的订单"}];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = WWColor(243, 243, 243);
    
    [self initHeadView];
    
    [self initItemView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initHeadView
{
    self.baseScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT - TabbarHeight + 20)];
    self.baseScroll.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.baseScroll];
    
    self.view_head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 469 / 750 + 50)];
    self.view_head.backgroundColor = [UIColor whiteColor];
    [self.baseScroll addSubview:self.view_head];
    
    UIImageView *imgV_head = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 469 / 750)];
    imgV_head.contentMode = UIViewContentModeScaleToFill;
    imgV_head.image = [UIImage imageNamed:@"my_headBack"];
    [self.view_head addSubview:imgV_head];
    
    UIImageView *imgV_user = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (imgV_head.height - 140))/2.0f, 65, imgV_head.height - 140, imgV_head.height - 140)];
    imgV_user.layer.cornerRadius = (imgV_head.height - 140)/2.0f;
    imgV_user.layer.masksToBounds = YES;
    imgV_user.image = [UIImage imageNamed:@"my_defaultHead"];
    [self.view_head addSubview:imgV_user];
    
    UIImageView *imgV_userStatus = [[UIImageView alloc] initWithFrame:CGRectMake(imgV_user.left + imgV_user.width - 30, imgV_user.top + imgV_user.height - 30, 30, 30)];
    imgV_userStatus.contentMode = UIViewContentModeScaleAspectFit;
    imgV_userStatus.image = [UIImage imageNamed:@"主播"];
    [self.view_head addSubview:imgV_userStatus];
    
    UILabel *lab_user = [[UILabel alloc] initWithFrame:CGRectMake(0, imgV_user.bottom, self.view_head.width, 60)];
    lab_user.backgroundColor = [UIColor clearColor];
    lab_user.font = [UIFont boldSystemFontOfSize:18.f];
    lab_user.textColor = [UIColor whiteColor];
    lab_user.textAlignment = NSTextAlignmentCenter;
    lab_user.text = @"天越网455";
    [self.view_head addSubview:lab_user];
    
    self.view_yuebi = [[MyCategoryView alloc] initWithFrame:CGRectMake(15, imgV_head.bottom + 15, 125, 20) image:@"my_yuebi" title:@"越币"];
    [self.view_head addSubview:self.view_yuebi];
    
    self.view_lingtao = [[MyCategoryView alloc] initWithFrame:CGRectMake(self.view_yuebi.right + 10, imgV_head.bottom + 15, 125, 20) image:@"my_lingtao" title:@"灵桃"];
    [self.view_head addSubview:self.view_lingtao];

}

- (void)initItemView
{
    CGFloat itemWidth = (SCREEN_WIDTH - 40)/3.0f;
    for (int i = 0; i < self.itemArray.count; i++) {
        int x = i%3;
        int y = i/3;
        MyItemView *itemV = [[MyItemView alloc] initWithFrame:CGRectMake(10 + (10 + itemWidth) * x, self.view_head.bottom + 10 + (10 + itemWidth) * y, itemWidth, itemWidth)];
        itemV.tag = 100 + i;
        [self.baseScroll addSubview:itemV];
        
        NSDictionary *dict = self.itemArray[i];
        [itemV setImageString:dict[@"image"]];
        [itemV setTitleString:dict[@"title"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [itemV addGestureRecognizer:tap];
    }
    
    int count = self.itemArray.count / 3.0f;
    float countF = self.itemArray.count / 3.0f;
    if (countF > count) {
        count++;
    }
    
    [self.baseScroll setContentSize:CGSizeMake(self.baseScroll.width, self.view_head.height + (10 + itemWidth) * 2 + 30)];
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    MyItemView *itemV = (MyItemView *)tap.view;
    int i = (int)itemV.tag - 100;
    switch (i) {
        case 0: { // 我的订阅
            
            break;
        }
        case 1: { // 播放历史
            
            break;
        }
        case 2: { // 开始直播
            
            break;
        }
        case 3: { // 账号安全
            
            break;
        }
        case 4: { // 设置
           
            [self intoSetting];
            break;
        }
        case 5: { // 我的订单
            
            break;
        }
        default:
            break;
    }
}

//设置
- (void)intoSetting {

    WWMineFiveViewController *mineFiveVc = [[WWMineFiveViewController alloc] init];
    mineFiveVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineFiveVc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
