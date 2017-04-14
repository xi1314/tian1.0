//
//  ProductDetailVIew.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "ProductDetailVIew.h"
#import "MessageTableViewCell.h"
#import "ShopModel.h"

static NSString *cellIndentifer = @"kMessageTableViewCell";

@implementation ProductDetailVIew

+ (instancetype)shareInstanceType {
    return [[NSBundle mainBundle] loadNibNamed:@"ProductDetailVIew" owner:self options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.productTableView.estimatedRowHeight = 200;
    self.productTableView.rowHeight = UITableViewAutomaticDimension;
    self.productTableView.delegate = self;
    self.productTableView.dataSource = self;
    self.webView.hidden = NO;
    self.productTableView.hidden = YES;
    [self.productTableView registerNib:[UINib nibWithNibName:@"MessageTableViewCell" bundle:nil] forCellReuseIdentifier:cellIndentifer];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifer];
    MessageModel *model = self.dataSource[indexPath.row];
    [cell configCellWithModel:model];
    return cell;
}


#pragma mark - Button method
//商品详情
- (IBAction)productDetailButton_action:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:18];
    self.messageButton.selected = NO;
    self.messageButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.webView.hidden = NO;
    self.productTableView.hidden = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.indictorView.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

//用户留言
- (IBAction)messageButton_action:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    sender.selected = YES;
    sender.titleLabel.font = [UIFont systemFontOfSize:18];
    self.productButton.selected = NO;
    self.productButton.titleLabel.font = [UIFont systemFontOfSize:14];
    
    self.webView.hidden = YES;
    self.productTableView.hidden = NO;
    
    [UIView animateWithDuration:0.2 animations:^{
    
        self.indictorView.transform = CGAffineTransformMakeTranslation(self.indictorView.bounds.size.width, 0);
    }];
}


#pragma mark - Setter method
- (void)setHtmlStr:(NSString *)htmlStr {
    _htmlStr = htmlStr;
    [self.webView loadHTMLString:_htmlStr baseURL:nil];
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    [self.productTableView reloadData];
}


@end
