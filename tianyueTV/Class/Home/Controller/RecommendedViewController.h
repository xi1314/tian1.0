//
//  RecommendedViewController.h
//  tianyueTV
//
//  Created by wwwwwwww on 2017/1/19.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveModel.h"

typedef void(^ReturnBlock)(NSInteger);
typedef void(^ItemSelectedBlock)(LiveModel *liveM);

@interface RecommendedViewController : UIViewController

@property (nonatomic, copy) ReturnBlock returnBlock;
@property (nonatomic, copy) ItemSelectedBlock itemSelBlock;

- (void)returnBtn:(ReturnBlock)block;

@end
