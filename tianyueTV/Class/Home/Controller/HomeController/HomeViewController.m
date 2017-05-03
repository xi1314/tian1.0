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
#import "SelectionViewController.h"



static int netI = 0; // 已请求完成的网络标识



@interface HomeViewController ()

// 品牌入驻视图
@property (nonatomic, strong) BrandComeInView *view_brand;

// 匠作间视图
@property (nonatomic, strong) CarpenteroomView *view_carpent;

// 底部类别视图
@property (nonatomic, strong) HomeTianyueCategoryView *view_tCategory;

// 登录腾讯需要的参数
@property (nonatomic, strong) NSString *userIdentifiler;

@property (nonatomic, strong) NSString *userSig;

// 遮挡视图
@property (nonatomic, strong) MBProgressHUD *hud;

// 品牌入驻数据
@property (nonatomic, strong) NSArray *brandArray;

// 品牌入驻数据
@property (nonatomic, strong) NSArray *liveArray;

// 品牌入驻数据
@property (nonatomic, strong) HomeSelectModel *homeSelM;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"天越源作";
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = WWColor(234, 230, 229);
    
    // 隐藏导航栏黑线
    [self useMethodToFindBlackLineAndHind];

    // 网络请求
    [self initializeDatasource];
    
    // 登录腾讯sdk
    [self loginIMSDk];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBar.hidden = NO;
}

- (void)initializeDatasource {
    self.hud = [MBProgressHUD showMessage:nil];
    
    @weakify(self);
    
    // 请求商标
    [HomeHandler requestForBrandTrademarkWithCompleteBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            
            self.brandArray = (NSArray *)respondsObject;
            netI++;
            [self initControllers];
        }
    }];
    
    // 请求匠作间
    [HomeHandler requestForLivingRoomWithCompleteBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            
            self.liveArray = (NSArray *)respondsObject;
            netI++;
            [self initControllers];
        }
    }];

    // 天越甄选 匠人头条
    [HomeHandler requestForTianyueCategoryWithCompleteBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            
            self.homeSelM = (HomeSelectModel *)respondsObject;
            netI++;
            [self initControllers];
        }
    }];
}

- (void)initControllers
{
    if (netI == 3) {
        [self.hud hide:YES afterDelay:0.1];
        
        // 加载品牌入驻视图
        [self addBrandComeInView];
        [self.view_brand configBrandViewWithArr:self.brandArray];
        
        // 加载匠作间视图
        [self addCarpenteroomView];
        [self.view_carpent configCarpenterRoomWithData:self.liveArray];
        
        // 加载底部类别视图
        [self addHomeTianyueCategoryView];
        [self.view_tCategory configeCategoryViewWithModel:self.homeSelM];
    }
    
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
    self.view_carpent = [[CarpenteroomView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.13, SCREEN_WIDTH, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.64)];
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
    self.view_tCategory = [[HomeTianyueCategoryView alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.77, SCREEN_WIDTH, (SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) * 0.23)];
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
                SelectionViewController *selectVC = [[SelectionViewController alloc] init];
                selectVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:selectVC animated:YES
                 ];
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

//在首页初始化腾讯SDk，并登录
//登录腾讯sdk
- (void)loginIMSDk {
    //    self.userSig = [USER_Defaults objectForKey:@"userSig"];
    self.userSig = @"eJxtz11PgzAUgOH-0luNaUu7MZNdwAIGbcPGdHO7aZpRluPkY1CRZfG-iwTjjbfvc05OzhU9i-WdripIlbbKqVN0jwjDGFPGOUe3g5uugtoonVlT-3gvtB8ZtTV1A2XRA8WEE*pg-IeQmsJCBsOiNY0dewPHPshgtYh8AZ5OQvEalJ86cbQ*zVi7ifAuXuRhst*SNRydaVfE55kHnt-FUbGH90Dszn4oJbw88di9LHP5lsh2a7LlzQQ-iGbzuJrPf4*lJzX8*N9zFnIzdHcyJZS5bOz6cCg-CqvspRocM0bQ1zeeuVlk";
    //    self.userIdentifiler = [NSString stringWithFormat:@"ty%@",USER_NAME];
    self.userIdentifiler = @"test";
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ] init];
    // accountType 和 sdkAppId 通讯云管理平台分配
    // identifier为用户名，userSig 为用户登录凭证
    // appidAt3rd 在私有帐号情况下，填写与sdkAppId 一样
    login_param.accountType = @"10441";
    login_param.identifier = self.userIdentifiler;
    login_param.userSig = self.userSig;
    login_param.appidAt3rd = @"1400024555";
    login_param.sdkAppId = 1400024555;
    
    TIMManager *manager = [TIMManager sharedInstance];
    [manager initSdk:[@"1400024555" intValue] accountType:@"10441"];
    
//    NSLog(@"----------userSig   %@", login_param.userSig);
    [manager login:login_param succ:^(){
        NSLog(@"Login Succ");
        [USER_Defaults setBool:YES forKey:@"IM_Login"];
        [USER_Defaults synchronize];
    } fail:^(int code, NSString * err) {
        NSLog(@"Login Failed: %d->%@", code, err);
        [USER_Defaults setBool:NO forKey:@"IM_Login"];
        [USER_Defaults synchronize];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end



