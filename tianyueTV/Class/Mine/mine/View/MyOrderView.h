//
//  MyOrderView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 17/4/28.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MyOrderBlock)(NSInteger tag);

@interface MyOrderView : UIView

@property (nonatomic, copy) MyOrderBlock block;

@end
