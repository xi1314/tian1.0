//
//  WWSettingViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWSettingViewController.h"
#import "WWBiaoqianViewController.h"
#import "WWAnchorSpaceViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WWLivingViewController.h"
@interface WWSettingViewController ()
<biaoqanDelegate>

{
    BOOL _isFirst;
}

// 取消按钮
@property (nonatomic,strong) UIBarButtonItem *cancelButton;

// 保存按钮
@property (nonatomic,strong) UIBarButtonItem *saveButton;

// 标签信息
@property (nonatomic,strong) NSMutableArray *biaoqianArrays;

// 开启直播
@property (nonatomic,strong) UIButton *startLivingButton;


@end

@implementation WWSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //去掉横线
    [self.navigationController.navigationBar setValue:@(0)forKeyPath:@"backgroundView.alpha"];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    //修改字体颜色及大小
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:17]};
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"baudit"] != nil) {
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"baudit"]);
        //如果有直播间进行网络请求
        [self netWorkRequestGet];
    }
    
    

    self.title = @"直播间设置";
    _settingView = [[WWSettingView alloc] initWithFrame:self.view.frame];
      [self.view addSubview:_settingView];
//    _settingView.settingVc = self;
    __weak typeof(self) ww = self;
    _settingView.SettingHandler = ^(){
        [ww SettingHandler];
    };
    
    _settingView.NamelevelHandler = ^(NSString *Namelevel){
        [ww NamelevelHandler:Namelevel];
    };
    NSString *messageString = self.roomInfos[@"keyWord"];
    if (messageString.length != 0) {

        NSArray *arr = [messageString componentsSeparatedByString:@"_"];
        self.biaoqianArrays = [arr mutableCopy];
        self.settingView.biaoqianArray = self.biaoqianArrays;
    }
       NSLog(@"________________________%@",self.biaoqianArrays);
  
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    
    UIBarButtonItem *saveButton1 = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToSave)];
    [saveButton1 setTintColor:WWColor(88, 86, 87)];
    self.navigationItem.rightBarButtonItem = saveButton1;
    [self.view addSubview:self.startLivingButton];
    [self.startLivingButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(50)];
    [self.startLivingButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(50)];
    [self.startLivingButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:200];
    [self.startLivingButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(85)];
    self.startLivingButton.hidden = self.isHiddenLivingButton;
    
    
}

- (void)SettingHandler{
    WWBiaoqianViewController *biaoqian = [[WWBiaoqianViewController alloc] init];
    biaoqian.dataArray = self.biaoqianArrays;
    biaoqian.delegate = self;
    [self.navigationController pushViewController:biaoqian animated:YES];
}


#pragma mark ----标签代理-----
- (void)returnBiaoqianArray:(NSMutableArray *)arrray{
    self.biaoqianArrays = nil;
    self.biaoqianArrays = arrray;
    //    NSLog(@"新的标签：%@",self.biaoqianArrays);
    [self biaoqianManager];
}


#pragma mark ----标签处理
- (void)NamelevelHandler:(NSString *)Namelevel{
    self.Namelevel = Namelevel;
}

- (void)biaoqianManager{
    
    
    
    //    dispatch_async(dispatch_get_main_queue(), ^{
    //        [self.tagView removeAllTags];
    //    });
    
    
    
    //    self.settingView.tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
    //    self.settingView.tagView.lineSpacing = 10;//上下之间的距离
    //    self.settingView.tagView.interitemSpacing = 20;//item之间的距离
    //    // 最大宽度
    //    self.settingView.tagView.preferredMaxLayoutWidth = 375;
    //    [self.biaoqianArray addObject:@"asd"];
    NSArray *arr = [self.biaoqianArrays copy];
    //  NSLog(@"新的标签：%@",arr);
    //            [self.collectionViewW autoPinEdgesToSuperviewEdges];
    
    NSLog(@"新标签%@",self.biaoqianArrays);
    [self.settingView.tagView removeAllTags];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        // 初始化标签
        SKTag *tag = [[SKTag alloc] initWithText:self.biaoqianArrays[idx]];
        
        // 标签相对于自己容器的上左下右的距离
        
        tag.padding = UIEdgeInsetsMake(8, 15, 8, 15);
        
        // 弧度
        
        tag.cornerRadius = 8.0f;
        
        // 字体
        
        tag.font = [UIFont boldSystemFontOfSize:kWidthChange(24)];
        
        // 边框宽度
        
        tag.borderWidth = 0;
        
        // 背景
        
        //                tag.bgColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
        tag.bgColor = WWColor(244, 117, 6);
        
        // 边框颜色
        
        tag.borderColor = [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
        
        // 字体颜色
        
        //                tag.textColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:1];
        tag.textColor = [UIColor whiteColor];
        // 是否可点击
        
        tag.enable = YES;
        
        // 加入到tagView
        
        [self.settingView.tagView addTag:tag];
        
    }];
}




- (void)respondsToCancel{
//    [self.delegate returnRoomName:self.settingView.nameTextFiled.text];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)respondsToSave{
        if (self.settingView.nameTextFiled.text.length == 0 ) {
            
            [MBProgressHUD showError:@"房间名不能为空"];
        }else if(self.settingView.typerTextFiled.text.length == 0){
            [MBProgressHUD showError:@"请选择房间类型"];
        }else{
             [self NetWork];
        }

//   NSLog(@"房间名：%@",self.settingView.nameTextFiled.text);
//    NSLog(@"分类：%@",self.settingView.typerTextFiled.text);
//    NSLog(@"保存shezhi");
  
  

}



- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
     self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)respondsToStartClicked:(UIButton *)sender{
//    WWLivingViewController *mineSecondVc = [[WWLivingViewController alloc] init];
//    [self.navigationController pushViewController:mineSecondVc animated:YES];
    if (self.settingView.nameTextFiled.text.length == 0) {
        [MBProgressHUD showError:@"房间名不能为空"];
    }else if (self.settingView.typerTextFiled.text.length == 0){
        [MBProgressHUD showError:@"请选择类型"];
    }else{
        //进行网络请求修改房间名
        [self netWorkRequest];
        
    }
    
    
    NSLog(@"开启直播");
}

//- (void)netWorkRequest{
//    NSString *url = @"http://192.168.0.88:8081/insertRoommobile";
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    param[@"Name"] = self.settingView.nameTextFiled.text;
//    param[@"id"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
//    param[@"typeName"] = self.settingView.typerTextFiled.text;
////    NSString *keyWord = self.biaoqianArrayW[0];
////    if (self.biaoqianArrayW.count != 0) {
////        for (int i = 1; i < self.biaoqianArrayW.count - 1; i ++) {
////            keyWord = [keyWord stringByAppendingFormat:@"_%@",self.biaoqianArrayW[i]];
////            param[@"keyWord"] = keyWord;
////        }
////    }else{
////        param[@"keyWord"] = @"";
////    }
//    
//    
//    NSLog(@"param:%@",param);
//    [MBProgressHUD showMessage:nil];
//    [[NetWorkTool sharedTool] requestMethod:POST URL:url paraments:param finish:^(id responseObject, NSError *error) {
//        NSLog(@"%@_______________________________%@",responseObject,error);
//        [MBProgressHUD hideHUD];
//        if (responseObject) {
//            if ([responseObject[@"ret"] isEqualToString:@"success"] || [responseObject[@"ret"] isEqualToString:@"fails"]) {
//                //            [MBProgressHUD showSuccess:@"修改成功"];
//                WWLivingViewController *mineSecondVc = [[WWLivingViewController alloc] init];
//                [self.navigationController pushViewController:mineSecondVc animated:YES];
//                
//            }
//        }else{
//            [MBProgressHUD showError:@"网络出错"];
//        }
//        
//    }];
//    
//    
//}






#pragma mark ---懒加载----


- (UIButton *)startLivingButton{
    if (!_startLivingButton) {
        _startLivingButton = [[UIButton alloc] init];
        [_startLivingButton setBackgroundImage:[UIImage imageNamed:@"redCornerJuxing"] forState:UIControlStateNormal];
        [_startLivingButton setTitle:@"开启直播" forState:UIControlStateNormal];
        [_startLivingButton addTarget:self action:@selector(respondsToStartClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _startLivingButton;
}

//- (WWSettingView *)settingView{
//    if (!_settingView) {
//        _settingView = [[WWSettingView alloc] initWithFrame:self.view.frame];
//        
//    }
//    return _settingView;
//}

- (UIBarButtonItem *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToSave)];
        [_saveButton setTintColor:WWColor(88, 86, 87)];
        
    }
    return _saveButton;
}
- (UIBarButtonItem *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToCancel)];
        [_cancelButton setTintColor:WWColor(88, 86, 87)];
    }
    return _cancelButton;
}

#pragma mark ----网络请求----
- (void)NetWork{
   
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"WWFirst"]);
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"WWFirst"] isEqualToString:@"0"]) {
        [self netWorkRequest];
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"WWFirst"] isEqualToString:@"1"]) {
        [self netWorkRequest2];
    }
}

- (void)netWorkRequest{
    
    NSString *url = @"insertRoommobile";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"Namelevel"] = self.settingView.Namelevel;
    param[@"Name"] = self.settingView.nameTextFiled.text;
    param[@"typeName"] = self.settingView.typerTextFiled.text;
    param[@"user_id"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSLog(@"param:%@",param);
    [MBProgressHUD showMessage:nil];
    [[NetWorkTool sharedTool] requestMethod:POST URL:url paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"%@____________申请直播间___________________%@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"] || [responseObject[@"ret"] isEqualToString:@"fails"]) {
            [MBProgressHUD showSuccess:@"申请成功"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"WWFirst"];
            WWAnchorSpaceViewController *achorSpace = [[WWAnchorSpaceViewController alloc] init];
            achorSpace.roomName = self.settingView.nameTextFiled.text;
            achorSpace.biaoqianArrayW = self.biaoqianArrays;
            achorSpace.typeName = [param objectForKey:@"typeName"];
            
            [self.navigationController pushViewController:achorSpace animated:YES];
        }else{
            [MBProgressHUD showError:@"申请失败"];
        }
    }];
    
}
- (void)netWorkRequest2{
    
    NSString *url = @"updateZbj_app";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    param[@"name"] = self.settingView.nameTextFiled.text;
    param[@"typeName"] = self.settingView.typerTextFiled.text;
    param[@"id"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSString *biaoqians = @"";
    if (self.biaoqianArrays.count != 0) {
        biaoqians = self.biaoqianArrays[0];
        for (int i = 1; i < self.biaoqianArrays.count; i++) {
            biaoqians = [biaoqians stringByAppendingFormat:@"_%@",self.biaoqianArrays[i]];
        }
    }
    
    param[@"keyWord"] = biaoqians;
    param[@"Namelevel"] = self.Namelevel;
    
    NSLog(@"param:%@",param);
    [MBProgressHUD showMessage:nil];
    [[NetWorkTool sharedTool] requestMethod:POST URL:url paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"%@______修改直播间_________________________%@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"修改成功"];
            WWAnchorSpaceViewController *achorSpace = [[WWAnchorSpaceViewController alloc] init];
            achorSpace.roomName = self.settingView.nameTextFiled.text;
            achorSpace.biaoqianArrayW = self.biaoqianArrays;
            
            achorSpace.typeName = [param objectForKey:@"typeName"];
            [self.delegate returnRoomName:self.settingView.nameTextFiled.text];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"网路出错"];
        }
    }];
    

    
}

- (void)netWorkRequestGet{
    
    
//    id responseObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"livingRoomInfo"];
//    NSLog(@"%@",responseObject);
//    if ([responseObject[@"ret"] isEqualToString:@"success"]) {
//       
//        NSString *messageString = responseObject[@"broadcast"][0][@"keyWord"];
//        self.settingView.nameTextFiled.text = responseObject[@"broadcast"][0][@"name"];
//        self.settingView.typerTextFiled.text = responseObject[@"broadcast"][0][@"tytypeName"];
//        self.Namelevel = responseObject[@"broadcast"][0][@"Namelevel"];
//        if (messageString.length != 0) {
//            
//            NSArray *arr = [messageString componentsSeparatedByString:@"_"];
//            self.biaoqianArrays = [arr mutableCopy];
//            self.settingView.biaoqianArray = self.biaoqianArrays;
//        }
//        
//        
//    }
    
    NSString *url = @"broadcast_app";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    [MBProgressHUD showMessage:nil];
    [[NetWorkTool sharedTool] requestMethod:POST URL:url paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"%@_______________________________%@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [MBProgressHUD hideHUD];
            NSString *messageString = responseObject[@"broadcast"][0][@"keyWord"];
            self.settingView.nameTextFiled.text = responseObject[@"broadcast"][0][@"name"];
            self.settingView.typerTextFiled.text = responseObject[@"broadcast"][0][@"tytypeName"];
            self.Namelevel = responseObject[@"broadcast"][0][@"bctypeName"];
            if (messageString.length != 0) {
                
                NSArray *arr = [messageString componentsSeparatedByString:@"_"];
                self.biaoqianArrays = [arr mutableCopy];
                self.settingView.biaoqianArray = self.biaoqianArrays;
            }
            
//            [MBProgressHUD showSuccess:@"修改成功"];
//            WWAnchorSpaceViewController *achorSpace = [[WWAnchorSpaceViewController alloc] init];
//            achorSpace.roomName = self.settingView.nameTextFiled.text;
//            [self.navigationController pushViewController:achorSpace animated:YES];
        }else{
            [MBProgressHUD showError:@"网路出错"];
        }
    }];

}



#pragma mark -----WWSettingView---



@end
