//
//  AddAddressViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AddAddressViewController.h"
#import "ShopHandle.h"

@interface AddAddressViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextView *addressTextView;

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
    @weakify(self);
    [ShopHandle requestForAddNewAddressWithUser:USER_ID name:self.nameTextField.text phone:self.phoneTextField.text province:@"重庆市" city:@"九龙坡区" address:self.addressTextView.text zipcode:@"400030" completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        NSLog(@"respondsObject.. %@ %@",respondsObject,error);
        if (respondsObject) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:@"添加失败"];
        }
    }];
}

// 删除地址
- (IBAction)deleteAddress_action:(UIButton *)sender {
    
}

@end
