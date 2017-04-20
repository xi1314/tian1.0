//
//  WWBianjiView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/20.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWBianjiView.h"

@interface WWBianjiView()


@property (nonatomic,strong) UILabel *nameLabel;
@property (nonatomic,strong) UILabel *qianmingLabel;
@property (nonatomic,strong) UIButton *backButton;
@property (nonatomic,strong) UILabel *titleWbalel;
@end

@implementation WWBianjiView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addPureLayOut];
    }
    return self;
}


- (void)addPureLayOut{
    
    [self addSubview:self.bigHeadView];
    [self.bigHeadView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [self.bigHeadView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [self.bigHeadView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [self.bigHeadView autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    // 头像
    [self.bigHeadView addSubview:self.headImages];
    [self.headImages autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(170)];
    [self.headImages autoAlignAxis:ALAxisVertical toSameAxisOfView:self.bigHeadView withOffset:kWidthChange(-120)];
    [self.headImages autoSetDimensionsToSize:CGSizeMake(kWidthChange(166), kWidthChange(166))];
    
    //昵称
    [self.bigHeadView addSubview:self.nameLabel];
    [self.nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.headImages withOffset:kHeightChange(30)];
    [self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.headImages withOffset:kWidthChange(25)];
    [self.nameLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(380)];
    
    //个性签名
    [self.bigHeadView addSubview:self.qianmingLabel];
    [self.qianmingLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:kHeightChange(40)];
    [self.qianmingLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.nameLabel];
    [self.qianmingLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(380)];
    
    [self addSubview:self.backButton];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(10)];
    [self.backButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:22 + kHeightChange(10)];
    [self.backButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(80), kHeightChange(40))];
    
    [self addSubview:self.titleWbalel];
    [self.titleWbalel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:22 + kHeightChange(10)];
    [self.titleWbalel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [self.titleWbalel autoSetDimension:ALDimensionWidth toSize:kWidthChange(200)];
}

#pragma mark ----Getters----
- (UILabel *)titleWbalel{
    if (!_titleWbalel) {
        _titleWbalel = [[UILabel alloc] init];
        _titleWbalel.text = @"个人资料";
        _titleWbalel.textAlignment = NSTextAlignmentCenter;
        _titleWbalel.textColor = [UIColor whiteColor];
        _titleWbalel.font = [UIFont systemFontOfSize:kWidthChange(34)];
    }
    return _titleWbalel;
}

- (UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] init];
        [_backButton setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(respondsToBackButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UILabel *)qianmingLabel{
    if (!_qianmingLabel) {
        _qianmingLabel = [[UILabel alloc] init];
        _qianmingLabel.text = @"个性签名：做好每一件事";
//        _qianmingLabel.lineBreakMode = UILineBreakModeWordWrap;
        _qianmingLabel.numberOfLines = 2;
        _qianmingLabel.textColor = [UIColor whiteColor];
        _qianmingLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
    }
    return _qianmingLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"昵称：哈哈哈哈哈哈";
        _nameLabel.font = [UIFont systemFontOfSize:kWidthChange(28)];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UIImageView *)bigHeadView{
    if (!_bigHeadView) {
        _bigHeadView = [[UIImageView alloc] init];
        UIImage *images = [UIImage imageNamed:@"897"];
        _bigHeadView.image = images;
        // 实现模糊效果
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blur];
        visualEffectView.frame = self.frame;
        visualEffectView.alpha = 1.0;
        visualEffectView.userInteractionEnabled = YES;
         _bigHeadView.userInteractionEnabled = YES;
        [_bigHeadView addSubview:visualEffectView];
    }
    return _bigHeadView;
}

// 头像
- (UIImageView *)headImages{
    if (!_headImages) {
        _headImages = [[UIImageView alloc] init];
        _headImages.layer.cornerRadius = kWidthChange(83);
        _headImages.layer.masksToBounds = YES;
        _headImages.image = [UIImage imageNamed:@"897"];
        _headImages.layer.borderColor = [UIColor whiteColor].CGColor;
        //        _headImages.layer.backgroundColor
        _headImages.layer.borderWidth = 2.0f;
        _headImages.userInteractionEnabled = YES;
        UITapGestureRecognizer *gester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(respondsToChoiceHeadImage)];
        [_headImages addGestureRecognizer:gester];
    }
    return _headImages;
}

#pragma mark ----Actions----
- (void)respondsToChoiceHeadImage{
    NSLog(@"点击选择投降");
    if (self.ChoiceHeadImageHandler) {
        self.ChoiceHeadImageHandler();
    }
}

- (void)respondsToBackButtonClicked:(UIButton *)sender{
    NSLog(@"返回");
    if (self.BackButtonHandler) {
        self.BackButtonHandler();
    }
}

@end
