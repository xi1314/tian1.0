//
//  loginViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/19.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "loginViewController.h"
#import "CustomRegistView.h"
#import "ViewController.h"
#import "MBProgressHUD+MJ.h"

@interface loginViewController ()
<UITextFieldDelegate>

@property(nonatomic,strong)CustomRegistView *registView;
@property(nonatomic,strong)UIButton *registBtn;
@property(nonatomic,strong)UIImageView *warnImageView;
@property(nonatomic,strong)UILabel *warnLabel;
@property(nonatomic,strong)UIButton *agreementBtn;

@end

@implementation loginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"注册";
    self.view.backgroundColor=WWColor(240, 240, 240);
    [self customBackBtn];
    [self addLayout];
}

-(void)registRequet
{
    // NSString *url = @"http://www.tianyue.tv/mobileSendRegister";
    // NSString *url = @"http://192.168.0.88:8081/mobileSendRegister";
    
    NSMutableDictionary *paraments =[[NSMutableDictionary alloc]init];
    paraments[@"code"] = self.code;
    paraments[@"telephone"] = self.phoneString;
    paraments[@"nickName"] = self.registView.nameTextField.text;
    paraments[@"password"] = self.registView.passwordTextField.text;
    
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"mobileSendRegister" paraments:paraments finish:^(id responseObject, NSError *error) {
        
        if ([responseObject[@"ret"] isEqualToString:@"repeat2"])
        {
            [MBProgressHUD showError:@"该昵称已存在"];
        }else if([responseObject[@"ret"] isEqualToString:@"success"])
        {
            ViewController *vc =[[ViewController alloc]init];
            [[NSUserDefaults standardUserDefaults]setObject:self.registView.nameTextField.text forKey:@"nickName"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.registView.passwordTextField)
    {
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
        }
        if (self.registView.nameTextField.text.length > 0 && text.length > 5)
        {
            self.registBtn.userInteractionEnabled = YES;
            self.registBtn.backgroundColor = WWColor(211, 5, 26);
        }else
        {
            self.registBtn.userInteractionEnabled = NO;
            self.registBtn.backgroundColor = WWColor(192, 192, 192);
            
        }
        
    }
    return YES;
}
- (void)eyeImageViewClick:(UIButton *)btn
{
    btn.selected =!btn.selected;
    if (btn.selected ==YES)
    {
        self.registView.passwordTextField.secureTextEntry =NO;
    }else
    {
        self.registView.passwordTextField.secureTextEntry =YES;
    }
}
- (UIImageView *)warnImageView
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
- (UILabel *)warnLabel
{
    if (!_warnLabel)
    {
        _warnLabel =[[UILabel alloc]init];
        _warnLabel.text =@"昵称是您在平台上的唯一标识";
        _warnLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _warnLabel.textColor =WWColor(128, 128, 128);
        _warnLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.warnLabel];
    }
    return _warnLabel;
}

- (CustomRegistView *)registView
{
    if (!_registView)
    {
        _registView =[[CustomRegistView alloc]init];
        _registView.backgroundColor =[UIColor whiteColor];
        _registView.layer.cornerRadius =5.0f;
        _registView.clipsToBounds =YES;
        _registView.nameTextField.delegate =self;
        _registView.passwordTextField.delegate =self;
        [_registView.eyeImageView addTarget:self action:@selector(eyeImageViewClick:) forControlEvents:UIControlEventTouchUpInside];
        _registView.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.registView];
    }
    return _registView;
}

- (UIButton *)registBtn
{
    if (!_registBtn)
    {
        _registBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_registBtn setTitle:@"提交注册" forState:UIControlStateNormal];
        _registBtn.layer.cornerRadius =5.0f; ;
        _registBtn.clipsToBounds =YES;
        [_registBtn setBackgroundColor:WWColor(192, 192, 192)];
        [_registBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_registBtn addTarget:self action:@selector(registBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _registBtn.userInteractionEnabled =NO;
        
        _registBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.registBtn];
    }
    return _registBtn;
}
- (void)addLayout
{
    [self.warnImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(25)+64];
    [self.warnImageView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(59)];
    [self.warnImageView autoSetDimensionsToSize:CGSizeMake(kWidthChange(30), kHeightChange(30))];
    
    [self.warnLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.warnImageView withOffset:kWidthChange(5)];
    [self.warnLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(25)+64];
    [self.warnLabel autoSetDimensionsToSize:CGSizeMake(kWidth, kHeightChange(30))];
    
    [self.registView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(80)+64];
    [self.registView autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.registView autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    [self.registView autoSetDimension:ALDimensionHeight toSize:kHeightChange(260)];
    
    [self.registBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.registView withOffset:kHeightChange(72)];
    [self.registBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.registBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    [self.registBtn autoSetDimension:ALDimensionHeight toSize:kHeightChange(85)];
    
}
- (void)customBackBtn
{
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame =CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem =[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem =backItem;
    
}

- (void)registBtnClick:(id)sender
{
    [self registRequet];
}
- (void)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
