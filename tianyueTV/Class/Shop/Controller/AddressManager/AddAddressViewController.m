//
//  AddAddressViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AddAddressViewController.h"

@interface AddAddressViewController ()

@end

@implementation AddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeDatasource];
    [self initilizeUserInterface];
}

#pragma mark -- Init method
- (void)initilizeDatasource {
    
}

- (void)initilizeUserInterface {
    self.title = @"添加地址";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToRightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- Button method
//返回
- (void)respondsToBackItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//确认
- (void)respondsToRightItem:(UIBarButtonItem *)sender {
    
}



@end
