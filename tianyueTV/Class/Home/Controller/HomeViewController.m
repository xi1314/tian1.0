//
//  HomeViewController.m
//  tianyueTV
//
//  Created by Mac-chen on 2017/4/17.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "HomeViewController.h"
#import "BrandComeInView.h"
#import "CarpenteroomView.h"
#import "HomeTianyueCategoryView.h"
#import "HomeHandler.h"
#import "LIvingViewController.h"
#import "WWLivingViewController.h"
#import "HeadlineViewController.h"

@interface HomeViewController ()

// 品牌入驻视图
@property (nonatomic, strong) BrandComeInView *view_brand;

// 匠作间视图
@property (nonatomic, strong) CarpenteroomView *view_carpent;

// 底部类别视图
@property (nonatomic, strong) HomeTianyueCategoryView *view_tCategory;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"天越源作";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = WWColor(234, 230, 229);
    
    // 隐藏导航栏黑线
    [self useMethodToFindBlackLineAndHind];
    // 添加导航栏
//    [self customNavigationBar];
    
    // 加载品牌入驻视图
    [self addBrandComeInView];
    
    // 加载匠作间视图
    [self addCarpenteroomView];
    
    // 加载底部类别视图
    [self addHomeTianyueCategoryView];
    
    // 网络请求
    [self initializeDatasource];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = NO;
}

- (void)initializeDatasource {
    [MBProgressHUD showMessage:nil];
    @weakify(self);
    // 请求商标
    [HomeHandler requestForBrandTrademarkWithCompleteBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            [self.view_brand configBrandViewWithArr:respondsObject];
            [MBProgressHUD hideHUD];
        }
    }];
    
    // 请求匠作间
    [HomeHandler requestForLivingRoomWithCompleteBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            [self.view_carpent configCarpenterRoomWithData:respondsObject];
        }
    }];
    
    // 天越甄选 匠人头条
    [HomeHandler requestForTianyueCategoryWithCompleteBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            HomeSelectModel *SM = (HomeSelectModel *)respondsObject;
            [self.view_tCategory configeCategoryViewWithModel:SM];
        }
    }];
}


/**
 当设置navigationBar的背景图片或背景色时，使用该方法都可移除黑线，且不会使translucent属性失效
 */
- (void)useMethodToFindBlackLineAndHind
{
    UIImageView* blackLineImageView = [self findHairlineImageViewUnder:self.navigationController.navigationBar];
    // 隐藏黑线（在viewWillAppear时隐藏，在viewWillDisappear时显示）
    blackLineImageView.hidden = YES;
}


- (UIImageView *)findHairlineImageViewUnder:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0)
    {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}


/**
 添加导航栏
 */
- (void)customNavigationBar
{
    UIImageView *centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 30 * 249 / 77, 30)];
    [centerImage setImage:[UIImage imageNamed:@"homeNavLogo"]];
    self.navigationItem.titleView = centerImage;
}


/**
 加载品牌入驻视图
 */
- (void)addBrandComeInView
{
    self.view_brand = [[BrandComeInView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.13)];
    _view_brand.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view_brand];
    
    // 点击下拉按钮
    @weakify(self);
    self.view_brand.block = ^(BOOL flag) {
        @strongify(self);
        
        [UIView animateWithDuration:0.2 animations:^{
            
            if (flag) {
                self.view_brand.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
            } else {
                self.view_brand.frame = CGRectMake(0, 0, SCREEN_WIDTH, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.13);
            }
            self.view_carpent.frame = CGRectMake(0, self.view_brand.bottom, SCREEN_WIDTH, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.63);
            self.view_tCategory.frame = CGRectMake(0, self.view_carpent.bottom, SCREEN_WIDTH, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.24);
        }];
    
    };
}


/**
 加载匠作间视图
 */
- (void)addCarpenteroomView
{
    self.view_carpent = [[CarpenteroomView alloc] initWithFrame:CGRectMake(0, self.view_brand.bottom, SCREEN_WIDTH, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.63)];
    _view_carpent.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_view_carpent];
    
    @weakify(self);
    self.view_carpent.liveBlock = ^(HomeLiveModel *liveM) {
        @strongify(self);
        
        LIvingViewController *livingVC = [[LIvingViewController alloc] init];
        livingVC.topic = liveM.stream;
        livingVC.isPushPOM = liveM.isPushPOM;
        livingVC.ql_push_flow = liveM.ql_push_flow;
        livingVC.playAddress = liveM.playAddress;
        livingVC.uesr_id = liveM.user_id;
        livingVC.ID = liveM.ID;
        livingVC.onlineNum = liveM.onlineNum;
        livingVC.name = liveM.name;
        livingVC.nickName = liveM.nickName;
        livingVC.headUrl = liveM.headUrl;
        
        livingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:livingVC animated:YES];
    };
}


/**
 加载底部类别视图
 */
- (void)addHomeTianyueCategoryView
{
    self.view_tCategory = [[HomeTianyueCategoryView alloc] initWithFrame:CGRectMake(0, self.view_carpent.bottom, SCREEN_WIDTH, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.24)];
    _view_tCategory.backgroundColor = WWColor(235, 230, 230);
    [self.view addSubview:_view_tCategory];
    
    @weakify(self);
    _view_tCategory.buttonBlock = ^(NSInteger tag){
        @strongify(self);
        
        switch (tag) {
            case 0: { // 直播
                WWLivingViewController *liveVC = [[WWLivingViewController alloc] init];
                liveVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:liveVC animated:YES];
            } break;
                
            case 1: { // 天越甄选
                
            } break;
                
            case 2: { // 匠人头条
                HeadlineViewController *headVC = [[HeadlineViewController alloc] init];
                headVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:headVC animated:YES];
            } break;
                
            default:
                break;
        }
        
    };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end



