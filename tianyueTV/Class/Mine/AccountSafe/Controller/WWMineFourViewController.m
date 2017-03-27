//
//  WWMineFourViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineFourViewController.h"
#import "WWSaveView.h"
#import "MBProgressHUD+MJ.h"
#import "ViewController.h"

@interface WWMineFourViewController ()

@property (nonatomic,strong) WWSaveView *saveView;
@property (nonatomic,strong) NSString *pCode;

@end

@implementation WWMineFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.backgroundColor = WWColor(245, 245, 245);
    
//     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked2)];
    leftItem.image = [UIImage imageNamed:@"返回"];
    leftItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftItem;

    self.title = @"账号安全";
    
    [self.view addSubview:self.saveView];
    __weak typeof(self) ws = self;
    self.saveView.getButtonHandler = ^(){
        [ws getCodeButtonClicked];
    };
    self.saveView.confirmButtonHandler = ^(){
        [ws alreadyButtonClicked];
    };

    
}


#pragma mark ----Actions---

- (void)backItemClicked2{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCodeButtonClicked{
    
    
    [self netWorkRequest];
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.saveView.getVerificationCodeButton.backgroundColor = WWColor(51, 51, 51);
                [self.saveView.getVerificationCodeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                self.saveView.getVerificationCodeButton.userInteractionEnabled = YES;
            });
        }else{
            
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.saveView.getVerificationCodeButton.backgroundColor = [UIColor lightGrayColor];
                self.saveView.getVerificationCodeButton.userInteractionEnabled = NO;
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.saveView.getVerificationCodeButton setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime]  forState:UIControlStateNormal];
                self.saveView.getVerificationCodeButton.titleLabel.numberOfLines = 0;
                self.saveView.getVerificationCodeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
    
  

}

- (void)alreadyButtonClicked{
//    NSString *url = @"http://www.tianyue.tv/findPasswordmobile";
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    para[@"telephone"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    para[@"code"] = self.saveView.verificationCode.text;
    para[@"password"] = self.saveView.newpasswdTextField1.text;
    para[@"nowpassword"] = self.saveView.aginpasswdTextField.text;
    if (self.saveView.verificationCode.text.length == 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
    }else if (self.saveView.newpasswdTextField1.text.length == 0 || self.saveView.aginpasswdTextField.text.length == 0){
        [MBProgressHUD showError:@"密码不能为空"];
    }else if (self.saveView.newpasswdTextField1.text == self.saveView.aginpasswdTextField.text) {
        [[NetWorkTool sharedTool] requestMethod:POST URL:@"findPasswordmobile" paraments:para finish:^(id responseObject, NSError *error) {
            NSLog(@"%@",para);
            NSLog(@"responseObject:%@~~~~~~~~error:%@",responseObject,error);
            if (responseObject) {
                if ([responseObject[@"ret"] isEqualToString:@"success"]) {
//                    [MBProgressHUD showSuccess:@"修改成功"];
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"当前登录已失效" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *reloginAction = [UIAlertAction actionWithTitle:@"请重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        ViewController *login = [[ViewController alloc] init];
                         [self presentViewController:login animated:YES completion:nil];
                    }];
                   
                    [alert addAction:reloginAction];
                   
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
                if (responseObject[@"repeat2"]) {
                    [MBProgressHUD showError:@"验证码错误"];
                }
                
                if (responseObject[@"repeat3"]) {
                    [MBProgressHUD showError:@"两次密码不一致"];
                }
                
                
            }
            
        }];

    }else{
        [MBProgressHUD showError:@"两次密码不一致"];
    }

   }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)netWorkRequest{
//    NSString *url = @"http://www.tianyue.tv/getPxgaiCodemobile";
//    NSString *url = @"http://192.168.0.88:8081/Classifiedcataloguemobile";
    NSMutableDictionary *para = [[NSMutableDictionary alloc] init];
    para[@"telephone"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"getPxgaiCodemobile" paraments:para finish:^(id responseObject, NSError *error) {
        NSLog(@"responseObject:%@~~~~~~~~error:%@",responseObject,error);
        if (responseObject) {
            if ([responseObject[@"ret"] isEqualToString:@"success"]) {
                self.pCode = responseObject[@"pCode"];
            }
        }
       
    }];
}

- (WWSaveView *)saveView{
    if (!_saveView) {
        _saveView = [[WWSaveView alloc] initWithFrame:self.view.frame];
    }
    return _saveView;
}

@end
