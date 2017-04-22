//
//  MineViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/11.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "MineViewController.h"

#import "WWMineView.h"
#import "WWMineFirstViewController.h"
#import "WWMineSecondViewController.h"
#import "WWMineThirdViewController.h"
#import "WWMineFourViewController.h"
#import "WWMineFiveViewController.h"
#import "WWMineBianjiViewController.h"
#import "WWCameraCutViewController.h"
#import "MBProgressHUD+MJ.h"

#import "WWResultStatusViewController.h"
#import "WWResultingViewController.h"
#import "WWResultDefailtViewController.h"
#import "WWRealNameViewController.h"

#import "WWLivingViewController.h"
#import "WWAnchorSpaceViewController.h"

#import "UpYun.h"


//#import "UIImageView+WebCache.h"
#import "WWImageURLCacher.h"

#import "WWFirstArtisanRecruit.h"
#import "WWFeedbackViewController.h"

#import "OrderManagerViewController.h"


@interface MineViewController ()
<UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
WWCameraCutViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;


@property (nonatomic, strong) WWMineView *mine;


@property (nonatomic, strong) UIImagePickerController *pick;


@property (nonatomic, strong) WWCameraCutViewController *imageCrop;


@property (nonatomic,strong) UIImage *choiceImage;


@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mine];
    __weak typeof(self) ws = self;
    
    //我的关注
    self.mine.FirstButtonHandler = ^(){
        [ws firstButtonClicked];
    };
    
    //播放历史
    self.mine.ScondButtonHandler = ^(){
        [ws SecondButtonClicked];
    };
    
    //我的直播间
    self.mine.ThirdButtonHandler = ^(){
        [ws thirdButtonClicked];
    };
    
    //账号安全
    self.mine.FourButtonHandler = ^(){
        [ws fourthButtonClicked];
    };
    
    //设置
    self.mine.FiveButtonHandler = ^(){
        [ws FiveButtonClicked];
    };
    
    //暂时取消
    self.mine.bianjiButtonHandler = ^(){
        [ws bianjiButtonClicker];
    };
    
    //修改头像
    self.mine.gestureClickedHandler = ^(){
        [ws gestureClickedHandler];
    };
    
    //主播认证
    self.mine.zhuborenzhengHandler = ^(){
        [ws zhuborenzhengClicker];
    };
    
    //反馈
    self.mine.messageClickedHander = ^(){
        [ws messageClickedHander];
    };
    
    
    [self netWorkRequest];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"WIFIwarning"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"remind" forKey:@"WIFIwarning"];
    }
    
    
}


- (void)realName{
    
    WWRealNameViewController *realnameVC = [[WWRealNameViewController alloc] init];
    [self.navigationController pushViewController:realnameVC animated:YES];
}

- (WWMineView *)mine{
    if (!_mine) {
        _mine = [[WWMineView alloc] initWithFrame:self.view.frame];
    }
    return _mine;
}



#pragma mark ----头像剪切----
- (void)gestureClickedHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"请选择图片来源" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        self.pick = imagePicker;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:imagePicker.sourceType];
            imagePicker.delegate   = self;
//            imagePicker.editing = NO;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }else{
            [MBProgressHUD showError:@"没有获取到相机权限"];
        }
        
        
    }];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"从相册选择照片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *albumPicker = [[UIImagePickerController alloc] init];
         self.pick = albumPicker;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            albumPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            albumPicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:albumPicker.sourceType];
            albumPicker.delegate   = self;
//            albumPicker.editing = NO;
            [self presentViewController:albumPicker animated:YES completion:nil];
        }else{
            [MBProgressHUD showError:@"无法获取相册权限"];
        }
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:camera];
    [alert addAction:album];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"头像选择");
}


#pragma mark -----WWCameraCutViewDelegate----
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    self.imageView.image = cropImage;
    self.imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*(cropImage.size.height/cropImage.size.width));
    self.mine.headImages.image = cropImage;
    self.mine.bigHeadView.image = cropImage;
    self.choiceImage = cropImage;
    __weak typeof(self) ww = self;
    self.imageCrop.quedingClickedHandler = ^(){
        [ww quedingClickedHandler];
    };
    
}


#pragma mark ----UINavigationControllerDelegate& & UIImagePickerControllerDelegate----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//    WWCameraCutViewController *imageCrop = [[WWCameraCutViewController alloc] init];
    self.imageCrop.delegate = self;
    self.imageCrop.ratioOfWidthAndHeight = 800.0f/600.0f;
    self.imageCrop.image = image;
    [self.imageCrop showWithAnimation:YES];
    

    
}

- (WWCameraCutViewController *)imageCrop{
    if (!_imageCrop) {
        _imageCrop = [[WWCameraCutViewController alloc] init];
        _imageCrop.ratioOfWidthAndHeight = 1.0;
    }
    return _imageCrop;
}






- (UIImagePickerController *)pick{
    if (!_pick) {
        _pick = [[UIImagePickerController alloc] init];
    }
    return _pick;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
 
}

- (void)quedingClickedHandler{
    NSLog(@"dianji");
    [self.pick dismissViewControllerAnimated:YES completion:nil];
    [self networkRequestHeadImage];
    
}

#pragma mark ----跳转----
//反馈按钮
- (void)messageClickedHander{
//    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    WWFeedbackViewController *feedback = [[WWFeedbackViewController alloc] init];
    feedback.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:feedback animated:YES];
}

//主播认证
- (void)zhuborenzhengClicker{
    
    if ([self.mine.zhuBoRenzheng.titlew.text isEqualToString:@"我的直播间"]) {
        // 直播间
//        WWAnchorSpaceViewController *anchorSpace = [[WWAnchorSpaceViewController alloc] init];
//        [self.navigationController pushViewController:anchorSpace animated:YES];
        //直播画面        
        WWLivingViewController *living = [[WWLivingViewController alloc] init];
        [self.navigationController pushViewController:living animated:YES];
    }else{
        
        
        //        WWResultDefailtViewController *success = [[WWResultDefailtViewController alloc] init];
        //        [self.navigationController pushViewController:success animated:YES];
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
            [self realName];
            //        WWResultStatusViewController *success = [[WWResultStatusViewController alloc] init];
            //        [self.navigationController pushViewController:success animated:YES];
        }

    }
    
}

//编辑
- (void)bianjiButtonClicker{
    WWMineBianjiViewController *mineBianjiVC = [[WWMineBianjiViewController alloc] init];
    [self.navigationController pushViewController:mineBianjiVC animated:YES];
}

//设置
- (void)FiveButtonClicked{
    self.navigationController.navigationBarHidden = NO;
//    self.tabBarController.tabBar.hidden = YES;
    WWMineFiveViewController *mineFiveVc = [[WWMineFiveViewController alloc] init];
    mineFiveVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineFiveVc animated:YES];
}

//账号安全
- (void)fourthButtonClicked{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    WWMineFourViewController *mineFourVc = [[WWMineFourViewController alloc] init];
    [self.navigationController pushViewController:mineFourVc animated:YES];
}

//我的直播
- (void)thirdButtonClicked{
    WWMineThirdViewController *mineThirdVc = [[WWMineThirdViewController alloc] init];
    [self.navigationController pushViewController:mineThirdVc animated:YES];
}

//关注
- (void)SecondButtonClicked{
    // 模拟卖家入口
    OrderManagerViewController *orderVC = [[OrderManagerViewController alloc] init];
    orderVC.hidesBottomBarWhenPushed = YES;
    orderVC.isSeller = YES;
    [self.navigationController pushViewController:orderVC animated:YES];
}

//个人作品及视频
- (void)firstButtonClicked{
    // 模拟买家入口
    OrderManagerViewController *orderVC = [[OrderManagerViewController alloc] init];
    orderVC.hidesBottomBarWhenPushed = YES;
    orderVC.isSeller = NO;
    [self.navigationController pushViewController:orderVC animated:YES];
}



- (void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
//    self.tabBarController.tabBar.hidden = NO;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"baudit"] ) {
        NSInteger baudit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"baudit"] integerValue];
        if (baudit == 1) {
            [self netWorkRequestGet];
        }
    }
    
}




- (void)netWorkRequest{
//    NSString *url = @"http://www.tianyue.tv/mobileUserCenter";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"uId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"mobileUserCenter" paraments:param finish:^(id responseObject, NSError *error) {
//        NSLog(@"%@",param);
        
        if (responseObject) {
            NSLog(@"%@",responseObject);

            if (responseObject[@"baudit"] != [NSNull null] ) {
                 [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"baudit"] forKey:@"baudit"];
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"bCard"];
            if (responseObject[@"bCard"] != [NSNull null] ) {
                [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"bCard"] forKey:@"bCard"];

            }
            
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"WWFirst"];
            if (responseObject[@"baudit"] != [NSNull null] ) {
                NSInteger baudit = [responseObject[@"baudit"] integerValue];
                if (baudit == 1) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"WWFirst"];
                }else{
                    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"WWFirst"];
                }
            }
            

            
            
            //        NSLog(@"%@-----------%@",responseObject,error);
            self.mine.moneyLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"score"]];
            self.mine.secondMoney.text = [NSString stringWithFormat:@"%@",responseObject[@"integral"]];
            
            if (![[NSString stringWithFormat:@"%@",responseObject[@"headUrl"]] isEqualToString:@"<null>"]) {
                [[WWImageURLCacher sharedImageURLCacher] ww_setCacheWithImageView:self.mine.headImages imageURL:responseObject[@"headUrl"] imageKey:[NSString stringWithFormat:@"headImage%@",responseObject[@"id"]]];
                [[WWImageURLCacher sharedImageURLCacher] ww_setCacheWithImageView:self.mine.bigHeadView imageURL:responseObject[@"headUrl"] imageKey:[NSString stringWithFormat:@"headImage%@",responseObject[@"id"]]];
//                UIImage *cachedImage;
//                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"headUrl"]) {
//                    cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[[NSUserDefaults standardUserDefaults] objectForKey:@"headUrl"]];
//                    
//                }
//                if (cachedImage) {
////                    [self.mine.headImages sd_setImageWithURL:[NSURL URLWithString:responseObject[@"headUrl"]] placeholderImage:cachedImage];
////                    
////                    [self.mine.bigHeadView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"headUrl"]] placeholderImage:cachedImage];
//                    self.mine.headImages.image = cachedImage;
//                    self.mine.bigHeadView.image = cachedImage;
//                  
//                    
//                }else{
//                    [self.mine.headImages sd_setImageWithURL:[NSURL URLWithString:responseObject[@"headUrl"]] placeholderImage:[UIImage imageNamed:@"897"]];
//                    
//                    [self.mine.bigHeadView sd_setImageWithURL:[NSURL URLWithString:responseObject[@"headUrl"]] placeholderImage:[UIImage imageNamed:@"897"]];
//                }
//                
//                
//                 [[NSUserDefaults standardUserDefaults] setObject:responseObject[@"headUrl"] forKey:@"headUrl"];
                
            }
            
            NSInteger baudit = [[[NSUserDefaults standardUserDefaults] objectForKey:@"baudit"] integerValue];
            if (baudit == 1) {
                self.mine.zhuBoRenzheng.titlew.text = @"我的直播间";
                [self netWorkRequestGet];
            }
            self.mine.nameLabel.text = responseObject[@"nickName"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            [MBProgressHUD showError:@"网络出错"];
        }
        

        
//        NSLog(@"%@,%@",self.mine.moneyLabel.text,self.mine.secondMoney.text);
    }];
}


#pragma mark ----网络请求----
- (void)netWorkRequestGet{
//    NSString *url = @"http://www.tianyue.tv/broadcast_app";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];

    [[NetWorkTool sharedTool] requestMethod:POST URL:@"broadcast_app" paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"%@_______________________________%@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [[NSUserDefaults standardUserDefaults] setObject:responseObject forKey:@"livingRoomInfo"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }else{
            
        }
    }];
    
}


#pragma mark ----修改头像----
- (void)networkRequestHeadImage{



    
    [UPYUNConfig sharedInstance].DEFAULT_BUCKET = @"zswl-images";
    [UPYUNConfig sharedInstance].DEFAULT_PASSCODE = @"28LU61t4/anqeXKM6sJwzx1toL4=";
    //    [UPYUNConfig sharedInstance].DEFAULT_EXPIRES_IN = 1800;
//    UIImage * image = self.addIDimageView.image;
//    UIImage *image2 = self.addSecondImageView.image;
    
    
    
    
    
    __block UpYun *uy = [[UpYun alloc] init];
    //        uy.uploadMethod = UPMutUPload;
     [MBProgressHUD showMessage:@"正在上传..." toView:self.view];
     [uy uploadFile:self.choiceImage saveKey:[self getSaveKeyWith:@"jpg"]];
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"response body %@", responseData);
//            NSString *url = @"http://www.tianyue.tv/update_headUrl";
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
//            params[@"userName"] = self.mine.nameLabel.text;
            params[@"headUrl"] = responseData[@"url"];//backImage
            params[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
            NSLog(@"%@",params);
            [[NetWorkTool sharedTool] requestMethod:POST URL:@"update_headUrl" paraments:params finish:^(id responseObject, NSError *error) {
                NSLog(@"头像修改%@_________-----%@",responseObject,error);
                if ([responseObject[@"ret"] isEqualToString:@"success"]) {
                    [MBProgressHUD hideHUDForView:self.view];
                    [MBProgressHUD showSuccess:@"上传成功" toView:self.view];
                }else{
                    [MBProgressHUD hideHUDForView:self.view];
                    [MBProgressHUD showError:@"上传失败" toView:self.view];
                }
            }];
            
        
        //
        
        
    };
    uy.failBlocker = ^(NSError * error) {
        //        NSString *message = error.description;
        //        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"message" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //        [alert show];
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:@"图片上传失败"];
        NSLog(@"error %@", error);
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        //        [self.customPressView setPercent:percent];
    };
    
    
    //    [uy uploadImage:image savekey:[self getSaveKeyWith:@"png"]];
    
   
    
    
    


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
    NSDate *curDate = [NSDate date];//获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy/MM/dd"];//这里去掉 具体时间 保留日期
    NSString * curTime = [formater stringFromDate:curDate];
    curTime = [NSString stringWithFormat:@"%@/%.0f", curTime, [curDate timeIntervalSince1970]];
    return curTime;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
