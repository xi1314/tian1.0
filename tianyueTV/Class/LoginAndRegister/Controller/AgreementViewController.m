//
//  AgreementViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2017/1/3.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AgreementViewController.h"

@interface AgreementViewController ()

@end

@implementation AgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title =@"天越网直播协议/用户隐私协议";
    [self.navigationController.navigationBar setBackgroundColor:[UIColor whiteColor]];
    self.view.backgroundColor=[UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self customBackBtn];
    
    UIWebView *webView =[[UIWebView alloc]initWithFrame:self.view.frame];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.tianyue.tv/m_agreement"]];
    
    [webView setScalesPageToFit:YES];
    [self.view addSubview:webView];
    [webView loadRequest:request];
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
