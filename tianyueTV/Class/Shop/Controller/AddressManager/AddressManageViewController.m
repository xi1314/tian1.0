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
                infoModle.index = i;
                // 查找默认地址
                if ([infoModle.isDefault isEqualToString:@"1"]) {
                    [self updateCellWithRow:i];
                    infoModle.index = 0;
//                    infoModle.address = [NSString stringWithFormat:@"[默认地址]%@",infoModle.address];
                    [self.dataSource insertObject:infoModle atIndex:0];
                } else {
                    [self.dataSource addObject:infoModle];
                }
                // 遍历最后一个元素，刷新列表
                if (i == addM.sAddresses_list.count - 1) {
                    [self.tableView reloadData];
                }
            }
            if (!addM.sAddresses_list.count) {
                [self.tableView reloadData];
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
                           model:(AddressInfoModel *)model
{
    int row = model.index;
//    NSLog(@"row %d",row);
    switch (tag) {
        case 0: { // 默认地址
            if ([model.isDefault isEqualToString:@"0"]) {
                [self setDefaultAddressWithRow:row];
            }
        } break;
          
        case 1: { // 编辑
            AddAddressViewController *addVC = [[AddAddressViewController alloc] init];
            addVC.dataModel = model;
            [self.navigationController pushViewController:addVC animated:YES];
        } break;
            
        case 2: { // 删除
            [MBProgressHUD showMessage:nil];
            [self deleteAddressWithRow:row addressID:model.ID];
        } break;
            
        default:
            break;
    }
}

#pragma mark -- UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //编辑状态
    if (self.isEdit) {
        AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:editCellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle]
                     loadNibNamed:@"AddressTableViewCell" owner:nil options:nil] objectAtIndex:1];
        }
        [cell configEditCellWithModel:_dataSource[indexPath.row]];
        
        cell.cellBlock = ^(NSInteger tag, AddressInfoModel *model){
               [self cellButton_actionWithTag:tag model:model];
        };
        return cell;
    }
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellIdentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle]
                 loadNibNamed:@"AddressTableViewCell" owner:nil options:nil] objectAtIndex:0];
    }
    [cell configCellWithModel:_dataSource[indexPath.row]];
    return cell;
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
    AddressInfoModel *infoM = _dataSource[indexPath.row];
    if (self.isEdit) {
       return infoM.cellHeight + 40;
    }
    return infoM.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    if (self.block) {
        @strongify(self);
        AddressInfoModel *infoM = _dataSource[indexPath.row];
        self.block(infoM);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- Pravite method

/**
 删除地址

 @param row 需要删除的row
 @param addressID 地址id
 */
- (void)deleteAddressWithRow:(int)row
                       addressID:(NSString *)addressID
{
    [ShopHandle requestForDeleteAddressWithUser:USER_ID addressID:addressID completeBlock:^(id respondsObject, NSError *error) {
        [MBProgressHUD hideHUD];
        if (respondsObject) {
            if (row == 0) { // 删除的是默认地址，需要重新请求数据
                [self initilizeDatasource];
            } else {
                [_dataSource removeObjectAtIndex:row];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
                [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationFade];
                [self updateCellWhileDeleteWithRow:row];
            }
        } else {
            [MBProgressHUD showError:@"删除失败"];
        }
    }];
}

/**
 设置默认地址

 @param row 选择的row
 */
- (void)setDefaultAddressWithRow:(int)row {
    [MBProgressHUD showMessage:nil];
    AddressInfoModel *infoModle = _dataSource[row];
    @weakify(self);
    [ShopHandle reqeustForDefaultAddressWithUser:USER_ID isDefault:@"1" addressID:infoModle.ID completeBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        [MBProgressHUD hideHUD];
        if (respondsObject) {
            [self updateCellWithRow:row];
            NSIndexPath *firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            AddressInfoModel *lastM = _dataSource[0];
            lastM.isDefault = @"0";
            [_dataSource replaceObjectAtIndex:0 withObject:lastM];
            [self.tableView reloadRowAtIndexPath:firstIndex withRowAnimation:UITableViewRowAnimationNone];
            
            infoModle.isDefault = @"1";
            infoModle.index = 0;
            [_dataSource insertObject:infoModle atIndex:0];
            [self.tableView insertRowAtIndexPath:firstIndex withRowAnimation:UITableViewRowAnimationFade];
            
            [_dataSource removeObjectAtIndex:row + 1];
            NSIndexPath *deleIndex = [NSIndexPath indexPathForRow:row + 1 inSection:0];
            [self.tableView deleteRowAtIndexPath:deleIndex withRowAnimation:UITableViewRowAnimationFade];
            
        } else {
            [MBProgressHUD showError:@"设置失败"];
        }
    }];
}

// 刷新cell的index
- (void)updateCellWithRow:(int)row {
    for (int i = 0; i < row; i++) {
        AddressInfoModel *model = _dataSource[i];
        model.index += 1;
    }
}

// 删除操作是刷新cell
- (void)updateCellWhileDeleteWithRow:(int)row {
    for (int i = row; i < self.dataSource.count; i++) {
        AddressInfoModel *model = _dataSource[i];
        model.index -= 1;
    }
}


@end
