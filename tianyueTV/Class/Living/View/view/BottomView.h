//
//  BottomView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSCustomTextField.h"
@interface BottomView : UIView

//开始
@property(nonatomic,strong)UIButton *startButton;
//弹幕
@property(nonatomic,strong)UIButton *barrageButton;
//输入框
@property(nonatomic,strong)ZSCustomTextField *textField;
//发送按钮
@property(nonatomic,strong)UIButton *sendBtn;
//礼物按钮
@property(nonatomic,strong)UIButton *giftBtn;

@end
