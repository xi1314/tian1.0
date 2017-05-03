//
//  SecondTableViewCell.m
//  tianyueTV
//
//  Created by wwwwwwww on 2016/12/7.
//  Copyright © 2016年 wwwwwwww. All rights reserved.
//

#import "SecondTableViewCell.h"
#import "UIImage+CustomImage.h"
#import "MainCollectionViewCell.h"
#import "LiveModel.h"
@interface SecondTableViewCell()

@end
@implementation SecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self =[super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addLayut];
        [self SecondCollectionView];
        //[self createContentBtn];
        //[self netRequest];
    }
    return self;
}
-(UILabel *)typeLabel
{
    if (!_typeLabel)
    {
        _typeLabel =[[UILabel alloc]init];
        _typeLabel.text =@"匠人";
        _typeLabel.font =[UIFont systemFontOfSize:kWidthChange(24)];
        _typeLabel.textAlignment =NSTextAlignmentCenter;
        _typeLabel.translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:self.typeLabel];
    }
    return _typeLabel;
}
-(MoreBtn *)moreBtn
{
    if (!_moreBtn)
    {
        _moreBtn =[MoreBtn buttonWithType:UIButtonTypeCustom];
        _moreBtn.translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:self.moreBtn];
    }
    return _moreBtn;
}
-(UICollectionView *)SecondCollectionView
{
    if (!_SecondCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize =CGSizeMake(kWidthChange(340), kHeightChange(237));
        flowLayout.minimumLineSpacing =kWidthChange(15);
        flowLayout.minimumInteritemSpacing =kWidthChange(30);
        flowLayout.sectionInset =UIEdgeInsetsMake(kHeightChange(25), kWidthChange(20), kHeightChange(25), kWidthChange(20));
        _SecondCollectionView =[[UICollectionView alloc]initWithFrame:CGRectMake(0, kHeightChange(80), SCREEN_WIDTH, kHeightChange(504)) collectionViewLayout:flowLayout];
        _SecondCollectionView.backgroundColor =[UIColor  whiteColor];
        [_SecondCollectionView registerClass:[MainCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:self.SecondCollectionView];
    }
    return _SecondCollectionView;
}
-(UIImageView *)grayLine
{
    if (!_grayLine)
    {
        _grayLine =[[UIImageView alloc]initWithImage:[UIImage createImageWithColor:WWColor(228, 228, 228)]];
        _grayLine.translatesAutoresizingMaskIntoConstraints=NO;[self addSubview:self.grayLine];
    }
    return _grayLine;
}
-(void)addLayut
{
    [self.typeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:kHeightChange(25)];
    [self.typeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
    [self.typeLabel autoSetDimensionsToSize:CGSizeMake(kWidthChange(80), kHeightChange(30))];
    
    [self.moreBtn autoPinEdgeToSuperviewEdge:ALEdgeTrailing withInset:kWidthChange(15)];
    [@[self.typeLabel ,self.moreBtn]autoAlignViewsToAxis:ALAxisHorizontal];
    [@[self.typeLabel,self.moreBtn]autoMatchViewsDimension:ALDimensionHeight];
    [self.moreBtn autoSetDimension:ALDimensionWidth toSize:kWidthChange(80)];

//    [self.contentBtn1 autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:kWidthChange(20)];
//    [self.contentBtn1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.typeLabel withOffset:kHeightChange(25)];
//    [self.contentBtn1 autoSetDimensionsToSize:CGSizeMake(kWidthChange(340), kHeightChange(237))];
//    
//    [self.contentBtn2 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.contentBtn1 withOffset:kWidthChange(30)];
//    [@[self.contentBtn1,self.contentBtn2,self.contentBtn3,self.contentBtn4]autoMatchViewsDimension:ALDimensionWidth];
//    [@[self.contentBtn1,self.contentBtn2,self.contentBtn3,self.contentBtn4]autoMatchViewsDimension:ALDimensionHeight];
//    [@[self.contentBtn1,self.contentBtn2]autoAlignViewsToAxis:ALAxisHorizontal];
//    
//    [self.contentBtn3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentBtn1 withOffset:kHeightChange(15)];
//    [@[self.contentBtn1,self.contentBtn3]autoAlignViewsToAxis:ALAxisVertical];
//    
//    [self.contentBtn4 autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:self.contentBtn3 withOffset:kWidthChange(30)];
//    [@[self.contentBtn3,self.contentBtn4] autoAlignViewsToAxis:ALAxisHorizontal];
    
    [self.grayLine autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [self.grayLine autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [self.grayLine autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    [self.grayLine autoSetDimension:ALDimensionHeight toSize:kHeightChange(10)];
}
@end












