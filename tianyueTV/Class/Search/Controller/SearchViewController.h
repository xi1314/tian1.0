//
//  SearchViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

// 取消按钮block
typedef void(^SearchBlock)(void);
// 搜索结果
typedef void(^SearchResultBlock)(NSArray *dataArr);

@interface SearchViewController : UIViewController

@property (nonatomic, copy) SearchBlock cancelBlock;

@property (nonatomic, copy) SearchResultBlock searchBlock;

@end
