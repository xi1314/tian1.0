//
//  WWMineSecondViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineSecondViewController.h"
#import "WWMineSecondView.h"
#import "WWGuanliSecondViewController.h"
#import "WWPesonalShowViewController.h"

@interface WWMineSecondViewController ()



@end

@implementation WWMineSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注的主播";
//    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: WWColor(135, 135, 135),
//                                                                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked)];
    leftItem.image = [UIImage imageNamed:@"back_black"];
    leftItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftItem;
//    self.view.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClicked)];
    rightItem.tintColor = WWColor(135, 135, 135);
//    rightItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    WWMineSecondView *secondView = [[WWMineSecondView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:secondView];
    __weak typeof(self) ws = self;
    secondView.guanzhuButtonHandler = ^(){
        [ws pushToPersonalShow];
    };
    
}

- (void)pushToPersonalShow{
    WWPesonalShowViewController *personalShow = [[WWPesonalShowViewController alloc] init];
    [self.navigationController pushViewController:personalShow animated:YES];
}


- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark ----Actions----
- (void)backItemClicked{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightItemClicked{
    NSLog(@"管理");
    WWGuanliSecondViewController *guanli = [[WWGuanliSecondViewController alloc] init];
    [self.navigationController pushViewController:guanli animated:YES];
}

@end
