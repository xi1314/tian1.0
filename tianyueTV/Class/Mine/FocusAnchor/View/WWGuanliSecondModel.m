//
//  WWGuanliSecondModel.m
//  tianyueTV
//
//  Created by 哈儿林林 on 16/10/19.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "WWGuanliSecondModel.h"

#import "WWLeftImageButton.h"

@interface WWGuanliSecondModel()
{
    
}
- (void)initializeUserInterface; /**< 初始化用户界面 */
@property (nonatomic,strong) UIButton *headButtonW;
@property (nonatomic,strong) UIImageView *guanzheImageW;
@property (nonatomic,strong) UIView *topViewW;
@property (nonatomic,strong) UILabel *titleLbaelW;
@property (nonatomic,strong) NSMutableArray <UIButton *>*buttonArray;
@property (nonatomic,strong) UIButton *selectedAll;//全选
@property (nonatomic,strong) WWLeftImageButton *leftImageButton;
@property (nonatomic,strong) NSMutableArray <UIImageView *>*selectedImageViewArray;
@property (nonatomic,strong) UIButton *noGuanzhuButton;

@end


@implementation WWGuanliSecondModel

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
    [self addSubview:self.topViewW];
    [self.topViewW autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:64];
    [self.topViewW autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.topViewW autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.topViewW autoSetDimension:ALDimensionHeight toSize:kHeightChange(30)];
    
    [self addSubview:self.guanzheImageW];
    [self.guanzheImageW autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(10)];
    [self.guanzheImageW autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50) + 64];
    [self.guanzheImageW autoSetDimensionsToSize:CGSizeMake(kWidthChange(30), kHeightChange(30))];
    
    CGFloat width = self.frame.size.width * 0.25;
    
    NSInteger num = 100;
    for (int i = 0; i < 4; i ++) {
        for (int j = 0; j < 2; j++) {
            
            UIButton *buttonw = [[UIButton alloc] initWithFrame:CGRectMake(i * width + width*0.15,  j *width *1.2 +64 + kHeightChange(120), width*0.7, width*1.2)];
            
            [buttonw setImage:[UIImage imageNamed:@"图层-1"] forState:UIControlStateNormal];
            buttonw.imageView.frame = CGRectMake(0, 0, width*0.7, width*0.7);
            [buttonw setTitle:@"雕刻大师哈哈哈" forState:UIControlStateNormal];
            [buttonw setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            buttonw.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(24)];
            buttonw.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            buttonw.imageView.layer.cornerRadius = width * 0.35;
            buttonw.imageView.layer.masksToBounds = YES;
            buttonw.tag = num;

            [buttonw addTarget:self action:@selector(respondsToButtonw:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *_selectedImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidthChange(40), kWidthChange(40))];
            _selectedImage.image = [UIImage imageNamed:@"形状-1"];
            _selectedImage.center = CGPointMake(buttonw.imageView.center.x, buttonw.imageView.center.y - kHeightChange(40));
            
            [buttonw.imageView addSubview:_selectedImage];
            _selectedImage.tag = num + 100;
            num ++;
            [self initButton:buttonw];
            [self addSubview:buttonw];
            [self.buttonArray addObject:buttonw];
            [self.selectedImageViewArray addObject:_selectedImage];
            _selectedImage.hidden = YES;
            
        }
    }
    
    [self addSubview:self.titleLbaelW];
    [self.titleLbaelW autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50) + 64];
    [self.titleLbaelW autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.guanzheImageW withOffset:kWidthChange(10)];
    
    
    [self addSubview:self.leftImageButton];
    [self.leftImageButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kWidthChange(20)];
    [self.leftImageButton autoSetDimensionsToSize:CGSizeMake(kWidthChange(100), kHeightChange(40))];
    [self.leftImageButton autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(50) + 64];
    
    [self addSubview:self.noGuanzhuButton];
    [self.noGuanzhuButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:kWidthChange(40)];
    [self.noGuanzhuButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:kHeightChange(40)];
    UIButton *lastButton = [_buttonArray lastObject];
    [self.noGuanzhuButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lastButton withOffset:kHeightChange(148)];
    [self.noGuanzhuButton autoSetDimension:ALDimensionHeight toSize:kHeightChange(85)];
}



-(void)initButton:(UIButton*)btn{
    CGFloat width = self.frame.size.width * 0.25;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(btn.imageView.frame.size.height,-115, width*0.6,-10.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0,width*0.5, 0.0)];//图片距离右边框距离减少图片的宽度，其它不边
}

#pragma mark ----Actions----
- (void)respondsToButtonw:(UIButton *)sender{
    NSLog(@"选中");
    UIImageView *imageView = (UIImageView *)[self viewWithTag:(sender.tag + 100)];
    if (imageView.isHidden) {
        imageView.hidden = NO;
    }else{
        imageView.hidden = YES;
    }
    sender.selected = !sender.selected;

}

- (void)respondsToleftImageButton:(WWLeftImageButton *)sender{
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        sender.selectedImage.hidden = NO;
        for (int i = 0; i < self.selectedImageViewArray.count; i ++) {
            UIImageView *image = self.selectedImageViewArray[i];
            
            image.hidden = NO;
        }
        
    }else{
        sender.selectedImage.hidden = YES;
        for (int i = 0; i < self.selectedImageViewArray.count; i ++) {
            UIImageView *image = self.selectedImageViewArray[i];
            image.hidden = YES;
        }
    }
}


#pragma mark ----Gettts----
- (NSMutableArray *)selectedImageViewArray{
    if (!_selectedImageViewArray) {
        _selectedImageViewArray = [[NSMutableArray alloc] init];
    }
    return _selectedImageViewArray;
}

- (UIButton *)noGuanzhuButton{
    if (!_noGuanzhuButton) {
        _noGuanzhuButton = [[UIButton alloc] init];
        [_noGuanzhuButton setTitle:@"不再关注" forState:UIControlStateNormal];
        _noGuanzhuButton.backgroundColor = WWColor(211, 5, 26);
        _noGuanzhuButton.layer.cornerRadius = kWidthChange(10);
        _noGuanzhuButton.layer.masksToBounds = YES;
    }
    return _noGuanzhuButton;
}

- (WWLeftImageButton *)leftImageButton{
    if (!_leftImageButton) {
        _leftImageButton = [[WWLeftImageButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _leftImageButton.circle.image = [UIImage imageNamed:@"椭圆-1_圈"];
        _leftImageButton.label.text = @"全选";
        _leftImageButton.label.font = [UIFont systemFontOfSize:kWidthChange(25)];
        _leftImageButton.selectedImage.image = [UIImage imageNamed:@"形状-15"];
        _leftImageButton.selectedImage.hidden = YES;
        [_leftImageButton addTarget:self action:@selector(respondsToleftImageButton:) forControlEvents:UIControlEventTouchUpInside];
//        _btn.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(25)];
//        [_btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _leftImageButton;
}
- (UIButton *)selectedAll{
    if (!_selectedAll) {
        _selectedAll = [[UIButton alloc] init];
        [_selectedAll setImage:[UIImage  imageNamed:@"椭圆-1_圈"] forState:UIControlStateNormal];
      
        [_selectedAll setTitle:@"全选" forState:UIControlStateNormal];
        _selectedAll.titleLabel.font = [UIFont systemFontOfSize:kWidthChange(25)];
        [_selectedAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _selectedAll.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
        [_selectedAll setTitleEdgeInsets:UIEdgeInsetsMake(_selectedAll.imageView.frame.size.height,0, 0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
        [_selectedAll setImageEdgeInsets:UIEdgeInsetsMake(kWidthChange(0), 0,kWidthChange(0), 0)];//图片距离右边框距离减少图片的宽度，其它不边
        

//        [_selectedAll layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:kWidthChange(0)];
        

    }
    return _selectedAll;
}


- (NSMutableArray<UIButton *> *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [[NSMutableArray alloc] init];
    }
    return _buttonArray;
}



- (UILabel*)titleLbaelW{
    if (!_titleLbaelW) {
        _titleLbaelW = [[UILabel alloc] init];
        _titleLbaelW.text = @"关注的主播";
        _titleLbaelW.font = [UIFont systemFontOfSize:kWidthChange(30)];
    }
    return _titleLbaelW;
}

- (UIView *)topViewW{
    if (!_topViewW) {
        _topViewW = [[UIView alloc] init];
        _topViewW.backgroundColor = WWColor(240, 240, 240);
    }
    return _topViewW;
}

- (UIImageView *)guanzheImageW{
    if (!_guanzheImageW) {
        _guanzheImageW = [[UIImageView alloc] init];
        _guanzheImageW.image = [UIImage imageNamed:@"人员关注"];
        
        
    }
    return _guanzheImageW;
}


@end
