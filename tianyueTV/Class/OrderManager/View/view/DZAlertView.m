//
//  DZAlertView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 17/3/20.
//  Copyright © 2017年 wwwwwwww. All rights reserved.
//

#import "DZAlertView.h"

@interface DZAlertView()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (copy, nonatomic) LeftHandleBlock leftHandleBlock;
@property (copy, nonatomic) RightHandleBlock rightHandleBlock;

@end

@implementation DZAlertView

+ (instancetype)shareDZAlertViewInstanceType {
    return [[[NSBundle mainBundle] loadNibNamed:@"DZAlertView" owner:self options:nil] objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
}

/**
 自定义弹框
 
 @param message 提示内容
 @param leftTitle 左按钮title
 @param rightTitle 右按钮title
 @param leftHandle 左按钮点击操作
 @param rightHandle 右按钮点击操作
 */
-(void)initDZAlertViewMessage:(NSString *)message leftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle leftHandle:(LeftHandleBlock)leftHandle rightHandle:(RightHandleBlock)rightHandle {
    self.messageLabel.text = message;
    [self.leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [self.rightButton setTitle:rightTitle forState:UIControlStateNormal];
    self.leftHandleBlock = leftHandle;
    self.rightHandleBlock = rightHandle;
}


- (IBAction)buttonsAction:(UIButton *)sender {
    if (_leftHandleBlock && sender.tag == 245) {
        _leftHandleBlock(sender);
    }
    if (_rightHandleBlock && sender.tag == 246) {
        _rightHandleBlock(sender);
    }
}



@end
