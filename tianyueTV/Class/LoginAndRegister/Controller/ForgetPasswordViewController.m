//
//  ForgetPasswordViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/11/4.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "CustomView.h"
#import "ChangePasswordViewController.h"
#import "UIImage+CustomImage.h"
#import "MBProgressHUD+MJ.h"
#import "TianyueTools.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>
{
    int _timeOut;
}
@property(nonatomic,strong)UIImageView *warnImageView;
@property(nonatomic,strong)UILabel *warnLabel;

@property(nonatomic,strong)CustomView *CustomView;

@property(nonatomic,strong)UIButton *nextButton;

@property(nonatomic,strong)NSString *pCode;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"忘记密码";
    self.view.backgroundColor=WWColor(240, 240, 240);
    
    [self customBackBtn];
    [self addLayout];
    // Do any additional setup after loading the view.
}
//验证按钮点击事件
-(void)validationButtonClick:(UIButton *)sender
{
    //NSString *url =@"http://192.168.0.88:8081/getPxgaiCodemobile";
//    NSString *url =@"http://www.tianyue.tv/getPxgaiCodemobile";
    NSMutableDictionary *paraments =[[NSMutableDictionary alloc]init];
    paraments[@"telephone"] =self.CustomView.phoneTextField.text;
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"getPxgaiCodemobile" paraments:paraments finish:^(id responseObject, NSError *error) {
        NSLog(@"--验证%@-----%@---",responseObject,error);
        
        self.pCode =responseObject[@"pCode"];
        if ([responseObject[@"ret"] isEqualToString:@"error"])
        {
            [MBProgressHUD showError:@"手机号未注册"];
            
        }
        if([responseObject[@"ret"] isEqualToString:@"success"])
        {
            [self validationTimeOut];
            
        }
    }];
}

//判断输入的是否是手机号
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField ==self.CustomView.phoneTextField)
    {
        if ([TianyueTools isMobileNumber:textField.text]) {
            self.CustomView.validationButton.userInteractionEnabled = YES;
        }else{
            [MBProgressHUD showError:@"手机号输入有误"];
            self.CustomView.validationButton.userInteractionEnabled = NO;
        }
    }
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField ==self.CustomView.validationTextField)
    {
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }        if ([text isEqualToString:self.pCode])
        {
            NSLog(@"....验证码正确....");
            self.nextButton.userInteractionEnabled =YES;
            self.nextButton.backgroundColor =WWColor(211, 5, 26) ;
        }else
        {
            _nextButton.backgroundColor =WWColor(192, 192, 192);
            //[MBProgressHUD showError:@"验证码错误"];
        }
    }
    return YES;
}
//验证倒计时
-(void)validationTimeOut
{
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.CustomView.validationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.CustomView.validationButton.userInteractionEnabled = YES;
            });
        }else{
            int seconds = timeout ;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.CustomView.validationButton setTitle:[NSString stringWithFormat:@"%@ S",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                self.CustomView.validationButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}
-(void)nextBtnClick:(UIButton *)sender
{
    ChangePasswordViewController*loginVC =[[ChangePasswordViewController alloc]init];
    UINavigationController *loginNav =[[UINavigationController alloc]initWithRootViewController:loginVC];
    
    loginVC.phoneString =self.CustomView.phoneTextField.text;
    loginVC.code =self.CustomView.validationTextField.text;
    
    [self presentViewController:loginNav animated:YES completion:nil];
    
}
-(UIImageView *)warnImageView
{
    if (!_warnImageView)
    {
        _warnImageView =[[UIImageView alloc]init];
        [_warnImageView setImage:[UIImage imageNamed:@"感叹号"]];
        _warnImageView.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.warnImageView];
    }
    return _warnImageView;
}
-(UILabel *)warnLabel
{
    if (!_warnLabel)
    {
        _warnLabel =[[UILabel alloc]init];
        _warnLabel.text =@"请填您已注册的手机号";
        _warnLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _warnLabel.textColor =WWColor(128, 128, 128);
        _warnLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.warnLabel];
    }
    return _warnLabel;
}
-(UIButton *)nextButton
{
    if (!_nextButton)
    {
        _nextButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.tintColor =[UIColor whiteColor];
        _nextButton.backgroundColor =WWColor(192, 192, 192);
        _nextButton.layer.cornerRadius =5.0f;
        _nextButton.clipsToBounds =YES;
        
        _nextButton.userInteractionEnabled =NO;
        
        _nextButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.nextButton];
    }
    return _nextButton;
}
-(CustomView *)CustomView
{
    if (!_CustomView)
    {
        _CustomView =[[CustomView alloc]init];
        _CustomView.backgroundColor =[UIColor whiteColor];
        _CustomView.layer.cornerRadius =5.0f;
        _CustomView.clipsToBounds =YES;
        
        _CustomView.phoneTextField.delegate =self;
        _CustomView.validationTextField.delegate =self;
        [_CustomView.validationButton addTarget:self action:@selector(validationButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _CustomView.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.CustomView];
    }
    return _CustomView;
}


-(void)addLayout
{
    
    [self.CustomView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.CustomView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    [self.CustomView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kWidthChange(80)+64];
    [self.CustomView autoSetDimension:ALDimensionHeight toSize:kHeightChange(260)];
    
    [self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.CustomView withOffset:kHeightChange(72)];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.nextButton autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    [self.nextButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(85)];
    
    [self.warnImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(25)+64];
    [self.warnImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(59)];
    [self.warnImageView autoSetDimensionsToSize:CGSizeMake(kWidthChange(30), kHeightChange(30))];
    
    [self.warnLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.warnImageView withOffset:kWidthChange(5)];
    [self.warnLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(25)+64];
    [self.warnLabel autoSetDimensionsToSize:CGSizeMake(kWidth, kHeightChange(30))];
    
}
-(void)customBackBtn
{
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem =backItem;
    
}
-(void)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
