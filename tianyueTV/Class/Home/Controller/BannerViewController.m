//
//  BannerViewController.m
//  tianyueTV
//
//  Created by wwwwwwww on 2017/1/16.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "BannerViewController.h"

@interface BannerViewController ()

@end

@implementation BannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title =self.titl;
    
    [self customBackBtn];
    
    UIWebView *webView =[[UIWebView alloc]initWithFrame:self.view.frame];
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.uil]];
    
    [webView setScalesPageToFit:YES];
    [self.view addSubview:webView];
    [webView loadRequest:request];
    
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

- (void)backBtnClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
