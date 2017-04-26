//
//  SearchViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/26.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchBlock)(void);

@interface SearchViewController : UIViewController

@property (nonatomic, copy) SearchBlock cancelBlock;

@end
