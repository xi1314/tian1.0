//
//  registViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/10.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "registViewController.h"
#import "CustomView.h"
#import "UIImage+CustomImage.h"
#import "loginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "AgreementViewController.h"
#import "TianyueTools.h"

@interface registViewController ()<UITextFieldDelegate>
{
    int _timeOut;
    BOOL _isAgreement;
}

@property(nonatomic,strong)UIImageView *warnImageView;
@property(nonatomic,strong)UILabel *warnLabel;

@property(nonatomic,strong)CustomView *CustomView;

@property(nonatomic,strong)UIButton *nextButton;

@property (nonatomic,strong) NSString *pCode;

@property(nonatomic,strong)UIButton *boxButton;
@property(nonatomic,strong)UILabel *agreementLabel;

@end

@implementation registViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"注册";
    self.view.backgroundColor=WWColor(240, 240, 240);
    _isAgreement =YES;
    
    [self customBackBtn];
    [self addLayout];
    // Do any additional setup after loading the view.
}
//验证按钮点击事件
-(void)validationButtonClick:(UIButton *)sender
{
//    NSString *url =@"http://www.tianyue.tv/getPhoneCodemobile";
    // NSString *url =@"http://192.168.0.88:8081/getPhoneCodemobile";
    
    NSMutableDictionary *paraments =[[NSMutableDictionary alloc]init];
    paraments[@"telephone"] =self.CustomView.phoneTextField.text;
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"getPhoneCodemobile" paraments:paraments finish:^(id responseObject, NSError *error) {
        NSLog(@"--验证%@-----%@---",responseObject,error);
        
        self.pCode =responseObject[@"pCode"];
        if ([responseObject[@"ret"] isEqualToString:@"error"])
        {
            [MBProgressHUD showError:@"手机号已注册"];
        }
        if([responseObject[@"ret"] isEqualToString:@"success"])
        {
            [self validationTimeOut];
            
        }
    }];
}
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
        }
        if ([text isEqualToString:self.pCode]&& _isAgreement ==YES)
        {
            NSLog(@"....验证码正确....");
            self.nextButton.userInteractionEnabled =YES;
            self.nextButton.backgroundColor =WWColor(211, 5, 26) ;
        }else
        {
            self.nextButton.userInteractionEnabled =NO;
            _nextButton.backgroundColor =WWColor(192, 192, 192);
            //[MBProgressHUD showError:@"验证码错误"];
        }
    }
    return YES;
}

//倒计时
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
-(void)boxButtonClick:(UIButton *)btn
{
    _isAgreement =YES;
    btn.selected =!btn.selected;
    if (btn.selected ==YES)
    {
        _isAgreement =NO;
        self.nextButton.userInteractionEnabled =NO;
        self.nextButton.backgroundColor =WWColor(192, 192, 192);
        
    }else
    {
        _isAgreement =YES;
        if (self.CustomView.phoneTextField.text.length >0 && [self.CustomView.validationTextField.text isEqualToString:self.pCode])
        {
            self.nextButton.userInteractionEnabled =YES;
            self.nextButton.backgroundColor =WWColor(211, 5, 26);
        }
    }
}
-(UIButton *)boxButton
{
    if (!_boxButton)
    {
        _boxButton =[UIButton buttonWithType:UIButtonTypeCustom];
        _boxButton.layer.borderWidth =kWidthChange(1);
        _boxButton.layer.borderColor =[[UIColor blackColor]CGColor];
        [_boxButton setImage:[UIImage imageNamed:@"register_gou"] forState:UIControlStateNormal];
        [_boxButton setImage:[UIImage imageNamed:@"register_juxing"] forState:UIControlStateSelected];
        [_boxButton addTarget:self action:@selector(boxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _boxButton.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.boxButton];
    }
    return _boxButton;
}
-(UILabel *)agreementLabel
{
    if (!_agreementLabel)
    {
        NSString *str =@"我同意《天越网直播协议/用户隐私协议》";
        NSMutableAttributedString *attrStr =[[NSMutableAttributedString alloc]initWithString:str];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:kWidthChange(30)] range:NSMakeRange(0, 19)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 3)];
        [attrStr addAttribute:NSForegroundColorAttributeName value:WWColor(23, 151, 178) range:NSMakeRange(3, 16)];
        
        _agreementLabel =[[UILabel alloc]init];
        _agreementLabel.attributedText =attrStr;
        _agreementLabel.translatesAutoresizingMaskIntoConstraints =NO;
        ;
        _agreementLabel.userInteractionEnabled =YES;
        UITapGestureRecognizer *tapGestureRecognizer =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTag:)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [_agreementLabel addGestureRecognizer:tapGestureRecognizer];
        [self.view addSubview:self.agreementLabel];
    }
    return _agreementLabel;
}
-(void)handleTag:(UITapGestureRecognizer *)tap
{
    NSLog(@"---------协议-------");
    AgreementViewController *vc =[[AgreementViewController alloc]init];
    UINavigationController *nav =[[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)nextBtnClick:(UIButton *)sender
{
    loginViewController *loginVC =[[loginViewController alloc]init];
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
        [_warnImageView setImage:[UIImage imageNamed:@"register_alert"]];
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
        _warnLabel.text =@"请填写个人的真实手机号";
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
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    
    [self.boxButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(30), kHeightChange(30))];
    [self.boxButton autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(78)];
    [self.boxButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.CustomView withOffset:kHeightChange(25)];
    
    [self.agreementLabel autoSetDimensionsToSize:CGSizeMake(kWidth, kHeightChange(30))];
    [@[self.boxButton,self.agreementLabel]autoAlignViewsToAxis:ALAxisHorizontal];
    [self.agreementLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.boxButton ];
    [self.agreementLabel autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(78)];
    
    
    
    [self.nextButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.boxButton withOffset:kHeightChange(72)];
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
    [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
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
