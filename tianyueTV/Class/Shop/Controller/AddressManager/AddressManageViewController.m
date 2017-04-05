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
#import "ShopHandle.h"
#import "AddressModel.h"

@interface AddressManageViewController ()
<UITableViewDelegate,
UITableViewDataSource>

// 列表
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// 数据源
@property (strong, nonatomic) NSMutableArray *dataSource;

// 约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *addNewBottom;

@end

@implementation AddressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeUserInterface];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initilizeDatasource];
}

#pragma mark -- init method
- (void)initilizeDatasource {
    _dataSource = [NSMutableArray array];
    @weakify(self);
    [ShopHandle requestForAddressListWithUSer:USER_ID completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        if (respondsObject) {
            AddressModel *addM = (AddressModel *)respondsObject;
            for (int i = 0; i < addM.sAddresses_list.count; i++) {
                AddressInfoModel *infoModle = addM.sAddresses_list[i];
                if ([infoModle.isDefault isEqualToString:@"1"]) {
                    [self.dataSource insertObject:infoModle atIndex:0];
                } else {
                    [self.dataSource addObject:infoModle];
                }
                // 遍历最后一个元素，刷新列表
                if (i == addM.sAddresses_list.count - 1) {
                    [self.tableView reloadData];
                }
            }
        }
    }];
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
// 返回
- (void)respondsToBackItem:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 管理
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

// 添加新地址
- (IBAction)addNewButton_action:(UIButton *)sender {
    AddAddressViewController *addVC = [[AddAddressViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

// cell按钮点击事件
- (void)cellButton_actionWithTag:(NSInteger)tag
                         section:(NSUInteger)section
{
    AddressInfoModel *infoModle = _dataSource[section];
    switch (tag) {
        case 0: { // 默认地址
            if ([infoModle.isDefault isEqualToString:@"1"]) {
                return;
            } else {
                @weakify(self);
                [ShopHandle reqeustForDefaultAddressWithUser:USER_ID isDefault:@"1" addressID:infoModle.ID completeBlock:^(id respondsObject, NSError *error) {
                    @strongify(self);
                    if (respondsObject) {
                        [self initilizeDatasource];
                    } else {
                        [MBProgressHUD showError:@"设置失败"];
                    }
                }];
            }
        } break;
          
        case 1: { // 编辑
            AddAddressViewController *addVC = [[AddAddressViewController alloc] init];
            addVC.dataModel = _dataSource[section];
            [self.navigationController pushViewController:addVC animated:YES];
        } break;
            
        case 2: { // 删除
            [MBProgressHUD showMessage:nil];
            [self deleteAddressWithSection:section addressID:infoModle.ID];
        }
            
        default:
            break;
    }
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
        [cell configEditCellWithModel:_dataSource[indexPath.section]];
        cell.cellBlock = ^(NSInteger tag){
            [self cellButton_actionWithTag:tag section:indexPath.section];
        };
        return cell;
    }
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]
                 loadNibNamed:@"AddressTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell configCellWithModel:_dataSource[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == _dataSource.count-1) {
        return 10;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = WWColor(241, 241, 241);
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = WWColor(241, 241, 241);
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressInfoModel *infoM = _dataSource[indexPath.section];
    if (self.isEdit) {
       return infoM.cellHeight + 40;
    }
    return infoM.cellHeight;
}

#pragma mark -- Pravite method
- (void)deleteAddressWithSection:(NSInteger)section
                       addressID:(NSString *)addressID
{
    [ShopHandle requestForDeleteAddressWithUser:USER_ID addressID:addressID completeBlock:^(id respondsObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (respondsObject) {
            [_dataSource removeObjectAtIndex:section];
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showError:@"删除失败"];
        }
    }];
}

@end
