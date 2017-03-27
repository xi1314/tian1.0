//
//  GiftView.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/11/29.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "GiftView.h"
#import "UIImage+CustomImage.h"
#import "GiftCollectionViewCell.h"
@interface  GiftView()

@end
@implementation GiftView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame])
    {
        self.backgroundColor =[UIColor whiteColor];
        [self addLayout];
        [self giftCollectionView];
    }
    return self;
}
-(UILabel *)wealthLabel
{
    if (!_wealthLabel)
    {
        _wealthLabel =[[UILabel alloc]init];
        _wealthLabel.text =@"我的财富:";
        _wealthLabel.textColor=WWColor(106, 108, 108);
        _wealthLabel.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _wealthLabel.translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:self.wealthLabel];
    }
    return _wealthLabel;
}
-(UILabel *)moneyLabel
{
    if (!_moneyLabel)
    {
        _moneyLabel =[[UILabel alloc]init];
        _moneyLabel.text =@"0";
        _moneyLabel.textColor =WWColor(175, 0, 0);
        _moneyLabel.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _moneyLabel.translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:self.moneyLabel];
    }
    return _moneyLabel;
}
-(UILabel *)typeLabel
{
    if (!_typeLabel)
    {
        _typeLabel =[[UILabel alloc]init];
        _typeLabel.text =@"越币";
        _typeLabel.textColor =WWColor(106, 108, 108);
        _typeLabel.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _typeLabel.translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:self.typeLabel];
    }
    return _typeLabel;
}
-(UIButton *)topupBtn
{
    if (!_topupBtn)
    {
        _topupBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [_topupBtn setBackgroundColor:[UIColor redColor]];
        [_topupBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_topupBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _topupBtn.titleLabel.font =[UIFont systemFontOfSize:kWidthChange(22)];
        _topupBtn.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.topupBtn];
    }
    return _topupBtn;
}
-(UILabel *)coinsLabel
{
    if (!_coinsLabel)
    {
        _coinsLabel =[[UILabel alloc]init];
        _coinsLabel.text =@"1";
        _coinsLabel.textColor =WWColor(219, 102, 34);
        _coinsLabel.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _coinsLabel.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.coinsLabel];
    }
    return _coinsLabel;
}
-(UILabel *)typeLabel1
{
    if (!_typeLabel1)
    {
        _typeLabel1 =[[UILabel alloc]init];
        _typeLabel1.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _typeLabel1.textColor= WWColor(106, 108, 108);
        _typeLabel1.text =@"灵桃";
        _typeLabel1.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.typeLabel1];
    }
    return _typeLabel1;
}
-(UIImageView *)line
{
    if (!_line)
    {
        _line =[[UIImageView alloc]init];
        _line .image =[UIImage createImageWithColor:WWColor(235, 232, 232)];
        _line.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.line];
    }
    return _line;
}
-(UIImageView *)longLine
{
    if (!_longLine)
    {
        _longLine =[[UIImageView alloc]init];
        _longLine .image =[UIImage createImageWithColor:WWColor(235, 232, 232)];
        _longLine.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.longLine];
    }
    return _longLine;
}
-(UICollectionView *)giftCollectionView
{
    if (!_giftCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize =CGSizeMake(kWidthChange(110), kHeightChange(170));
        flowLayout.scrollDirection =UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing =kWidthChange(71);
        flowLayout.sectionInset =UIEdgeInsetsMake(kHeightChange(10), kWidthChange(52), kHeightChange(10), kWidthChange(52));
        _giftCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, kHeightChange(70), kWidth, kHeightChange(190)) collectionViewLayout:flowLayout];
        _giftCollectionView.backgroundColor =[UIColor whiteColor];
        [_giftCollectionView registerClass:[GiftCollectionViewCell class] forCellWithReuseIdentifier:@"GiftCollectionViewCell"];
        [self addSubview:self.giftCollectionView];
    }
    return _giftCollectionView;
}
-(GiftBtn *)giftBtn1
{
    if (!_giftBtn1)
    {
        _giftBtn1 =[GiftBtn buttonWithType:UIButtonTypeCustom];
        
        _giftBtn1.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.giftBtn1];
    }
    return _giftBtn1;
}
-(GiftBtn *)giftBtn3
{
    if (!_giftBtn3)
    {
        _giftBtn3 =[GiftBtn buttonWithType:UIButtonTypeCustom];
        
        _giftBtn3.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.giftBtn3];
    }
    return _giftBtn3;
}
-(GiftBtn *)giftBtn2
{
    if (!_giftBtn2)
    {
        _giftBtn2 =[GiftBtn buttonWithType:UIButtonTypeCustom];
        
        _giftBtn2.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.giftBtn2];
    }
    return _giftBtn2;
}
-(GiftBtn *)giftBtn4
{
    if (!_giftBtn4)
    {
        _giftBtn4 =[GiftBtn buttonWithType:UIButtonTypeCustom];
        
        _giftBtn4.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.giftBtn4];
    }
    return _giftBtn4;
}
-(GiftBtn *)giftBtn5
{
    if (!_giftBtn5)
    {
        _giftBtn5 =[GiftBtn buttonWithType:UIButtonTypeCustom];
        
        _giftBtn5.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.giftBtn5];
    }
    return _giftBtn5;
}
-(GiftBtn *)giftBtn6
{
    if (!_giftBtn6)
    {
        _giftBtn6 =[GiftBtn buttonWithType:UIButtonTypeCustom];
        
        _giftBtn6.translatesAutoresizingMaskIntoConstraints =NO;[self addSubview:self.giftBtn6];
    }
    return _giftBtn6;
}

-(void)addLayout
{
    [self.wealthLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(15)];
    [self.wealthLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(120)];
    [self.wealthLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(22)];
    
    [self.moneyLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.wealthLabel withOffset:kWidthChange(3)];
    [self.moneyLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(100)];
    
    [self.typeLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.moneyLabel withOffset:kWidthChange(3)];
    [self.typeLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(50)];
    [@[self.wealthLabel,self.moneyLabel,self.typeLabel,self.topupBtn,self.typeLabel1,self.coinsLabel]autoAlignViewsToAxis:ALAxisHorizontal];
    
    [self.topupBtn autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.typeLabel withOffset:kWidthChange(55)];
    [self.topupBtn autoSetDimensionsToSize:CGSizeMake(kWidthChange(80), kHeightChange(40))];
    
    [self.line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(6)];
    [self.line autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.longLine withOffset:-kHeightChange(6)];
    [self.line autoSetDimension:ALDimensionWidth toSize:kWidthChange(1)];
    [self.line autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.topupBtn withOffset:kWidthChange(20)];
    
    [self.coinsLabel autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.line withOffset:kWidthChange(70)];
    [self.coinsLabel autoSetDimension:ALDimensionWidth toSize:kWidthChange(98)];
    
    [self.typeLabel1 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.coinsLabel withOffset:kWidthChange(3)];
    [self.typeLabel1 autoSetDimension:ALDimensionWidth toSize:kWidthChange(50)];
    
    [self.longLine autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.longLine autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.longLine autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(69)];
    [self.longLine autoSetDimension:ALDimensionHeight toSize:kHeightChange(1)];
    
//    [self.giftBtn1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.longLine withOffset:kHeightChange(10)];
//    [self.giftBtn1 autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(52)];
//    [self.giftBtn1 autoSetDimensionsToSize:CGSizeMake(kWidthChange(110), kHeightChange(170))];
//    
//    [self.giftBtn2 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.giftBtn1 withOffset:kWidthChange(71)];
//    [self.giftBtn3 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.giftBtn2 withOffset:kWidthChange(71)];
//    [self.giftBtn4 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.giftBtn3 withOffset:kWidthChange(71)];
//
//    [@[self.giftBtn1,self.giftBtn2,self.giftBtn3,self.giftBtn4,self.giftBtn5,self.giftBtn6]autoMatchViewsDimension:ALDimensionWidth];
//    [@[self.giftBtn1,self.giftBtn2,self.giftBtn3,self.giftBtn4,self.giftBtn5,self.giftBtn6]autoMatchViewsDimension:ALDimensionHeight];
//    [@[self.giftBtn1,self.giftBtn2,self.giftBtn3,self.giftBtn4]autoAlignViewsToAxis:ALAxisHorizontal];
//
//    [self.giftBtn5 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.giftBtn1 withOffset:kHeightChange(10)];
//    [@[self.giftBtn1,self.giftBtn5]autoAlignViewsToAxis:ALAxisVertical];
//    
//    [self.giftBtn6 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.giftBtn5 withOffset:kWidthChange(71)];
//    [@[self.giftBtn5,self.giftBtn6]autoAlignViewsToAxis:ALAxisHorizontal];
}
@end













