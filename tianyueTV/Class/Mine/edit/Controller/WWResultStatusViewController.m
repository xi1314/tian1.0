//
//  WWResultStatusViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/18.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWResultStatusViewController.h"
#import "MBProgressHUD+MJ.h"
#import "WWLivingViewController.h"
#import "WWSettingViewController.h"
@interface WWResultStatusViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    BOOL datePickerShowOrHiden;/* 日期选择器是否隐藏 */
}
@property (nonatomic,strong) UIImageView *topImageView;//上面的图片
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIView *bgView;//输入框背景
@property (nonatomic,strong) UITextField *roomName;//房间名字
@property (nonatomic,strong) UITextField *choiceType;//选择分类
@property (nonatomic,strong) UIView *midLine;//输入框中线
@property (nonatomic,strong) UIButton *openLiving;//开启直播

@property (nonatomic,strong) UILabel *titleLabelw;//标题
@property (nonatomic,strong) UIButton *backButton;//返回按钮

@property (nonatomic,strong) UIPickerView *datePickerView;/* 日期选择器 */
@property (nonatomic,strong) NSDictionary *cityNames;/* plist文件信息 */
@property (nonatomic,strong) NSArray *provinces;/* 所有省份 */
@property (nonatomic,strong) NSArray *cities;/* 所有城市 */
@property (nonatomic,strong) NSString *city;/* 城市 */
@property (nonatomic,strong) NSString *province;/* 省份 */
@property (nonatomic,strong) UIView *topDateView;
@property (nonatomic,strong) UIButton *wanchengButton;/* 完成按钮 */

@end

@implementation WWResultStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
//    UIBarButtonItem *nItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
//    
//    self.navigationController.navigationItem.backBarButtonItem = nItem;
    
    self.navigationItem.hidesBackButton = YES;
//    self.navigationController.navigationItem.backBarButtonItem = nil;
    [self addPurLayOut];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----Actions----
- (void)respondsToOpenLiving:(UIButton *)sender{
//    if (self.roomName.text.length == 0 ) {
//        [MBProgressHUD showError:@"房间名不能为空"];
//    }else if(self.choiceType.text.length == 0){
//        [MBProgressHUD showError:@"请选择房间类型"];
//    }else{
//        [self netWorkRequest];
//    }
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"WWFirst"];
    WWSettingViewController *settingVc = [[WWSettingViewController alloc] init];
    settingVc.isHiddenLivingButton = NO;
    [self.navigationController pushViewController:settingVc animated:YES];
    NSLog(@"开启直播");
}

- (void)respondsToBackButton:(UIButton *)sender{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}


//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self hiddenDatePickerView];
//}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (datePickerShowOrHiden == NO) {
        [self showDatePickerView];
    }else{
        [self hiddenDatePickerView];
    }
    //写你要实现的：页面跳转的相关代码
    
    return NO;
    
}


#pragma mark ----网络请求----
- (void)netWorkRequest{
//    NSString *url = @"http://www.tianyue.tv/insertRoommobile";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"Name"] = self.roomName.text;
    param[@"typeName"] = self.choiceType.text;
    param[@"user_id"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    NSLog(@"param:%@",param);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"insertRoommobile" paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"%@_______________________________%@",responseObject,error);
        if ([responseObject[@"ret" ] isEqualToString:@"success"]) {
            [MBProgressHUD showSuccess:@"申请成功"];
            WWLivingViewController *living = [[WWLivingViewController alloc] init];
            [self.navigationController pushViewController:living animated:YES];
        }
    }];
   
}

#pragma mark ----日期选择器----
- (UIPickerView *)datePickerView{
    if (!_datePickerView) {
        _datePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0 , SCREEN_HEIGHT, SCREEN_WIDTH, kHeightChange(300))];
        //        _datePickerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _datePickerView.backgroundColor = [UIColor whiteColor];
        _datePickerView.dataSource = self;
        _datePickerView.delegate = self;
        _datePickerView.showsSelectionIndicator = YES;
        _datePickerView.layer.borderWidth = 0.5;
        _datePickerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _datePickerView.userInteractionEnabled = YES;
        
    }
    return _datePickerView;
}

- (NSDictionary *)cityNames{
    if (_cityNames == nil) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"typeData" ofType:@"plist"];
        _cityNames = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    return _cityNames;
}

- (NSArray *)provinces{
    if (_provinces == nil) {
        _provinces = [self.cityNames allKeys];
    }
    return _provinces;
}

- (UIView *)topDateView{
    if (!_topDateView) {
        _topDateView = [[UIView alloc] initWithFrame:CGRectMake(0 , SCREEN_HEIGHT, SCREEN_WIDTH, kHeightChange(80))];
        _topDateView.backgroundColor = [UIColor blueColor];
    }
    return _topDateView;
}



- (void)showDatePickerView{
    [self.view addSubview:self.datePickerView];
    [self.view addSubview:self.topDateView];
    ;
    [UIView beginAnimations:@"showDatePickerView" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationWillStartSelector:<#(nullable SEL)#>]
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGPoint cent = CGPointMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT - kHeightChange(150));
    self.datePickerView.center = cent;
    datePickerShowOrHiden = YES;
    [UIView commitAnimations];
}

- (void)hiddenDatePickerView{
    [UIView beginAnimations:@"hiddenDatePickerView" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    //    [UIView setAnimationWillStartSelector:<#(nullable SEL)#>]
    [UIView setAnimationDidStopSelector:@selector(removeDatePickerView)];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    CGPoint cent = CGPointMake(SCREEN_WIDTH *0.5, SCREEN_HEIGHT + kHeightChange(150));
    self.datePickerView.center = cent;
    self.topDateView.center = cent;
    datePickerShowOrHiden = NO;
    [UIView commitAnimations];
    //    [self.datePickerView removeFromSuperview];
}

- (void)removeDatePickerView{
    [self.datePickerView removeFromSuperview];
    NSLog(@"删除了datePickerView");
}


#pragma mark ----UIPickerViewDataSource && UIPickerViewDelegate----


//返回cell
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerTextLb = (UILabel *)view;
    if (!pickerTextLb) {
        pickerTextLb = [[UILabel alloc]init];
        pickerTextLb.textColor = [UIColor blackColor];
        pickerTextLb.adjustsFontSizeToFitWidth = YES;
        pickerTextLb.textAlignment = NSTextAlignmentCenter;
        pickerTextLb.font = [UIFont systemFontOfSize:kWidthChange(34)];
    }
    pickerTextLb.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerTextLb;
}
/**
 *  返回每一列的行数
 */
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    
    
    if (component == 0) {
        return self.provinces.count;
    }
    else {
        
        [self loadData:pickerView];
        
        
        return self.cities.count;
    }
}

/**
 *  返回每一行显示的文本
 */
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    //第一列返回所有的省份
    if (component == 0) {
        
        
        return self.provinces[row];
        
    }else{
        
        
        //         [self loadData:pickerView];
        return self.cities[row];
    }
}




/**
 *  加载第二列显示的数据
 */
-(void)loadData:(UIPickerView*)pickerView
{
    
    //一定要首先获取用户选择的那一行 然后才可以根据选中行获取省份 获取省份以后再去字典中加载省份对应的城市
    NSInteger selRow = [pickerView selectedRowInComponent:0];
    
    NSString *key = self.provinces[selRow];
    
    self.cities = [self.cityNames valueForKey:key];
    
}

/**
 *  一共多少咧
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 2;
}

/**
 *  选中某一行后回调 联动的关键
 */
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    WWBianjiTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (component == 0) {
        
        //重新加载第二列的数据
        [pickerView reloadComponent:1];
        //让第二列归位
        [pickerView selectRow:0 inComponent:1 animated:YES];
        self.province = self.provinces[row];
        NSLog(@"省份：%@",self.provinces[row]);
        
        
        self.choiceType.text = self.cities[0];
        
//        cell.rightLabel.text = self.provinces[row];
        //获取当前选中cell
        //        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        
    }else{
        self.city = self.cities[row];
        NSLog(@"城市：%@",self.cities[row]);
        if (self.province) {
            self.choiceType.text = self.city;
        }
    }
}



#pragma mark ----添加约束----
- (void)addPurLayOut{
    //上边的图片
    [self.view addSubview:self.topImageView];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(130)];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(80)];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(80)];
    [self.topImageView autoSetDimension:ALDimensionHeight toSize:kHeightChange(345)];
    
    //文字
    [self.view addSubview:self.label];
    [self.label autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topImageView withOffset:kHeightChange(75)];
    
    
    //输入框背景
    [self.view addSubview:self.bgView];
    [self.bgView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label withOffset:kHeightChange(58)];
    [self.bgView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(40)];
    [self.bgView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(40)];
    [self.bgView autoSetDimension:ALDimensionHeight toSize:kHeightChange(170)];
    
    // 输入中线
    [self.bgView addSubview:self.midLine];
    [self.midLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(10)];
    [self.midLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(10)];
    [self.midLine autoSetDimension:ALDimensionHeight toSize:kHeightChange(1)];
    [self.midLine autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    
    //房间名输入框
    [self.bgView addSubview:self.roomName];
    [self.roomName autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.roomName autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.roomName autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20)];
    
    //分类选择
    [self.bgView addSubview:self.choiceType];
    [self.choiceType autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.choiceType autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.choiceType autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(20)];
    
    [self.view addSubview:self.openLiving];
    [self.openLiving autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(35)];
    [self.openLiving autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(35)];
    [self.openLiving autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.bgView withOffset:kHeightChange(100)];
    [self.openLiving autoSetDimension:ALDimensionHeight toSize:kHeightChange(80)];
    
    //
    [self.view addSubview:self.backButton];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(14)];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [self.view addSubview:self.titleLabelw];
    [self.titleLabelw autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [self.titleLabelw autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
}

#pragma mark ----Getters----

//返回按钮
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(respondsToBackButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

//标题
- (UILabel *)titleLabelw{
    if (!_titleLabelw) {
        _titleLabelw = [[UILabel alloc] init];
        _titleLabelw.text = @"验证结果";
        _titleLabelw.textColor = WWColor(110, 110, 110);
    }
    return _titleLabelw;
}
//开启直播
-(UIButton *)openLiving{
    if (!_openLiving) {
        _openLiving = [[UIButton alloc] init];
        [_openLiving setBackgroundImage:[UIImage imageNamed:@"redCornerJuxing"] forState:UIControlStateNormal];
        _openLiving.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(34)];
        [_openLiving setTitle:@"下一步" forState:UIControlStateNormal];
        [_openLiving addTarget:self action:@selector(respondsToOpenLiving:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _openLiving;
    
}

//选择分类
- (UITextField *)choiceType{
    if (!_choiceType) {
        _choiceType = [[UITextField alloc] init];
        _choiceType.placeholder = @"选择分类";
        _choiceType.layer.borderWidth = 0;
        _choiceType.clearButtonMode = UITextFieldViewModeWhileEditing;
        _choiceType.delegate = self;
    }
    return _choiceType;
}

// 输入框背景中线
- (UIView *)midLine{
    if (!_midLine) {
        _midLine = [[UIView alloc] init];
        _midLine.backgroundColor = [UIColor blackColor];
        _midLine.alpha = 0.5;
    }
    return _midLine;
}
//房间名
- (UITextField *)roomName{
    if (!_roomName) {
        _roomName = [[UITextField alloc] init];
        _roomName.placeholder = @"请设置直播间名称";
        _roomName.layer.borderWidth = 0;
        _roomName.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _roomName;
}

//输入框的背景
- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = WWColor(237, 237, 237);
        _bgView.hidden = YES;
        
    }
    return _bgView;
}

//
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"恭喜您，实名认证成功，马上开启直播之旅吧";
        _label.font = [UIFont systemFontOfSize:kWidthChange(28)];
    }
    return _label;
}

//上面的图片
- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"微笑-拷贝"];
    }
    return _topImageView;
}

@end
