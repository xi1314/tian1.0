//
//  BottomView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/21.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "ZSCustomTextField.h"
@interface TextFieldView : UIView
//礼物
@property(nonatomic,strong)UIButton *giftBtn;
//灰线
@property(nonatomic,strong)UIImageView *line;
//输入框
@property(nonatomic,strong)ZSCustomTextField *textField;
//发送按钮 
@property(nonatomic,strong)UIButton *sendButton;

//@property(nonatomic,strong)UIView *bgView;

@property(nonatomic,strong)UIImageView *bgView;

@end
