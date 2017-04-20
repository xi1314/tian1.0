//
//  ChangePasswordViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/11/4.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "CustomRegistView.h"
#import "UIImage+CustomImage.h"
#import "MBProgressHUD+MJ.h"
#import "ViewController.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)CustomRegistView *registView;
@property(nonatomic,strong)UIButton *nextBtn;

@property(nonatomic,strong)UIImageView *warnImageView;
@property(nonatomic,strong)UILabel *warnLabel;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"忘记密码";
    self.view.backgroundColor=WWColor(240, 240, 240);
    
    [self customBackBtn];
    [self addLayout];
    // Do any additional setup after loading the view.
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField ==self.registView.passwordTextField)
    {
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0)
        {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else
        {
            text = [textField.text substringToIndex:range.location];
        }
        if ([text isEqualToString:self.registView.nameTextField.text])
        {
            _nextBtn.userInteractionEnabled =YES;
            
            [_nextBtn setBackgroundColor:WWColor(211, 5, 26)];
        }else
        {
            _nextBtn.userInteractionEnabled =NO;
            
            [_nextBtn setBackgroundColor:WWColor(192, 192, 192)];

        }
    }
    return YES;
}
-(void)registRequet
{
    //NSString *url =@"http://192.168.0.88:8081/findPassword_app";
//    NSString *url =@"http://www.tianyue.tv/findPassword_app";

    NSMutableDictionary *paraments =[[NSMutableDictionary alloc]init];
    paraments[@"code"] =self.code;
    paraments[@"telephone"] =self.phoneString;
    paraments[@"password"] =self.registView.nameTextField.text;
    
    [[NetWorkTool sharedTool]requestMethod:POST URL:@"findPassword_app" paraments:paraments finish:^(id responseObject, NSError *error) {
        NSLog(@" ppp ~~~%@",paraments);
        NSLog(@"~~~~~~~%@---%@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"])
        {
            ViewController *vc =[[ViewController alloc]init];
            [self presentViewController:vc animated:YES completion:nil];
        }
    }];
}

-(void)nextBtnClick:(id)sender
{
    [self registRequet];
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
        _warnLabel.text =@"请输入您的新密码";
        _warnLabel.font =[UIFont systemFontOfSize:kWidthChange(30)];
        _warnLabel.textColor =WWColor(128, 128, 128);
        _warnLabel.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.warnLabel];
    }
    return _warnLabel;
}

-(CustomRegistView *)registView
{
    if (!_registView)
    {
        _registView =[[CustomRegistView alloc]init];
        _registView.backgroundColor =[UIColor whiteColor];
        _registView.layer.cornerRadius =5.0f;
        _registView.clipsToBounds =YES;
        
        _registView.passwordTextField.delegate =self;
        _registView.eyeImageView.hidden =YES;
        _registView.nameLabel.text =@"新密码";
        _registView.nameTextField.placeholder =@"密码至少为6为数字组成";
        _registView.passwordLabel.text =@"确认密码";
        _registView.passwordTextField.placeholder =@"请再次输入您的密码";
        
        _registView.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.registView];
    }
    return _registView;
}
-(UIButton *)nextBtn
{
    if (!_nextBtn)
    {
        _nextBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_nextBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        _nextBtn.layer.cornerRadius =5.0f; ;
        _nextBtn.clipsToBounds =YES;
        [_nextBtn setBackgroundColor:WWColor(192, 192, 192)];
        [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _nextBtn.userInteractionEnabled =NO;
        
        _nextBtn.translatesAutoresizingMaskIntoConstraints =NO;
        [self.view addSubview:self.nextBtn];
    }
    return _nextBtn;
}

-(void)addLayout
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
    
    [self.nextBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.registView withOffset:kHeightChange(72)];
    [self.nextBtn autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(75)];
    [self.nextBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(75)];
    [self.nextBtn autoSetDimension:ALDimensionHeight toSize:kHeightChange(85)];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
