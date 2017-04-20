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
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = WWColor(234, 230, 229);
    
    [self initializeDatasource];
    
    // 添加导航栏
    [self customNavigationBar];
    
    // 加载品牌入驻视图
    [self addBrandComeInView];
    
    // 加载匠作间视图
    [self addCarpenteroomView];
    
    // 加载底部类别视图
    [self addHomeTianyueCategoryView];
    
}

- (void)initializeDatasource {
    // 请求商标
    [HomeHandler requestForBrandTrademarkWithCompleteBlock:^(id respondsObject, NSError *error) {
        NSLog(@"BrandTrademark %@",respondsObject);
        [self.view_brand configBrandViewWithArr:respondsObject];
    }];
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
}


/**
 加载底部类别视图
 */
- (void)addHomeTianyueCategoryView
{
    self.view_tCategory = [[HomeTianyueCategoryView alloc] initWithFrame:CGRectMake(0, self.view_carpent.bottom, SCREEN_WIDTH, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.24)];
    _view_tCategory.backgroundColor = WWColor(235, 230, 230);
    [self.view addSubview:_view_tCategory];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end



