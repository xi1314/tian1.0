//
//  WWSaveView.h
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/3.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWSaveView : UIView

@property (nonatomic,copy) void (^getButtonHandler)();
@property (nonatomic,copy) void (^confirmButtonHandler)();
@property (nonatomic,strong) UIButton *getVerificationCodeButton;
@property (nonatomic,strong) UIButton *determineButton;
//三个输入框
@property (nonatomic,strong) UITextField *verificationCode;
@property (nonatomic,strong) UITextField *newpasswdTextField1;
@property (nonatomic,strong) UITextField *aginpasswdTextField;

@end
