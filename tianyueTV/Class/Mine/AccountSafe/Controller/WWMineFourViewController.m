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

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClicked:)];
    leftItem.image = [UIImage imageNamed:@"nav_back"];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


#pragma mark - Actions
- (void)backItemClicked:(UIBarButtonItem *)item {
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取验证码
- (void)getCodeButtonClicked {
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
        } else {
            
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

// 确认修改
- (void)alreadyButtonClicked {
    
    NSString *telephone = [self gainObjectFromUsersDefaults:@"userName"];
    
    NSDictionary *paraDic = @{@"telephone" : telephone,
                              @"code" : self.saveView.verificationCode.text,
                              @"password" : self.saveView.newpasswdTextField1.text,
                              @"nowpassword" : self.saveView.aginpasswdTextField.text};
    
    if (self.saveView.verificationCode.text.length == 0) {
        [MBProgressHUD showError:@"验证码不能为空"];
    }else if (self.saveView.newpasswdTextField1.text.length == 0 || self.saveView.aginpasswdTextField.text.length == 0){
        [MBProgressHUD showError:@"密码不能为空"];
    }else if (self.saveView.newpasswdTextField1.text == self.saveView.aginpasswdTextField.text) {
        [[NetWorkTool sharedTool] requestMethod:POST URL:@"findPasswordmobile" paraments:paraDic finish:^(id responseObject, NSError *error) {

            NSLog(@"responseObject:%@~~~~~~~~error:%@",responseObject,error);
            if (responseObject) {
                if ([responseObject[@"ret"] isEqualToString:@"success"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"修改成功，当前登录已失效" preferredStyle:UIAlertControllerStyleAlert];
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



// 获取验证码
- (void)netWorkRequest{

    NSString *telephone = [self gainObjectFromUsersDefaults:@"userName"];
    NSDictionary *paraDic = @{@"telephone" : telephone};
    
    @weakify(self);
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"getPxgaiCodemobile" paraments:paraDic finish:^(id responseObject, NSError *error) {
        @strongify(self);
        NSLog(@"responseObject:%@~~~~~~~~error:%@",responseObject,error);
        if (responseObject) {
            if ([responseObject[@"ret"] isEqualToString:@"success"]) {
                self.pCode = responseObject[@"pCode"];
                [MBProgressHUD showSuccess:@"发送成功"];
            } else {
                [MBProgressHUD showError:@"发送失败"];
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
