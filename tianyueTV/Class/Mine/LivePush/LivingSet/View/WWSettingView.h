//
//  WWSettingView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKTagView.h"
//#import "WWSettingViewController.h"

//@class WWSettingViewController;
@interface WWSettingView : UIView
@property (nonatomic,strong) UITextField *nameTextFiled;//房间名字输入框
@property (nonatomic,strong) UITextField *typerTextFiled;//分类选项输入框
@property (nonatomic,strong) NSMutableArray *biaoqianArray;//标签数组
@property (nonatomic,strong) NSString *Namelevel;//一级标题

@property (nonatomic,copy) void (^SettingHandler)();

@property (nonatomic,strong) SKTagView *tagView;
//@property (nonatomic,strong) WWSettingViewController *settingVc;
@property (nonatomic,copy) void (^NamelevelHandler)(NSString *Namelevel);

@end
