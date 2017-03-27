//
//  CustomRegistView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/19.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSCustomTextField.h"

@interface CustomRegistView : UIView

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)ZSCustomTextField *nameTextField;
@property(nonatomic,strong)UILabel *passwordLabel;
@property(nonatomic,strong)ZSCustomTextField *passwordTextField;
@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,strong)UIButton *eyeImageView;

@end
