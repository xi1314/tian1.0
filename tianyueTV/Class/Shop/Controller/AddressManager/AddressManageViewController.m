//
//  AddressManageViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/15.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "AddressManageViewController.h"
#import "AddressTableViewCell.h"
#import "AddAddressViewController.h"

@interface AddressManageViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewBottom;
@end

@implementation AddressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeDatasource];
    [self initilizeUserInterface];
}

#pragma mark -- init method
- (void)initilizeDatasource {
    _dataSource = [NSMutableArray array];
    NSArray *arr = @[@"",@""];
    _dataSource = [arr mutableCopy];
}

- (void)initilizeUserInterface {
    self.title = @"地址管理";
    self.tableView.estimatedRowHeight = 150;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"向左(5)"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToBackItem:)];
    self.navigationItem.leftBarButtonItem = backItem;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"管理" style:UIBarButtonItemStylePlain target:self action:@selector(respondsToRightItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

#pragma mark -- Button method
//返回
- (void)respondsToBackItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//管理
- (void)respondsToRightItem:(UIBarButtonItem *)sender {
    self.isEdit = !self.isEdit;
    if (self.isEdit) {
        [UIView animateWithDuration:0.3 animations:^{
            self.addNewBottom.constant = 0;
//            self.addNewBottom.
        }];
        self.navigationItem.rightBarButtonItem.title = @"保存";
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.addNewBottom.constant = -50;
        }];
        self.navigationItem.rightBarButtonItem.title = @"管理";
    }
    [self.tableView reloadData];
}

//添加新地址
- (IBAction)addNewButton_action:(UIButton *)sender {
    AddAddressViewController *addVC = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //编辑状态
    if (self.isEdit) {
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]
                     loadNibNamed:@"AddressTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }
        return cell;
    }
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]
                 loadNibNamed:@"AddressTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _dataSource.count-1) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}



@end
