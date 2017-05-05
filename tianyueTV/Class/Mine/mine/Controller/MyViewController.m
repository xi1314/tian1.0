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
#import "LoginModel.h"
#import "UpYun.h"
#import "WWLivingViewController.h"
#import "WWResultingViewController.h"
#import "WWRealNameViewController.h"
#import "WWResultDefailtViewController.h"
#import "WWSettingViewController.h"
#import "MyOrderView.h"
#import "OrderManagerViewController.h"
#import "WWMineFourViewController.h"

@interface MyViewController ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (nonatomic, strong) UIScrollView *baseScroll;
@property (nonatomic, strong) UIView *view_head;
@property (nonatomic, strong) UIImageView *imgV_user;
@property (nonatomic, strong) UIImageView *imgV_userStatus;
@property (nonatomic, strong) MyCategoryView *view_yuebi;
@property (nonatomic, strong) MyCategoryView *view_lingtao;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) LoginModel *loginModel;
@property (nonatomic, strong) UIImage *choiceImage;

// 订单二级视图
@property (nonatomic, strong) MyOrderView *myOrderView;

// 返回上一级
@property (nonatomic, strong) UIButton *backButton;


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
    
    self.loginModel = [self gainObjectFromUsersDefaults:@"loginSuccess"];
    
    [self initHeadView];
    
    [self initItemView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
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
    
    self.imgV_user = [[UIImageView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - (imgV_head.height - 140))/2.0f, 65, imgV_head.height - 140, imgV_head.height - 140)];
    _imgV_user.layer.cornerRadius = (imgV_head.height - 140)/2.0f;
    _imgV_user.layer.masksToBounds = YES;
    [_imgV_user setImageWithURL:[NSURL URLWithString:self.loginModel.headUrl] placeholderImage:[UIImage imageNamed:@"my_defaultHead"]];
    _imgV_user.userInteractionEnabled = YES;
    [self.view_head addSubview:_imgV_user];
    
    UITapGestureRecognizer *userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapAction:)];
    [_imgV_user addGestureRecognizer:userTap];
    
    
    
    self.imgV_userStatus = [[UIImageView alloc] initWithFrame:CGRectMake(_imgV_user.left + _imgV_user.width - 30, _imgV_user.top + _imgV_user.height - 30, 30, 30)];
    _imgV_userStatus.contentMode = UIViewContentModeScaleAspectFit;
    _imgV_userStatus.image = [UIImage imageNamed:@"主播"];
    _imgV_userStatus.hidden = YES;
    if ([self.loginModel.bCard intValue] == 1) { // 如果实名认证已通过，则显示图标
        _imgV_userStatus.hidden = NO;
    }
    [self.view_head addSubview:_imgV_userStatus];
    
    UILabel *lab_user = [[UILabel alloc] initWithFrame:CGRectMake(0, _imgV_user.bottom, self.view_head.width, 60)];
    lab_user.backgroundColor = [UIColor clearColor];
    lab_user.font = [UIFont boldSystemFontOfSize:18.f];
    lab_user.textColor = [UIColor whiteColor];
    lab_user.textAlignment = NSTextAlignmentCenter;
    lab_user.text = self.loginModel.nickName;
    [self.view_head addSubview:lab_user];
    
    self.view_yuebi = [[MyCategoryView alloc] initWithFrame:CGRectMake(15, imgV_head.bottom + 15, 125, 20) image:@"my_yuebi" title:@"越币"];
    if ([self.loginModel.score intValue] > 0) {
        [self.view_yuebi setNum:[NSString stringWithFormat:@"%@", self.loginModel.score]];
    }else {
        [self.view_yuebi setNum:@"0"];
    }
    [self.view_head addSubview:self.view_yuebi];
    
    self.view_lingtao = [[MyCategoryView alloc] initWithFrame:CGRectMake(self.view_yuebi.right + 10, imgV_head.bottom + 15, 125, 20) image:@"my_lingtao" title:@"灵桃"];
    if ([self.loginModel.integral intValue] > 0) {
        [self.view_lingtao setNum:[NSString stringWithFormat:@"%@", self.loginModel.integral]];
    }else {
        [self.view_lingtao setNum:@"0"];
    }
    [self.view_head addSubview:self.view_lingtao];

}

// 头像点击响应
- (void)userTapAction:(UITapGestureRecognizer *)tap
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
    UIAlertAction* fromPhotoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self LocalPhoto];
        
    }];
    UIAlertAction* fromCameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        [self takePhoto];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:fromCameraAction];
    [alertController addAction:fromPhotoAction];
    [self presentViewController:alertController animated:YES completion:nil];

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
        case 2: { // 直播前进行认证判断
            [self zhuborenzhengClicker];
            break;
        }
        case 3: { // 账号安全
            WWMineFourViewController *mineFourVc = [[WWMineFourViewController alloc] init];
            mineFourVc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mineFourVc animated:YES];
            break;
        }
        case 4: { // 设置
           
            [self intoSetting];
            break;
        }
        case 5: { // 我的订单
            [self.baseScroll addSubview:self.myOrderView];
            [self.view addSubview:self.backButton];
            break;
        }
        default:
            break;
    }
}


// 直播前进行认证判断
- (void)zhuborenzhengClicker {

    NSString *bCardString = [NSString stringWithFormat:@"%@", self.loginModel.bCard];
    if ([bCardString containsString:@"null"] || [bCardString isEqualToString:@""]) {
        // 未进行实名认证，进入实名认证界面
        WWRealNameViewController *realnameVC = [[WWRealNameViewController alloc] init];
        realnameVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:realnameVC animated:YES];
        
    }else {
        if ([bCardString intValue] == 1) { // 实名认证成功
            if ([self.loginModel.baudit intValue] == 1) { // 直播间已设置
                // 直播画面
                WWLivingViewController *living = [[WWLivingViewController alloc] init];
                living.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:living animated:YES];
            }else {
                // 进入直播间设置界面
                WWSettingViewController *liveSetVC = [[WWSettingViewController alloc] init];
                liveSetVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:liveSetVC animated:YES];
            }
        }else if ([bCardString intValue] == 2) { // 实名认证审核中
            
            WWResultingViewController *resulting = [[WWResultingViewController alloc] init];
            resulting.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:resulting animated:YES];
            
        }else if ([bCardString intValue] == 0) { // 实名认证失败
            WWResultDefailtViewController *resultFail = [[WWResultDefailtViewController alloc] init];
            resultFail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:resultFail animated:YES];
        }
    }
}


//设置
- (void)intoSetting {

    WWMineFiveViewController *mineFiveVc = [[WWMineFiveViewController alloc] init];
    mineFiveVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineFiveVc animated:YES];
}

//返回，移除订单二级页面
- (void)respondsToBackButton:(UIButton *)sender {
    [self.myOrderView removeFromSuperview];
    [self.backButton removeFromSuperview];
}

#pragma mark - Getter method
- (MyOrderView *)myOrderView {
    CGFloat height = self.view_head.height;
    if (!_myOrderView) {
        _myOrderView = [[MyOrderView alloc] initWithFrame:CGRectMake(0 ,self.view_head.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - height - NavigationBarHeight)];
        _myOrderView.backgroundColor = WWColor(242, 242, 242);
        
        @weakify(self);
        _myOrderView.block = ^(NSInteger tag){
            @strongify(self);
            
            OrderManagerViewController *orderVC = [[OrderManagerViewController alloc] init];
            orderVC.hidesBottomBarWhenPushed = YES;
            if (tag == 0) {
                // 模拟买家入口
                orderVC.isSeller = NO;
                
            } else {
                // 模拟卖家入口
                orderVC.isSeller = YES;
            }
            [self.navigationController pushViewController:orderVC animated:YES];
        };
    }
    return _myOrderView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(10, 20, 30, 30);
        [_backButton setImage:[UIImage imageNamed:@"btn_backWhite"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(respondsToBackButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}


#pragma mark - 开始拍照
- (void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        [MBProgressHUD showError:@"您的手机不支持拍照功能"];
    }
}

#pragma mark - 打开本地相册
- (void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
// 选择图片后信息处理
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    // 当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        
        // 先把图片保存
        self.choiceImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
        // 修改用户头像
        [self networkRequestHeadImage];
        
        // 关闭相册界面
        [picker dismissViewControllerAnimated:YES completion:NULL];
 
    }
}

// 取消图片的编辑选择
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - 修改用户头像
- (void)networkRequestHeadImage {

    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"zswl-images";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"28LU61t4/anqeXKM6sJwzx1toL4=";

    UpYun *uy = [[UpYun alloc] init];
    [MBProgressHUD showMessage:@"正在上传..." toView:self.view];
    [uy uploadFile:self.choiceImage saveKey:[self getSaveKeyWith:@"jpg"]];
    
    @weakify(self);
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        
        @strongify(self);
        
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
        params[@"headUrl"] = responseData[@"url"]; // backImage
        params[@"userId"] = self.loginModel.ID;
     
        [[NetWorkTool sharedTool] requestMethod:POST URL:api_update_headUrl paraments:params finish:^(id responseObject, NSError *error) {

            [MBProgressHUD hideHUDForView:self.view];
            
            if ([responseObject[@"ret"] isEqualToString:@"success"]) {
                
                [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
                
                self.imgV_user.image = self.choiceImage;
            }else{

                [MBProgressHUD showError:@"上传失败" toView:self.view];
            }
        }];

    };
    uy.failBlocker = ^(NSError * error) {

        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"图片上传失败"];

    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
       
    };
 
}

- (NSString * )getSaveKeyWith:(NSString *)suffix {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    return [NSString stringWithFormat:@"/%@.%@", [self getDateString], suffix];
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
    //        return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    /**
     *	@brief	更多方式 参阅 http://docs.upyun.com/api/form_api/#_4
     */
}
- (NSString *)getDateString {
    NSDate *curDate = [NSDate date]; // 获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"]; // 这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
