//
//  HeadlineViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/25.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "HeadlineViewController.h"
#import "HeadlineTableViewCell.h"
#import "HomeHandler.h"
#import "HeadlineModel.h"

@interface HeadlineViewController ()
<UITableViewDelegate,
UITableViewDataSource>

// 列表
@property (nonatomic, strong) UITableView *tableView;

// 数据数组
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation HeadlineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MBProgressHUD showMessage:nil];
    [self initilizeDatasource];
    [self initilizeInterface];
}

- (void)initilizeDatasource {
    @weakify(self);
    [HomeHandler requestForHeadlineWithCompleteBlock:^(id respondsObject, NSError *error) {
        @strongify(self);
        
        [MBProgressHUD hideHUD];
        HeadlineModel *hm = (HeadlineModel *)respondsObject;
        self.dataSource = hm.newsList;
        [self.tableView reloadData];
    }];
}

- (void)initilizeInterface {
    self.title = @"匠人头条";
    self.view.backgroundColor = WWColor(240, 235, 235);
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToNavBack:)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

#pragma mark - respondsToNavBack
- (void)respondsToNavBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HeadlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:headlineCellIndentifer];
    
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"HeadlineTableViewCell" owner:nil options:nil].firstObject;
    }
    
    HeadNewsModel *newM = (HeadNewsModel *)_dataSource[indexPath.row];
    [cell configCellWithModel:newM];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightChange(500);
}

@end
