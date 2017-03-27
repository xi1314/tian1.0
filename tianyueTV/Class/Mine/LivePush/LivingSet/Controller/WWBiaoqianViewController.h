//
//  WWBiaoqianViewController.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/30.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol biaoqanDelegate <NSObject>

- (void)returnBiaoqianArray:(NSMutableArray *)arrray;

@end

@interface WWBiaoqianViewController : UIViewController
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic, weak) id <biaoqanDelegate> delegate;

@end
