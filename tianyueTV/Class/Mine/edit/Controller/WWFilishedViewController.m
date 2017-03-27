//
//  WWFilishedViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/28.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWFilishedViewController.h"

@interface WWFilishedViewController ()
- (void)initializeUserInterface; /**< 初始化用户界面 */
@property (nonatomic,strong) UILabel *headLabel;
@property (nonatomic,strong) UILabel *firstLabel;
@property (nonatomic,strong) UILabel *secondLabel;
@property (nonatomic,strong) UIButton *filishedButton;
@end

@implementation WWFilishedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"申请完成";
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked)];
    leftItem.image = [UIImage imageNamed:@"返回"];
    leftItem.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = leftItem;
    [self initializeUserInterface];
    // Do any additional setup after loading the view.
}

- (void)respondsToFilishedButton:(UIButton *)sender{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSLog(@"完成");
}

- (void)backItemClicked{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark ----initializeUserInterface----

- (void)initializeUserInterface{
    [self.view addSubview:self.headLabel];
    [self.headLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(131)+64];
    [self.headLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.headLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.headLabel autoSetDimension:ALDimensionHeight toSize:kHeightChange(54)];
    
    [self.view addSubview:self.firstLabel];
    [self.firstLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(40)];
    [self.firstLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(40)];
    [self.firstLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.headLabel withOffset:kHeightChange(59)];
    [self.firstLabel autoSetDimension:ALDimensionHeight toSize:kHeightChange(90)];
    
    [self.view addSubview:self.secondLabel];
    [self.secondLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(40)];
    [self.secondLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(40)];
    [self.secondLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.firstLabel withOffset:kHeightChange(49)];
    [self.secondLabel autoSetDimension:ALDimensionHeight toSize:kHeightChange(90)];
    
    [self.view addSubview:self.filishedButton];
    [self.filishedButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:kHeightChange(202)];
    
    [self.filishedButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(35)];
    [self.filishedButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(35)];
    [self.filishedButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(80)];
    
}

#pragma mark ----Getters----
- (UIButton *)filishedButton{
    if (!_filishedButton) {
        _filishedButton = [[UIButton alloc] init];
        [_filishedButton setBackgroundImage:[UIImage imageNamed:@"圆角矩形-3"] forState:UIControlStateNormal];
        [_filishedButton setTitle:@"完成" forState:UIControlStateNormal];
        [_filishedButton addTarget:self action:@selector(respondsToFilishedButton:) forControlEvents:UIControlEventTouchUpInside];
        _filishedButton.titleLabel.textColor = [UIColor whiteColor];
        _filishedButton.titleLabel.font = [UIFont boldSystemFontOfSize:kWidthChange(34)];
        
    }
    return _filishedButton;
}

- (UILabel *)secondLabel{
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.text = @"认证成功后，您可以再“我的”——“我的直播”页面进行直播。";
        _secondLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _secondLabel.textColor = WWColor(159, 159, 159);
        _secondLabel.numberOfLines = 0;
    }
    return _secondLabel;
}

- (UILabel *)firstLabel{
    if (!_firstLabel) {
        _firstLabel = [[UILabel alloc] init];
        
        _firstLabel.numberOfLines=0;
        _firstLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _firstLabel.textColor = WWColor(159, 159, 159);
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"        天越网会在1~3个工作日内完成审核，届时将以短信/邮件的方式告知您结果，感谢您的耐心等待!"];
        //获取要调整颜色的文字位置,调整颜色
        NSRange range1=[[hintString string]rangeOfString:@"短信/邮件"];
        [hintString addAttribute:NSForegroundColorAttributeName value:WWColor(7, 135, 253) range:range1];

        _firstLabel.attributedText=hintString;
    }
    return _firstLabel;
}

- (UILabel *)headLabel{
    if (!_headLabel) {
        _headLabel = [[UILabel alloc] init];
        _headLabel.text = @"我们已收到您的申请";
        _headLabel.font = [UIFont systemFontOfSize:kWidthChange(38)];
        _headLabel.textColor = [UIColor blackColor];
        _headLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _headLabel;
}

@end
