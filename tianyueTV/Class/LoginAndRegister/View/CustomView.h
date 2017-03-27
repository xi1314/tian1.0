//
//  CustomView.h
//  tianyueTV
//
//  Created by wwwwwwww on 2016/10/19.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZSCustomTextField.h"
@interface CustomView : UIView

@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)ZSCustomTextField *phoneTextField;
@property(nonatomic,strong)UILabel *validationLabel;
@property(nonatomic,strong)ZSCustomTextField *validationTextField;
@property(nonatomic,strong)UIButton *validationButton;

@property(nonatomic,strong)UIImageView *line;

@end
