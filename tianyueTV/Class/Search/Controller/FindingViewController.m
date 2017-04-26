//
//  FindingViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "FindingViewController.h"
#import "HeadlineTableViewCell.h"
#import "HeadlineModel.h"
#import "FindHandle.h"

@interface FindingViewController ()
<UITableViewDelegate,
UITableViewDataSource>
// 列表
@property (nonatomic, strong) UITableView *tableView;

// 数组
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation FindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initilizeDatasource];
    [self initilizeInterface];
}


#pragma mark - Init method
- (void)initilizeDatasource {
    [FindHandle requestForAllLivingRoomWithCompleteBlock:^(id respondsObject, NSError *error) {
        
    }];
    
//    [HomeHandler requestForHeadlineWithCompleteBlock:^(id respondsObject, NSError *error) {
//        if (respondsObject) {
//            HeadlineModel *hm = (HeadlineModel *)respondsObject;
//            self.dataSource = hm.newsList;
//            [self.tableView reloadData];
//        }
//    }];
}

- (void)initilizeInterface {
    // 设置导航栏背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_red"] forBarMetrics:UIBarMetricsDefault];
    // item 颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // title字体
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont fontWithName:@"PingFangTC-Semibold" size:18]};
    
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_search"] style:UIBarButtonItemStylePlain target:self action:@selector(respondsToSearchItem:)];
    self.navigationItem.rightBarButtonItem = searchItem;
    
    self.title = @"发现";
    self.view.backgroundColor = WWColor(106, 105, 105);
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NavigationBarHeight - TabbarHeight) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}


#pragma mark - respondsToSearchItem
- (void)respondsToSearchItem:(UIBarButtonItem *)sender {
    
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HeadlineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:findinfCellIndentifer];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HeadlineTableViewCell" owner:nil options:nil] objectAtIndex:1];
    }
    HeadNewsModel *newM = (HeadNewsModel *)_dataSource[indexPath.row];
    [cell configFindCellWithModel:newM];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kHeightChange(460);
}


@end
