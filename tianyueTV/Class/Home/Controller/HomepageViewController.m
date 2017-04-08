//
//  HomepageViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2017/1/19.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "HomepageViewController.h"
#import "RecommendedViewController.h"
#import "BuildersViewController.h"
#import "LiveModel.h"
#import "ShopDetailViewController.h"
#import "LIvingViewController.h"
#import <ImSDK/ImSDK.h>

#import "AddressManageViewController.h"

@interface HomepageViewController ()

//登录腾讯需要的参数
@property (nonatomic, strong) NSString *userIdentifiler;
@property (nonatomic, strong) NSString *userSig;
@property (nonatomic, strong) NSMutableArray *typeNameArray;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationBar];
    self.segmentType = XHSegmentTypeFit;
    RecommendedViewController *vc1 = [[RecommendedViewController alloc] init];
    @weakify(self);
    vc1.itemSelBlock = ^(LiveModel *liveM){
        
        @strongify(self);
        /*
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
        */
        
        AddressManageViewController *addVC = [[AddressManageViewController alloc] init];
        addVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addVC animated:YES];
        
        
    };
    vc1.title = @"推荐";
    BuildersViewController *vc2 = [[BuildersViewController alloc] init];
    vc2.title = @"匠人";
    BuildersViewController *vc3 = [[BuildersViewController alloc] init];
    vc3.title = @"衣";
    BuildersViewController *vc4 = [[BuildersViewController alloc] init];
    vc4.title = @"食";
    BuildersViewController *vc5 = [[BuildersViewController alloc] init];
    vc5.title = @"住";
    BuildersViewController *vc6 = [[BuildersViewController alloc] init];
    vc6.title = @"行";
    self.viewControllers = @[vc1,vc2,vc3,vc4,vc5,vc6];
    
    [self loginIMSDk];

    //[self netRequest];
//    NSMutableArray *array =[[NSMutableArray alloc]init];
//    [array addObject:vc1];
//    for (int i=0; i<self.typeNameArray.count; i++)
//    {
//        BuildersViewController *vc =[[BuildersViewController alloc]init];
//        
//        TypeModel *model =self.typeNameArray[i];
//        vc.title =[NSString stringWithFormat:@"%@",model.typeName];
//        [array addObject:vc];
//    }
//    self.viewControllers =array;
//    
//    __weak HomepageViewController *blockSelf =self;
//    [vc1 returnBtn:^(NSInteger index) {
//        
//        blockSelf.segmentControl.selectIndex =index;
//        
//    }];
    
//    ShopDetailViewController *shopVC = [[ShopDetailViewController alloc] init];
//    [self presentViewController:shopVC animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}


- (void)netRequest
{
//    NSString *url =@"http://192.168.0.88:8080/appTytype_sood";
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"appTytype_sood" paraments:nil finish:^(id responseObject, NSError *error) {
    
        if ([responseObject[@"ret"] isEqualToString:@"success"])
        {
            NSLog(@"----typeName-%@------",responseObject);
            NSArray *data =responseObject[@"appTytypeList"];
            self.typeNameArray =[NSMutableArray array];
            [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                TypeModel *model =[[TypeModel alloc]initWithDictionary:obj];
                [self.typeNameArray addObject:model];
                NSLog(@"----typeNameArray-%@------",self.typeNameArray);

            }];
        }
    }];
}

- (void)customNavigationBar
{
    UIImageView *centerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 7, 80, 30)];
    [centerImage setImage:[UIImage imageNamed:@"1"]];
    self.navigationItem.titleView = centerImage;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//在首页初始化腾讯SDk，并登录
//登录腾讯sdk
- (void)loginIMSDk {
    //    self.userSig = [USER_Defaults objectForKey:@"userSig"];
    self.userSig = @"eJxtz11PgzAUgOH-0luNaUu7MZNdwAIGbcPGdHO7aZpRluPkY1CRZfG-iwTjjbfvc05OzhU9i-WdripIlbbKqVN0jwjDGFPGOUe3g5uugtoonVlT-3gvtB8ZtTV1A2XRA8WEE*pg-IeQmsJCBsOiNY0dewPHPshgtYh8AZ5OQvEalJ86cbQ*zVi7ifAuXuRhst*SNRydaVfE55kHnt-FUbGH90Dszn4oJbw88di9LHP5lsh2a7LlzQQ-iGbzuJrPf4*lJzX8*N9zFnIzdHcyJZS5bOz6cCg-CqvspRocM0bQ1zeeuVlk";
    //    self.userIdentifiler = [NSString stringWithFormat:@"ty%@",USER_NAME];
    self.userIdentifiler = @"test";
    
    TIMLoginParam * login_param = [[TIMLoginParam alloc ]init];
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
    
    NSLog(@"----------userSig   %@",login_param.userSig);
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

//- (void)dengluchengg{
//    //    __weak typeof(self) weakSelf = self;
//    [[TIMGroupManager sharedInstance] JoinGroup:self.groupID msg:nil succ:^{
//        NSLog(@"加入成功");
//        //        [weakSelf switchToLiveRoom:self.GroupId];
//    } fail:^(int code, NSString *msg) {
//        NSLog(@"加入失败%d---%@",code,msg);
//    }];
//}



@end
