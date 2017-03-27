//
//  WWShopsViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/1/22.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "WWShopsViewController.h"
#import "WWShopsTableViewCell.h"

@interface WWShopsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) UITableView *mainTableView;

@end

@implementation WWShopsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark -----setUI----
- (void)setUI{
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(64);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        
    }];
}

#pragma mark -----UITableViewDataSource,UITableViewDelegate----
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WWShopsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WWShopsTableViewCell"];
    if (!cell) {
        cell = [[WWShopsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WWShopsTableViewCell"];
    }
    return cell;
}

#pragma mark -----Gettters-----
- (UITableView *)mainTableView{
    if (!_mainTableView) {
        _mainTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        [_mainTableView registerClass:[WWShopsTableViewCell class] forCellReuseIdentifier:@"WWShopsTableViewCell"];
        _mainTableView.dataSource = self;
        _mainTableView.delegate = self;
        _mainTableView.estimatedRowHeight = kHeightChange(200);
    }
    return _mainTableView;
}

@end
