//
//  WWGuanliSecondViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/19.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWGuanliSecondViewController.h"
#import "WWGuanliSecondModel.h"

@interface WWGuanliSecondViewController ()

@end

@implementation WWGuanliSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"关注的主播";
    
    self.navigationController.navigationBar.titleTextAttributes = @{UITextAttributeTextColor: WWColor(135, 135, 135),
                                                                    UITextAttributeFont : [UIFont boldSystemFontOfSize:18]};
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked)];
    leftItem.image = [UIImage imageNamed:@"返回"];
    leftItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    //    self.view.backgroundColor = [UIColor lightGrayColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked)];
    rightItem.tintColor = WWColor(135, 135, 135);
    //    rightItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    WWGuanliSecondModel *gualiView = [[WWGuanliSecondModel alloc] initWithFrame:self.view.frame];
    [self.view addSubview:gualiView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)backItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
