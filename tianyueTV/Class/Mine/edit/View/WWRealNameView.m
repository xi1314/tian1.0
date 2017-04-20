//
//  WWRealNameView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/27.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWRealNameView.h"

@interface WWRealNameView()
@property (nonatomic,strong) UILabel *label1;
@property (nonatomic,strong) UILabel *label2;
@property (nonatomic,strong) UILabel *label3;
@property (nonatomic,strong) UILabel *label4;
@property (nonatomic,strong) UILabel *label5;
@property (nonatomic,strong) UILabel *label6;
@property (nonatomic,strong) UIButton *readedButton;//已阅读按钮


@end
@implementation WWRealNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addPureLayout];
    }
    return self;
}

#pragma mark ----Actions----
- (void)respondsToReaderButton:(UIButton *)sender{
    NSLog(@"已阅读");
    if (self.ReadedButtonHandler) {
        self.ReadedButtonHandler();
    }
    
}
#pragma mark ----天界视图----
- (void)addPureLayout{
    [self addSubview:self.label1];
    [self.label1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(20) + 64];
    [self.label1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.label1 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.label1 autoSetDimension:ALDimensionHeight toSize:kHeightChange(80)];
    UIView *yuan = [[UIView alloc] init];
    yuan.backgroundColor = [UIColor redColor];
    yuan.layer.cornerRadius = kWidthChange(4);
    yuan.layer.masksToBounds = YES;
    [self addSubview:yuan];
    [yuan autoSetDimensionsToSize:CGSizeMake(kWidthChange(8), kWidthChange(8))];
    [yuan autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [yuan autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(40) + 64];
    
    [self addSubview:self.label2];
    [self.label2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label1 withOffset:kHeightChange(38)];
    [self.label2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.label2 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = WWColor(239, 238, 238);
    [self addSubview:lineView];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [lineView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label2 withOffset:kHeightChange(26)];
    [lineView autoSetDimension:ALDimensionHeight toSize:kHeightChange(1)];
    
    [self addSubview:self.label3];
    [self.label3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView withOffset:kHeightChange(25)];
    [self.label3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.label3 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    UIView *yuan1 = [[UIView alloc] init];
    yuan1.backgroundColor = [UIColor redColor];
    yuan1.layer.cornerRadius = kWidthChange(4);
    yuan1.layer.masksToBounds = YES;
    [self addSubview:yuan1];
    [yuan1 autoSetDimensionsToSize:CGSizeMake(kWidthChange(8), kWidthChange(8))];
    [yuan1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [yuan1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lineView withOffset:kHeightChange(35)];
    
    [self addSubview:self.label4];
    [self.label4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label3 withOffset:kHeightChange(26)];
    [self.label4 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.label4 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    UIView *yuan2 = [[UIView alloc] init];
    yuan2.backgroundColor = [UIColor redColor];
    yuan2.layer.cornerRadius = kWidthChange(4);
    yuan2.layer.masksToBounds = YES;
    [self addSubview:yuan2];
    [yuan2 autoSetDimensionsToSize:CGSizeMake(kWidthChange(8), kWidthChange(8))];
    [yuan2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [yuan2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label3 withOffset:kHeightChange(36)];
    
    
    [self addSubview:self.label5];
    [self.label5 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label4 withOffset:kHeightChange(26)];
    [self.label5 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.label5 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    UIView *yuan3 = [[UIView alloc] init];
    yuan3.backgroundColor = [UIColor redColor];
    yuan3.layer.cornerRadius = kWidthChange(4);
    yuan3.layer.masksToBounds = YES;
    [self addSubview:yuan3];
    [yuan3 autoSetDimensionsToSize:CGSizeMake(kWidthChange(8), kWidthChange(8))];
    [yuan3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [yuan3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label4 withOffset:kHeightChange(36)];
    
    [self addSubview:self.label6];
    [self.label6 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label5 withOffset:kHeightChange(26)];
    [self.label6 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(20)];
    [self.label6 autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    UIView *yuan4 = [[UIView alloc] init];
    yuan4.backgroundColor = [UIColor redColor];
    yuan4.layer.cornerRadius = kWidthChange(4);
    yuan4.layer.masksToBounds = YES;
    [self addSubview:yuan4];
    [yuan4 autoSetDimensionsToSize:CGSizeMake(kWidthChange(8), kWidthChange(8))];
    [yuan4 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(30)];
    [yuan4 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label5 withOffset:kHeightChange(36)];
    
    
    [self addSubview:self.readedButton];
    [self.readedButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(40)];
    [self.readedButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(40)];
    [self.readedButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kWidthChange(200)];
    [self.readedButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(85)];
    
    
}

#pragma mark ----Getters---
- (UIButton *)readedButton{
    if (!_readedButton) {
        _readedButton = [[UIButton alloc] init];
        [_readedButton setTitle:@"已阅读" forState:UIControlStateNormal];
        _readedButton.titleLabel.textColor = [UIColor whiteColor];
        _readedButton.titleLabel.font = [UIFont boldSystemFontOfSize:kWidthChange(34)];
        [_readedButton addTarget:self action:@selector(respondsToReaderButton:) forControlEvents:UIControlEventTouchUpInside];
        _readedButton.layer.cornerRadius = kWidthChange(5);
        _readedButton.layer.masksToBounds = YES;
//        [_readedButton setImage:[UIImage imageNamed:@"redCornerJuxing"] forState:UIControlStateNormal];
        [_readedButton setBackgroundImage:[UIImage imageNamed:@"redCornerJuxing"] forState:UIControlStateNormal];
    }
    return _readedButton;
}

- (UILabel *)label1{
    if (!_label1) {
        _label1 = [[UILabel alloc] init];
        _label1.text = @"    实名认证是主播申请途中最重要的一步，为确保您顺利通过认证，请准确填写个人信息，谢谢配合。";
        _label1.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _label1.textColor = [UIColor blackColor];
        _label1.numberOfLines = 2;
    }
    return _label1;
}
- (UILabel *)label2{
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"存在以下情形，将无法完成认证";
        _label2.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _label2.textColor = [UIColor blackColor];
    }
    return _label2;
}
- (UILabel *)label3{
    if (!_label3) {
        _label3 = [[UILabel alloc] init];
        _label3.text = @"    申请人未年满18岁";
        _label3.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _label3.textColor = [UIColor blackColor];
    }
    return _label3;
}
- (UILabel *)label4{
    if (!_label4) {
        _label4 = [[UILabel alloc] init];
        _label4.text = @"    申请人已被平台限制认证";
        _label4.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _label4.textColor = [UIColor blackColor];
    }
    return _label4;
}
- (UILabel *)label5{
    if (!_label5) {
        _label5 = [[UILabel alloc] init];
        _label5.text = @"    认证资料已被其他账户占用";
        _label5.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _label5.textColor = [UIColor blackColor];
    }
    return _label5;
}
- (UILabel *)label6{
    if (!_label6) {
        _label6 = [[UILabel alloc] init];
        _label6.text = @"    非大陆用户";
        _label6.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _label6.textColor = [UIColor blackColor];
    }
    return _label6;
}

@end
