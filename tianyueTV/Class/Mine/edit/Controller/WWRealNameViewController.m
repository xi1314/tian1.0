//
//  WWRealNameViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/27.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWRealNameViewController.h"
#import "WWRealNameView.h"
#import "WWCardViewController.h"

@interface WWRealNameViewController ()

@end

@implementation WWRealNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证须知";
    
    self.navigationController.navigationBar.hidden = NO;

    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked)];
    leftItem.image = [UIImage imageNamed:@"back_black"];
    leftItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.view.backgroundColor = [UIColor whiteColor];
    WWRealNameView *realName = [[WWRealNameView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:realName];
    __weak typeof (self) ww = self;
    realName.ReadedButtonHandler = ^(){
        [ww nextVC];
    };
    
}


- (void)nextVC{
    WWCardViewController *carVc = [[WWCardViewController alloc] init];
    [self.navigationController pushViewController:carVc animated:YES];
//    [self presentViewController:carVc animated:YES completion:nil];
}


- (void)backItemClicked{

    [self.navigationController popViewControllerAnimated:YES];
}



@end
