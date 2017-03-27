//
//  WWResultingViewController.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/11/18.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWResultingViewController.h"

@interface WWResultingViewController ()
@property (nonatomic,strong) UIImageView *topImageView;//上面的图片
@property (nonatomic,strong) UILabel *label;

@property (nonatomic,strong) UIButton *openLiving;//开启直播

@property (nonatomic,strong) UILabel *titleLabelw;//标题
@property (nonatomic,strong) UIButton *backButton;//返回按钮


@end

@implementation WWResultingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self addPurLayOut];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark ----Actions----
- (void)respondsToOpenLiving:(UIButton *)sender{
    NSLog(@"返回");
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"WWFirst"];
    [self.navigationController popViewControllerAnimated:YES];
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    //写你要实现的：页面跳转的相关代码
    
    return NO;
    
}


#pragma mark ----添加约束----
- (void)addPurLayOut{
    //上边的图片
    [self.view addSubview:self.topImageView];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(130) + 64];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(80)];
    [self.topImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(80)];
    [self.topImageView autoSetDimension:ALDimensionHeight toSize:kHeightChange(345)];
    
    //文字
    [self.view addSubview:self.label];
    [self.label autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.topImageView withOffset:kHeightChange(75)];
    
    
    
    [self.view addSubview:self.openLiving];
    [self.openLiving autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(35)];
    [self.openLiving autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(35)];
    [self.openLiving autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.label withOffset:kHeightChange(75)];
    [self.openLiving autoSetDimension:ALDimensionHeight toSize:kHeightChange(80)];
    
    [self.view addSubview:self.backButton];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(14)];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [self.view addSubview:self.titleLabelw];
    [self.titleLabelw autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [self.titleLabelw autoAlignAxisToSuperviewAxis:ALAxisVertical];
    
    
}

#pragma mark ----Getters----
//返回按钮
- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setBackgroundImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(respondsToOpenLiving:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

//标题
- (UILabel *)titleLabelw{
    if (!_titleLabelw) {
        _titleLabelw = [[UILabel alloc] init];
        _titleLabelw.text = @"验证结果";
        _titleLabelw.textColor = WWColor(110, 110, 110);
    }
    return _titleLabelw;
}

//开启直播
-(UIButton *)openLiving{
    if (!_openLiving) {
        _openLiving = [[UIButton alloc] init];
        [_openLiving setBackgroundImage:[UIImage imageNamed:@"圆角矩形-3"] forState:UIControlStateNormal];
        _openLiving.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(34)];
        [_openLiving setTitle:@"返回" forState:UIControlStateNormal];
        [_openLiving addTarget:self action:@selector(respondsToOpenLiving:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _openLiving;
    
}




//
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"你的资料我们正在审核中，请耐心等待";
        _label.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _label.textColor = WWColor(103, 103, 103);
    }
    return _label;
}

//上面的图片
- (UIImageView *)topImageView{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] init];
        _topImageView.image = [UIImage imageNamed:@"正在审核中"];
    }
    return _topImageView;
}


@end
