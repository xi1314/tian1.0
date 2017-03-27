//
//  ProductDetailVIew.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/8.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MessageModel.h"

@interface ProductDetailVIew : UIView <UITableViewDelegate,UITableViewDataSource>
//@property (weak, nonatomic) IBOutlet UITextView *productTextView;
@property (weak, nonatomic) IBOutlet UITableView *productTableView;     //留言table
@property (weak, nonatomic) IBOutlet UIButton *productButton;           //商品详情
@property (weak, nonatomic) IBOutlet UIButton *messageButton;           //用户留言
@property (weak, nonatomic) IBOutlet UIView *indictorView;              //指示view
@property (weak, nonatomic) IBOutlet UIWebView *webView;                //商品详情
@property (copy, nonatomic) NSString *htmlStr;
@property (strong, nonatomic) NSArray *dataSource;
+ (instancetype)shareInstanceType;

@end
