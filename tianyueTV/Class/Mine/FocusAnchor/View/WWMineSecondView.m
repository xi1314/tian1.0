//
//  WWMineSecondView.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/17.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWMineSecondView.h"


@interface WWMineSecondView()
- (void)initializeUserInterface; /**< 初始化用户界面 */
@property (nonatomic,strong)UIButton *headButton;
@property (nonatomic,strong) UIImageView *guanzheImage;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UILabel *titleLbael;
@property (nonatomic,strong) UILabel *livingView;//正在直播


@end

@implementation WWMineSecondView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initializeUserInterface];
    }
    return self;
}


-(void)initializeUserInterface{
    [self addSubview:self.topView];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.topView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.topView autoSetDimension:ALDimensionHeight toSize:kHeightChange(30)];
    
    [self addSubview:self.guanzheImage];
    [self.guanzheImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(10)];
    [self.guanzheImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50) + 64];
    [self.guanzheImage autoSetDimensionsToSize:CGSizeMake(kWidthChange(30), kHeightChange(30))];
    
    CGFloat width = self.frame.size.width * 0.25;
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 2; j++) {
//            UIView *sview = [[UIView alloc] initWithFrame:CGRectMake(i * width, j *width +64 + kHeightChange(80), width, width + 60)];
//            sview.backgroundColor = [UIColor orangeColor];
////            view.layer.borderWidth = 1.0f;
////            view.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor blueColor]);
//            [self addSubview:sview];
//            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width *0.15, width *0.15, width *0.7, width*0.7)];
////            button.center = sview.center;
//        
//            [button setImage:[UIImage imageNamed:@"图层-2"] forState:UIControlStateNormal];
//            button.layer.cornerRadius = width * 0.35;
//            button.layer.masksToBounds = YES;
//           
//            [sview addSubview:button];
            UIButton *buttonw = [[UIButton alloc] initWithFrame:CGRectMake(i * width + width*0.15,  j *width *1.2 +64 + kHeightChange(120), width*0.7, width*1.2)];
            
            [buttonw setImage:[UIImage imageNamed:@"图层-1"] forState:UIControlStateNormal];
            buttonw.imageView.frame = CGRectMake(0, 0, width*0.7, width*0.7);
            [buttonw setTitle:@"雕刻大师哈哈哈" forState:UIControlStateNormal];
           
            [buttonw setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            buttonw.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
            buttonw.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            buttonw.imageView.layer.cornerRadius = width * 0.35;
            buttonw.imageView.layer.masksToBounds = YES;
            [buttonw addTarget:self action:@selector(respondsToButtonw:) forControlEvents:UIControlEventTouchUpInside];
            UILabel *label = [[UILabel alloc] init];
            label = self.livingView;
            [buttonw addSubview:label];
            
            [label autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:buttonw.imageView];
            [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:buttonw.imageView];
            [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:buttonw.imageView withOffset:kHeightChange(-10)];
            [self initButton:buttonw];
            [self addSubview:buttonw];
        
            
            
        }
    }
    
    [self addSubview:self.titleLbael];
    [self.titleLbael autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50) + 64];
    [self.titleLbael autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.guanzheImage withOffset:kWidthChange(10)];
    
}



-(void)initButton:(UIButton*)btn{
    CGFloat width = self.frame.size.width * 0.25;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height,-115, width*0.6,-10.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,width*0.5, 0.0)];//图片距离右边框距离减少图片的宽度，其它不边
}

#pragma mark ----Actions----
- (void)respondsToButtonw:(UIButton *)sender{
    
    if (self.guanzhuButtonHandler) {
        self.guanzhuButtonHandler();
    }
}


#pragma mark ----Gettts----
- (UILabel *)livingView{
    if (!_livingView) {
        _livingView = [[UILabel alloc] init];
        _livingView.backgroundColor = WWColor(210, 5, 26);
        _livingView.layer.cornerRadius = 10.0f;
        _livingView.layer.masksToBounds = YES;
        _livingView.text = @"正在直播";
        _livingView.font = [UIFont systemFontOfSize:kWidthChange(30)];
        _livingView.textColor = [UIColor whiteColor];
        _livingView.textAlignment = NSTextAlignmentCenter;
    }
    return _livingView;
}

- (UILabel*)titleLbael{
    if (!_titleLbael) {
        _titleLbael = [[UILabel alloc] init];
        _titleLbael.text = @"关注的主播";
        _titleLbael.font = [UIFont systemFontOfSize:kWidthChange(30)];
    }
    return _titleLbael;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = WWColor(240, 240, 240);
    }
    return _topView;
}

- (UIImageView *)guanzheImage{
    if (!_guanzheImage) {
        _guanzheImage = [[UIImageView alloc] init];
        _guanzheImage.image = [UIImage imageNamed:@"人员关注"];
        
        
    }
    return _guanzheImage;
}




@end
