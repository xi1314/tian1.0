//
//  WWAnchorSpaceViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/12/7.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWAnchorSpaceViewController.h"
#import "WWAnchorSpaceCell.h"
#import "WWLivingViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WWSettingViewController.h"

@interface WWAnchorSpaceViewController ()<UITableViewDataSource,UITableViewDelegate,roomNameDelegate>
@property (nonatomic,strong) UIView *roomNameBgView;
@property (nonatomic,strong) UITextField *roomNameTextField;
@property (nonatomic,strong) UITableView *mainTabaleView;
@property (nonatomic,strong) UIButton *startLivingButton;
@property (nonatomic,strong) UIButton *bianjiButton;//输入框的编辑按钮
@property (nonatomic,strong) UIButton *leftButton;//返回
@property (nonatomic,strong) UIButton *rightButton;//帮助
@property (nonatomic,strong) UILabel *titleLableW;//标题
@property (nonatomic,strong) NSArray *imageArray;//图片数组
@property (nonatomic,strong) NSMutableArray *titileArray;//标题数组

@property (nonatomic,strong) NSDictionary *roomInafos;//房间信息
@property (nonatomic,strong) NSMutableArray *biaoqiansArrays;//标签数组


@end

@implementation WWAnchorSpaceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self netWorkRequestGet];
    [self addPureLayOut];
    [self netWorkRequestLivingInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)respondsToBianji:(UIButton *)sender{
    [self.roomNameTextField becomeFirstResponder];
}

- (void)respondsToStartClicked:(UIButton *)sender{
//    WWLivingViewController *mineSecondVc = [[WWLivingViewController alloc] init];
//    [self.navigationController pushViewController:mineSecondVc animated:YES];
    if (self.roomNameTextField.text.length == 0) {
        [MBProgressHUD showError:@"房间名不能为空"];
    }else if ([self.roomNameTextField.text isEqualToString:self.roomName]){
        //和前面的名字一样直接跳转
        WWLivingViewController *mineSecondVc = [[WWLivingViewController alloc] init];
        [self.navigationController pushViewController:mineSecondVc animated:YES];
        NSLog(@"直接跳转");
    }else{
        //进行网络请求修改房间名
        [self netWorkRequest];
        
    }
    
    
    NSLog(@"开启直播");
}

- (void)respondsToHelp:(UIButton *)sender{
    NSLog(@"帮助");
}

- (void)respondsToBack:(UIButton *)sender{
    self.tabBarController.tabBar.hidden = NO;
//    self.navigationController.navigationBarHidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark ----网络请求----
- (void)netWorkRequest{
//    NSString *url = @"http://www.tianyue.tv/updateZbj_app";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"name"] = self.roomNameTextField.text;
    param[@"id"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    param[@"typeName"] = self.typeName;
    param[@"Namelevel"] = self.Namelevel;
    NSString *keyWord = self.biaoqianArrayW[0];
    if (self.biaoqianArrayW.count != 0) {
        for (int i = 1; i < self.biaoqianArrayW.count; i ++) {
            keyWord = [keyWord stringByAppendingFormat:@"_%@",self.biaoqianArrayW[i]];
            param[@"keyWord"] = keyWord;
        }
    }else{
        param[@"keyWord"] = @"";
    }
    
    NSLog(@"%@",param);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"updateZbj_app" paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"%@_______________________________%@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
//            [MBProgressHUD showSuccess:@"修改成功"];
            WWLivingViewController *mineSecondVc = [[WWLivingViewController alloc] init];
            [self.navigationController pushViewController:mineSecondVc animated:YES];

        }
    }];

    
}

#pragma mark ----roomNameDelegate----
- (void)returnRoomName:(NSString *)roomName{
    self.roomNameTextField.text = roomName;
}

#pragma mark ----UITableViewDataSource && UITableViewDelegate---

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imageArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWAnchorSpaceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWAnchorSpaceCell"];
    if (!cell) {
        cell = [[WWAnchorSpaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWAnchorSpaceCell"];
    }
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = WWColor(242, 242, 242);
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (indexPath.row == 2) {
        cell.cornerView.hidden = NO;
    }else{
        cell.cornerView.hidden = YES;
    }
    cell.headImageViewW.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.titleLbaleW.text = self.titileArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1) {
        WWSettingViewController *settingVc = [[WWSettingViewController alloc] init];
        settingVc.isHiddenLivingButton = YES;
        settingVc.roomInfos = self.roomInafos;
        settingVc.settingView.biaoqianArray = self.biaoqiansArrays;
        settingVc.delegate = self;
        [self.navigationController pushViewController:settingVc animated:YES];
    }
}

#pragma mark ----网络请求----
- (void)netWorkRequestLivingInfo{
//    NSString *url = @"http://www.tianyue.tv/broadcast_app";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];

    [[NetWorkTool sharedTool] requestMethod:POST URL:@"broadcast_app" paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"%@_______________________________%@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
//            [self.titileArray insertObject:[NSString stringWithFormat:@"我的粉丝：%@",responseObject[@"broadcast"][0][@"focusNum"]] atIndex:0];
            [self.titileArray setObject:[NSString stringWithFormat:@"我的粉丝：%@",responseObject[@"broadcast"][0][@"focusNum"]] atIndexedSubscript:0];
            [self.mainTabaleView reloadData];
        }else{
            
        }
    }];
    
}


- (void)netWorkRequestGet{
    id responseObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"livingRoomInfo"];
    NSLog(@"%@",responseObject);
    if ([responseObject[@"ret"] isEqualToString:@"success"]) {
        self.Namelevel = responseObject[@"broadcast"][0][@"bctypeName"];
        self.typeName = responseObject[@"broadcast"][0][@"tytypeName"];
        [MBProgressHUD hideHUD];
        self.roomNameTextField.text = responseObject[@"broadcast"][0][@"name"];
        NSString *messageString = responseObject[@"broadcast"][0][@"keyWord"];
        if (messageString.length != 0) {
            
            NSArray *arr = [messageString componentsSeparatedByString:@"_"];
            self.biaoqiansArrays = [arr mutableCopy];
            self.biaoqianArrayW = arr;
        }
        self.roomInafos = responseObject[@"broadcast"][0];
    }
}


#pragma mark ----addPureLayOut--
- (void)addPureLayOut{
    [self.view addSubview:self.roomNameBgView];
    [self.roomNameBgView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    [self.roomNameBgView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.roomNameBgView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.roomNameBgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(82)];
    
    [self.roomNameBgView addSubview:self.roomNameTextField];
    [self.roomNameTextField autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.roomNameTextField autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.roomNameTextField autoSetDimensionsToSize:CGSizeMake(kWidthChange(500), kHeightChange(50))];
    
    [self.roomNameBgView addSubview:self.bianjiButton];
    [self.bianjiButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.bianjiButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    [self.view addSubview:self.startLivingButton];
    [self.startLivingButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(50)];
    [self.startLivingButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(50)];
    [self.startLivingButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:85];
    [self.startLivingButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(85)];
    
    [self.view addSubview:self.mainTabaleView];
    [self.mainTabaleView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.mainTabaleView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.mainTabaleView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.roomNameBgView withOffset:kHeightChange(96)];
    [self.mainTabaleView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(350)];
    
    [self.view addSubview:self.leftButton];
    [self.leftButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [self.leftButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.roomNameBgView withOffset:-10];

    [self.view addSubview:self.titleLableW];
    [self.titleLableW autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.roomNameBgView withOffset:-10];
    [self.titleLableW autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    [self.view addSubview:self.rightButton];
    [self.rightButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [self.rightButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.roomNameBgView withOffset:-5];
}

#pragma mark ----Getters----

//房间信息
-(NSDictionary *)roomInafos{
    if (!_roomInafos) {
        _roomInafos = [[NSDictionary alloc] init];
    }
    return _roomInafos;
}

- (UIButton *)bianjiButton{
    if (!_bianjiButton) {
        _bianjiButton = [[UIButton alloc] init];
        [_bianjiButton setImage:[UIImage imageNamed:@"修改-拷贝-3"] forState:UIControlStateNormal];
        [_bianjiButton addTarget:self action:@selector(respondsToBianji:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bianjiButton;
}

- (NSMutableArray *)titileArray{
    if (!_titileArray) {
//        _titileArray = [[NSArray alloc] initWithObjects:@"我的粉丝：2000", @"我的店铺",@"我的收益",@"直播设置",nil];
        _titileArray = [[NSMutableArray alloc] initWithObjects:@"我的粉丝",@"直播设置",nil];
        
    }
    return _titileArray;
    
}
- (NSArray *)imageArray{
    if (!_imageArray) {
//        _imageArray = [[NSArray alloc] initWithObjects:@"我的粉丝",@"店铺-(1)",@"收益",@"直播设置", nil];
        _imageArray = [[NSArray alloc] initWithObjects:@"我的粉丝",@"直播设置", nil];
    }
    return _imageArray;
}

- (UIButton *)rightButton{
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] init];
        _rightButton.hidden = YES;
        [_rightButton setTitle:@"帮助" forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(respondsToHelp:) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setTitleColor:WWColor(122, 122, 122) forState:UIControlStateNormal];
//        _rightButton.titleLabel.textColor = [UIColor blackColor];
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:17];
    }
    return _rightButton;
}

- (UILabel *)titleLableW{
    if (!_titleLableW) {
        _titleLableW = [[UILabel alloc] init];
        _titleLableW.text = @"主播空间";
        _titleLableW.textColor = WWColor(122, 122, 122);
        _titleLableW.font = [UIFont systemFontOfSize:17];
        _titleLableW.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLableW;
}

- (UIButton *)leftButton{
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] init];
        [_leftButton setBackgroundImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(respondsToBack:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftButton;
}

- (UIButton *)startLivingButton{
    if (!_startLivingButton) {
        _startLivingButton = [[UIButton alloc] init];
        [_startLivingButton setBackgroundImage:[UIImage imageNamed:@"redCornerJuxing"] forState:UIControlStateNormal];
        [_startLivingButton setTitle:@"开启直播" forState:UIControlStateNormal];
        [_startLivingButton addTarget:self action:@selector(respondsToStartClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _startLivingButton;
}

- (UITableView *)mainTabaleView{
    if (!_mainTabaleView) {
        _mainTabaleView = [[UITableView alloc] init];
        _mainTabaleView.dataSource = self;
        _mainTabaleView.delegate = self;
        [_mainTabaleView registerClass:[WWAnchorSpaceCell class] forCellReuseIdentifier:@"WWAnchorSpaceCell"];
        _mainTabaleView.rowHeight = kHeightChange(125);
        _mainTabaleView.scrollEnabled = NO;
        _mainTabaleView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _mainTabaleView;
}

- (UITextField *)roomNameTextField{
    if (!_roomNameTextField) {
        _roomNameTextField = [[UITextField alloc] init];
        _roomNameTextField.layer.borderWidth = 0;
        _roomNameTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        _roomNameTextField.textColor = [UIColor blackColor];
        _roomNameTextField.placeholder = @"请输入房间名称";
        _roomNameTextField.text = self.roomName;
        _roomNameTextField.textAlignment = NSTextAlignmentCenter;
        
    }
    return _roomNameTextField;
}

-(UIView *)roomNameBgView{
    if (!_roomNameBgView) {
        _roomNameBgView = [[UIView alloc] init];
        _roomNameBgView.backgroundColor = WWColor(242, 242, 242);
    }
    return _roomNameBgView;
    
}

@end
