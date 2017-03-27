//
//  WWBiaoqianViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/30.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWBiaoqianViewController.h"

#import "WWBiaoqiaoTableViewCell.h"
#import "MBProgressHUD+MJ.h"







@interface WWBiaoqianViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _change;
}
@property (nonatomic,strong) UILabel *alreadyLabel;//已有标签

@property (nonatomic,strong) UITextField *cumtumBiaoqian;
@property (nonatomic,strong) UIButton *quedingButton;//确定按钮
@property (nonatomic,strong) UITableView *biaoqianTbaleView;//

@property (nonatomic,strong) UIBarButtonItem *cancelButton;//取消按钮
@property (nonatomic,strong) UIBarButtonItem *saveButton;//保存按钮




@end

@implementation WWBiaoqianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"标签管理";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.cancelButton;
    self.navigationItem.rightBarButtonItem = self.saveButton;
//    [self netWorkRequestGet];
    [self addPureLayOut];
}

- (void)respondsToCancel{
   


 [self.delegate returnBiaoqianArray:self.dataArray];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(returnBiaoqianArray:)]) {
//        [self.delegate returnBiaoqianArray:self.dataArray];
//    }
     [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)respondsToSave{
    
    NSLog(@"保存le");
}




- (void)respondsToQueding:(UIButton *)sender{
    if (self.cumtumBiaoqian.text.length >4) {
        [MBProgressHUD showError:@"标签不能超过四个字"];
    }else{
        if ([sender.titleLabel.text isEqualToString:@"修改"]) {
            if (self.cumtumBiaoqian.text.length != 0) {
                self.dataArray[_change] = self.cumtumBiaoqian.text;
                self.cumtumBiaoqian.text = @"";
                [self.quedingButton setTitle:@"贴上" forState:UIControlStateNormal];
                [self.biaoqianTbaleView reloadData];
            }else{
                [MBProgressHUD showError:@"标签不能为空"];
            }
        }else if ([sender.titleLabel.text isEqualToString:@"贴上"]){
            if (self.cumtumBiaoqian.text.length != 0 && self.dataArray.count < 4) {
                [self.dataArray addObject:self.cumtumBiaoqian.text];
                self.cumtumBiaoqian.text = @"";
                [self.biaoqianTbaleView reloadData];
                [self.quedingButton setTitle:@"贴上" forState:UIControlStateNormal];
            }else{
                if (self.cumtumBiaoqian.text.length == 0) {
                    [MBProgressHUD showError:@"标签不能为空"];
                }else if (self.dataArray.count > 3) {
                    [MBProgressHUD showError:@"标签不能超过四个"];
                }
                
            }
        }
        

    }
    
   
}

#pragma mark ----UITableViewDataSource,UITableViewDelegate----
-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WWBiaoqiaoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WWBiaoqiaoTableViewCell"];
        if (!cell)
        {
            cell =[[WWBiaoqiaoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWBiaoqiaoTableViewCell"];
        }
    __weak typeof(self) ww = self;
    cell.DeleteHandler = ^(NSInteger tag){
        [ww DeleteHandler:tag];
    };
    cell.ChangeHandler = ^(NSInteger tag){
        [ww ChangeHandler:tag];
    };
    [cell.biaoqianButton setTitle:self.dataArray[indexPath.row] forState:UIControlStateNormal];
    cell.deleteButton.tag = 520+indexPath.row;
    cell.changeButton.tag = 510+indexPath.row;
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kWidthChange(26)]};
      CGFloat length = [self.dataArray[indexPath.row] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    [cell.biaoqianButton autoSetDimension:ALDimensionWidth toSize:kWidthChange(length)*3];
//    [cell.biaoqianButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(15)];
//    [cell.biaoqianButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kWidthChange(22)];
//    [cell.biaoqianButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kWidthChange(22)];
//    cell.biaoqianButton.backgroundColor = [UIColor blueColor];
//    [self.biaoqianTbaleView layoutIfNeeded];
    

    NSLog(@"宽度%f",kWidthChange(length)*3);
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)DeleteHandler:(NSInteger)tag{
   
    NSInteger inde = tag - 520;
    [self.dataArray removeObjectAtIndex:inde];
    [self.biaoqianTbaleView reloadData];
    
}
- (void)ChangeHandler:(NSInteger)tag{
    
    NSInteger inde = tag - 510;
    _change = inde;
    if (inde < self.dataArray.count) {
        self.cumtumBiaoqian.text = self.dataArray[inde];
        [self.quedingButton setTitle:@"修改" forState:UIControlStateNormal];
    }
    
//    [self.dataArray removeObjectAtIndex:inde];
//    [self.biaoqianTbaleView reloadData];
    
}



- (void)addPureLayOut{
    [self.view addSubview:self.alreadyLabel];
    [self.alreadyLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kWidthChange(44) + 64];
    [self.alreadyLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(15)];
    
    
    [self.view addSubview:self.biaoqianTbaleView];
    [self.biaoqianTbaleView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.biaoqianTbaleView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.biaoqianTbaleView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.alreadyLabel withOffset:kHeightChange(44)];
    [self.biaoqianTbaleView autoSetDimension:ALDimensionHeight toSize:kHeightChange(450)];
    
//    for (int i = 0; i < self.dataArray.count; i ++) {
//        WWBiaoqianView *biaoqian = [[WWBiaoqianView alloc] initWithFrame:CGRectMake(0,kWidthChange(120) + 64 + i *kHeightChange(100) , SCREEN_WIDTH, kHeightChange(100))];
//        [biaoqian.biaoqianButton setTitle:self.dataArray[i] forState:UIControlStateNormal];
//        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:kWidthChange(26)]};
//          CGFloat length = [self.dataArray[i] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
//        [biaoqian.biaoqianButton autoSetDimension:ALDimensionWidth toSize:kWidthChange(length)*3];
//        [self.view addSubview:biaoqian];
//    }
    
    [self.view addSubview:self.cumtumBiaoqian];
    [self.cumtumBiaoqian autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(550) +64];
    [self.cumtumBiaoqian autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(15)];
    [self.cumtumBiaoqian autoSetDimensionsToSize:CGSizeMake(kWidthChange(550), kHeightChange(68))];
    
    
    [self.view addSubview:self.quedingButton];
    [self.quedingButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(550) + 64];
    [self.quedingButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(122), kHeightChange(68))];
    [self.quedingButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.cumtumBiaoqian withOffset:kWidthChange(40)];
}





#pragma mark ----Getters---


- (UIBarButtonItem *)saveButton{
    if (!_saveButton) {
        _saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToSave)];
        [_saveButton setTintColor:WWColor(88, 86, 87)];
        
    }
    return _saveButton;
}
- (UIBarButtonItem *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(respondsToCancel)];
        [_cancelButton setTintColor:WWColor(88, 86, 87)];
    }
    return _cancelButton;
}
- (UIButton *)quedingButton{
    if (!_quedingButton) {
        _quedingButton = [[UIButton alloc] init];
        [_quedingButton setTitle:@"贴上" forState:UIControlStateNormal];
        [_quedingButton addTarget:self action:@selector(respondsToQueding:) forControlEvents:UIControlEventTouchUpInside];
        [_quedingButton setBackgroundColor:WWColor(244, 117, 6)];
        _quedingButton.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(26)];
        _quedingButton.layer.masksToBounds = YES;
        _quedingButton.layer.cornerRadius = kWidthChange(10);
    }
    return _quedingButton;
}

- (UITextField *)cumtumBiaoqian{
    if (!_cumtumBiaoqian) {
        _cumtumBiaoqian = [[UITextField alloc] init];
        _cumtumBiaoqian.placeholder = @"输入自定义标签";
        _cumtumBiaoqian.backgroundColor = WWColor(177, 171, 171);
        _cumtumBiaoqian.layer.cornerRadius = kWidthChange(10);
        _cumtumBiaoqian.layer.masksToBounds = YES;
    }
    return _cumtumBiaoqian;
}

- (UILabel *)alreadyLabel{
    if (!_alreadyLabel) {
        _alreadyLabel = [[UILabel alloc] init];
        _alreadyLabel.text = @"已有标签";
        _alreadyLabel.textColor = WWColor(140, 140, 140);
        _alreadyLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
    }
    return _alreadyLabel;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    return _dataArray;
}

- (UITableView *)biaoqianTbaleView{
    if (!_biaoqianTbaleView) {
        _biaoqianTbaleView = [[UITableView alloc] init];
        
        _biaoqianTbaleView.dataSource = self;
        _biaoqianTbaleView.delegate = self;
        _biaoqianTbaleView.rowHeight = kHeightChange(100);
        _biaoqianTbaleView.scrollEnabled = NO;
        _biaoqianTbaleView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_biaoqianTbaleView registerClass:[WWBiaoqiaoTableViewCell class] forCellReuseIdentifier:@"WWBiaoqiaoTableViewCell"];
    }
    return _biaoqianTbaleView;
}

- (void)netWorkRequestGet{
//    NSString *url = @"http://192.168.0.88:8082/broadcast_app";
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"user_id"];
    [MBProgressHUD showMessage:nil];
    [[NetWorkTool sharedTool] requestMethod:POST URL:@"broadcast_app" paraments:param finish:^(id responseObject, NSError *error) {
        NSLog(@"%@_______________________________%@",responseObject,error);
        if ([responseObject[@"ret"] isEqualToString:@"success"]) {
            [MBProgressHUD hideHUD];
            NSString *messageString = responseObject[@"broadcast"][0][@"keyWord"];
            if (messageString.length != 0) {
                
                NSArray *arr = [messageString componentsSeparatedByString:@"_"];
                self.dataArray = [arr mutableCopy];
                
            }
            //            [MBProgressHUD showSuccess:@"修改成功"];
            //            WWAnchorSpaceViewController *achorSpace = [[WWAnchorSpaceViewController alloc] init];
            //            achorSpace.roomName = self.settingView.nameTextFiled.text;
            //            [self.navigationController pushViewController:achorSpace animated:YES];
        }else{
            [MBProgressHUD showError:@"网路出错"];
        }
    }];
    
}

@end
