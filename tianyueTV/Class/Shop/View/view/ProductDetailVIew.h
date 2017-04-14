//
//  ProductDetailVIew.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MessageModel.h"

@interface ProductDetailVIew : UIView
<UITableViewDelegate,
UITableViewDataSource>

// 留言table
@property (weak, nonatomic) IBOutlet UITableView *productTableView;

// 商品详情
@property (weak, nonatomic) IBOutlet UIButton *productButton;

// 用户留言
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

// 指示view
@property (weak, nonatomic) IBOutlet UIView *indictorView;

// 商品详情
@property (weak, nonatomic) IBOutlet UIWebView *webView;

// h5地址
@property (copy, nonatomic) NSString *htmlStr;

// 数据源
@property (strong, nonatomic) NSArray *dataSource;


+ (instancetype)shareInstanceType;

@end
