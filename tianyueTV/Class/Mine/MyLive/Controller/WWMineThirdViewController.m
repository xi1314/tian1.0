//
//  WWMineThirdViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/13.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineThirdViewController.h"
#import "WWMineThirdView.h"

@interface WWMineThirdViewController ()

@end

@implementation WWMineThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"直播间申请";
  
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked3)];
    leftItem.image = [UIImage imageNamed:@"返回"];
    leftItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightItemClicked3)];
//    leftItem.image = [UIImage imageNamed:@"返回"];
    rightItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    WWMineThirdView *mineThird = [[WWMineThirdView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:mineThird];

}

- (void)rightItemClicked3{
    NSLog(@"完成");
}

- (void)backItemClicked3{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
